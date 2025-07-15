## To run and stop

> Before the Docker Compose, first generate the containers inside projects

```(bash)
docker build -t o11ylabs-app1-gateway:latest -f dockerfile .
```

> Run your Docker Compose setup

```(bash)
docker compose up
```

> Add -d to run in detached mode

```(bash)
docker compose up -d
```

> To rebuild images before starting

```(bash)
docker compose up --build
```

> TTo stop and remove containers

```(bash)
docker compose down
```

---

## Envs vars

> DD_LOGS_ENABLED=true,DD_APM_ENABLED=true,DD_ENV=lab,DD_SERVICE=o11y-labs-app1-gateway,DD_VERSION=001,DD_API_KEY=${KEY},DD_APPS_KEY=${KEY},DD_URI_SITE="us5.datadoghq.com"
