# Use the official Node.js image as the base image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install client dependencies
RUN npm install

# Copy the client code to the container
COPY . .

# Change directory to the client folder
WORKDIR /usr/src/app/client

# Start the client
CMD ["node", "index.js"]
