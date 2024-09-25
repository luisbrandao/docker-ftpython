Docker debug container.

kubectl run ftpython --image registry.hub.docker.com/techmago/docker-ftpython
kubectl exec -it ftpython bash
kubectl delete pod ftpython
