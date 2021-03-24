#----------------------------------
# Source image

FROM paritytech/ci-linux:production as source

LABEL org.label-schema.vendor="Evercity" \
      org.label-schema.name="Smart Sustainable Bond" \
      org.label-schema.description="Blockchain node, which is a main part of Evercity's Smart Sustainable Bond project" \
      org.label-schema.url="https://evercity.io" \
      org.label-schema.schema-version="1.0" \
      org.opencontainers.image.source="https://github.com/EvercityEcosystem/smart-sustainable-bond"

WORKDIR /home/source
COPY . .
RUN cargo build --release


#----------------------------------
# Runtime image

FROM ubuntu:20.04 as runtime

LABEL org.label-schema.vendor="Evercity" \
      org.label-schema.name="Smart Sustainable Bond" \
      org.label-schema.description="Blockchain node, which is a main part of Evercity's Smart Sustainable Bond project" \
      org.label-schema.url="https://evercity.io" \
      org.label-schema.schema-version="1.0" \
      org.opencontainers.image.source="https://github.com/EvercityEcosystem/smart-sustainable-bond"

ENV USER="node"

RUN apt update && \
    addgroup --gecos "" --gid 2000 $USER && \
    adduser --gecos "" --gid 2000 --shell /bin/sh --disabled-login --disabled-password $USER
USER $USER
WORKDIR /home/$USER

COPY --chown=$USER:$USER --from=source ["/home/source/target/release", "/home/$USER/"]

EXPOSE 9944
CMD [ "./evercity-node", "--dev", "--ws-port", "9944", "--rpc-cors", "all"]
