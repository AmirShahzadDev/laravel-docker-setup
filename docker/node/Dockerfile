FROM node:18-alpine

# Create a non-root user for better security
ARG NODE_USER=nodeusr
ARG NODE_GROUP=nodegrp
ARG NODE_UID=1000
ARG NODE_GID=1000
RUN addgroup -g ${NODE_GID} ${NODE_GROUP} && \
    adduser -u ${NODE_UID} -G ${NODE_GROUP} -s /bin/sh -D ${NODE_USER}

# Set working directory
WORKDIR /var/www/html

# Arguments for build process (can be overridden at build time)
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

# Install global dependencies
RUN npm install -g npm@latest

# Copy package files first (for better caching)
COPY --chown=${NODE_USER}:${NODE_GROUP} package*.json ./

# Switch to the non-root user
USER ${NODE_USER}

# Install dependencies based on the environment
RUN if [ "$NODE_ENV" = "production" ]; then \
        npm ci --only=production; \
    else \
        npm install; \
    fi

# Copy the rest of the files
# When mounting a volume in docker-compose, this will be overridden
COPY --chown=${NODE_USER}:${NODE_GROUP} . .

# Default command - this will be overridden by commands in docker-compose
CMD ["npm", "run", "build"]

