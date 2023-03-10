# Use a Node.js base image with version 14
FROM node:18-alpine

# Create a non-root user and group with a specific UID and GID
RUN addgroup --gid 10014 mygroup \
    && adduser --uid 10014 --ingroup mygroup --disabled-password myuser

# Create a directory to hold the application code
WORKDIR /app

# Copy package.json and package-lock.json files to the container
COPY package*.json ./

# Install the application dependencies
RUN npm install

# Copy the application code to the container
COPY . .

# Set the ownership of the application files to the non-root user and group
RUN chown -R myuser:mygroup /app

# Expose the port that the application will listen on
EXPOSE 3000

# Start the application as the non-root user
USER 10014

# Start the application
CMD ["node", "main.js"]
