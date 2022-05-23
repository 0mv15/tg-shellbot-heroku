FROM phusion/baseimage:bionic-1.0.0

# Use baseimage-docker's init system:
CMD ["/sbin/my_init"]

# Install dependencies:
RUN apt-get update
RUN apt-get install -y ffmpeg software-properties-common mediainfo mkvtoolnix unzip wget git bash curl sudo make busybox  build-essential nodejs npm
 && mkdir -p /home/stuff

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
