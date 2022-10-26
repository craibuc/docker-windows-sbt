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
        --tag "ghcr.io/$($env:GITHUB_ACCOUNT)/$APP_NAME" `
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