# Voting System - Docker Setup

This repository contains a production-ready Docker setup for the Voting System Laravel application.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Directory Structure](#directory-structure)
3. [Initial Setup](#initial-setup)
4. [Environment Configuration](#environment-configuration)
5. [Docker Services](#docker-services)
6. [Running the Application](#running-the-application)
7. [Common Commands](#common-commands)
8. [Troubleshooting](#troubleshooting)

## Prerequisites

Before you begin, make sure you have the following software installed on your system:

- Docker and Docker Compose (latest versions recommended)
- Git

## Directory Structure

```
laravel-docker-setup/
├── docker/                      # Docker configuration files
│   ├── nginx/                   # Nginx configuration
│   │   ├── conf.d/              # Nginx server configurations
│   │   └── ssl/                 # SSL certificates for HTTPS
│   ├── php/                     # PHP configuration
│   │   ├── Dockerfile           # PHP container build instructions
│   │   └── local.ini            # PHP settings
│   ├── postgres/                # PostgreSQL configuration
│   │   └── init/                # DB initialization scripts
│   └── redis/                   # Redis configuration
│       └── redis.conf           # Redis settings
├── projects/                    # Projects directory
│   └── voting/                  # Voting application code
├── docker-compose.yml           # Docker Compose configuration
├── .env                         # Environment variables
└── README.md                    # Documentation
```

## Initial Setup

Follow these steps to set up the project:

1. Clone this repository to your local machine:
   ```
   git clone https://github.com/your-username/laravel-docker-setup.git
   cd laravel-docker-setup
   ```

2. Create a `.env` file from the example:
   ```
   cp .env.example .env
   ```

3. Modify the `.env` file with your desired settings (database credentials, etc.)

4. In case you don't already have the voting application in the projects/voting directory:
   ```
   mkdir -p projects
   cd projects
   git clone https://github.com/AmirShahzadDev/voting.git
   cd ..
   ```

## Environment Configuration

The `.env` file should contain these variables (adjust values as needed):

```
# App Environment
APP_ENV=production
APP_DEBUG=false

# Database Configuration
DB_DATABASE=voting
DB_USERNAME=postgres
DB_PASSWORD=your_secure_password

# Redis Configuration
REDIS_PASSWORD=your_secure_redis_password
```

## Docker Services

This setup includes the following services:

1. **app**: The main Laravel application container running PHP-FPM
2. **queue**: Worker for Laravel queue processing
3. **web**: Nginx web server
4. **postgres**: PostgreSQL database
5. **redis**: Redis for caching and queues
6. **pgadmin**: Web-based PostgreSQL administration tool

Each service is configured with:
- Health checks to ensure proper operation
- Volume mappings for data persistence
- Environment variables from the `.env` file
- Network configuration for service discovery
- Restart policies for high availability

## Running the Application

Access PgAdmin:
```
1. Open your browser and navigate to http://localhost:5050
2. Login with the credentials set in your .env file:
   - Email: admin@admin.com
   - Password: The value of PGADMIN_PASSWORD in your .env file
3. To connect to the database server:
   - Right click on "Servers" in the left panel and select "Create" > "Server..."
   - In the General tab, give your connection a name (e.g., "Voting Database")
   - In the Connection tab, use the following settings:
     - Host name/address: postgres (the service name from docker-compose)
     - Port: 5432
     - Maintenance database: postgres
     - Username: The value of DB_USERNAME in your .env file
     - Password: The value of DB_PASSWORD in your .env file
   - Click Save
```

Access PgAdmin:

```

1. Open your browser and navigate to http://localhost:5050

2. Login with the credentials set in your .env file:

   - Email: admin@admin.com

   - Password: The value of PGADMIN_PASSWORD in your .env file

3. To connect to the database server:

   - Right click on "Servers" in the left panel and select "Create" > "Server..."

   - In the General tab, give your connection a name (e.g., "Voting Database")

   - In the Connection tab, use the following settings:

     - Host name/address: postgres (the service name from docker-compose)

     - Port: 5432

     - Maintenance database: postgres

     - Username: The value of DB_USERNAME in your .env file

     - Password: The value of DB_PASSWORD in your .env file

   - Click Save

```



Start all services in detached mode:
```
docker-compose up -d
```

Initialize the Laravel application (first time only):
```
docker-compose exec app composer install
docker-compose exec app php artisan key:generate
docker-compose exec app php artisan migrate
docker-compose exec app php artisan db:seed  # if you want to seed the database
```

## Common Commands

Below are common Docker commands you'll need:

### Container Management

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View running containers
docker-compose ps

# View container logs
docker-compose logs -f [service_name]
```

### Executing Commands in Containers

```bash
# Run Composer commands
docker-compose exec app composer install
docker-compose exec app composer update

# Run Artisan commands
docker-compose exec app php artisan migrate
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan config:cache

# Access PostgreSQL
docker-compose exec postgres psql -U ${DB_USERNAME} -d ${DB_DATABASE}
```

### Rebuilding Containers

If you modify Dockerfile or configuration:
```bash
docker-compose build --no-cache
docker-compose up -d
```

## Troubleshooting

### Service Won't Start

Check logs for errors:
```
docker-compose logs -f [service_name]
```

### Database Connection Issues

Make sure environment variables are correctly set:
```
docker-compose exec app php artisan env
```

### Permission Issues

If you encounter permission problems with mounted volumes:
```
docker-compose exec app chown -R www-data:www-data /var/www/html/storage
```

### Health Check Failures

If services are failing health checks:
```
docker inspect [container_name] | grep Health
```
