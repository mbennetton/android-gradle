FROM openjdk:8

ENV BUILD_TOOLS_VERSION=28.0.3 \
    GRADLE_VERSION=4.10.3 \
    GRADLE_HOME=/usr/bin/gradle \
    ANDROID_HOME=/usr/bin/android-sdk-linux \
    ANDROID_SDK_ROOT=/usr/bin/android-sdk-linux \
    ANDROID_SDK_TOOLS_VERSION=4333796 \
    ANDROID_PLATFORM_VERSION=28

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update && \
    apt-get install -yq libc6 libstdc++6 zlib1g libncurses5 build-essential libssl-dev ruby ruby-dev --no-install-recommends && \
    apt-get clean

# Download and unzip Gradle 
RUN mkdir -p $GRADLE_HOME && \
    wget https://services.gradle.org/distributions/gradle-"$GRADLE_VERSION"-all.zip -O gradle.zip && \
    unzip -d $GRADLE_HOME gradle.zip && \
    rm -rf gradle.zip

# Download and unzip Android SDK tools
RUN mkdir -p ${ANDROID_HOME} && \
    mkdir -p /root/.android && touch /root/.android/repositories.cfg && \
    wget https://dl.google.com/android/repository/sdk-tools-linux-"$ANDROID_SDK_TOOLS_VERSION".zip -O tools.zip && \
    unzip tools.zip -d ${ANDROID_HOME} && \
    rm tools.zip

# Make license agreement
RUN mkdir $ANDROID_HOME/licenses true && \
    echo "24333f8a63b6825ea9c5514f83c2829b004d1fee" > "$ANDROID_HOME/licenses/android-sdk-license"

# Update and install using sdkmanager
RUN $ANDROID_HOME/tools/bin/sdkmanager --update && \
    $ANDROID_HOME/tools/bin/sdkmanager --install "platform-tools" "build-tools;${BUILD_TOOLS_VERSION}" "platforms;android-${ANDROID_PLATFORM_VERSION}"

ENV PATH=${PATH}:"$ANDROID_HOME"/build-tools/"$BUILD_TOOLS_VERSION":"$ANDROID_HOME"/tools:"$ANDROID_HOME"/platform-tools:"$GRADLE_HOME"/gradle-"$GRADLE_VERSION"/bin