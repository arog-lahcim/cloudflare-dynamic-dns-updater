FROM debian:stable-slim

RUN apt-get update -y && apt-get install -y curl jq

WORKDIR /client

COPY ./update.sh ./

ENTRYPOINT ["./update.sh"]
