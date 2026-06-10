#!/bin/bash
# -------------------------------------------------------
# Import SQL schema into Amazon RDS (SQL Server)
# Requires: sqlcmd (mssql-tools), AWS RDS endpoint
# -------------------------------------------------------

# --- Configure these ---
RDS_ENDPOINT="your-rds-endpoint.rds.amazonaws.com"
DB_USER="admin"
DB_PASS="your-password"
SCHEMA_FILE="../schema/critical_event_db.sql"
# -----------------------

echo "Installing sqlcmd (if not already installed)..."
if ! command -v sqlcmd &> /dev/null; then
    sudo yum update -y
    sudo yum install -y curl
    sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/pki/rpm-gpg/Microsoft.asc
    sudo curl https://packages.microsoft.com/config/rhel/7/prod.repo | sudo tee /etc/yum.repos.d/mssql-release.repo
    sudo ACCEPT_EULA=Y yum install -y mssql-tools unixODBC-devel
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
    source ~/.bashrc
fi

echo "Testing connection to RDS..."
sqlcmd -S "$RDS_ENDPOINT" -U "$DB_USER" -P "$DB_PASS" -Q "SELECT @@VERSION" || {
    echo "ERROR: Cannot connect to RDS. Check endpoint and credentials."
    exit 1
}

echo "Importing schema from $SCHEMA_FILE..."
sqlcmd -S "$RDS_ENDPOINT" -U "$DB_USER" -P "$DB_PASS" -i "$SCHEMA_FILE"

echo "Verifying tables created..."
sqlcmd -S "$RDS_ENDPOINT" -U "$DB_USER" -P "$DB_PASS" -d "critical_event_db" \
    -Q "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';"

echo "Done."
