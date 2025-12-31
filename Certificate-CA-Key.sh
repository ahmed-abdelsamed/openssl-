#!/usr/bin/env bash
set -e

### CONFIG (change these) ###
CERT_DIR="certs"
CA_NAME="Dev-Local-CA"
SERVER_CN="linkdev.net"
DAYS_CA=3650
DAYS_CERT=825

# SANs (edit as needed)
DNS_NAMES=("linkdev.net" "localhost")
IP_ADDRESSES=("127.0.0.1")

################################

mkdir -p "$CERT_DIR"
cd "$CERT_DIR"

echo "==> Generating CA private key"
openssl genrsa -out ca.key 4096

echo "==> Generating CA certificate"
openssl req -x509 -new -nodes \
  -key ca.key \
  -sha256 \
  -days "$DAYS_CA" \
  -subj "/C=EG/O=Dev/CN=$CA_NAME" \
  -out ca.crt

echo "==> Generating server private key"
openssl genrsa -out server.key 2048

echo "==> Creating SAN config"
cat > san.cnf <<EOF
[ req ]
default_bits       = 2048
prompt             = no
default_md         = sha256
req_extensions     = req_ext
distinguished_name = dn

[ dn ]
C  = EG
O  = Dev
CN = $SERVER_CN

[ req_ext ]
subjectAltName = @alt_names

[ alt_names ]
EOF

i=1
for dns in "${DNS_NAMES[@]}"; do
  echo "DNS.$i = $dns" >> san.cnf
  ((i++))
done

j=1
for ip in "${IP_ADDRESSES[@]}"; do
  echo "IP.$j = $ip" >> san.cnf
  ((j++))
done

echo "==> Generating CSR"
openssl req -new \
  -key server.key \
  -out server.csr \
  -config san.cnf

echo "==> Signing certificate with CA"
openssl x509 -req \
  -in server.csr \
  -CA ca.crt \
  -CAkey ca.key \
  -CAcreateserial \
  -out server.crt \
  -days "$DAYS_CERT" \
  -sha256 \
  -extensions req_ext \
  -extfile san.cnf

echo
echo "✅ Certificates generated successfully!"
echo "📁 Location: $CERT_DIR/"
echo
echo "CA Certificate:     ca.crt"
echo "Server Certificate: server.crt"
echo "Server Key:         server.key"

