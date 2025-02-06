#1. Extract the Private Key

openssl pkcs12 -in yourfile.pfx -nocerts -out en_privatekey.pem -nodes

# Decrept Key 
openssl rsa -in en_privatekey.pem -out privatekey.pem 

#2. Extract the Certificate
openssl pkcs12 -in yourfile.pfx -clcerts -nokeys -out certificate.pem

# 3. Extract Intermediate Certificates
openssl pkcs12 -in yourfile.pfx -cacerts -nokeys -out intermediates.pem

#4. Extract the Root Certificate (if included)
If the .pfx file includes the root certificate, it will be extracted along with the intermediate certificates in the previous step. You can manually separate the root certificate from the intermediates.pem file if needed

#5. Verify the Extracted Files
openssl rsa -in privatekey.pem -check
openssl x509 -in certificate.pem -text -noout
openssl x509 -in intermediates.pem -text -noout

#6. Combine Certificates (Optional)
# For some applications (e.g., Nginx, Apache), you may need to combine the certificate and intermediate certificates into a single file:
cat certificate.pem intermediates.pem > fullchain.pem

Notes
Ensure you keep the extracted private key (privatekey.pem) secure, as it is sensitive information.

If the .pfx file does not include intermediate or root certificates, you may need to download them separately from your Certificate Authority (CA).

By following these steps, you can successfully extract the certificate, private key, and intermediate certificates from a .pfx file.
