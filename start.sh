#!/bin/bash

# Novel Navigation - System Start Script
# Interactive Novel Map Visualization System
# Version: 1.0

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}"
    echo "=================================================="
    echo "  Novel Navigation - System Start Script"
    echo "  Interactive Map Visualization System"
    echo "=================================================="
    echo -e "${NC}"
}

# Check if Node.js is installed
check_nodejs() {
    print_status "Checking Node.js installation..."
    
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        print_success "Node.js is installed: $NODE_VERSION"
        
        # Check if version is >= 16
        NODE_MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
        if [ "$NODE_MAJOR_VERSION" -ge 16 ]; then
            print_success "Node.js version is compatible (>= 16.x)"
            return 0
        else
            print_warning "Node.js version is too old. Recommended: >= 16.x"
            return 1
        fi
    else
        print_error "Node.js is not installed"
        return 1
    fi
}

# Install Node.js using different methods
install_nodejs() {
    print_status "Installing Node.js..."
    
    # Check if Homebrew is available (macOS)
    if command -v brew &> /dev/null; then
        print_status "Installing Node.js via Homebrew..."
        brew install node
        return 0
    fi
    
    # Check if we're on macOS and suggest manual installation
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_error "Homebrew not found. Please install Node.js manually:"
        echo "1. Visit https://nodejs.org/"
        echo "2. Download the LTS version for macOS"
        echo "3. Run the installer"
        echo "4. Restart your terminal"
        echo "5. Run this script again"
        return 1
    fi
    
    # For Linux systems
    if command -v apt-get &> /dev/null; then
        print_status "Installing Node.js via apt-get..."
        sudo apt-get update
        sudo apt-get install -y nodejs npm
        return 0
    elif command -v yum &> /dev/null; then
        print_status "Installing Node.js via yum..."
        sudo yum install -y nodejs npm
        return 0
    else
        print_error "Could not determine package manager. Please install Node.js manually:"
        echo "Visit https://nodejs.org/ and follow the installation instructions"
        return 1
    fi
}

# Check if npm is available
check_npm() {
    print_status "Checking npm availability..."
    
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm --version)
        print_success "npm is available: v$NPM_VERSION"
        return 0
    else
        print_error "npm is not available"
        return 1
    fi
}

# Install project dependencies
install_dependencies() {
    print_status "Installing project dependencies..."
    
    if [ -f "package.json" ]; then
        npm install
        print_success "Dependencies installed successfully"
        return 0
    else
        print_error "package.json not found. Are you in the correct directory?"
        return 1
    fi
}

# Start the development server
start_server() {
    print_status "Starting development server..."
    print_status "The application will open in your browser at http://localhost:3000"
    print_status "Press Ctrl+C to stop the server"
    echo ""
    
    npm run dev
}

# Check system requirements
check_system() {
    print_status "Checking system requirements..."
    
    # Check operating system
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_success "Operating System: macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_success "Operating System: Linux"
    else
        print_warning "Operating System: $OSTYPE (may not be fully supported)"
    fi
    
    # Check available memory
    if command -v free &> /dev/null; then
        MEMORY=$(free -h | awk '/^Mem:/ {print $2}')
        print_status "Available Memory: $MEMORY"
    fi
    
    # Check disk space
    DISK_SPACE=$(df -h . | awk 'NR==2 {print $4}')
    print_status "Available Disk Space: $DISK_SPACE"
}

# Main execution flow
main() {
    print_header
    
    # Change to script directory
    cd "$(dirname "$0")"
    
    print_status "Current directory: $(pwd)"
    echo ""
    
    # Check system requirements
    check_system
    echo ""
    
    # Check and install Node.js if needed
    if ! check_nodejs; then
        print_status "Attempting to install Node.js..."
        if ! install_nodejs; then
            print_error "Failed to install Node.js. Please install manually and run this script again."
            exit 1
        fi
        
        # Verify installation
        if ! check_nodejs; then
            print_error "Node.js installation verification failed."
            exit 1
        fi
    fi
    
    echo ""
    
    # Check npm
    if ! check_npm; then
        print_error "npm is required but not available. Please reinstall Node.js."
        exit 1
    fi
    
    echo ""
    
    # Install dependencies
    if ! install_dependencies; then
        print_error "Failed to install dependencies."
        exit 1
    fi
    
    echo ""
    print_success "System setup complete!"
    echo ""
    
    # Start the server
    start_server
}

# Handle script interruption
trap 'echo -e "\n${YELLOW}[INFO]${NC} Script interrupted by user"; exit 0' INT

# Run main function
main "$@"
