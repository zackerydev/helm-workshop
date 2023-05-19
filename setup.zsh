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

echo "Setting up Kubes demo"

docker build -f cowsay-app/Dockerfile -t $REGISTRY/cowsay:latest cowsay-app &

docker build -f exercise-three/user-service/Dockerfile -t $REGISTRY/user-service:latest exercise-three/user-service &

docker build -f exercise-three/download-service/Dockerfile -t $REGISTRY/download-service:latest exercise-three/download-service &

docker build -f exercise-three/invoice-service/Dockerfile -t $REGISTRY/invoice-service:latest exercise-three/invoice-service &

wait

docker push $REGISTRY/cowsay:latest &

docker push $REGISTRY/user-service:latest &

docker push $REGISTRY/download-service:latest &

docker push $REGISTRY/invoice-service:latest &

wait

echo "Creating namespaces"

kubectl create namespace exercise-three

echo "Installing services..."

helm install cowsay exercise-two --namespace exercise-two --create-namespace &
 
helm install cowsay exercise-one --namespace exercise-one --create-namespace &

helm install invoice-db bitnami/postgresql --namespace exercise-three  -f exercise-three/db/values.yaml &

helm install user-service exercise-three/user-service/chart --namespace exercise-three &

helm install invoice-service exercise-three/invoice-service/chart --namespace exercise-three &

helm install download-service exercise-three/download-service/chart --namespace exercise-three &

wait

# Do this after the wait so we dont actually wait on it, it will fail on purpose

helm install download-service exercise-three/download-service/chart --namespace exercise-three --set affinityEnabled=true --wait &

echo "Installing nginx ingress controller"

kubectl apply -f setup/ingress.yaml

echo "Wait for ingress controller to be ready"
sleep 10
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=80s


kubectl config current-context
