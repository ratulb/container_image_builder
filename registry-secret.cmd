
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=$HOME/.docker/config.json \ #Replace with your docker config json
    --type=kubernetes.io/dockerconfigjson
