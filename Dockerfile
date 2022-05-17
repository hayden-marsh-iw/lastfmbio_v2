FROM ballerina/ballerina:nightly
EXPOSE 9091
USER root
COPY ./modules /home/ballerina/lastfmbio/modules
COPY ./resources /home/ballerina/lastfmbio/resources
COPY ./*.toml /home/ballerina/lastfmbio
COPY ./main.bal /home/ballerina/lastfmbio/main.bal
WORKDIR /home/ballerina/lastfmbio
ENTRYPOINT ["/bin/sh", "-c", "bal run 2>&1 | tee -a /home/ballerina/lastfmbio/resources/lastfmbio.log"]