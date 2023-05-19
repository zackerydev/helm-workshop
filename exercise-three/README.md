# Exercise Three

Exercise Three consists of three services.

All of the services are in the `exercise-three` namespace.

The three services are all currently **down** and it's your job to fix them!

You **do not** need to fix app code to solve this exercise, use _only_ the `kubectl` and `helm` commands we've discussed in the workshop!

## The User Service

The user service is current **down**!

```bash
curl localhost/exercise-three/user
```

This should return a list of users! But it's not working!

Dive into the cluster with `kubectl` and `helm` to figure out what's wrong!

Once this service is up:

```bash
curl localhost/exercise-three/user/users
```

should return a list of users!

## The Invoice Service

The invoice services needs to be deployed!

From the root of this repo run to attempt a deploy!

```
helm upgrade --install invoice-service exercise-three/invoice-service/chart -n exercise-three
```

Check out the cluster to see if it deployed correctly!

Once this service is up:

```bash
curl localhost/exercise-three/invoice/invoices
```

should return a list of invoices!

## The Download Service

The download service was deployed but the deployment failed! 😱

Look for the pods in the cluster and see if you can figure out what happened!

Once this service is up:

```bash
curl localhost/exercise-three/download/download
```

should return a CSV of invoices!

## Hints

- Use `kubectl get pods` to see what pods are running

- Use `helm ls` to see what helm releases are installed

- Use `helm history <release-name>` to see the history of a helm release

- Use `helm ls --pending` to see what helm releases are pending
