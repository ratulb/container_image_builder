# container_image_builder
Build container image(optionally push to registry) 

sudo nerdctl run --rm -v $(pwd):/workspace -v ~/.docker/config.json:/workspace/config.json --env DOCKER_CONFIG=/workspace gcr.io/kaniko-project/executor -d [USER ACCPOUNT]/[IMAGE]:[TAG] -v debug
