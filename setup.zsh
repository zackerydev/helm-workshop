# Exit if any command fails
set -e
# Setup Local Kubernetes Cluster and Registry

echo "🛠️ Installing Dependencies..."

brew install --quiet kubernetes-cli helm tilt-dev/tap/ctlptl colima

# Install Kind v0.19.0 with curl as only v0.20.0 is available via Brew and it has a bug that causes Colima to fail https://github.com/kubernetes-sigs/kind/issues/3277
[ $(uname -m) = x86_64 ] && curl -Lo ${HOME}/local/bin/kind https://kind.sigs.k8s.io/dl/v0.19.0/kind-darwin-amd64 
[ $(uname -m) = arm64 ] && curl -Lo ${HOME}/local/bin/kind https://kind.sigs.k8s.io/dl/v0.19.0/kind-darwin-arm64 
chmod +x ${HOME}/local/bin/kind
# mv ./kind $HOME/.local/bin
export PATH=$PATH:$HOME/local/bin

echo "✅ Done!\n\n"

echo "🐳 Ensuring Colima is running..."

colima stop

colima start --disk 100

# output=`colima stop 2>&1` || (echo "❌ $output" && exit 1)
#
# output=`colima start --disk 100  2>&1` || (echo "❌ $output" && exit 1)

echo "✅ Done!\n\n"

echo "🚢 Creating local Kubernetes cluster..."
# Todo figure out if we can make this port somewhat stable
#   Ignoring exit code
ctlptl apply -f setup/cluster.yaml 

echo "✅ Done!\n\n"

REGISTRY=$(ctlptl get cluster kind-kind -o template --template '{{.status.localRegistryHosting.host}}')

# echo "Your local registry is available at localhost:5000"

echo  "🐋 Building Docker images..."

docker build -q -f cowsay-app/Dockerfile -t $REGISTRY/cowsay:latest cowsay-app & 

docker build -q -f exercise-three/user-service/Dockerfile -t $REGISTRY/user-service:latest exercise-three/user-service &

docker build -q -f exercise-three/download-service/Dockerfile -t $REGISTRY/download-service:latest exercise-three/download-service &

docker build -q -f exercise-three/invoice-service/Dockerfile -t $REGISTRY/invoice-service:latest exercise-three/invoice-service &

wait

echo "✅ Done!\n\n"

echo  "🌐 Pushing Docker images..."

docker push -q $REGISTRY/cowsay:latest  &

docker push -q $REGISTRY/user-service:latest  &

docker push -q $REGISTRY/download-service:latest  &

docker push -q $REGISTRY/invoice-service:latest  &

wait

echo "✅ Done!\n\n"

echo  "⚙️ Creating namespaces..."

kubectl create namespace exercise-one &
kubectl create namespace exercise-two &
kubectl create namespace exercise-three &

wait

echo "✅ Done!\n\n"

echo  "🚀 Installing services...t"

helm install cowsay exercise-two --namespace exercise-two &

helm install cowsay exercise-one --namespace exercise-one &

helm install invoice-db bitnami/postgresql --namespace exercise-three  -f exercise-three/db/values.yaml &

helm install user-service exercise-three/user-service/chart --namespace exercise-three &

# Skip installing this, have people do it themselves
# helm install invoice-service exercise-three/invoice-service/chart --namespace exercise-three  2>&1 &

helm install download-service exercise-three/download-service/chart --namespace exercise-three &

wait

helm upgrade --install download-service exercise-three/download-service/chart --namespace exercise-three --set affinityEnabled=true --wait --timeout=4h & 

echo "✅ Done!\n\n"

# Do this after the wait so we dont actually wait on it, it will fail on purpose


echo  "⛩️ Installing nginx ingress controller..."

kubectl apply -f setup/ingress.yaml

echo "✅ Done!\n\n"

echo  "⌚ Waiting for ingress controller to be ready..."
sleep 10
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=300s  > /dev/null

echo "✅ Done!\n\n"

echo ""
echo "🎉 All done!"
echo ""
echo "🐳 Your local registry is available at $REGISTRY"
echo "☸️  Your local Kubernetes cluster context is kind-kind and is now your default."
