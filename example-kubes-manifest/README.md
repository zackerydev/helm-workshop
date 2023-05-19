# Deploy cowsay

Lets deploy a cowsay app to our local cluster. You should have run the setup instructions from the top level Readme before doing this.

[Project Setup](../README.md)
[App Readme](../cowsay-app/README.md)

## Steps

[kubes yaml](./manifest.yaml)

Double check your current kubectl context. Should be set to `kind-kind`.

```sh
kubectl config current-context
```

Apply the manifest to the new namespace.

```sh
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


## Exploring Kubectl commands

On your laptop run these commands (if you have access already setup)

List all deployments

`kubectl get deployments -n cowsay`

List all pods sorted by age

`kubectl get pods -n cowsay -o json --sort-by='.metadata.creationTimestamp'`

List service endpoints
`kubectl get svc -n cowsay`

List ingresses
`kubectl get ingresses -n cowsay`

List all pods with label customer-api
`kubectl get pods -n cowsay -l app=cowsay`

Delete the namespace

`kubectl delete namespace cowsay`

## Troubleshooting

```
Error from server (InternalError): error when creating "example-kubes-manifest/manifest.yaml": Internal error occurred: failed calling webhook "validate.nginx.ingress.kubernetes.io": failed to call webhook: Post "https://ingress-nginx-controller-admission.ingress-nginx.svc:443/networking/v1/ingresses?timeout=10s": dial tcp 10.96.129.223:443: connect: connection refused
```

If this happens the ingress controller is not ready yet. Wait a few seconds and try again.

