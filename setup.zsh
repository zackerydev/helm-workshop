# Setup Local Kubernetes Cluster and Registry

echo -n "🛠️ Installing Dependencies...\t\t\t"
output=`brew install --quiet kubernetes-cli helm kind tilt-dev/tap/ctlptl colima docker` 2>&1 || ((echo "❌ $output" && exit 1))
echo "✅"

echo -n "🐳 Ensuring Colima is running...\t\t"

output=`colima stop 2>&1` || (echo "❌ $output" && exit 1)

output=`colima start --disk 100  2>&1` || (echo "❌ $output" && exit 1)

echo "✅"

echo -n "☸️ Creating local Kubernetes cluster...\t\t"
# Todo figure out if we can make this port somewhat stable
#   Ignoring exit code
outout=`ctlptl apply -f setup/cluster.yaml  2>&1` || (echo "❌ $output" && exit 1)

echo "✅"

REGISTRY=$(ctlptl get cluster kind-kind -o template --template '{{.status.localRegistryHosting.host}}')

# echo "Your local registry is available at localhost:5000"

echo -n "🐋 Building Docker images...\t\t\t"

output=`docker build -f cowsay-app/Dockerfile -t $REGISTRY/cowsay:latest cowsay-app  2>&1 &` || (echo "❌ $output" && exit 1)

output=`docker build -f exercise-three/user-service/Dockerfile -t $REGISTRY/user-service:latest exercise-three/user-service  2>&1 &` || (echo "❌ $output" && exit 1)

output=`docker build -f exercise-three/download-service/Dockerfile -t $REGISTRY/download-service:latest exercise-three/download-service  2>&1 &` || (echo "❌ $output" && exit 1)

output=`docker build -f exercise-three/invoice-service/Dockerfile -t $REGISTRY/invoice-service:latest exercise-three/invoice-service  2>&1 &` || (echo "❌ $output" && exit 1)

wait

echo "✅"

echo -n "🌐 Pushing Docker images...\t\t\t"

output=`docker push $REGISTRY/cowsay:latest  2>&1 &` || (echo "❌ $output" && exit 1)

output=`docker push $REGISTRY/user-service:latest  2>&1 &` || (echo "❌ $output" && exit 1)

output=`docker push $REGISTRY/download-service:latest  2>&1 &` || (echo "❌ $output" && exit 1)

output=`docker push $REGISTRY/invoice-service:latest  2>&1 &` || (echo "❌ $output" && exit 1)

wait

echo "✅"

echo -n "⚙️ Creating namespaces...\t\t\t"

output=`kubectl create namespace exercise-three  2>&1` || (echo "❌ $output" && exit 1)

echo "✅"

echo -n "🚀 Installing services...\t\t\t"

output=`helm install cowsay exercise-two --namespace exercise-two --create-namespace  2>&1 &` || (echo "❌ $output" && exit 1)
 
output=`helm install cowsay exercise-one --namespace exercise-one --create-namespace  2>&1 &` || (echo "❌ $output" && exit 1)

output=`helm install invoice-db bitnami/postgresql --namespace exercise-three  -f exercise-three/db/values.yaml  2>&1 &` || (echo "❌ $output" && exit 1)

output=`helm install user-service exercise-three/user-service/chart --namespace exercise-three  2>&1 &` || (echo "❌ $output" && exit 1)

# Skip installing this, have people do it themselves
# helm install invoice-service exercise-three/invoice-service/chart --namespace exercise-three  2>&1 &

output=`helm install download-service exercise-three/download-service/chart --namespace exercise-three  2>&1 &` || (echo "❌ $output" && exit 1)

wait

output=`helm upgrade --install download-service exercise-three/download-service/chart --namespace exercise-three --set affinityEnabled=true --wait --timeout=4h  2>&1 &` || (echo "❌ $output" && exit 1)

echo "✅"

# Do this after the wait so we dont actually wait on it, it will fail on purpose


echo -n "⛩️ Installing nginx ingress controller...\t"

output=`kubectl apply -f setup/ingress.yaml  2>&1` || (echo "❌ $output" && exit 1)

echo "✅"

echo -n "⌚ Waiting for ingress controller to be ready..."
sleep 10
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=80s  2>&1

echo "✅"

output=`kubectl config current-context  2>&1` || (echo "❌ $output" && exit 1)

echo ""
echo "🎉 All done!"
echo ""
echo "🐳 Your local registry is available at $REGISTRY"
echo "☸️  Your local Kubernetes cluster context is kind-kind and is now your default."
