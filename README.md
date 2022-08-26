# Docker MCRIT
Dockerized Setup for the MinHash-based Code Recognition and Investigation Toolkit (MCRIT).

## Usage

This repository should enable you to run a production-ready deployment of [MCRIT](https://github.com/danielplohmann/mcrit) including its frontend [MCRITweb](https://github.com/danielplohmann/mcritweb) through a pre-configured Docker setup. 
### Setup for HTTPS

If you want to run the service over HTTPS
* you will need to adjust the Nginx service of the `docker-compose.yml` to use the `mcritweb_ssl.conf` instead of `mcritweb_plain.conf` and 
* Fill the respective files in `./nginx/ssl` with a certificate, private key, and ideally fresh Diffie-Hellman parameters.