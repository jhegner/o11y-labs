## To run and stop

> Before the Docker Compose, first generate the containers inside projects

```(bash)
docker build -t o11ylabs-app1-gateway:latest .
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