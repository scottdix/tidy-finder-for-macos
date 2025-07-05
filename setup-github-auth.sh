#!/bin/bash

# Script to configure GitHub authentication for the TidyFinder project
# This sets up project-specific git configuration and authentication

echo "GitHub Authentication Setup for TidyFinder"
echo "=========================================="
echo ""

# Get the project directory
PROJECT_DIR="/Users/scottdix/Documents/tidyfinder"

# Prompt for credentials
read -p "Enter GitHub username (scottdix): " github_username
github_username=${github_username:-scottdix}

read -p "Enter Git email address: " git_email
if [ -z "$git_email" ]; then
    echo "Error: Email address is required"
    exit 1
fi

read -sp "Enter GitHub Personal Access Token: " github_token
echo ""
if [ -z "$github_token" ]; then
    echo "Error: Personal Access Token is required"
    exit 1
fi

echo ""
echo "Configuring git for this project..."

# Set local git configuration (only for this project)
git -C "$PROJECT_DIR" config --local user.name "$github_username"
git -C "$PROJECT_DIR" config --local user.email "$git_email"

echo "✓ Local git user configured"

# Update the remote URL to include the token
# This embeds the token in the URL for this project only
REPO_URL="https://${github_username}:${github_token}@github.com/scottdix/tidy-finder-for-macos.git"
git -C "$PROJECT_DIR" remote set-url origin "$REPO_URL"

echo "✓ Remote URL updated with authentication"

# Verify the configuration
echo ""
echo "Configuration Summary:"
echo "---------------------"
echo "Username: $(git -C "$PROJECT_DIR" config --local user.name)"
echo "Email: $(git -C "$PROJECT_DIR" config --local user.email)"
echo "Remote: $(git -C "$PROJECT_DIR" remote get-url origin | sed 's/:.*@/:****@/')"

echo ""
echo "Testing connection to GitHub..."

# Test the connection by fetching from the remote
if git -C "$PROJECT_DIR" ls-remote &>/dev/null; then
    echo "✓ Successfully connected to GitHub!"
    echo ""
    echo "You can now push to GitHub with:"
    echo "  git push -u origin main"
else
    echo "✗ Failed to connect to GitHub. Please check your token and try again."
    exit 1
fi

# Optional: Configure GitHub CLI if desired
read -p "Do you also want to configure GitHub CLI with this token? (y/N): " configure_gh
if [[ "$configure_gh" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Configuring GitHub CLI..."
    echo "$github_token" | gh auth login --with-token --hostname github.com
    echo "✓ GitHub CLI configured"
fi

echo ""
echo "Setup complete! Your project is now configured to use the $github_username account."
echo ""
echo "Security Notes:"
echo "- The token is stored in the git remote URL for this project only"
echo "- This won't affect your other git repositories"
echo "- To remove the token later, run: git remote set-url origin https://github.com/scottdix/tidy-finder-for-macos.git"