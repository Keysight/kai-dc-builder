# Running the DSE Controller via Docker Compose

Use this example to run the DSE Controller using Docker Compose.

## Parameters

By default, Docker Compose will read parameters like DSE version, server name, ports and path to storage from an environment file `.env`. Read [Configure](configure.md) section on how to create and modify the `.env` file.

To use the commands below, you must in the `aidc` directory, where the Docker Compose files are located:

```bash
cd ${REPODIR}/aidc
```

## Starting

To start the controller, use

```bash
docker compose up -d
```

To display logs, use

```bash
docker compose logs -f
```

## Stopping

To stop the controller, use

```bash
docker compose down
```

## Multiple environment files

If you would like to have multiple environment files, specify which one to use with the `--env-file` option when running Docker Compose. We recommend naming the files with `.local` suffix, as we configured this Git repository to ignore such names. That way they will not cause any conflicts when pulling updates.

For example, to use `env.dfe1.local`:

```bash
docker compose --env-file env.dfe1.local up -d
```