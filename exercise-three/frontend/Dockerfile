# Docker file to build and run a vite app with nginx

# Base image
FROM node:latest

# Create app directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json ./
COPY pnpm-lock.yaml ./

# Install dependencies

RUN npm install -g pnpm

RUN pnpm install

# Copy app source code

COPY . .

# Build app

RUN pnpm run build

# Install nginx

RUN apt-get update && apt-get install -y nginx

# Remove default nginx website

RUN rm -rf /var/www/html/*

# Copy nginx config

COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built app to nginx public folder

RUN cp -r dist/* /var/www/html

# Expose port 80

EXPOSE 80

# Start nginx

CMD ["nginx", "-g", "daemon off;"]







