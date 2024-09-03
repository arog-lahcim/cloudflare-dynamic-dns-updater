FROM debian:bookworm-slim

RUN apt update -y && apt install -y curl jq

WORKDIR /client

COPY ./update.sh ./

ENTRYPOINT ["./update.sh"]
