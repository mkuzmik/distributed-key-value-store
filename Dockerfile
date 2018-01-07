FROM erlang:18
COPY ebin ebin
COPY config config
EXPOSE 1234:1234
ENTRYPOINT ["erl","-noshell","-pa","ebin","-run","store_app"]