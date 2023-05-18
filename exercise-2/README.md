# Demo helm chart

```sh
cd basic-helm-chart
helm template demo .

---
# Source: mychart/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-deployment
  template:
    metadata:
      labels:
        app: nginx-deployment
    spec:
      containers:
      - name: nginx-deployment
        image: "nginx:latest"
        ports:
        - containerPort: 80
```

```sh
➜  basic-helm-chart git:(main) ✗ helm template demo . --set replicaCount=2 --set service.port=900
---
# Source: mychart/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx-deployment
  template:
    metadata:
      labels:
        app: nginx-deployment
    spec:
      containers:
      - name: nginx-deployment
        image: "nginx:latest"
        ports:
        - containerPort: 900
```