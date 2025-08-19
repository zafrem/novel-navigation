#!/bin/bash

# Novel Navigation - System Stop Script
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
    echo "  Novel Navigation - System Stop Script"
    echo "  Graceful Shutdown Manager"
    echo "=================================================="
    echo -e "${NC}"
}

# Find and kill Node.js processes related to this project
stop_nodejs_processes() {
    print_status "Searching for Novel Navigation processes..."
    
    # Find processes running on port 3000 (default Vite port)
    PORT_PROCESSES=$(lsof -ti:3000 2>/dev/null || true)
    
    if [ -n "$PORT_PROCESSES" ]; then
        print_status "Found processes on port 3000:"
        echo "$PORT_PROCESSES" | while read -r pid; do
            if [ -n "$pid" ]; then
                PROCESS_INFO=$(ps -p "$pid" -o pid,ppid,cmd --no-headers 2>/dev/null || echo "Process not found")
                echo "  PID: $pid - $PROCESS_INFO"
            fi
        done
        
        print_status "Terminating processes on port 3000..."
        echo "$PORT_PROCESSES" | while read -r pid; do
            if [ -n "$pid" ]; then
                kill -TERM "$pid" 2>/dev/null || true
                print_status "Sent SIGTERM to process $pid"
            fi
        done
        
        # Wait a moment for graceful shutdown
        sleep 2
        
        # Force kill if still running
        REMAINING_PROCESSES=$(lsof -ti:3000 2>/dev/null || true)
        if [ -n "$REMAINING_PROCESSES" ]; then
            print_warning "Some processes didn't respond to SIGTERM, force killing..."
            echo "$REMAINING_PROCESSES" | while read -r pid; do
                if [ -n "$pid" ]; then
                    kill -KILL "$pid" 2>/dev/null || true
                    print_status "Force killed process $pid"
                fi
            done
        fi
        
        print_success "All processes on port 3000 have been terminated"
    else
        print_status "No processes found running on port 3000"
    fi
}

# Find and kill Node.js processes by name pattern
stop_node_processes() {
    print_status "Searching for Node.js development processes..."
    
    # Look for node processes containing 'vite' or running from this directory
    CURRENT_DIR=$(pwd)
    NODE_PROCESSES=$(pgrep -f "node.*vite" 2>/dev/null || true)
    
    if [ -n "$NODE_PROCESSES" ]; then
        print_status "Found Node.js development processes:"
        echo "$NODE_PROCESSES" | while read -r pid; do
            if [ -n "$pid" ]; then
                PROCESS_INFO=$(ps -p "$pid" -o pid,ppid,cmd --no-headers 2>/dev/null || echo "Process not found")
                echo "  PID: $pid - $PROCESS_INFO"
            fi
        done
        
        print_status "Terminating Node.js development processes..."
        echo "$NODE_PROCESSES" | while read -r pid; do
            if [ -n "$pid" ]; then
                kill -TERM "$pid" 2>/dev/null || true
                print_status "Sent SIGTERM to process $pid"
            fi
        done
        
        # Wait for graceful shutdown
        sleep 2
        
        # Check if any are still running
        REMAINING_NODE_PROCESSES=$(pgrep -f "node.*vite" 2>/dev/null || true)
        if [ -n "$REMAINING_NODE_PROCESSES" ]; then
            print_warning "Some Node.js processes didn't respond to SIGTERM, force killing..."
            echo "$REMAINING_NODE_PROCESSES" | while read -r pid; do
                if [ -n "$pid" ]; then
                    kill -KILL "$pid" 2>/dev/null || true
                    print_status "Force killed process $pid"
                fi
            done
        fi
        
        print_success "All Node.js development processes have been terminated"
    else
        print_status "No Node.js development processes found"
    fi
}

# Clean up temporary files
cleanup_temp_files() {
    print_status "Cleaning up temporary files..."
    
    # Remove Vite cache if it exists
    if [ -d "node_modules/.vite" ]; then
        rm -rf "node_modules/.vite"
        print_status "Removed Vite cache"
    fi
    
    # Remove any .tmp files
    find . -name "*.tmp" -type f -delete 2>/dev/null || true
    
    # Remove any lock files that might be stale
    if [ -f ".vite-dev-server.lock" ]; then
        rm -f ".vite-dev-server.lock"
        print_status "Removed stale lock files"
    fi
    
    print_success "Temporary files cleaned up"
}

# Check if any processes are still running
verify_shutdown() {
    print_status "Verifying shutdown..."
    
    # Check port 3000
    if lsof -ti:3000 >/dev/null 2>&1; then
        print_warning "Port 3000 is still in use"
        return 1
    fi
    
    # Check for node processes
    if pgrep -f "node.*vite" >/dev/null 2>&1; then
        print_warning "Node.js development processes are still running"
        return 1
    fi
    
    print_success "All Novel Navigation processes have been stopped"
    return 0
}

# Show running processes (optional debug info)
show_running_processes() {
    if [ "$1" = "--verbose" ] || [ "$1" = "-v" ]; then
        print_status "Current Node.js processes:"
        pgrep -fl node 2>/dev/null || print_status "No Node.js processes found"
        echo ""
        
        print_status "Processes using port 3000:"
        lsof -i:3000 2>/dev/null || print_status "Port 3000 is free"
        echo ""
    fi
}

# Main execution flow
main() {
    print_header
    
    # Change to script directory
    cd "$(dirname "$0")"
    
    print_status "Current directory: $(pwd)"
    echo ""
    
    # Show running processes if verbose mode
    show_running_processes "$1"
    
    # Stop processes
    stop_nodejs_processes
    echo ""
    
    stop_node_processes
    echo ""
    
    # Clean up
    cleanup_temp_files
    echo ""
    
    # Verify shutdown
    if verify_shutdown; then
        echo ""
        print_success "Novel Navigation system has been successfully stopped"
        print_status "Port 3000 is now available"
        print_status "You can restart the system using ./start.sh"
    else
        echo ""
        print_error "Some processes may still be running"
        print_status "You may need to manually kill remaining processes"
        print_status "Use 'ps aux | grep node' to find them"
    fi
}

# Handle script options
case "$1" in
    --help|-h)
        echo "Novel Navigation - System Stop Script"
        echo ""
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  -h, --help     Show this help message"
        echo "  -v, --verbose  Show detailed process information"
        echo ""
        echo "This script will:"
        echo "  1. Find and terminate all Novel Navigation processes"
        echo "  2. Free up port 3000"
        echo "  3. Clean up temporary files"
        echo "  4. Verify successful shutdown"
        exit 0
        ;;
esac

# Handle script interruption
trap 'echo -e "\n${YELLOW}[INFO]${NC} Stop script interrupted"; exit 0' INT

# Run main function
main "$@"
