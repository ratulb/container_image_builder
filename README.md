# container_image_builder
### Building a Container Image Using [Google Kaniko Container](https://github.com/GoogleContainerTools/kaniko) on [Containerd](https://github.com/containerd/containerd) Runtime 

Containerd is an open source container runtime that provides an industry-standard container execution environment for running containers. It is designed to be lightweight, portable, and extensible. With the help of Google’s Kaniko container, you can build and push container images to a Docker registry(or any other) without having to install Docker. Here we show how to build(and push a container) image on Containerd runtime using Google Kaniko container.


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

#### Push to docker registry lauching kaniko container

With the docker file in place - lets trigger container build process by running the `gcr.io/kaniko-project/executor` container. Also, we are assuming our current working directory as the project root directory for the following example:

```bash
sudo nerdctl run --rm -v $(pwd):/workspace -v ~/.docker/config.json:/workspace/config.json \
--env DOCKER_CONFIG=/workspace gcr.io/kaniko-project/executor -d ratulb/echo:1.1.1 -v debug
```

-  The command starts by using `nerdctl` to launch the `gcr.io/kaniko-project/executor` container in containerd. This container is used to create and push a container image to a Docker registry. 

-  The command then mounts the current working directory `(pwd)` to the workspace directory inside the container. This allows the executor to access any files or directories that are needed for building and pushing the image. 

-  The command also mounts the user's Docker configuration file (`config.json`) into the workspace directory inside the container. This allows Kaniko to authenticate with the Docker registry when pushing images. 

-  The command then sets an environment variable, `DOCKER_CONFIG`, which points to the mounted `config.json` file in order for Kaniko to use it for authentication purposes. 

-  Finally, the command specifies that Kaniko should build and push an image with tag `ratulb/echo:1.1.1` and run in debug mode so that more detailed output is provided during execution of Kaniko commands.

Now we can launch the container:

```bash
sudo nerdctl run ratulb/echo:1.1.1
hello
```
**We can also place the generated container to a local archive without pushing it to any registry:**

```bash
sudo nerdctl run --rm -v $(pwd):/workspace gcr.io/kaniko-project/executor
  --tar-path=/workspace/image.tar --no-push --destination /workspace -v debug
```

We need to provide the `--tar-path` and `--no-push` flags for that.

#### Push to docker registry lauching kaniko as a pod in k8s cluster

We can also run kaniko as one-shot container to build our container and push it to docker registry. For that - we would need to create a `storage volume` in our k8s cluster and make that volume available to `kaniko` pod via `volume claim`. Also, we would need create a docker registry secret and provide it to `kaniko` pod so that it can authenticate with docker registry to push to created container. We detail the steps below:

-  The `registry-secret.cmd` file has the `kubectl` command to create the `secret` that would be used by the `kaniko` container to authenicate itself with docker registry before it pushes the generated image to the registry.
-  The volume respure defintion is defined in `volume.yaml` and the corresponding volume claim in `volume-claim.yaml` file.
-  `kaniko-pod.yaml` holds the pod defintion for the `kaniko pod` itself. All the required resources for kaniko pod is speficied in this yaml resource defintion file.
-  Finally - we can run the `create-image.sh` script which combines all steps and executes them in order. The successful output should look as shown below:

```bash
**kubectl logs kaniko**
DEBU[0000] Copying file /workspace/Dockerfile to /kaniko/Dockerfile 
DEBU[0002] Skip resolving path /kaniko/Dockerfile       
DEBU[0002] Skip resolving path /workspace               
DEBU[0002] Skip resolving path /cache                   
DEBU[0002] Skip resolving path                          
DEBU[0002] Skip resolving path                          
DEBU[0002] Skip resolving path                          
DEBU[0002] Skip resolving path                          
DEBU[0002] Built stage name to index map: map[]         
INFO[0002] Retrieving image manifest ubuntu             
INFO[0002] Retrieving image ubuntu from registry index.docker.io 
INFO[0004] Built cross stage deps: map[]                
INFO[0004] Retrieving image manifest ubuntu             
INFO[0004] Returning cached image manifest              
INFO[0004] Executing 0 build triggers                   
INFO[0004] Building stage 'ubuntu' [idx: '0', base-idx: '-1'] 
INFO[0004] Skipping unpacking as no commands require it. 
INFO[0004] ENTRYPOINT ["/bin/bash", "-c", "echo hello"] 
DEBU[0004] Build: skipping snapshot for [ENTRYPOINT ["/bin/bash", "-c", "echo hello"]] 
DEBU[0004] Mapping stage idx 0 to digest sha256:6c7f12d9981293a0c6e0d41ebe1d5c5e8df640d88a022cf21763d7ad4e766d72 
DEBU[0004] Mapping digest sha256:6c7f12d9981293a0c6e0d41ebe1d5c5e8df640d88a022cf21763d7ad4e766d72 to cachekey  
INFO[0004] Pushing image to ratulb/echo-hello:3.3.3     

```

