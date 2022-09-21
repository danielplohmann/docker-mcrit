# Docker MCRIT
Dockerized Setup for the MinHash-based Code Recognition and Investigation Toolkit (MCRIT).

## Summary

This repository should enable you to run a production-ready deployment of [MCRIT](https://github.com/danielplohmann/mcrit) including its frontend [MCRITweb](https://github.com/danielplohmann/mcritweb) with minimal effort through a pre-configured Docker setup. 

## Setup

Given an installation of `docker-compose`, running this command in the repository root:

```bash
$ docker-compose up
```

should build the MCRIT and MCRITweb containers, pull images for mongodb and nginx, and then start everything up.

The data produced and stored by the services are found in `./storage`:

* `./storage/mcritweb` contains the sqlite DB for the web application and cached data
* `./storage/mongodb`  contains all collections and indices, allowing it to persist across instance rebuilds.


### Setup for HTTP(S)

By default, the Nginx included in this setup is only listening for the `server_name` of `localhost`, so you will need to configure
* `./nginx/mcritweb_plain.conf` or recommendably:
* `./nginx/mcritweb_ssl.conf`

based on the specifics of your server.

If you want to run the service over HTTPS
* you will need to adjust the Nginx service of the `docker-compose.yml` to use the `./nginx/mcritweb_ssl.conf` instead of `./nginx/mcritweb_plain.conf` and 
* Fill the respective files in `./nginx/ssl` with a certificate, private key, and ideally fresh Diffie-Hellman parameters.

### Development Mode

If you want to use this Docker setup for development on MCRIT, you will need the repositories available outside of the containers.
For this, `mcrit` and `mcritweb` should first be cloned into `./repositories`, for which you can conveniently use the script `clone_repositories.sh`.
Afterwards, you can start the setup up in development mode, using:
```bash
$ docker-compose -f docker-compose-dev.yml up
```
Note that running in development mode will not start up Nginx, meaning you can reach MCRIT only via ports `5000` (frontend) and `8000` (backend).