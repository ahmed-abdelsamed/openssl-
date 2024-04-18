#Execute the following command to export Private Key file:

openssl pkcs12 -in [yourfile.pfx] -nocerts -out [keyfile-encrypted.key]

#Then remove the passphrase from the Private Key

openssl rsa -in [keyfile-encrypted.key] -out [keyfile-decrypted.key] 

#Export certificate file:

openssl pkcs12 -in [yourfile.pfx] -clcerts -nokeys -out [certificate.crt]
