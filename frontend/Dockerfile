# Use the official Node.js image as the base image
FROM node:16.8-alpine

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json into the working directory
COPY package*.json ./

# Install the dependencies
RUN npm clean-install

# Copy the rest of the application code into the working directory
COPY . .

# Build the Next.js application
RUN npm run build

# Expose the port the application will run on
EXPOSE 3000

# Start the application
CMD ["npm", "run", "start"]
