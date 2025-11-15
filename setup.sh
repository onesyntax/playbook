#!/bin/bash
# OneSyntax Playbook - Git Setup Script
# Run this script from inside the onesyntax-playbook directory

set -e  # Exit on error

echo "🚀 OneSyntax Playbook - Git Setup"
echo "=================================="
echo ""

# Check if we're in the right directory
if [ ! -f "README.md" ]; then
    echo "❌ Error: README.md not found."
    echo "Please run this script from inside the onesyntax-playbook directory."
    exit 1
fi

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Error: git is not installed."
    echo "Please install git first: https://git-scm.com/"
    exit 1
fi

echo "✅ Prerequisites checked"
echo ""

# Initialize git repository
echo "📦 Initializing git repository..."
git init

# Add all files
echo "➕ Adding all files..."
git add .

# Create first commit
echo "💾 Creating initial commit..."
git commit -m "feat: Initial OneSyntax Playbook

- Add mission and golden circle
- Add core values
- Add development system (DDD + Clean Architecture + TDD)
- Add career progression framework
- Add enforcement system
- Add quality initiative execution plan
- Add README with navigation

This playbook establishes OneSyntax standards as non-negotiable
and provides clear path for team growth and quality delivery."

echo "✅ Local repository initialized"
echo ""

# Prompt for GitHub username
echo "📝 GitHub Setup"
echo "--------------"
read -p "Enter your GitHub username: " github_username

if [ -z "$github_username" ]; then
    echo "❌ Error: GitHub username cannot be empty"
    exit 1
fi

# Add remote
echo "🔗 Adding GitHub remote..."
git remote add origin "https://github.com/$github_username/onesyntax-playbook.git"

# Rename branch to main
echo "🌿 Setting up main branch..."
git branch -M main

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "==========="
echo ""
echo "1. Create the repository on GitHub:"
echo "   https://github.com/new"
echo "   - Name: onesyntax-playbook"
echo "   - Private repository"
echo "   - DO NOT initialize with README"
echo ""
echo "2. After creating the repo, push your code:"
echo "   git push -u origin main"
echo ""
echo "3. Set up branch protection (recommended):"
echo "   - Go to: Settings → Branches → Add rule"
echo "   - Pattern: main"
echo "   - Require pull request reviews: 1 approval"
echo "   - Include administrators"
echo ""
echo "📚 See SETUP.md for detailed instructions"
echo ""
echo "🎉 Ready to push to GitHub!"
