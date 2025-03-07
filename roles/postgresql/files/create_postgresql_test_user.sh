#!/bin/bash

# Script to create a Test user in PostgreSQL on Ubuntu

# Variables
PG_USER="postgres"           # Default PostgreSQL admin user
TEST_USER="test"             # Name of the user to create
PASSWORD_FILE="/tmp/postgresql_test_user.txt"  # Where to save credentials
PASSWORD_LENGTH=20            # Length of the random password

# Function to generate a random password
generate_password() {
    openssl rand -base64 48 | head -c "$PASSWORD_LENGTH"
}

# Check if PostgreSQL is installed and running
if ! systemctl is-active --quiet postgresql; then
    echo "Error: PostgreSQL is not running or not installed."
    exit 1
fi

# Generate a random secure password
PASSWORD=$(generate_password)
if [ -z "$PASSWORD" ]; then
    echo "Error: Failed to generate password."
    exit 1
fi

# Create the Test user in PostgreSQL
echo "Creating PostgreSQL user '$TEST_USER'..."
sudo -u "$PG_USER" psql -c "DO \$\$ BEGIN IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$TEST_USER') THEN CREATE ROLE $TEST_USER WITH LOGIN PASSWORD '$PASSWORD'; END IF; END \$\$;" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "User '$TEST_USER' created successfully."
else
    echo "Error: Failed to create user '$TEST_USER'. Check PostgreSQL logs."
    exit 1
fi

# Save the credentials to a file
echo "Saving credentials to $PASSWORD_FILE..."
echo "PostgreSQL User: $TEST_USER" > "$PASSWORD_FILE"
echo "Password: $PASSWORD" >> "$PASSWORD_FILE"
chmod 600 "$PASSWORD_FILE"
echo "Credentials saved to $PASSWORD_FILE with restricted permissions."

# Verify the user exists
echo "Verifying user creation..."
sudo -u "$PG_USER" psql -c "\du $TEST_USER" | grep "$TEST_USER"
if [ $? -eq 0 ]; then
    echo "Verification successful: User '$TEST_USER' exists."
else
    echo "Warning: User verification failed. Check PostgreSQL manually."
fi

exit 0