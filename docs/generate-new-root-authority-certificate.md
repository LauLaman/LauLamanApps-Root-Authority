# Generate new Root Authority Certificate
1. `openssl genrsa -out LauLamanAppsCA.key 2048`
2. `openssl genrsa -des3 -out LauLamanAppsCA.key 2048`
    * Enter a `pass phrase` _remember: you I'll need to enter this each time you sign a certificate with the Root Authority key_
3. `openssl req -x509 -new -nodes -key LauLamanAppsCA.key -sha256 -days 10240 -out LauLamanAppsCA.pem`
    * enter the folowing info:
        * **Country Name:** `NL`
        * **State or Province Name:** `Flevoland`
        * **Organization Name:** `LauLaman Apps`
        * **Common Name:** `LauLaman Apps Root Authority`
4. [Install the Root Authority Certificate](./install-root-authority-certificate.md)
    

