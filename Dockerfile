FROM debian:stretch-slim as builder

ENV VERSION=110.78 SMLROOT=/usr/local/sml

RUN apt-get update && apt-get install -y build-essential gcc-multilib g++-multilib wget lib32z1 lib32ncurses5
RUN mkdir -p "$SMLROOT"
WORKDIR /usr/local/sml
RUN wget "http://smlnj.org/dist/working/$VERSION/config.tgz" && \
	tar axvf config.tgz && \
        config/install.sh

FROM debian:stretch-slim as runtime
COPY --from=builder /usr/local/sml /usr/local/sml
RUN apt-get update && apt-get install -y lib32z1 lib32ncurses5
ENTRYPOINT ["/usr/local/sml/bin/sml"]
