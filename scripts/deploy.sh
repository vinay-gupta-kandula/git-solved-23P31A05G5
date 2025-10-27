#!/bin/bash
# Unified Deployment Script for DevOps Simulator
# Version: 2.1.0
# Supports both Production and Development environments

set -e

echo "====================================="
echo "DevOps Simulator - Deployment Script"
echo "====================================="

# --- Environment Selection ---
DEPLOY_ENV=${1:-"development"}  # Default is 'development' if no argument passed

echo "Selected environment: $DEPLOY_ENV"
echo "-------------------------------------"

# --- Common Pre-check ---
echo "Running pre-deployment checks..."
if [ ! -f "config/app-config.yaml" ]; then
    echo "❌ Error: Configuration file not found!"
    exit 1
fi

# --- Environment-specific Logic ---
if [ "$DEPLOY_ENV" == "production" ]; then
    echo "🚀 Starting Production Deployment..."
    DEPLOY_REGION="us-east-1"
    APP_PORT=8080

    echo "Environment: $DEPLOY_ENV"
    echo "Region: $DEPLOY_REGION"
    echo "Port: $APP_PORT"

    echo "Pulling latest Docker images..."
    # docker pull devops-simulator:latest

    echo "Applying rolling update..."
    # kubectl rolling-update devops-simulator

    echo "✅ Deployment completed successfully!"
    echo "Application available at: https://app.example.com"

elif [ "$DEPLOY_ENV" == "development" ]; then
    echo "🧩 Starting Development Deployment..."
    DEPLOY_MODE="docker-compose"
    APP_PORT=3000
    ENABLE_DEBUG=true

    echo "Mode: $DEPLOY_MODE"
    echo "Port: $APP_PORT"
    echo "Debug mode: $ENABLE_DEBUG"

    echo "Installing dependencies..."
    npm install

    echo "Running tests..."
    npm test

    echo "Starting development environment..."
    docker-compose up -d

    echo "Waiting for application to be ready..."
    sleep 5

    echo "Performing health check..."
    curl -f http://localhost:$APP_PORT/health || exit 1

    echo "✅ Development deployment completed successfully!"
    echo "Application running at: http://localhost:$APP_PORT"
    echo "Hot reload enabled - code changes will auto-refresh"

else
    echo "❌ Invalid environment! Use:"
    echo "   ./deploy.sh production"
    echo "   ./deploy.sh development"
    exit 1
fi
