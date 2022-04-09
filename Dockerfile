## Installer
FROM ubuntu:focal AS installer

ARG VAUDTAX_YEAR
ENV VAUDTAX_DOWNLOAD_URL="https://vaudtax-dl.vd.ch/vaudtax${VAUDTAX_YEAR}/telechargement/linux/64bit/VaudTax_${VAUDTAX_YEAR}.tar.gz"
ENV VAUDTAX_SHA256SUM_URL="https://vaudtax-dl.vd.ch/vaudtax${VAUDTAX_YEAR}/telechargement/linux/64bit/VaudTax_${VAUDTAX_YEAR}.SHA256"
ENV VAUDTAX_SHA256SIG_URL="https://vaudtax-dl.vd.ch/vaudtax${VAUDTAX_YEAR}/telechargement/linux/64bit/VaudTax_${VAUDTAX_YEAR}.SHA256.asc"

# OS dependencies
RUN \
    export DEBIAN_FRONTEND='noninteractive' \
    && apt-get update --quiet \
    && apt-get install --no-install-recommends --yes \
       ca-certificates \
       gnupg \
       tar \
       wget

# VaudTax
RUN \
    wget --progress=bar "${VAUDTAX_SHA256SUM_URL}" -O '/vaudtax-linux.sha256sum' \
    && wget --progress=bar "${VAUDTAX_SHA256SIG_URL}" -O '/vaudtax-linux.sha256sum.sig' \
    && gpg --keyserver keys.openpgp.org --recv-key 92A8CF12B6EE09D8F6A8900BFABB0217083F31DE \
    && gpg --verify '/vaudtax-linux.sha256sum.sig' '/vaudtax-linux.sha256sum' \
    && wget --progress=bar "${VAUDTAX_DOWNLOAD_URL}" -O '/vaudtax-linux.tar.gz' \
    && sed -nE 's|(\S+)\s+\S+\.tar\.gz\s*$|\1  /vaudtax-linux.tar.gz|p' '/vaudtax-linux.sha256sum' | sha256sum -c - \
    && mkdir -p '/opt' \
    && cd '/opt' \
    && tar -xzf '/vaudtax-linux.tar.gz' \
    && mv -v '/opt/VaudTax'* '/opt/vaudtax-linux' \
    && chmod -R go-w "/opt/vaudtax-linux"


## VaudTax
FROM ubuntu:focal AS vaudtax

ARG VAUDTAX_YEAR
ARG VAUDTAX_UID=1000
ARG VAUDTAX_GID=1000

# OS dependencies
RUN \
    export DEBIAN_FRONTEND='noninteractive' \
    && echo 'locales locales/locales_to_be_generated string fr_CH.UTF-8 UTF-8' | debconf-set-selections \
    && apt-get update --quiet \
    && apt-get install --no-install-recommends --yes \
       ca-certificates \
       curl \
       epiphany-browser \
       evince \
       libwebkit2gtk-4.0-37 \
       locales \
       openjdk-11-jre \
       sudo \
       tzdata \
    && apt-get clean \
    && update-locale 'LANG=fr_CH.UTF-8'

# User/group
RUN \
    addgroup \
       --gid ${VAUDTAX_GID} \
       --force-badname _vaudtax \
    && adduser \
       --gecos 'VaudTax' \
       --disabled-login \
       --shell /bin/bash \
       --home /home/vaudtax/data \
       --gid ${VAUDTAX_GID} \
       --uid ${VAUDTAX_UID} \
       --force-badname _vaudtax \
    && echo '_vaudtax ALL=NOPASSWD: ALL' > /etc/sudoers.d/_vaudtax \
    && chmod 440 /etc/sudoers.d/_vaudtax

# VaudTax
COPY --from=installer /opt/vaudtax-linux /opt/vaudtax-linux
COPY vaudtax /usr/local/bin/vaudtax
RUN \
    sed -i "s|%{VAUDTAX_YEAR}|${VAUDTAX_YEAR}|g" '/usr/local/bin/vaudtax' \
    && chmod a+rx '/usr/local/bin/vaudtax'

CMD /bin/bash /usr/local/bin/vaudtax
