# docker-babylon
Docker image for the Babylon chain in cosmos

# Building images to linux/amd64/v3 locally.
If you're building Docker images on a Macbook using Docker Desktop, by default, it builds images for the linux/arm64/v8 architecture since Docker Desktop runs on an Apple M1 chip, which is based on ARM architecture. To build Docker images for the linux/amd64/v3 architecture on your Macbook, you have a few options:

Use Docker Buildx:
Docker Buildx is a Docker CLI plugin that provides extended build capabilities with BuildKit. It supports building images for multiple platforms, including linux/amd64. Here's how you can use it:

bash
Copy code
# Enable experimental features
export DOCKER_CLI_EXPERIMENTAL=enabled

# Create a new builder instance
docker buildx create --use --name mybuilder

# Build the image using the builder instance
docker buildx build --platform linux/amd64 -t your_image_name:your_version .
This will build the image for the linux/amd64/v3 architecture.

Use Docker Desktop with Rosetta 2:
If you're using an Apple M1 chip, you can run Docker Desktop using Rosetta 2 translation, which allows running Intel-based (x86_64) applications on ARM-based Macs. This way, Docker Desktop will run in the x86_64 emulation mode, and you can build images for the linux/amd64/v3 architecture.

To enable Rosetta 2 for Docker Desktop:

Right-click on Docker Desktop in the Applications folder.
Select "Get Info."
Check the box next to "Open using Rosetta."
After enabling Rosetta 2, Docker Desktop will run in the x86_64 emulation mode, allowing you to build images for the linux/amd64/v3 architecture.

Use a Remote Docker Host:
You can set up a remote Docker host running on a Linux machine and build your images there. This way, you can ensure that the images are built for the linux/amd64/v3 architecture.

Choose the option that best fits your requirements and environment.
