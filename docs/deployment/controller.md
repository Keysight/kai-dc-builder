# Controller Installation

## Docker

1. Install Docker environment to run the DSE Controller:

    ```bash
    curl -fsSL https://get.docker.com | sudo sh -
    ```

2. Add your user account to the `docker` group to be able to run Docker commands without `sudo`:

    ```bash
    sudo usermod -aG docker "$USER"
    logout
    ```

## DSE Controller

1. Download "KAI Distributed System Experiments (DSE) Controller – Docker" file. See [Releases](../kaidcb/versions.md) for a download link.

2. Load the DSE image into Docker with the following command:

    ```bash
    docker load -i <path_to_dse_controller_image>.tar.gz
    ```


