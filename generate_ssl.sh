#!/bin/bash

if [ ! -e './config/config.sh' ]; then
  echo "Error: Config file not found (config.sh)"
  exit 1
else
	source ./config/config.sh
fi

USAGE="$(basename "$0") [-d] [-o] -- generate domain certificates

options:
    -d=[domian name]       --domain=[domian name]
    -c=[country code]      --country=[country code]             A 2 letter code: NL
    -s=[state]             --state=[state]                      state or province
    -l=[locality]          --locality=[locality]                locality or city
    -o=[organization name] --organization=[organization name]   who owns this domain
    -q                     --quiet                              enable quiet mode
    -h                     --help                               show this help"
CERTIFICATE_DOMAIN_NAME=''
CERTIFICATE_COUNTRY_CODE=''
CERTIFICATE_STATE=''
CERTIFICATE_LOCALITY=''
CERTIFICATE_ORGANIZATION=''
CERTIFICATE_DAYS_VALID=365
QUIET=false

while [ $# -gt 0 ]; do
  case "$1" in
    --domain=*)
      CERTIFICATE_DOMAIN_NAME="${1#*=}"
      ;;
    -d=*)
      CERTIFICATE_DOMAIN_NAME="${1#*=}"
      ;;
    --country=*)
      CERTIFICATE_COUNTRY_CODE="${1#*=}"
      ;;
    -c=*)
      CERTIFICATE_COUNTRY_CODE="${1#*=}"
      ;;
    --state=*)
      CERTIFICATE_STATE="${1#*=}"
      ;;
    -s=*)
      CERTIFICATE_STATE="${1#*=}"
      ;;
    --locality=*)
      CERTIFICATE_LOCALITY="${1#*=}"
      ;;
    -l=*)
      CERTIFICATE_LOCALITY="${1#*=}"
      ;;
    --organization=*)
      CERTIFICATE_ORGANIZATION="${1#*=}"
      ;;
    -o=*)
      CERTIFICATE_ORGANIZATION="${1#*=}"
      ;;
    --quiet)
      QUIET=true
      ;;
    -q)
      QUIET=true
      ;;
    --help)
      HELP="${1#*=}"
      echo "$USAGE"
      ;;
    -h)
      HELP="${1#*=}"
      echo "$USAGE"
      ;;
  esac
  shift
done

print_screen() {
	if [ "$QUIET" = false ]; then
		printf "$1"
	fi
}
print_screen_width() {
	print_screen "$1"
	size=${#1} 
	for ((i=$size; i<=60; i++)); do
   		printf ' '
	done
}
run_if() {
	print_screen_width "$1"
	if eval $2 > /dev/null 2> /dev/null; then
		print_screen "\033[32m[DONE]\033[0m\n"
		$3
	else
	  print_screen "\033[31m[FAILED]\033[0m\n"
		exit 1
	fi
}

if [ -z "$CERTIFICATE_DOMAIN_NAME" ]; then
	print_screen "\033[31m**************************************\n"
  print_screen "* Error: please supply a domain name.*\n"
  print_screen "**************************************\033[0m\n\n"
  echo "$USAGE"
	exit 1
fi

if [ -z "$CERTIFICATE_ORGANIZATION" ]; then
	print_screen "\033[31m**********************************************\n"
  print_screen "* Error: please supply the organization name.*\n"
  print_screen "**************************************\033[0m\n\n"
  echo "$USAGE"
	exit 1
fi


run_if "Generating Domain Private Key" "openssl genrsa -out ${SSL_STORE_PATH}/${CERTIFICATE_DOMAIN_NAME}.key ${ENCRYPTION_KEY_SIZE}"
run_if "Generating Certificate Signing Request" "openssl req -new -key ${SSL_STORE_PATH}/$CERTIFICATE_DOMAIN_NAME.key -out ${SSL_STORE_PATH}/$CERTIFICATE_DOMAIN_NAME.csr -subj \"/C=${CERTIFICATE_COUNTRY_CODE}/ST=${CERTIFICATE_STATE}/L=${CERTIFICATE_LOCALITY}/O=${CERTIFICATE_ORGANIZATION}/CN=${CERTIFICATE_DOMAIN_NAME}\""
run_if "Signing the requested certificate" "openssl x509 -passin pass:${CA_PASSPHRASE} -req -in ${SSL_STORE_PATH}/${CERTIFICATE_DOMAIN_NAME}.csr -CA ${CA_CERTIFICATE} -CAkey ${CA_KEY} -CAcreateserial -out ${SSL_STORE_PATH}/${CERTIFICATE_DOMAIN_NAME}.crt -days ${CERTIFICATE_DAYS_VALID} -${ENCRYPTION_METHOD}" "rm ${SSL_STORE_PATH}/${CERTIFICATE_DOMAIN_NAME}.csr"
run_if "Combining Root certificate and domain certificate" "cat ${CA_CERTIFICATE} >> ${SSL_STORE_PATH}/${CERTIFICATE_DOMAIN_NAME}.crt"
	
