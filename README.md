# container_image_builder
### Building a Container Image Using [Google Kaniko Container](https://github.com/GoogleContainerTools/kaniko) on [Containerd](https://github.com/containerd/containerd) Runtime 

Containerd is an open source container runtime that provides an industry-standard container execution environment for running containers. It is designed to be lightweight, portable, and extensible. With the help of Google’s Kaniko container, you can now build and push container images to a Docker registry without having to install Docker. Here we show how to build(and push a container) image on Containerd runtime using Google Kaniko container.


#### Pre-requisite
We need to have containerd installed. Follow the steps [here](https://github.com/containerd/containerd/blob/main/docs/getting-started.md) to install containerd.

If we have a k8s cluster - we can run the container build process as a pod(Optional).

#### Install [nerdctl](https://github.com/containerd/nerdctl)

Nerdctl is a command line tool for managing containers on Containerd. It allows you to create, delete, start, stop, and inspect containers. To install Nerdctl, run the following commands: 

```bash 
wget https://github.com/containerd/nerdctl/releases/download/v1.2.0/nerdctl-1.2.0-linux-amd64.tar.gz
sudo tar Cxzvvf /usr/local/bin nerdctl-1.2.0-linux-amd64.tar.gz
rm nerdctl-1.2.0-linux-amd64.tar.gz
```

With nerdctl in place - we would need a `Dockerfile` which dictates what we want containerize. Let's use the following sample `Dockerfile`. We expect the `Dockerfile` to be present in the project root directory.

```bash 
FROM ubuntu
ENTRYPOINT ["/bin/bash", "-c", "echo hello"]
```

With the docker file in place - lets trigger container build process by running the `gcr.io/kaniko-project/executor` container. Also, we are assuming our current working directory as the project root directory for the following example:

```bash
sudo nerdctl run --rm -v $(pwd):/workspace gcr.io/kaniko-project/executor \
  --tar-path=/workspace/image.tar --no-push --destination /workspace
```

In the above build - we not pushing the image to docker registry. We are simply generating image tar file to our current working directory(/workspace inside the container). We do a directory listing - we can see the `image.tar` file in our current directory.



sudo nerdctl run --rm -v $(pwd):/workspace -v ~/.docker/config.json:/workspace/config.json --env DOCKER_CONFIG=/workspace gcr.io/kaniko-project/executor -d [USER ACCPOUNT]/[IMAGE]:[TAG] -v debug
