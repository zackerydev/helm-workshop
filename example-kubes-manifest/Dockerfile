# FROM debian:latest

# RUN apt-get update && apt-get install -y cowsay fortune

# CMD /usr/games/fortune | /usr/games/cowsay
FROM golang:latest

RUN apt-get update && apt-get install -y cowsay

WORKDIR /app
COPY . .

# RUN go build -o main .

EXPOSE 8080

CMD ["go", "run", "api.go"]
