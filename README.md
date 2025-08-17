# amr_docker
Dockerfile for ROS2 jazzy on ubuntu24

step-1: change "git clone https://github.com/sahana-arulanandam/amr-prototype.git" to what ever your git is or simply just remove   that line

step-2: change <user_id> to the user id you require and <passwd> to password you want

step-3: CD into the folder that contains the Dockerfile and type in "docker build -t <container_name> ."

step-4: docker run -it --user <user_id> --entrypoint /bin/bash <your-image-name>
