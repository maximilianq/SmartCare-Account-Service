from uuid import UUID as uuid, uuid4
from typing import Callable

from os import listdir
from os.path import dirname, realpath, splitext, isdir, isfile
from pathlib import Path
from string import Formatter
from json import loads, JSONDecodeError

from psycopg2 import connect
from psycopg2.errors import UniqueViolation, Error
from psycopg2.extras import register_uuid
from psycopg2._psycopg import connection as Connection, cursor as Cursor, Notify

from asyncio import sleep

from logging import Logger, getLogger

from socketio import AsyncServer

logger: Logger = getLogger('uvicorn.error')

formatter: Formatter = Formatter()

class Query:

    def __init__(self, database: "Database", name: str, query: str) -> None:

        self.database: Database = database
        self.name: str = name
        self.query: str = query

        self.parameters: list[str] = None
        self.prepare_query: str = None
        self.execute_query: str = None
        self.deallocate_query: str = None

    def __call__(self, **kwargs: dict[str, object]) -> None:
        return self.execute(kwargs)
    
    def prepare(self):

        query_replace: str = self.query

        self.parameters = list(dict.fromkeys([item[1] for item in formatter.parse(query_replace) if item[1]]))
        for index, parameter in enumerate(self.parameters):
            query_replace = query_replace.replace('{' + parameter + '}', '$' + str(index + 1))

        self.guid: uuid = uuid4()

        self.prepare_query = f'PREPARE "{self.guid}" AS {query_replace.removesuffix(";")};'
        self.execute_query = f'EXECUTE "{self.guid}"({", ".join([f"%({parameter})s" for parameter in self.parameters])});'
        self.deallocate_query = f'DEALLOCATE "{self.guid}";'

        logger.debug(f'Preparing query {self.name} ({self.guid}).')

        self.database._execute(self.prepare_query, {})
    
    def execute(self, data: dict[str, object] = {}) -> dict[str, object]:

        parameters: dict[str, object] = {parameter: data.get(parameter, None) for parameter in self.parameters}

        logger.debug(f'Execute query {self.name} ({self.guid})')

        return self.database._execute(self.execute_query, parameters)

    def deallocate(self):

        logger.debug(f'Deallocating query {self.name} ({self.guid}).')

        self.database._execute(self.deallocate_query, {})

class QueryLibrary:

    def __init__(self, queries: dict[str, Query]) -> None:
        self.queries = queries
    
    def __getattr__(self, name: str) -> Query:
        return self.queries[name]

class SQLRouter:

    def __init__(self) -> None:
        self.listeners: dict[str, list[Callable[[dict | str], None]]] = {}

    def add_listener(self, event: str, callback: Callable[[dict | str], None]):
        if event in self.listeners:
            self.listeners[event].append(callback)
        else:
            self.listeners[event] = [callback]

    def listen(self, event: str):
        def decorate(callback: Callable[[dict | str], None]):
            self.add_listener(event, callback)
        return decorate
    
    def include_router(self, router: "SQLRouter"):
        for event, listeners in router.listeners.items():
            if event in self.listeners:
                self.listeners[event] = self.listeners[event] + listeners
            else:
                self.listeners[event] = listeners

def socket_pipe(socket: AsyncServer):
    async def pipe(event: str, data: dict | str):
        await socket.emit(event=event, data=data)
        logger.info(f'Emitted event "{event}".')
    return pipe

class Database:

    def __init__(self, host: str, port: str, username: str, password: str, database: str, path: str = f'{dirname(realpath(__file__))}\queries') -> None:
        
        self.host: str = host
        self.port: str = port
        self.username: str = username
        self.password: str = password
        self.database: str = database
        self.path: str = path

        self.connection: Connection = None
        self.queries: dict[str, Query] = None
        
        self.listeners: dict[str, list[Callable[[dict | str], None]]] = {}
        self.pipes: list[Callable[[str, dict | str], None]] = []

        self._import_queries()

        self.query: QueryLibrary = QueryLibrary(self.queries)
    
    def include_router(self, router: SQLRouter):
        for event, listeners in router.listeners.items():
            if event in self.listeners:
                self.listeners[event] = self.listeners[event] + listeners
            else:
                self.listeners[event] = listeners

    def include_pipe(self, callback: Callable[[str, dict | None], None]):
        self.pipes.append(callback)

    def start(self):
        self.connection = connect(host=self.host, port=self.port, database=self.database, user=self.username, password=self.password)
        register_uuid()
        self._prepare()

    async def listen(self):
        cursor: Cursor = self.connection.cursor()

        for event in self.listeners:
            cursor.execute(f'LISTEN "{event}";')
        self.connection.commit()

        try:

            while await sleep(0.1, True):

                self.connection.poll()

                while self.connection.notifies:

                    notify: Notify = self.connection.notifies.pop()
                    
                    logger.debug(f'Recieved database event "{notify.channel}".')

                    for listener in self.listeners.get(notify.channel, []):
                        try:
                            listener(loads(notify.payload))
                        except JSONDecodeError:
                            listener(notify.payload)

                    for pipe in self.pipes:
                        await pipe(notify.channel, notify.payload)
                    
        finally:

            for event in self.listeners:
                cursor.execute(f'UNLISTEN "{event}";')
            self.connection.commit()

            cursor.close()


    def stop(self):
        self._deallocate()
        self.connection.close()

    def _import_queries(self):

        self.queries = {}
        for item in listdir(self.path):
            if isdir(f'{self.path}/{item}'):
                for file in listdir(f'{self.path}/{item}'):
                    name, extension = splitext(file)
                    if extension.upper() == '.SQL':
                        self.queries[(item + '_' + name).upper()] = Query(self, (item + '_' + name).upper(), Path(f'{self.path}/{item}/{file}').read_text())
            if isfile(f'{self.path}/{item}'):
                name, extension = splitext(item)
                if extension.upper() == '.SQL':
                    self.queries[name.upper()] = Query(self, name.upper(), Path(f'{self.path}/{item}').read_text())

    def _execute(self, query: str, data: dict[str, object]) -> object | dict[str, object] | list[object] | list[dict[str, object]]:

        output: object | dict[str, object] | list[object] | list[dict[str, object]] = None

        with self.connection.cursor() as cursor:

            try:
                cursor.execute(query, data)

            except UniqueViolation as error:
                self.connection.rollback()
                return None
            
            except Error as error:
                logger.error(f'{error.diag.message_primary[0].upper() + error.diag.message_primary[1:]}')
                self.connection.rollback()
                return None

            if cursor.description:
                rows: list[tuple] = cursor.fetchall()
                if len(rows) == 1:
                    if len(cursor.description) == 1:
                        output = rows[0][0]
                    else:
                        output = {column.name: rows[0][index] for index, column in enumerate(cursor.description)}
                else:
                    if len(cursor.description) == 1:
                        output = [row[0] for row in rows]
                    else:
                        output = [{column.name: row[index] for index, column in enumerate(cursor.description)} for row in rows]

        self.connection.commit()

        return output

    def _prepare(self) -> None:
        
        for query in self.queries.values():
            query.prepare()

    def _deallocate(self):

        for query in self.queries.values():
            query.deallocate()