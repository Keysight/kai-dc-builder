# Migration to Storage v2

> Make sure to follow the [Repository](../../deployment/configure.md#repository) section from the DSE Controller Configuration page. 

Use this procedure to migrate existing trial results from KAI DC Builder version 1.x to version 2.0. It assumes you are using the recommended deployment method with the `${REPODIR}/aidc/.env` configuration file for Docker Compose.

1. Edit the `.env` to make sure the STORAGE variable points to a path to a new storage location. If you're using the standard template for the `env.2.0`, it would look like this:

    ```sh
    STORAGE=${HOME}/dse-storage-v2/${COMPOSE_PROJECT_NAME}
    ```

2. In the current shell session, initialize a variable with a path to the existing `v1` storage location – the same way it was used to run KAI DC Builder version 1.x. For example:

    ```sh
    # replace with a proper path to the v1 storage
    STORAGE_V1=${HOME}/dse-storage
    ```

3. Copy the existing storage data to the new storage location. If you were using multiple DSE server names for different set of results with v1, it is a good moment to decide if you want to migrate all of them or only results from some servers. Choose subdirectories below accordingly. The example below copies results from all servers via a `*` wildcard.

    ```sh
    cd ${REPODIR}/aidc
    source .env
    mkdir -p ${STORAGE}/v1
    sudo cp -r ${STORAGE_V1}/* ${STORAGE}/v1/
    ```

4. Clean the existing virtual environment to make sure all dependencies are reinstalled for version 2.0.

    ```sh
    cd ${REPODIR} && sudo -E make clean-venv
    ```

5. Deploy KAI DC Builder v2.0 from a Docker Compose setup with a Jupyter Notebook server. First, only start the DSE server.

    ```sh
    cd ${REPODIR}/aidc
    docker compose -f compose.nb.yml create
    docker compose -f compose.nb.yml start dse
    docker compose -f compose.nb.yml logs -f dse
    ```

    Observe the logs to ensure the server starts correctly – you should see a message below. Interrupt the log streaming with `Control-C`.

    ```
    SERVER - INFO - Starting UI on port     : 443
    ```

6. Pull the required Python modules from the DSE and install Jupyter notebooks. Start the Jupyter server. This step may take several minutes.

    ```sh
    cd ${REPODIR} && sudo -E make pull-modules notebooks
    cd ${REPODIR}/aidc
    docker compose -f compose.nb.yml start jupyter
    docker compose -f compose.nb.yml logs -f jupyter
    ```

    Wait until the package installation is complete and you see the message below. Interrupt the log streaming with `Control-C`.

    ```
    Jupyter Server 2.8.0 is running at:
    ```

6. Open the Jupyter Notebook server in your browser, depending on the hostname of system with the DSE. Open the `migrate_storage.ipynb` notebook and follow the instructions there to complete the migration process.

7. After the migration is complete, delete the `v1` subfolder under the storage location to free up space. This will still keep the original data intact in the previous storage location defined by the `STORAGE_V1` variable.

    ```
    cd ${REPODIR}/aidc
    source .env
    sudo rm -rf ${STORAGE}/v1
    ```

!!! warning "Data Duplicates"
    The migration process creates new IDs for each trial result. Therefore, if running the migration multiple times, you may see duplicate results.

