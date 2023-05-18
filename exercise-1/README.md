# Demo helm chart

This will be running in the cluster under the exercise-1 namespace.

## Look for the pods

```
kubectl get pods -n exercise-1
```

## Describe the pod

Use the pod name from above.

```
kubectl describe <cowsay-f55465498-w2gjn> -n exercise-1
```

Pay attention to the Containers State and LastState values. They should help you debug the problem.

## Pushing fixes

If you want to run another deploy with Helm.

```sh
helm upgrade exercise-1 exercise-1 -n exercise-1
```
