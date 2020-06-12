# Step 1:
# Build image and add a descriptive tag
docker build --tag=taha3azab/capstone-app:latest -f ./src/capstone-app/Dockerfile  ./src/capstone-app

# Step 2: 
# List docker images
docker image ls

# Step 3: 
# Run create-react-app
docker run -p 8080:80 taha3azab/capstone-app:latest
