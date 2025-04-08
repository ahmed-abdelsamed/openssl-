cd  /etc/pki/nssdb/
PKICertImport -d . -n "CA Root" -t "CT,C,C" -a -i ca_root.crt -u L
PKICertImport -d . -n "CA SUB" -t "CT,C,C" -a -i ca_sub.crt -u L

## Test
openssl s_client -connect api.id.gov.sa:443 -showcerts | less

# Note that domain (api.id.gov.sa) in CN in certificate

## List
certutil -L -d sql:.
certutil -L -d sql:. -n "CA Root"
certutil -L -d sql:. -n "CA SUB"


## Delete the certificate by running the certutil with the -D option.
certutil -D -d . -n "CA Root"
certutil -D -d . -n "CA SUB"
############
## Update certificate on Java
keytool -import -trustcacerts -keystore /etc/java/java-11-openjdk/java-11-openjdk-11.0.14.1.1-6.el9.x86_64/lib/security/cacerts -storepass changeit -noprompt -alias nafath-user-new  -file /var/liferay/liferay-dxp/"sb.crt"



#####################################################################
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
