#!/bin/bash

if [ ! -e './config/config.sh' ]; then
  echo "Error: Config file not found (CertificateAuthority.sh)"
  exit 1
else
	source ./config/config.sh
fi

QUIET=false

while [ $# -gt 0 ]; do
  case "$1" in
    --quiet)
      QUIET=true
      ;;
    -q)
      QUIET=true
      ;;
    --help)
      HELP="${1#*=}"
      ;;
    -h)
      HELP="${1#*=}"
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
    $2
		exit 1
	fi
}
echo "${CA_PASSPHRASE}" 
run_if "Generating Private Key" "openssl genrsa -out ${CA_KEY} ${ENCRYPTION_KEY_SIZE}"
run_if "Enable 3DES encryption on Private Key" "openssl genrsa -des3 -out ${CA_KEY} ${ENCRYPTION_KEY_SIZE}"
run_if "Generating CA Certificate" "openssl req -x509 -passin pass:${CA_PASSPHRASE} -new -nodes -key ${CA_KEY} -${ENCRYPTION_METHOD} -days ${CA_DAYS_VALID} -out ${CA_CERTIFICATE} -subj \"/C=${CERTIFICATE_COUNTRY_CODE}/ST=${CERTIFICATE_STATE}/L=${CERTIFICATE_LOCALITY}/O=${CERTIFICATE_ORGANIZATION}/CN=${CERTIFICATE_COMON_NAME}\""
	
