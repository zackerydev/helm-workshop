# Demo helm chart


## Template

```sh
cd basic-helm-chart
helm template demo .
```

Notice the output is the different than the original template.

```sh
helm template demo . --set replicaCount=2 --set service.port=900
```

## Install

Lets watch the pods and see what happens. Can use k9s as well if you have it installed.

```sh
kubectl get pods --watch --all-namespaces
```

Go install the helm chart.

```sh
helm install demo . -n helmsay --create-namespace
```

Hit the endpoint

```sh
curl localhost/helmsay/cowsay\?text=mooooo
```

## Check the history

```
helm history demo -n helmsay
```

## Upgrade

Keep watching the pods and upgrade the helm chart.


```sh
helm upgrade demo . -n helmsay --set replicaCount=3 --set ingress.path=/moo
```

Hit the endpoint

```sh
curl localhost/moo/cowsay\?text=running+on+slash+moo
```

## Rollback

Watch the pods go bye bye

```sh
helm rollback demo -n helmsay
kubectl get pods -n helmsay
```

```sh
curl localhost/helmsay/cowsay\?text=mooooo
```

Check the history again. We should see the rollback now.

```sh
helm history demo -n helmsay
```

## Get Value

```sh
helm get values demo -n helmsay
helm get values demo -n helmsay --revision 1
```

## Delete

```sh
helm uninstall demo -n helmsay
kubectl delete namespace helmsay
```
