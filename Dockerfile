FROM ubuntu:xenial

RUN apt-get update \
    && apt-get install -y curl \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get update \
    && apt-get install -y \
    gconf-service \
    git \
    lib32gcc1 \
    lib32stdc++6 \
    libarchive13 \
    libasound2 \
    libav-tools \
    libc6 \
    libc6-i386 \
    libcairo2 \
    libcap2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libfreetype6 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libglu1-mesa \
    libgtk2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libpango1.0-0 \
    libpng12-0 \
    libsoup2.4-1 \
    libstdc++6 \
    libx11-6 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxtst6 \
    openjdk-8-jre \
    zlib1g \
    debconf \
    nodejs \
    gzip \
    xdg-utils \
    lsb-release \
    libpq5 \
    wget \
    xvfb

ARG UNITY_DOWNLOAD_LINK
ARG BUILD_TARGET
ENV BUILD_TARGET ${BUILD_TARGET}
ARG UNITY_COMPONENTS

RUN wget -O UnitySetup ${UNITY_DOWNLOAD_LINK} \
    && mkdir /Unity \
    && chmod 777 /Unity \
    && chmod +x /UnitySetup \
    && yes | ./UnitySetup --unattended --install-location=/Unity --components="Unity,${BUILD_TARGET},${UNITY_COMPONENTS}"

ENV PROJECT_PATH /app

ENTRYPOINT xvfb-run --auto-servernum /Unity/Editor/Unity \
          -quit \
          -batchmode \
          -nographics \
          -projectPath /app \
          -executeMethod ${UNITY_METHOD} \
          -username "${UNITY_EMAIL}" \
          -password "${UNITY_PASSWORD}" \
          -serial ${UNITY_SERIAL} \
          -logfile \
          -buildTarget ${BUILD_TARGET} \
          ${ADDITIONAL_OPTIONS}
