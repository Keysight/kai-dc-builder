# Running the DSE Controller via Docker Run

Use this example to run the KAI Data Center Builder via Docker Run.

## Parameters

We recommend managing parameters for Docker via an environment file `.env`. Read [Configure](configure.md) section on how to create and modify the `.env` file.

To use the commands below, initialize the environment variables:

```bash
source "${REPODIR}/aidc/.env"
```

## Starting

To start the controller, use

```bash
mkdir -p "${STORAGE}/log"
docker run --rm -d\
    --name ${DOCKER_NAME} \
    -p ${WEBUI}:443 \
    -p ${GRPC}:50001 \
    -v ${STORAGE}:/dse-storage \
    -v ${STORAGE}/log:/var/log \
    ${ENV_ARGS} \
    ${REGISTRY}/keysight_dse_server:${VERSION} \
    --accept_eula \
    --server_name ${SERVER_NAME} \
    --fs_url osfs:///dse-storage \
    ${LICENSE_SERVERS} \
    ${FEATURES} \
    ${PLUGINS}
```

To display logs

```bash
docker logs -f "${DOCKER_NAME}"
```

## Stopping

```bash
docker stop "${DOCKER_NAME}"
```
