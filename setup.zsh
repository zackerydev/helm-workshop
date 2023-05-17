# Setup Local Kubernetes Cluster and Registry

echo "Installing Kubernetes CLI, Helm, Kind, and Ctlptl..."
brew install --quiet kubernetes-cli helm kind tilt-dev/tap/ctlptl
echo "Done!"

echo "Stopping colima to assure disk size..."
#
# colima stop
#
# colima start --disk 100

echo "Creating local Kubernetes cluster..."
# Todo figure out if we can make this port somewhat stable
#   Ignoring exit code
ctlptl apply -f setup/cluster.yaml || true

echo "Done!"

REGISTRY=$(ctlptl get cluster kind-kind -o template --template '{{.status.localRegistryHosting.host}}')

echo "Your local registry is available at localhost:5000"


echo "Setting up Exercise 3..."

echo "Building the user service"

docker build -f exercise-3/user-service/Dockerfile -t $REGISTRY/user-service:latest exercise-3/user-service

echo "Building the frontend"

docker build -f exercise-3/frontend/Dockerfile -t $REGISTRY/frontend:latest exercise-3/frontend

echo "Pushing images to the local registry"

docker push $REGISTRY/user-service:latest

docker push $REGISTRY/frontend:latest

echo "Creating exercise-3 namespace"

kubectl create namespace exercise-3

echo "Installing the user service"

helm install user-service exercise-3/user-service/chart --namespace exercise-3 --set image.repository=$REGISTRY/user-service --set image.tag=latest

echo "Installing the frontend"

helm install frontend exercise-3/frontend/chart --namespace exercise-3 --set image.repository=$REGISTRY/frontend --set image.tag=latest

echo "Installing nginx ingress controller"

kubectl apply -f setup/ingress.yaml

echo "Wait for ingress controller to be ready"
sleep 10
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=60s
