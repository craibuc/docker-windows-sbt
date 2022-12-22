ARG WIN_VERSION=ltsc2019-amd64

FROM mcr.microsoft.com/windows/servercore:${WIN_VERSION}

ARG SBT_VERSION=1.8.0
ARG GIT_VERSION=2.38.1
ARG JDK_VERSION=11.0.16.1

WORKDIR /temp

#
# git (version control)
#

# retrieve and install package
RUN curl -L -o Git-%GIT_VERSION%-64-bit.exe https://github.com/git-for-windows/git/releases/download/v%GIT_VERSION%.windows.1/Git-%GIT_VERSION%-64-bit.exe
RUN .\Git-%GIT_VERSION%-64-bit.exe /VERYSILENT /NORESTART

# RUN scoop install git

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
