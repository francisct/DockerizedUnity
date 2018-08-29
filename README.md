## IMPORTANT
1) You will need a valid Unity pro license to use this image
2) Your Unity account must not use Google oAuth. You account must have been created directly on the Unity website.
3) You will need to rebuild the image to use any other components than WebGL
4) You will need to use the --memory flag to build the image. You can limit it to 3gb. Otherwise it will max out your ram and crash all your docker instances.
5) When you run the image make sure you are using the same hostname everytime because all unity subscriptions have a limited number of activation. Using the same hostname will trick the activation into thinking you are using the same computer.

## How to run
# Via docker
`docker run -v ./:/app --hostname=sameHostnameEverytime -e UNITY_USERNAME=myusename -e UNITY_PASSWORD=mypassword -e UNITY_SERIAL=myserial -e BUILD_TARGET=WebGL -e METHOD_FULLPATH=MyBuilder.build trespetitlegume:unity`

# ENV variables
- UNITY_USERNAME -> Do not use any quotes
- UNITY_PASSWORD -> Do not use any quotes
- UNITY_SERIAL -> The serial associated with your account or as Unity calls it, your seat.
- BUILD_TARGET -> WebGL, Android, etc
- ADDITIONAL_OPTIONS -> You can pass any additionnal options to the cli here
- METHOD_FULLPATH -> This is the method you want the cli to run. It must include the namespace, the class and the method

## How to build and add new components

# BUILD_ARG variables
- UNITY_COMPONENTS -> If you want more components/module such as Android, IOS, etc, you can do so by rebuilding the image and by using UNITY_COMPONENTS. Each component need to be separated by a comma.
`docker build --build-arg UNITY_COMPONENTS=webgl,android`

*The dependencies installed are currently only those for WebGL. You will need to add the required dependencies depending on your components. The dependencies are specified at https://forum.unity.com/threads/unity-on-linux-release-notes-and-known-issues.350256/

- UNITY_DOWNLOAD_LINK -> downgrade/upgrade the version of unity
`docker build --build-arg UNITY_DOWNLOAD_LINK=https://beta.unity3d.com/download/88f43da96871/UnitySetup-2018.2.5f1 .`

## Dockerfile
```
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
    && yes | ./UnitySetup --unattended --install-location=/Unity --components='Unity,${BUILD_TARGET},${UNITY_COMPONENTS}'

ENV PROJECT_PATH /app

ENTRYPOINT /Unity/Editor/Unity xvfb-run --auto-servernum /Unity/Editor/Unity \
           -quit \
           -batchmode \
           -nographics \
           -projectPath ${PROJECT_PATH} \
           -username \"${UNITY_EMAIL}\" \
           -password \"${UNITY_PASSWORD}\" \
           -serial ${UNITY_SERIAL} \
           -logfile /Unity/cli.log \
           -buildTarget ${BUILD_TARGET} \
           -executeMethod ${METHOD_FULLPATH}\
           ${ADDITIONAL_OPTIONS}

```
