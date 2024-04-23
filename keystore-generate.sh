## Install keytool
sudo rpm --import https://yum.corretto.aws/corretto.key
sudo curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
sudo yum install -y java-11-amazon-corretto-devel

## To create the p12 file run the following command: 
openssl pkcs12 -export -in bot_maan_gov_ae.crt -inkey bot_maan_gov_ae-decrypt.key -out key.p12

## To verify the alias of the private key run the following: 
keytool -v -list -storetype pkcs12 -keystore key.p12

# Look for alias and its value. It will be used in the next step.

## To convert the p12 file to JKS run the following:
keytool -importkeystore -srckeystore key.p12 -srcstoretype pkcs12 -srcalias 1 -destkeystore bot-maab.jks -deststoretype jks -deststorepass password -destalias liferay-alias

# (1) is alias name in verfiy command, password is password for keystore,  liferay-lais is new alias for keystore

############

## Addtional 
# migrate from jks to PKCS12 
keytool -importkeystore -srckeystore bot-maab.jks -destkeystore bot-maab.jks -deststoretype pkcs12
