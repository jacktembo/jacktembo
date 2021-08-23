From python:3.9-alpine
COPY . /websites
WORKDIR /websites
CMD python3 -m http.server
