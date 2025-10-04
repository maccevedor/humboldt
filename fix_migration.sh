#!/bin/bash

echo "Fixing migration conflict..."

# Stop backend container
echo "1. Stopping backend container..."
docker-compose stop backend

# Remove conflicting migration file
echo "2. Removing conflicting migration..."
sudo rm -f visor-geografico-I2D-backend/applications/projects/migrations/0001_add_color_to_layergroup.py

# Copy correct migration
echo "3. Copying correct migration..."
sudo cp /tmp/0002_layergroup_color.py visor-geografico-I2D-backend/applications/projects/migrations/

# Fix permissions
echo "4. Fixing permissions..."
sudo chown $USER:$USER visor-geografico-I2D-backend/applications/projects/migrations/0002_layergroup_color.py

# Start backend
echo "5. Starting backend..."
docker-compose start backend

# Wait for backend to start
echo "6. Waiting for backend to start..."
sleep 5

# Apply migration
echo "7. Applying migration..."
docker-compose exec -T backend python manage.py migrate projects

echo "Done! Migration applied successfully."
echo ""
echo "To verify, run:"
echo "  docker-compose logs backend | tail -20"
