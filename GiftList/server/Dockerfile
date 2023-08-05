# Use the official Node.js image as the base image
FROM node:14

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install server dependencies
RUN npm install

# Copy the server code to the container
COPY . .

# Change directory to the server folder
WORKDIR /usr/src/app/server

# Expose the port the server will run on
EXPOSE 1225

# Start the server
CMD ["node", "index.js"]
