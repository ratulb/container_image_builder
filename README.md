# container_image_builder
### Building and Pushing a Container Image on Containerd Runtime Using Google Kaniko Container


sudo nerdctl run --rm -v $(pwd):/workspace -v ~/.docker/config.json:/workspace/config.json --env DOCKER_CONFIG=/workspace gcr.io/kaniko-project/executor -d [USER ACCPOUNT]/[IMAGE]:[TAG] -v debug
