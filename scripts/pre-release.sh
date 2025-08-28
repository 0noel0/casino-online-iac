#!/bin/bash

# Pre-release validation script
# This script performs various checks before creating a release

set -e

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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main validation function
main() {
    print_status "Starting pre-release validation..."
    
    # Check if we're in the right directory
    if [[ ! -f "main.tf" ]]; then
        print_error "main.tf not found. Please run this script from the project root."
        exit 1
    fi
    
    # Check required tools
    print_status "Checking required tools..."
    
    if ! command_exists terraform; then
        print_error "Terraform is not installed or not in PATH"
        exit 1
    fi
    
    if ! command_exists git; then
        print_error "Git is not installed or not in PATH"
        exit 1
    fi
    
    print_success "All required tools are available"
    
    # Check Git status
    print_status "Checking Git status..."
    
    if [[ -n $(git status --porcelain) ]]; then
        print_warning "There are uncommitted changes in the repository"
        git status --short
        read -p "Do you want to continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Aborting due to uncommitted changes"
            exit 1
        fi
    fi
    
    # Check current branch
    current_branch=$(git branch --show-current)
    if [[ "$current_branch" != "main" && "$current_branch" != "master" ]]; then
        print_warning "Current branch is '$current_branch', not 'main' or 'master'"
        read -p "Do you want to continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Aborting due to branch check"
            exit 1
        fi
    fi
    
    print_success "Git status check completed"
    
    # Terraform format check
    print_status "Running terraform fmt check..."
    if ! terraform fmt -check -recursive; then
        print_error "Terraform files are not properly formatted"
        print_status "Run 'terraform fmt -recursive' to fix formatting"
        exit 1
    fi
    print_success "Terraform formatting is correct"
    
    # Terraform validation
    print_status "Running terraform validation..."
    
    # Initialize if needed
    if [[ ! -d ".terraform" ]]; then
        print_status "Initializing Terraform..."
        terraform init -backend=false
    fi
    
    if ! terraform validate; then
        print_error "Terraform validation failed"
        exit 1
    fi
    print_success "Terraform validation passed"
    
    # Check for required files
    print_status "Checking required files..."
    
    required_files=(
        "README.md"
        "CHANGELOG.md"
        "LICENSE"
        "CONTRIBUTING.md"
        "SECURITY.md"
        "VERSION"
        ".gitignore"
        "terraform.tfvars.example"
        "variables.tf"
        "outputs.tf"
        "main.tf"
        "Makefile"
    )
    
    missing_files=()
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            missing_files+=("$file")
        fi
    done
    
    if [[ ${#missing_files[@]} -gt 0 ]]; then
        print_error "Missing required files:"
        printf ' - %s\n' "${missing_files[@]}"
        exit 1
    fi
    
    print_success "All required files are present"
    
    # Check VERSION file
    print_status "Checking VERSION file..."
    
    if [[ ! -s "VERSION" ]]; then
        print_error "VERSION file is empty"
        exit 1
    fi
    
    version=$(cat VERSION | tr -d '\n\r')
    if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "VERSION file does not contain a valid semantic version: '$version'"
        exit 1
    fi
    
    print_success "VERSION file is valid: $version"
    
    # Check if tag already exists
    if git tag -l | grep -q "^v$version$"; then
        print_error "Tag v$version already exists"
        exit 1
    fi
    
    print_success "Tag v$version is available"
    
    # Check CHANGELOG
    print_status "Checking CHANGELOG.md..."
    
    if ! grep -q "## \[${version}\]" CHANGELOG.md; then
        print_warning "CHANGELOG.md does not contain an entry for version $version"
        read -p "Do you want to continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Please update CHANGELOG.md before creating a release"
            exit 1
        fi
    fi
    
    print_success "CHANGELOG.md check completed"
    
    # Security check with tfsec if available
    if command_exists tfsec; then
        print_status "Running security scan with tfsec..."
        if ! tfsec . --soft-fail; then
            print_warning "Security scan found issues (continuing with soft-fail)"
        else
            print_success "Security scan passed"
        fi
    else
        print_warning "tfsec not found, skipping security scan"
    fi
    
    # Final summary
    echo
    print_success "=== PRE-RELEASE VALIDATION COMPLETED ==="
    print_status "Version: $version"
    print_status "Branch: $current_branch"
    print_status "Ready to create release!"
    echo
    print_status "Next steps:"
    echo "  1. git tag v$version"
    echo "  2. git push origin v$version"
    echo "  3. GitHub Actions will automatically create the release"
    echo
}

# Run main function
main "$@"