kubectl delete pod kaniko
sleep 1
kubectl delete persistentvolumeclaims dockerfile-claim
sleep 1
kubectl delete persistentvolume dockerfile
sleep 1
kubectl apply -f volume.yaml
sleep 1
kubectl apply -f volume-claim.yaml
kubectl apply -f pod.yaml
sleep 1
kubectl logs kaniko
sleep 1
kubectl logs kaniko
