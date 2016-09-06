# Generate Domain Certificate
1. Generate server key: `openssl genrsa -out [domainname].key 2048`
2. Generate a Certificate Signing Request (CSR): `openssl req -new -key [domainname].key -out [domainname].csr`
    * Enter the folowing information:
        * **Country Name:** `NL`
        * **State or Province Name:** `Flevoland`
        * **Organization Name:** `LauLaman Webs`
        * **Common Name:** `[domainname]`
3. Generate server certificate from CSR and sign it with the LauLamanAppsCA.key private key:  `openssl x509 -req -in [domainname].csr -CA LauLamanAppsCA.pem -CAkey LauLamanAppsCA.key -CAcreateserial -out [domainname].crt -days 500 -sha256`
4. Open the `[domainname].crt` file and add the Root Certificate from the `LauLamanAppsCA.pem ` file to the _**bottom**_ of the file.
5. install the `[domainname].crt` and `[domainname].key` on the server 