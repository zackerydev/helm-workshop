# Setup Local Kubernetes Cluster and Registry

echo -n "🛠️ Installing Dependencies...\t\t\t"
brew install --quiet kubernetes-cli helm kind tilt-dev/tap/ctlptl
echo "✅"

echo -n "🐳 Ensuring Colima is running...\t\t"

colima stop > /dev/null 2>&1

colima start --disk 100 > /dev/null 2>&1

echo "✅"

echo -n "☸️ Creating local Kubernetes cluster...\t\t"
# Todo figure out if we can make this port somewhat stable
#   Ignoring exit code
ctlptl apply -f setup/cluster.yaml > /dev/null 2>&1 || true

echo "✅"

REGISTRY=$(ctlptl get cluster kind-kind -o template --template '{{.status.localRegistryHosting.host}}')

# echo "Your local registry is available at localhost:5000"

echo -n "🐋 Building Docker images...\t\t\t"

docker build -f cowsay-app/Dockerfile -t $REGISTRY/cowsay:latest cowsay-app > /dev/null 2>&1 &

docker build -f exercise-three/user-service/Dockerfile -t $REGISTRY/user-service:latest exercise-three/user-service > /dev/null 2>&1 &

docker build -f exercise-three/download-service/Dockerfile -t $REGISTRY/download-service:latest exercise-three/download-service > /dev/null 2>&1 &

docker build -f exercise-three/invoice-service/Dockerfile -t $REGISTRY/invoice-service:latest exercise-three/invoice-service > /dev/null 2>&1 &

wait

echo "✅"

echo -n "🌐 Pushing Docker images...\t\t\t"

docker push $REGISTRY/cowsay:latest > /dev/null 2>&1 &

docker push $REGISTRY/user-service:latest > /dev/null 2>&1 &

docker push $REGISTRY/download-service:latest > /dev/null 2>&1 &

docker push $REGISTRY/invoice-service:latest > /dev/null 2>&1 &

wait

echo "✅"

echo -n "⚙️ Creating namespaces...\t\t\t"

kubectl create namespace exercise-three > /dev/null 2>&1

echo "✅"

echo -n "🚀 Installing services...\t\t\t"

helm install cowsay exercise-two --namespace exercise-two --create-namespace > /dev/null 2>&1 &
 
helm install cowsay exercise-one --namespace exercise-one --create-namespace > /dev/null 2>&1 &

helm install invoice-db bitnami/postgresql --namespace exercise-three  -f exercise-three/db/values.yaml > /dev/null 2>&1 &

helm install user-service exercise-three/user-service/chart --namespace exercise-three > /dev/null 2>&1 &

helm install invoice-service exercise-three/invoice-service/chart --namespace exercise-three > /dev/null 2>&1 &

helm install download-service exercise-three/download-service/chart --namespace exercise-three > /dev/null 2>&1 &

wait

helm upgrade --install download-service exercise-three/download-service/chart --namespace exercise-three --set affinityEnabled=true --wait > /dev/null 2>&1 &

echo "✅"

# Do this after the wait so we dont actually wait on it, it will fail on purpose


echo -n "⛩️ Installing nginx ingress controller...\t"

kubectl apply -f setup/ingress.yaml > /dev/null 2>&1

echo "✅"

echo -n "⌚ Waiting for ingress controller to be ready..."
sleep 10
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=80s > /dev/null 2>&1

echo "✅"

kubectl config current-context > /dev/null 2>&1

echo ""
echo "🎉 All done!"
echo ""
echo "🐳 Your local registry is available at $REGISTRY"
echo "☸️  Your local Kubernetes cluster context is kind-kind and is now your default."
