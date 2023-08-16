# Simple Express Node.js Dockerfile

# Use the official image as a parent image.

FROM node:latest

# Set the working directory.

WORKDIR /app

# Copy the file from your host to your current location.

COPY package.json pnpm-lock.yaml ./

# Run the command inside your image filesystem.

RUN npm i -g pnpm

RUN pnpm i

COPY . .

# Inform Docker that the container is listening on the specified port at runtime.

EXPOSE 3000

# Run the specified command within the container.

CMD [ "pnpm", "start" ]

