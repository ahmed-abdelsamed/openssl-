#!/bin/bash

# Certificate Generator Script
# Usage: ./generate_certs.sh [DOMAIN] [DAYS_VALID]

set -e  # Exit on error

# Default values
DOMAIN=${1:-"localhost"}
DAYS_VALID=${2:-365}
OUTPUT_DIR="./certs"
CONFIG_FILE="openssl.cnf"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Generate OpenSSL config if it doesn't exist
if [[ ! -f "$CONFIG_FILE" ]]; then
    cat > "$CONFIG_FILE" <<EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
x509_extensions = v3_req

[dn]
C = US
ST = California
L = San Francisco
O = My Organization
OU = IT Department
CN = $DOMAIN

[v3_req]
subjectAltName = @alt_names
basicConstraints = CA:FALSE
keyUsage = digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth

[alt_names]
DNS.1 = $DOMAIN
DNS.2 = *.$DOMAIN
IP.1 = 127.0.0.1
EOF
fi

echo -e "${GREEN}[+] Generating private key...${NC}"
openssl genpkey -algorithm RSA \
    -out "$OUTPUT_DIR/server.key" \
    -aes256 \
    -pass pass:temp_password \
    -pkeyopt rsa_keygen_bits:2048

# Remove password from key (optional)
echo -e "${GREEN}[+] Removing password from key...${NC}"
openssl rsa -in "$OUTPUT_DIR/server.key" \
    -passin pass:temp_password \
    -out "$OUTPUT_DIR/server.key"

echo -e "${GREEN}[+] Generating Certificate Signing Request...${NC}"
openssl req -new \
    -key "$OUTPUT_DIR/server.key" \
    -out "$OUTPUT_DIR/server.csr" \
    -config "$CONFIG_FILE"

echo -e "${GREEN}[+] Generating self-signed certificate...${NC}"
openssl x509 -req \
    -in "$OUTPUT_DIR/server.csr" \
    -signkey "$OUTPUT_DIR/server.key" \
    -out "$OUTPUT_DIR/server.crt" \
    -days "$DAYS_VALID" \
    -extensions v3_req \
    -extfile "$CONFIG_FILE"

echo -e "${GREEN}[+] Generating PEM file (combined crt+key)...${NC}"
cat "$OUTPUT_DIR/server.crt" "$OUTPUT_DIR/server.key" > "$OUTPUT_DIR/server.pem"

echo -e "${GREEN}[+] Generating Diffie-Hellman parameters...${NC}"
openssl dhparam -out "$OUTPUT_DIR/dhparam.pem" 2048

# Set proper permissions
chmod 600 "$OUTPUT_DIR"/*.key
chmod 644 "$OUTPUT_DIR"/*.crt

echo -e "\n${GREEN}[+] Certificate generation complete!${NC}"
echo -e "Files saved to: $OUTPUT_DIR/"
echo -e "\nGenerated files:"
ls -lh "$OUTPUT_DIR"/
