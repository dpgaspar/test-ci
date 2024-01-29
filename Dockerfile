FROM python:alpine3.11 AS lean

WORKDIR /app

RUN ls /
RUN echo "Hello World"
