docker build --tag=taha3azab/capstone-app:latest -f ../Dockerfile  ../app/capstone-app

docker image ls

docker run -p 8080:80 taha3azab/capstone-app:latest
