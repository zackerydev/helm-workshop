# Exercise 2 - Debugging App Startup

This will be running in the cluster under the exercise-two namespace.

## Look for the pods

```
kubectl get pods -n exercise-two
```

## Describe the pod

Use the pod name from above.

```
kubectl describe <cowsay-f55465498-w2gjn> -n exercise-two
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