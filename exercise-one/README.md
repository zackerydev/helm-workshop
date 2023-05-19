# Exercise One: Debugging Container Startup

We are debugging the same application we deployed in the Kubes Manifest folder. [Dockerfile](../example-kubes-manifest/Dockerfile)

This will be running in the cluster under the exercise-one namespace.

```sh
curl localhost/exercise-one/cowsay\?text=winner
```

This should fail or return nothing

## Look for the pods

```
kubectl get pods -n exercise-one
```

## Describe the pod

Use the pod name from above.

```
kubectl describe pods <cowsay-f55465498-w2gjn> -n exercise-one
```

Pay attention to the Containers State and LastState values. They should help you debug the problem.

## Pushing fixes

If you want to run another deploy with Helm.

```sh
helm upgrade cowsay exercise-one -n exercise-one
```

## Done?

This should work if your done.

```sh
➜  helm-workshop git:(main) ✗ curl localhost/exercise-one/cowsay\?text=winner

  _____
< winner >
  -----
         \   ^__^
          \  (oo)\_______
             (__)\       )\/\
                 ||----w |
                 ||     ||
```
