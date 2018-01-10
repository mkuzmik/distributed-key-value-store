FROM erlang:18
COPY ebin ebin
COPY docker_boot.sh docker_boot.sh
EXPOSE 1234:1234
ENTRYPOINT ["./docker_boot.sh"]