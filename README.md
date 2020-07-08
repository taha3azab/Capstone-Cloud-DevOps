
# Cloud DevOps Nanodegree program

## Capstone Cloud DevOps

In this project the developed skills and knowledge were applied.

which include:
- Working in AWS.
- Using Jenkins to implement CI and CD.
- Building pipelines.
- Working with CloudFormation to deploy clusters.
- Building Kubernetes clusters.
- Building Docker containers in pipelines. 


The project uses a centralized image repository to manage images built in the project. After a clean build, images are pushed to the repository.

Execute linting step in code pipeline
Code is checked against a linter as part of a Continuous Integration step (demonstrated w/ two screenshots)

Build a Docker container in a pipeline
The project takes a Dockerfile and creates a Docker container in the pipeline.

Continuous Deployment, which includes:
- Pushing the built Docker container(s) to the Docker repository
- Deploying Docker container to a small Kubernetes cluster. 

The project performs the correct steps to do a rolling deployment into the environment selected.

