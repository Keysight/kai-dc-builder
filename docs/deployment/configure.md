# DSE Controller Configuration

## Repository

Clone KAI DC Builder repository to the machine where you intend to run the DSE Controller. This will become a home of your controller deployment. The repository contains the necessary files and scripts to set up and run the DSE Controller.

```bash
git clone https://github.com/Keysight/kai-dc-builder.git
cd kai-dc-builder
REPODIR="$(pwd)"
```

Later, to receive latest updates, you can run:

```bash
cd kai-dc-builder
REPODIR="$(pwd)"
git pull
```

## Environment File

We recommend managing the parameters of the DSE Controller using an environment file. This allows you to easily configure the deployment without modifying the Docker Run command syntax or Docker Compose YAML files. By default, Docker Compose method of running the DSE Controller will look for a file named `.env` in the `aidc` directory. If you prefer to use a different file name, you can specify it with the `--env-file` option when running Docker Compose.

The example below uses `env.latest` as a starting point to create `.env`. To run a specific [version](../kaidcb/versions.md) of the DSE software, use matching `env.<version>` file instead of `env.latest`.

1. Backup the existing `.env` file, if it exists:

    ```bash
    cd ${REPODIR}/aidc
    [ -f .env ] && cp .env .env.bak
    ```

2. Copy the environment file template for the latest version to `.env`. Compare it with the backup file, if it exists:

    ```bash
    cp env.latest .env
    [ -f .env.bak ] && diff .env .env.bak
    ```

3. Carry over any necessary modifications from the `.env.bak` to the `.env` by manually editing the `.env` file and checking the differences.

4. If you plan to use Data Flow Emulation on servers with RDMA NICs (Keysight software as a test platform), in the `.env` file uncomment the following line and replace `localhost` with hostname or IP of the primary DFE host (Redis server):

    ```bash
    PLUGINS="DfePlugin --redis_host localhost --redis_port 6379"
    ```

5. If this is your first time running the DSE Controller, and you need to use the licensed features of the product, you must change the `LICENSE_SERVERS` variable in the `.env` file to point to the License Server VM(s) you have deployed:

    ```bash
    LICENSE_SERVERS="--license_servers server1 server2"
    ```

    If you don't have a License Server, you can use the DSE Controller in the demo mode by leaving the `LICENSE_SERVERS` variable empty.
