# Based on:
# * github.com/certusone/wormhole/blob/79ab522f802ccc5ba34278d3c648fa62e06f4f1c/solana/Dockerfile
# * github.com/greencorelab/soteria-docker
FROM docker.io/library/rust:1.49@sha256:a50165ea96983c21832578afb1c8c028674c965bc1ed43b607871b1f362e06a5

ENV RUST_BACKTRACE=1

RUN apt-get update && apt-get install -y \
                build-essential \
                curl \
                git \
        && rm -rf /var/lib/apt/lists/*

RUN rustup component add rustfmt && rustup default nightly-2021-08-01

# solana
RUN sh -c "$(curl -sSfL https://release.solana.com/v1.8.1/install)"
ENV PATH "/root/.local/share/solana/install/active_release/bin:$PATH"

# soteria
RUN sh -c "$(curl -k https://supercompiler.xyz/install)"
ENV PATH "/soteria-linux-develop/bin:$PATH"

# wormhole
ENV EMITTER_ADDRESS 0
WORKDIR /usr/src
RUN set -eux; \
        git clone https://github.com/certusone/wormhole.git; \
        cd wormhole; \
        git checkout -b unsafe-code 79ab522f802ccc5ba34278d3c648fa62e06f4f1c;

WORKDIR /usr/src/wormhole/solana/bridge/program

RUN cargo build-bpf

RUN mkdir /tmp/soteria
CMD ["soteria", "-analyzeAll", "-o", "/tmp/soteria/report", "."]
