# Make some kubes

Double check your current kubectl context then make a new namespace.

Apply the manifest to the new namespace.

```sh

kubectl config current-context
kubectl create namespace cowsay
kubectl apply -f example-kubes-manifest/manifest.yaml -n cowsay
```

Check the status of the pods.

```sh
kubectl get pods -n cowsay
```

Hit the ingress endpoint.

```
curl 'localhost/cowsay'
curl 'localhost/cowsay?text=C2FO+Kubes+and+Helm+Workshop'
```
