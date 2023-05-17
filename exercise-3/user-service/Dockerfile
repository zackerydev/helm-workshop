# Golang Dockerfile to run the "api.go" file

# Start from the latest golang base image
FROM golang:latest

# Set the Current Working Directory inside the container

WORKDIR /app

# Copy everything from the current directory to the PWD(Present Working Directory) inside the container

COPY . .

# This container exposes port 8080 to the outside world

EXPOSE 8080

# Run the executable

CMD ["go", "run", "api.go"]
