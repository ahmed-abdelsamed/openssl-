# View PKCS#12 Information on Screen
openssl pkcs12 -info -in INFILE.p12 -nodes

#Encrypt Private Key
openssl pkcs12 -info -in INFILE.p12

# Extract Only Certificates or Private Key
openssl pkcs12 -info -in INFILE.p12 -nodes -nocerts
openssl pkcs12 -info -in INFILE.p12 -nokeys

#Save Certificates and Private Keys to Files
openssl pkcs12 -in INFILE.p12 -out OUTFILE.crt -nodes
openssl pkcs12 -in INFILE.p12 -out OUTFILE.key -nodes -nocerts
openssl pkcs12 -in INFILE.p12 -out OUTFILE.crt -nokeys
