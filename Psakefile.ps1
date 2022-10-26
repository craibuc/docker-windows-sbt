Properties {
    $APP_NAME='windows-sbt'
    $SBT_VERSION='1.6.2'
    $GIT_VERSION='2.38.1'
    $JDK_VERSION='11.0.16.1'
}

# 

Task Build {
	Write-Host 'Building image...'
    docker build `
        --build-arg "SBT_VERSION=$SBT_VERSION" `
        --build-arg "GIT_VERSION=$GIT_VERSION" `
        --build-arg "JDK_VERSION=$JDK_VERSION" `
        --tag "$APP_NAME`:latest" `
        .
}

Task Terminal {
	Write-Host 'Starting terminal...'
    docker run -it --rm "$APP_NAME`:latest" powershell
}