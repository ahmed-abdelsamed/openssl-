Here are the OpenSSL commands to split a `.pfx` (PKCS#12) file into its parts.

**1. Export the certificate (public cert only)**
```bash
openssl pkcs12 -in file.pfx -clcerts -nokeys -out cert.pem
```

**2. Export the private key**
```bash
openssl pkcs12 -in file.pfx -nocerts -nodes -out key.pem
```
- `-nodes` saves the key **unencrypted**. If you want it protected with a passphrase, remove `-nodes` and you'll be asked to set one.

**3. Export the CA / chain certificates**
```bash
openssl pkcs12 -in file.pfx -cacerts -nokeys -chain -out ca.pem
```
- Use `-cacerts` for the intermediate/root certs only.
- `-chain` adds the full chain, including the certificate itself, in the output.

**Export everything into one PEM file**
```bash
openssl pkcs12 -in file.pfx -nodes -out all.pem
```

Each command prompts for the PFX import password. To avoid the prompt, add `-passin pass:YOURPASSWORD`.

**OpenSSL 3.x and old PFX files**

If you get an error like `unsupported` or `error:0308010C:digital envelope routines`, the PFX uses legacy algorithms (RC2/3DES). Add the `-legacy` flag:
```bash
openssl pkcs12 -in file.pfx -nocerts -nodes -legacy -out key.pem
```

**Useful extras**

- Remove the "Bag Attributes" header lines from the output by converting to clean PEM:
  ```bash
  openssl x509 -in cert.pem -out cert_clean.pem
  openssl rsa -in key.pem -out key_clean.pem
  ```
- Check the contents of the PFX first:
  ```bash
  openssl pkcs12 -in file.pfx -info -nokeys
  ```
- Build a full chain file for web servers (Nginx, etc.):
  ```bash
  cat cert.pem ca.pem > fullchain.pem
  ```

Keep `key.pem` private and set strict permissions: `chmod 600 key.pem`.


###########################################
Yes, a PFX can contain only the certificate and private key. The CA/chain certs are included only if whoever created the PFX chose to bundle them, so an empty `ca.pem` usually just means there's no chain inside.

**1. Check what's inside the PFX**
```bash
openssl pkcs12 -in file.pfx -info -nokeys -nodes
```
Look for multiple `BEGIN CERTIFICATE` blocks or several "Bag Attributes" sections. If there's only one certificate, no chain is bundled.

You can also list the subject and issuer of each cert:
```bash
openssl pkcs12 -in file.pfx -nokeys -nodes | openssl crl2pkcs7 -nocrl -certfile /dev/stdin | openssl pkcs7 -print_certs -noout
```

**2. If the chain isn't in the PFX, get it elsewhere**

- **From the CA's website:** download the intermediate/root certs from the provider (DigiCert, Sectigo, Let's Encrypt, etc.) or from the email/zip they sent when issuing the certificate.
- **From the certificate itself** (the AIA field often has a download URL):
  ```bash
  openssl x509 -in cert.pem -noout -text | grep "CA Issuers"
  ```
  Then download the intermediate:
  ```bash
  curl -O http://the-url-from-above/intermediate.crt
  openssl x509 -inform DER -in intermediate.crt -out ca.pem   # only if it's DER format
  ```
- **From the live server**, if the certificate is already deployed:
  ```bash
  openssl s_client -connect yourdomain.com:443 -showcerts
  ```
  This prints the full chain the server sends.

**3. Self-signed or private CA**

If this is an internal certificate, the CA cert comes from your organization (your internal PKI or whoever issued it), not from the PFX.

Once you have the intermediate and root, combine them with your certificate:
```bash
cat cert.pem intermediate.pem root.pem > fullchain.pem
```
