FROM golang:latest

WORKDIR /app

COPY . .

# RUN go build -o main .

EXPOSE 8080

RUN go build api.go

CMD ["go", "run", "api.go"]
