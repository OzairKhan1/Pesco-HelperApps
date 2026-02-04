#!/bin/bash

# The Purpose of this script is to Update the .env file If there is any change to Credentials. Also for creating session secret

# Path to your .env file
ENV_FILE="./.env"

# Check if .env exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: .env file not found at $ENV_FILE"
    exit 1
fi

# --- 1️⃣ Update SESSION_SECRET ---
# Generate a new 64-character hex secret (256-bit)
NEW_SECRET=$(python3 -c "import secrets; print(secrets.token_hex(32))")

# Replace or append SESSION_SECRET
if grep -q "^SESSION_SECRET=" "$ENV_FILE"; then
    sed -i "s/^SESSION_SECRET=.*/SESSION_SECRET=$NEW_SECRET/" "$ENV_FILE"
else
    echo "SESSION_SECRET=$NEW_SECRET" >> "$ENV_FILE"
fi

echo "✅ SESSION_SECRET updated successfully!"

# --- 2️⃣ Update DATABASE_URL dynamically ---
# Read DB variables from .env
DB_USER=$(grep "^POSTGRES_USER=" "$ENV_FILE" | cut -d '=' -f2)
DB_PASS=$(grep "^POSTGRES_PASSWORD=" "$ENV_FILE" | cut -d '=' -f2)
DB_HOST=$(grep "^POSTGRES_HOST=" "$ENV_FILE" | cut -d '=' -f2)
DB_PORT=$(grep "^POSTGRES_PORT=" "$ENV_FILE" | cut -d '=' -f2)
DB_NAME=$(grep "^POSTGRES_DB=" "$ENV_FILE" | cut -d '=' -f2)

# Construct the URL
DB_URL="postgresql://$DB_USER:$DB_PASS@$DB_HOST:$DB_PORT/$DB_NAME"

# Replace or append DATABASE_URL
if grep -q "^DATABASE_URL=" "$ENV_FILE"; then
    sed -i "s|^DATABASE_URL=.*|DATABASE_URL=$DB_URL|" "$ENV_FILE"
else
    echo "DATABASE_URL=$DB_URL" >> "$ENV_FILE"
fi

echo "✅ DATABASE_URL updated successfully!"
echo "New URL: $DB_URL"

