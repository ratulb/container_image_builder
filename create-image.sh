# Delete existing secret
kubectl delete secrets regcred
sleep 1
# Create registry secret
. registry-secret.cmd
# Delete kaniko pod
kubectl delete pod kaniko
sleep 1
# Delete volume claim
kubectl delete persistentvolumeclaims dockerfile-claim
sleep 1
# Delete volume
kubectl delete persistentvolume dockerfile
sleep 1
# Recreate every thing
kubectl apply -f volume.yaml
sleep 1
kubectl apply -f volume-claim.yaml
kubectl apply -f pod.yaml
sleep 1
kubectl logs kaniko
sleep 1
kubectl logs kaniko
