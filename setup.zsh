# Setup Local Kubernetes Cluster and Registry

echo "Installing Kubernetes CLI, Helm, Kind, and Ctlptl..."
brew install --quiet kubernetes-cli helm kind tilt-dev/tap/ctlptl
echo "Done!"

echo "Creating local Kubernetes cluster..."
# Todo figure out if we can make this port somewhat stable
#   Ignoring exit code
ctlptl create cluster kind --registry=ctlptl-registry || true
echo "Done!"

REGISTRY=$(ctlptl get cluster kind-kind -o template --template '{{.status.localRegistryHosting.host}}')

echo "Your local registry is available at $REGISTRY"

echo "Setting up Exercise 3..."

echo "Building the user service"

docker build -f exercise-3/user-service/Dockerfile -t $REGISTRY/user-service:latest exercise-3/user-service

echo "Pushing the user service to the local registry"

docker push $REGISTRY/user-service:latest

echo "Creating exercise-3 namespace"

kubectl create namespace exercise-3

echo "Installing the user service"

helm install user-service exercise-3/user-service/chart --namespace exercise-3 --set image.repository=$REGISTRY/user-service --set image.tag=latest




