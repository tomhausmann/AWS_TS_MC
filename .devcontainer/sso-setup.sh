#!/bin/bash

# Text colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}AWS SSO Session Setup${NC}"

# Check if we already have valid credentials
if aws sts get-caller-identity &> /dev/null; then
    echo -e "${GREEN}You already have valid AWS credentials:${NC}"
    aws sts get-caller-identity
    echo -e "\nIf you need to switch roles or accounts, run: aws sso login"
    exit 0
fi

# Ensure .aws directory exists
mkdir -p ~/.aws

echo -e "\n${YELLOW}Starting AWS SSO login process...${NC}"
echo "You will be redirected to your browser to complete the login."
echo "If you're using a remote device, copy and paste the URL when prompted."

# Start AWS SSO login process
aws sso login --sso-session my-sso

# Verify the new credentials
if aws sts get-caller-identity &> /dev/null; then
    echo -e "\n${GREEN}Successfully authenticated with AWS SSO!${NC}"
    echo "Current identity:"
    aws sts get-caller-identity
    
    echo -e "\n${GREEN}Your development environment is ready.${NC}"
    echo "Remember: If your session expires, just run this script again."
else
    echo -e "\n${YELLOW}Authentication failed. Please try again.${NC}"
    exit 1
fi
