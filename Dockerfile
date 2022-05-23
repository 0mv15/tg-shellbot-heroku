FROM phusion/baseimage:bionic-1.0.0

# Use baseimage-docker's init system:
CMD ["/sbin/my_init"]

# Install dependencies:
RUN apt-get update && apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/* && \
    apt-add-repository non-free && \
    apt-get -qq update && apt-get -qq install -y --no-install-recommends \
    # this package is required to fetch "contents" via "TLS"
    apt-transport-https \
    # install coreutils
    coreutils jq pv gcc g++ \
    # install encoding tools
    mediainfo \
    # miscellaneous
    neofetch python3-dev git bash build-essential nodejs npm ruby \
    python-minimal locales python-lxml qbittorrent-nox nginx gettext-base xz-utils \
    # install extraction tools
    p7zip-full p7zip-rar rar unrar zip unzip \
    # miscellaneous helpers
    megatools mediainfo && \
    # clean up the container "layer", after we are done
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN wget https://johnvansickle.com/ffmpeg/builds/ffmpeg-git-amd64-static.tar.xz && \
    tar xvf ffmpeg*.xz && \
    cd ffmpeg-*-static && \
    mv "${PWD}/ffmpeg" "${PWD}/ffprobe" /usr/local/bin/


# Set work dir:
WORKDIR /home

# Copy files:
COPY startbot.sh /home
COPY config.sh /home
COPY /stuff /home/stuff

# Run config.sh and clean up APT:
RUN sh /home/config.sh \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install the bot:
RUN git clone https://github.com/botgram/shell-bot.git \
 && cd shell-bot \
 && npm install

RUN echo "Uploaded files:" && ls /home/stuff/

# Run bot script:
CMD bash /home/startbot.sh
