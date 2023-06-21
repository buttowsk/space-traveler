FROM crystallang/crystal

WORKDIR /app

COPY shard.yml shard.lock ./

RUN shards install

RUN apt-get update && \
    apt-get install -y libsqlite3-dev
    
COPY . .

RUN crystal build --release src/api.cr

EXPOSE 3000

CMD ["make", "server"]