# Exercise One: Debugging Container Startup

Lets debug a cowsay app running in your local cluster. You should have run the setup script from the top level Readme before doing this.

[Project Setup](../README.md)
[App Readme](../cowsay-app/README.md)

## Steps

The app should be failing to run in the cluster under the `exercise-one` namespace.

The goal is to make this URL http://localhost/exercise-one/cowsay return results. It currently returns a 503.

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

To deploy any changes to your config:

```sh
helm upgrade cowsay exercise-one -n exercise-one
```

## Done?

It should look like this if your done.

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
