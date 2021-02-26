FROM ubuntu:xenial as build
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q && apt-get install -qy \
    curl jq \
    texlive-full \
    python-pygments gnuplot \
    make git \
    && rm -rf /var/lib/apt/lists/*
                                   
WORKDIR /build
COPY . .

RUN latexmk

# Copy build to output
FROM scratch as export-stage
COPY --from=build /build/target .

