# Exercise Two: Debugging App Startup

Lets debug a cowsay app running in your local cluster. You should have run the setup script from the top level Readme before doing this.

[Project Setup](../README.md)
[App Readme](../cowsay-app/README.md)

# Steps

The app should be failing to run in the cluster under the `exercise-two` namespace.

The goal is to make this URL http://localhost/exercise-two/cowsay return results. It currently returns a 503.

## Look for the pods

```
kubectl get pods -n exercise-two
```

## Describe the pod

Use the pod name from above to get more information.

```
kubectl describe pods <cowsay-f55465498-w2gjn> -n exercise-two
```

Pay attention to the Containers State and LastState values. They should help you debug the problem.

## Pushing fixes

If you want to run another deploy with Helm.

```sh
helm upgrade cowsay exercise-two -n exercise-two
```

## Done?

This should work if your done.

```sh
➜  helm-workshop git:(main) ✗ curl localhost/exercise-two/cowsay\?text=winner

  _____
< winner >
  -----
         \   ^__^
          \  (oo)\_______
             (__)\       )\/\
                 ||----w |
                 ||     ||
```