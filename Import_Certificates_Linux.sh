cd  /etc/pki/nssdb/    # Default path of database of certificates

##Import Intermediate Certificate 
certutil -d . -n "CA Sub <num>" -t "CT,C,C" -a -i ca_sub_<num>.crt


##Import Root Certificate
certutil -d . -n "Root CA" -t "C,C,C" -a -i root_ca.crt


dnf install pki-tool

#############################
cd  /etc/pki/nssdb/
PKICertImport -d . -n "CA Root" -t "CT,C,C" -a -i ca_root.crt -u L
PKICertImport -d . -n "CA SUB" -t "CT,C,C" -a -i ca_sub.crt -u L

## Test
openssl s_client -connect api.id.gov.sa:443 -showcerts | less

# Note that domain (api.id.gov.sa) in CN in certificate
