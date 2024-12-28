#!/bin/bash

# Text colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${YELLOW}AWS SSO Session Setup${NC}"

# First, let's ensure our AWS config is properly set up
mkdir -p ~/.aws

# Create the AWS config file with SSO configuration
cat > ~/.aws/config << EOF
[profile default]
sso_session = my-sso
sso_account_id = ${SSO_ACCOUNT_ID}
sso_role_name = AdministratorAccess
region = eu-central-1
output = json

[sso-session my-sso]
sso_start_url = ${SSO_START_URL}
sso_region = eu-central-1
sso_registration_scopes = sso:account:access
EOF

echo -e "\n${BLUE}AWS SSO Configuration:${NC}"
echo -e "Account ID: ${SSO_ACCOUNT_ID}"
echo -e "SSO URL: ${SSO_START_URL}"

# Check if we already have valid credentials
if aws sts get-caller-identity &> /dev/null; then
    echo -e "\n${GREEN}You already have valid AWS credentials:${NC}"
    aws sts get-caller-identity
    exit 0
fi

echo -e "\n${YELLOW}Starting AWS SSO login process...${NC}"
echo -e "${BLUE}Since you're in a remote environment, you'll need to:${NC}"
echo "1. Copy the URL that will be displayed"
echo "2. Open it in your browser"
echo "3. Complete the SSO login"
echo "4. Copy and paste the verification code when prompted"
echo -e "\n${YELLOW}Press Enter when ready...${NC}"
read

# Start AWS SSO login process with device flow
aws sso login --sso-session my-sso --use-device-code

# Verify the new credentials
if aws sts get-caller-identity &> /dev/null; then
    echo -e "\n${GREEN}Successfully authenticated with AWS SSO!${NC}"
    echo "Current identity:"
    aws sts get-caller-identity
    
    echo -e "\n${GREEN}Your development environment is ready.${NC}"
    echo "Remember: If your session expires, just run this script again."
else
    echo -e "\n${YELLOW}Authentication failed. Please try again.${NC}"
    echo "Common issues:"
    echo "1. Make sure your SSO_ACCOUNT_ID and SSO_START_URL are correct in GitHub secrets"
    echo "2. Ensure you have the correct permissions in AWS IAM Identity Center"
    echo "3. Check if your SSO session is active"
    exit 1
fi
