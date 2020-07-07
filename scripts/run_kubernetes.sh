#!/usr/bin/env bash

# Step 1:
# This is the Docker ID/path
dockerpath="taha3azab/capstone-app"

# Step 2
# Run the Docker Hub container with kubernetes
kubectl run capstone-app --image=$dockerpath --port=80


# Step 3:
# List kubernetes pods
kubectl get pods


# Step 4:
# Forward the container port to a host
kubectl expose deployment capstone-app --type=LoadBalancer --port=80

# Open the service 
# minikube service capstone-app