# Generate Domain Certificate using bash script
_Make shure the root certificate is generated and the correct passphrase is in config.sh_

1. run `./generate_ssl.sh -o='some organization' -d=example.org` you'll have the folowing options available: (if null it will be prefilled with the info in [config.sh](../)
  - `-o=Apple` or `--organization=Apple` the organisation that needs this certificate (required)
  - `-d=example.org` or `--domain=example.org` the domain name (required)
  - `-c=NL` or `--country=US` 2 letter country code representing where the organization is located
  - `-s=Fevoland` or `--state=Fevoland` state or province where the organization is located
  - `-l=Almere` or `--locality=Almere` locality or city where the organization is located
  - `-q` or `--quiet` dont print anny output
  - `-h` or `--help` show help
5. install the `[domainname].crt` and `[domainname].key` on the server 