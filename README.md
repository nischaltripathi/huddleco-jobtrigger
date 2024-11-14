# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* <http://127.0.0.1:3000/letter_opener> <- to check emails

* ...
# Development

## Environemnt Variables

Enironment variables can be found in `.env` . It is recommended to copy the file to `.env.local.development` and add the required values.

## Credentials

To edit the `config/credentials.yml.enc` in vscode run the follow command.

```bash
VISUAL="code --wait" bin/rails credentials:edit && bin/rails restart
```

A new tab with a temporary unencrypted version of the credentials file will open. Save and close the tab to and encrypt changes.

## Deployment

### Initial Deployment

When deploying for the first time, secrets will need to be created so that app can boot successfully.

Create a docker secret on the production server with the contents of the local `config/master.key` file with the following command.

```bash
$ cat config/master.key | ssh deploy@laura-malta.bnr.la "docker secret create migr8now_webapp_rails_master_key -"
xqhgffymdlduqru41pm9f6kis
```

### Update deployment

Run these commands to deploy the app

```bash

$ rsync -azlP --delete --include Dockerfile --include docker-compose* --exclude-from=.dockerignore  . deploy@laura-malta.bnr.la:~/migr8now && \
  ssh deploy@laura-malta.bnr.la -t "\
    (cd ~/migr8now && \
    docker build . -t migr8now-webapp:latest && \
    docker stack deploy -c docker-compose.prod.yml migr8now) && \
    docker service update migr8now_app --image migr8now-webapp:latest --force && \
    docker system prune -af && \
    rm -rfv ~/migr8now"
```

## Production Console

To access the production console for the app, SSH into the production server.

```bash
$ ssh deploy@laura-malta.bnr.la
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-113-generic x86_64)
...
```

Run the `bin/docker-entrypoint bin/rails c` command via `docker exec` to access the production rails console.

```bash
docker exec -it <CONTAINER_NAME> bin/docker-entrypoint bin/rails c
```

Where `<CONTAINER_NAME>` is the container instance name that starts with `migr8now_webapp_app` .

*Tip: type `docker exec -it bdm` then press tab to autocomplete to container name.*
