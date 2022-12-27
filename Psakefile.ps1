Properties {
    $WIN_VERSION='ltsc2019-amd64'
    $SCALA_VERSION='2.13.10'
    $SBT_VERSION='1.6.2'
    $JDK_VERSION='11.0.16.1'
    $APP_NAME='windows-sbt'
}

Task Build {
	Write-Host 'Building image...'
    docker build `
        --build-arg "WIN_VERSION=$WIN_VERSION" `
        --build-arg "SCALA_VERSION=$SCALA_VERSION" `
        --build-arg "SBT_VERSION=$SBT_VERSION" `
        --build-arg "JDK_VERSION=$JDK_VERSION" `
        --tag "$APP_NAME`:latest" `
        .
}

Task Terminal {
	Write-Host 'Starting terminal...'
    docker run -it --rm "$APP_NAME`:latest" powershell
}

Task Publish {
	Write-Host 'Publishing image to Github...'
	$env:GITHUB_TOKEN | docker login ghcr.io -u $env:GITHUB_ACCOUNT --password-stdin
    docker tag $APP_NAME "ghcr.io/$($env:GITHUB_ACCOUNT)/$APP_NAME"
	docker push "ghcr.io/$($env:GITHUB_ACCOUNT)/$APP_NAME`:latest"
}