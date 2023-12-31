FROM alpine:3.18

RUN apk add --no-cache python3 py3-pip

COPY . /opt/python

WORKDIR "/opt/python"

RUN pip install -e .

CMD ["python", "src/main.py"]

EXPOSE 8080