### Must be update openssl


#Execute the following command to export Private Key file:

openssl pkcs12 -in [yourfile.pfx] -nocerts -out [keyfile-encrypted.key]

#Then remove the passphrase from the Private Key

openssl rsa -in [keyfile-encrypted.key] -out [keyfile-decrypted.key] 

#Export certificate file:

openssl pkcs12 -in [yourfile.pfx] -clcerts -nokeys -out [certificate.crt]


## Export csr from key
openssl req -out .\bot_maan_gov_ae.csr -new -key .\bot_maan_gov_ae-decrypt.key




##############################
#Extract the certificates and private key from the PFX file:
openssl pkcs12 -in yourfile.pfx -out certificates.pem -nodes

'This command will prompt you for the password of the PFX file (if it is password-protected). The -nodes option prevents the private key from being encrypted.'

#Open the certificates.pem file:
#Open the certificates.pem file in a text editor. This file contains all the certificates (the root, intermediate, and end-entity certificate) and possibly the private key.

## Verify the Extracted Certificate

openssl x509 -in intermediate.crt -text -noout


### Extract key from pfx
openssl pkcs12 -in [yourfile.pfx] -nocerts -out [drlive.key]

# error Enter PEM passwrd , can be remove it
#seriously, If you'll know the passphrase you can remove it:

openssl rsa -in website.com.key_secure.key -out website.com.key

## Exttract certificate from pfx
 openssl pkcs12 -in Bot_cert.pfx -clcerts -nokeys -out drlive.crt  -nodes
