ARG WIN_VERSION=ltsc2019-amd64

FROM mcr.microsoft.com/windows/servercore:${WIN_VERSION}

ARG SBT_VERSION=1.8.0
# RUN echo SBT_VERSION: %SBT_VERSION%

ARG SCALA_VERSION=2.13.10
# ENV SCALA_VERSION ${SCALA_VERSION:-2.13.10}
# RUN echo SCALA_VERSION: %SCALA_VERSION%

ARG JDK_VERSION=11.0.16.1
# RUN echo JDK_VERSION: %JDK_VERSION%

WORKDIR /temp

#
# java (MS' openjdk)
#

# retrieve and install package
RUN curl -L -o jdk-%JDK_VERSION%-windows-x64.msi https://aka.ms/download-jdk/microsoft-jdk-%JDK_VERSION%-windows-x64.msi
RUN msiexec /I jdk-%JDK_VERSION%-windows-x64.msi /QN /L*V jdk-%JDK_VERSION%-windows-x64.txt

#
# Scala build tool (sbt)
#

# retrieve and install package
RUN curl -L -o sbt-%SBT_VERSION%.msi https://github.com/sbt/sbt/releases/download/v%SBT_VERSION%/sbt-%SBT_VERSION%.msi
RUN msiexec /I sbt-%SBT_VERSION%.msi /QN /L*V sbt-%SBT_VERSION%.txt

WORKDIR /app

# 
# Prepare sbt (warm cache)
# 

RUN echo scalaVersion := "%SCALA_VERSION%" > build.sbt && \
    echo case object Temp > Temp.scala && \
    mkdir project && \
    echo sbt.version=%SBT_VERSION% > project\build.properties && \
    echo // force sbt compiler-bridge download > project\Dependencies.scala && \
    sbt sbtVersion && \
    sbt compile && \
    rmdir /s /q project && del build.sbt && del Temp.scala && rmdir /s /q target && \
    rmdir /s /q \temp

# CMD sbt