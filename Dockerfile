# Base Image
FROM ubuntu:latest AS base

# Set Environment Variables
ARG PGUSER_SUPERUSER=postgres
ARG PGPASSWORD_SUPERUSER=postgres
ARG PG_DATABASE_HOST=db:5432
ARG SERVER_URL
ARG REDIS_URL=redis://redis:6379
ARG STORAGE_TYPE
ARG STORAGE_S3_REGION
ARG STORAGE_S3_NAME
ARG STORAGE_S3_ENDPOINT
ARG APP_SECRET

# Install Dependencies
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and Yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn

# Set Work Directory
WORKDIR /app

# Copy Application Files (Modify if needed)
COPY . /app

# Ensure Required Directories Exist
RUN mkdir -p /app/packages/twenty-server/.local-storage /app/docker-data

# Set Volume Paths
VOLUME /app/packages/twenty-server/.local-storage
VOLUME /app/docker-data
VOLUME /home/postgres/pgdata

# Change Ownership of Volumes
RUN chown -R 1000:1000 /app/packages/twenty-server/.local-storage \
    && chown -R 1000:1000 /app/docker-data

# Install Project Dependencies
RUN yarn install --frozen-lockfile

# Expose Ports
EXPOSE 3000

# Set Default Command
CMD ["yarn", "start"]
