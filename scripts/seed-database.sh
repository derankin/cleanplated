#!/bin/bash

# CleanPlated Database Seeding Script
# This script populates the local development database with restaurant data

set -e

echo "🌱 Starting database seeding..."

# Check if postgres is running
if ! docker ps | grep -q cleanplated-postgres; then
    echo "❌ PostgreSQL container not running. Please start the main services first:"
    echo "   docker compose up -d postgres redis backend"
    exit 1
fi

# Check if database is ready
echo "⏳ Waiting for database to be ready..."
docker compose exec postgres pg_isready -U cleanplated -d cleanplated
if [ $? -ne 0 ]; then
    echo "❌ Database is not ready. Please wait for PostgreSQL to start completely."
    exit 1
fi

echo "📊 Running data ingestion (this may take a few minutes)..."
docker compose --profile seed run --rm seed

echo "✅ Database seeding completed!"
echo ""
echo "🔍 To verify the data was loaded, you can check:"
echo "   curl http://localhost:18080/api/v1/facilities?limit=5"
echo ""
echo "🌐 The frontend should now display restaurants when you visit:"
echo "   http://localhost:15173"