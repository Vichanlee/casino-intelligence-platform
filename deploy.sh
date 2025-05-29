#!/bin/bash

# 🎯 Casino Intelligence Platform Deployment Script
# Automated setup for enterprise demonstration

set -e

echo "🎯 Casino Intelligence Platform - Enterprise Setup"
echo "=================================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check prerequisites
echo -e "${BLUE}Checking prerequisites...${NC}"

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed. Please install Docker Compose first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Prerequisites met${NC}"
echo ""

# Environment setup
echo -e "${BLUE}Setting up environment...${NC}"

if [ ! -f .env ]; then
    cp .env.example .env
    echo -e "${YELLOW}⚠️  Please add your OpenAI API key to .env file${NC}"
    echo -e "${YELLOW}   Edit .env and add: OPENAI_API_KEY=your_key_here${NC}"
    read -p "Press Enter after setting up your API key..."
fi

# Create necessary directories
mkdir -p logs
mkdir -p data/postgres
mkdir -p data/redis
mkdir -p data/n8n

echo -e "${GREEN}✅ Environment configured${NC}"
echo ""

# Build and start services
echo -e "${BLUE}Building and starting services...${NC}"
echo "This may take a few minutes on first run..."
echo ""

# Pull images first for faster startup
docker-compose pull

# Start database services first
echo -e "${YELLOW}Starting database services...${NC}"
docker-compose up -d postgres redis

# Wait for databases to be ready
echo -e "${YELLOW}Waiting for databases to initialize...${NC}"
sleep 30

# Start remaining services
echo -e "${YELLOW}Starting application services...${NC}"
docker-compose up -d

echo ""
echo -e "${GREEN}✅ All services started successfully!${NC}"
echo ""

# Service status check
echo -e "${BLUE}Checking service status...${NC}"
docker-compose ps
echo ""

# Display access information
echo -e "${GREEN}🎯 Casino Intelligence Platform is now running!${NC}"
echo ""
echo -e "${BLUE}Access URLs:${NC}"
echo -e "📊 ${YELLOW}Dashboard:${NC}     http://localhost:3000"
echo -e "🔧 ${YELLOW}n8n Workflows:${NC} http://localhost:5678"
echo -e "📡 ${YELLOW}Backend API:${NC}   http://localhost:3001"
echo -e "🗄️  ${YELLOW}Database:${NC}      localhost:5432"
echo ""
echo -e "${BLUE}Default Credentials:${NC}"
echo -e "🔧 ${YELLOW}n8n:${NC} admin / casino_workflows_2025"
echo ""

# Display demo instructions
echo -e "${GREEN}🚀 Demo Ready!${NC}"
echo ""
echo -e "${BLUE}Quick Demo Steps:${NC}"
echo "1. Open Dashboard: http://localhost:3000"
echo "2. View real-time competitive intelligence"
echo "3. Access n8n workflows: http://localhost:5678"
echo "4. Trigger content generation workflow"
echo "5. Monitor competitor alerts and SEO metrics"
echo ""

# Health check
echo -e "${BLUE}Running health checks...${NC}"
sleep 10

# Check if services are responding
if curl -s http://localhost:3001/ > /dev/null; then
    echo -e "${GREEN}✅ Backend API is responding${NC}"
else
    echo -e "${RED}❌ Backend API not responding${NC}"
fi

if curl -s http://localhost:3000/ > /dev/null; then
    echo -e "${GREEN}✅ Frontend is responding${NC}"
else
    echo -e "${RED}❌ Frontend not responding${NC}"
fi

if curl -s http://localhost:5678/ > /dev/null; then
    echo -e "${GREEN}✅ n8n is responding${NC}"
else
    echo -e "${RED}❌ n8n not responding${NC}"
fi

echo ""
echo -e "${GREEN}🎯 Platform deployment complete!${NC}"
echo -e "${YELLOW}Ready to demonstrate enterprise-level casino intelligence.${NC}"
echo ""

# Optional: Open browser
read -p "Open dashboard in browser? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if command -v xdg-open &> /dev/null; then
        xdg-open http://localhost:3000
    elif command -v open &> /dev/null; then
        open http://localhost:3000
    else
        echo "Please open http://localhost:3000 in your browser"
    fi
fi

echo ""
echo -e "${BLUE}For logs and monitoring:${NC}"
echo "docker-compose logs -f [service_name]"
echo ""
echo -e "${BLUE}To stop all services:${NC}"
echo "docker-compose down"
echo ""

exit 0