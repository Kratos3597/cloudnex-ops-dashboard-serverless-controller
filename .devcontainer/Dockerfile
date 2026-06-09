FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Install dependencies for Linux Desktop and Android builds
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    wget \
    unzip \
    git \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev \
    && rm -rf /var/lib/apt/lists/*

# Set Environment Variables
ENV ANDROID_HOME=/home/vscode/Android/Sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# Setup Android SDK
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O /tmp/tools.zip && \
    unzip -q /tmp/tools.zip -d ${ANDROID_HOME}/cmdline-tools && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest && \
    rm /tmp/tools.zip && \
    chown -R vscode:vscode /home/vscode/Android

# Setup Flutter
RUN git clone https://github.com/flutter/flutter.git /home/vscode/flutter && \
    chown -R vscode:vscode /home/vscode/flutter
ENV PATH=$PATH:/home/vscode/flutter/bin

# Accept licenses and install required versions
USER vscode
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-36" "build-tools;28.0.3"