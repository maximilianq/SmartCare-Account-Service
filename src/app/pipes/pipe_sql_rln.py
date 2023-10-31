from simplerln import RLNClient

def create_sql_rln_pipe(client: RLNClient):
    async def pipe(name, data):
        await client.emit(name, data)
    return pipe