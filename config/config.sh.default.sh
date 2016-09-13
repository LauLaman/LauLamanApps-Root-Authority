#!/bin/bash

ENCRYPTION_METHOD=sha256
ENCRYPTION_KEY_SIZE=2048
SSL_STORE_PATH='./ssl'

CA_KEY='./config/RootCertificateAuthority.key'
CA_CERTIFICATE='./config/RootCertificateAuthority.pem'
CA_PASSPHRASE='thispassphraseisnotsecret'
CA_DAYS_VALID= 12500

CERTIFICATE_COUNTRY_CODE='NL'
CERTIFICATE_STATE='Flevoland'
CERTIFICATE_LOCALITY='Almere'
CERTIFICATE_ORGANIZATION='LauLaman Apps'
