# Git Repository Setup Guide
## Organizing the Visor-I2D Unified Repository

This guide helps you properly set up the Git repository with submodules for both frontend and backend projects.

---

## 🎯 Current Situation

You have:
- ✅ Initialized Git repository (`git init`)
- ✅ Created `.gitmodules` file
- ✅ Both project folders exist in root directory
- ❌ Need to convert folders to proper Git submodules
- ❌ Need to organize files properly

---

## 🚀 Quick Setup Steps

### Step 1: Make Scripts Executable
```bash
chmod +x scripts/git-setup.sh
chmod +x scripts/db-setup.sh
```

### Step 2: Run the Git Setup Script
```bash
# This will clean up and properly set up submodules
./scripts/git-setup.sh init
```

### Step 3: Commit the Initial Setup
```bash
# Add all files to Git
git add .

# Commit the unified repository setup
git commit -m "Initial unified repository setup with Docker Compose and submodules"
```

### Step 4: Verify Everything is Working
```bash
# Check repository status
./scripts/git-setup.sh status

# Verify Docker setup
docker-compose config

# Test database setup
./scripts/db-setup.sh status
```

---

## 📁 Final Repository Structure

After running the setup, your repository should look like this:

```
humboldt/                              # Root repository
├── .git/                             # Git repository data
├── .gitignore                        # Ignores submodule content, logs, etc.
├── .gitmodules                       # Submodule configuration
├──
├── docker-compose.yml                # Main orchestration file
├── DOCKER_SETUP_README.md           # Comprehensive Docker guide
├── GIT_SETUP_README.md              # This file
├── LEARNING_PLAN.md                 # Technology learning guide
├── UPGRADE_STRATEGY.md              # Modernization planning
├──
├── scripts/                         # Management scripts
│   ├── git-setup.sh                # Git and submodule management
│   ├── db-setup.sh                 # Database management
│   └── init-db.sql                 # Database initialization
├──
├── nginx/                           # Nginx configuration
│   ├── nginx.conf                  # Main Nginx config
│   └── default.conf                # Server configuration
├──
├── backups/                         # Database backups (ignored)
│   └── .gitkeep                    # Preserve directory
├──
├── logs/                            # Application logs (ignored)
│   └── .gitkeep                    # Preserve directory
├──
├── visor-geografico-I2D/           # Frontend submodule
│   └── (managed by Git submodule)
└──
└── visor-geografico-I2D-backend/   # Backend submodule
    └── (managed by Git submodule)
```

---

## 🔧 Git Submodule Management

### Common Commands
```bash
# Initialize repository with submodules
./scripts/git-setup.sh init

# Update submodules to latest versions
./scripts/git-setup.sh update

# Check repository and submodule status
./scripts/git-setup.sh status

# Verify setup is correct
./scripts/git-setup.sh verify

# Fix file permissions
./scripts/git-setup.sh permissions
```

### Manual Submodule Commands
```bash
# Update submodules manually
git submodule update --remote --merge

# Initialize submodules after cloning
git submodule init
git submodule update

# Check submodule status
git submodule status
```

---

## 🐛 Troubleshooting

### Issue: Submodule directories already exist
```bash
# Clean up and reinitialize
./scripts/git-setup.sh clean
./scripts/git-setup.sh init
```

### Issue: Permission denied on scripts
```bash
# Fix permissions
chmod +x scripts/*.sh
./scripts/git-setup.sh permissions
```

### Issue: Git submodule conflicts
```bash
# Remove submodules from Git index
git rm --cached visor-geografico-I2D
git rm --cached visor-geografico-I2D-backend

# Clean up directories
rm -rf visor-geografico-I2D visor-geografico-I2D-backend

# Reinitialize
./scripts/git-setup.sh init
```

---

## 📋 What the .gitignore Does

The `.gitignore` file excludes:
- ✅ **Submodule content** - Git tracks them as submodules, not regular folders
- ✅ **Docker volumes** - postgres_data, redis_data, etc.
- ✅ **Logs and backups** - Generated files that shouldn't be in version control
- ✅ **Environment files** - .env, secrets, etc.
- ✅ **IDE files** - .vscode settings, .idea, etc.
- ✅ **OS files** - .DS_Store, Thumbs.db, etc.

---

## 🎯 Next Steps After Git Setup

1. **Start the development environment:**
   ```bash
   docker-compose up -d
   ```

2. **Setup the database:**
   ```bash
   ./scripts/db-setup.sh setup
   ```

3. **Access the applications:**
   - Frontend: http://localhost
   - Backend: http://localhost:8001
   - Admin: http://localhost/admin/

4. **Development workflow:**
   - Work on submodules independently
   - Update main repository when needed
   - Use Docker for consistent environment

---

## 🔄 Working with Submodules

### Making Changes to Submodules
```bash
# Enter a submodule
cd visor-geografico-I2D

# Make changes, commit them
git add .
git commit -m "Your changes"
git push

# Return to main repository
cd ..

# Update main repository to point to new submodule commit
git add visor-geografico-I2D
git commit -m "Update frontend submodule"
```

### Pulling Latest Changes
```bash
# Update main repository
git pull

# Update submodules to match main repository
git submodule update --init --recursive

# Or update submodules to their latest versions
./scripts/git-setup.sh update
```

---

This setup gives you a clean, organized repository where the main repo contains the Docker orchestration and configuration, while the actual project code is managed as submodules. 🌱
