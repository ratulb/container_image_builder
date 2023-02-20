# container_image_builder
### Building and Pushing a Container Image on Containerd Runtime Using Google Kaniko Container

#### Pre-requisite
We need to have containerd installed. Follow the steps [here](https://github.com/containerd/containerd/blob/main/docs/getting-started.md) to install containerd.
sudo nerdctl run --rm -v $(pwd):/workspace -v ~/.docker/config.json:/workspace/config.json --env DOCKER_CONFIG=/workspace gcr.io/kaniko-project/executor -d [USER ACCPOUNT]/[IMAGE]:[TAG] -v debug
