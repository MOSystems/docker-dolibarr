# What is Dolibarr

Dolibarr ERP & CRM is an open-source and free software package to manage companies, freelancers or foundations. We can say Dolibarr is an ERP or CRM (or both depending on activated modules).

For more information and related downloads for Dolibarr, please visit [www.dolibarr.org](https://www.dolibarr.org/).

![logo](https://www.dolibarr.org/templates/dolibarr/images/bg2.png)

# How to use this image

## ... via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

Example `stack.yml` for `dolibarr`:

```yaml
version: '3.2'
services:
  app:
    restart: unless-stopped
    image: mosystems/dolibarr:10.0.3-debug
    environment:
      - DOLIBARR_SETUP_LANG=en_US
      - DOLIBARR_MAIN_URL=http://dolibarr.example.com
      - DOLIBARR_DB_HOST=db
      - DOLIBARR_DB_NAME=dolibarr
      - DOLIBARR_DB_USER=dolibarr
      - DOLIBARR_DB_PASS=dbpassword
      - DOLIBARR_DB_PORT=3306
      - DOLIBARR_FORCE_HTTPS=0
      - DOLIBARR_AUTH=dolibarr
      - DOLIBARR_ADMIN_USER=admin
      - DOLIBARR_ADMIN_PASS=admin
    volumes:
      - www:/www
      - documents:/documents
      - sessions:/sessions
    depends_on: 
      - db
  
  web:
    image: nginx:stable
    volumes:
      - www:/www
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
    ports: 
      - 8080:80
    depends_on: 
      - app

  db:
    image: mariadb:10.4
    environment:
      - MYSQL_DATABASE=dolibarr
      - MYSQL_USER=dolibarr
      - MYSQL_PASSWORD=dbpassword
      - MYSQL_RANDOM_ROOT_PASSWORD=yes
    volumes:
      - database:/var/lib/mysql
    command: [
      '--character-set-server=utf8',
      '--collation-server=utf8_general_ci'
    ]

volumes:
  www:
  database:
  documents:
  sessions:
```

[![Try in PWD](https://github.com/play-with-docker/stacks/raw/master/assets/images/button.png)](http://play-with-docker.com?stack=https://raw.githubusercontent.com/MOSystems/docker-dolibarr/master/stack.yml)

Run `docker stack deploy -c stack.yml dolibarr` (or `docker-compose -f stack.yml up`), wait for it to initialize completely, and visit `http://swarm-ip:8080`, `http://localhost:8080`, or `http://host-ip:8080` (as appropriate).

## Environment Variables
When you start the `dolibarr` image, you can adjust the configuration of the Dolibarr instance by passing one or more environment variables on the `docker run` command line.

### `DOLIBARR_SETUP_LANG`
This variable is optional and specifies the language that Dolibarr will use. If not defined `en_US` will be used by default.

### `DOLIBARR_MAIN_URL`
This variable is mandatory and defines the root URL of your Dolibarr index.php page without ending `/`. For example `https://dolibarr.example.com`.

### `DOLIBARR_DB_HOST`, `DOLIBARR_DB_PORT`, `DOLIBARR_DB_NAME`
These variables are mandatory and contain the host name, port and database name
of the database server to connect to.

### `DOLIBARR_DB_USER`, `DOLIBARR_DB_PASS`
These variables are mandatory and contain the user name and password used to read and write into the Dolibarr database.

### `DOLIBARR_FORCE_HTTPS`
This variable is optional and allows to force the HTTPS mode.

* 0 = No forced redirect
* 1 = Force redirect to https, until SCRIPT_URI start with https into response
* 2 = Force redirect to https, until SERVER["HTTPS"] is 'on' into response
* 'https://my.domain.com' = Force reditect to https using this domain name.

Warning: If you enable this parameter, your web server must be configured to
respond URL with https protocol.
According to your web server setup, some values may works and other not. Try
different values (1,2 or 'https://my.domain.com') if you experience problems.

### `DOLIBARR_AUTH`
This variable is optional and contains the way authentication is done.
If value "ldap" is used, you must also set variables `DOLIBARR_LDAP_*`

Default value: `dolibarr`

You can also separate several values using a ",".
In this case, Dolibarr will check login/pass for each value in the
order defined into value. However, note that this can't work with all values.
Examples:
* `dolibarr` Use the password defined into application on user record.
* `http` Use the HTTP Basic authentication
* `ldap` Check the password into a LDAP server
* `ldap,dolibarr` You can set several mode using a comma as a separator.
* `forceuser` This need to add also $dolibarr_auto_user='loginforuser';
* `twofactor` To use Google Authenticator. This need the non official external module "Two Factor" available on www.dolistore.com

### `DOLIBARR_ADMIN_USER`, `DOLIBARR_ADMIN_PASS`
These variables are mandatory and contain the user name and password
used to login in Dolibarr as the administrator.
These are used only during the installation that happens on first run.
After that they are ignored.


## Docker Secrets

As an alternative to passing sensitive information via environment variables,
`_FILE` may be appended to the previously listed environment variables,
causing the initialization script to load the values for those variables
from files present in the container. In particular, this can be used to
load passwords from Docker secrets stored in `/run/secrets/<secret_name>`
files. For example:

```console
$ docker run --name some-mysql -e MYSQL_ROOT_PASSWORD_FILE=/run/secrets/mysql-root -d mysql:tag
```

Currently, this is only supported for 
`DOLIBARR_DB_NAME`,
`DOLIBARR_DB_USER`,
`DOLIBARR_DB_PASS`,
`DOLIBARR_ADMIN_USER` and
`DOLIBARR_ADMIN_PASS`.
