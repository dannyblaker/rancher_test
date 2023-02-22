#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Set the domain, email, country, state, location, company, and certificate directory.
DOMAIN="domain.com"
EMAIL="test@test.com"
COUNTRY="AU"
STATE="SA"
LOCATION="Adelaide"
COMPANY="test"
CERT_DIR="$SCRIPT_DIR/cert"
CERT_NAME="test"
DAYS=90
PASSPHRASE="Password123!@"

# Generate the private key.
openssl genrsa -des3 -passout "pass:${PASSPHRASE}" -out "${CERT_DIR}/${CERT_NAME}.key" 2048

# Generate the certificate signing request (CSR).
openssl req -new -passin "pass:${PASSPHRASE}" -key "${CERT_DIR}/${CERT_NAME}.key" -out "${CERT_DIR}/${CERT_NAME}.csr" -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCATION}/O=${COMPANY}/CN=${DOMAIN}/emailAddress=${EMAIL}"

# Generate the self-signed certificate.
openssl x509 -req -days "${DAYS}" -in "${CERT_DIR}/${CERT_NAME}.csr" -signkey "${CERT_DIR}/${CERT_NAME}.key" -out "${CERT_DIR}/${CERT_NAME}.crt"

# Concatenate the certificate and the CA certificate, if it exists.
cat "${CERT_DIR}/${CERT_NAME}.crt" > "${CERT_DIR}/${CERT_NAME}-full-chain.crt"
if [ -f "${CERT_DIR}/ca.crt" ]; then
    cat "${CERT_DIR}/ca.crt" >> "${CERT_DIR}/${CERT_NAME}-full-chain.crt"
fi