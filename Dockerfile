FROM python:3.13

WORKDIR .

COPY . .

RUN pip install flask 

CMD python3 hello_flask.py

