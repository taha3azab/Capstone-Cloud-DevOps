@echo off

docker build --tag=taha3azab/capstone-app:latest -f ./src/capstone-app/Dockerfile  ./src/capstone-app

docker image ls

docker run -p 8080:80 taha3azab/capstone-app:latest
