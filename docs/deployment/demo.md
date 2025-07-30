# Demo results

Before deploying the KAI DC Builder, you can pre-seed the storage with demo results.

1. Download the demo results archive:

    ```bash
    make pull-demo-tgz
    ```

2. Extract the demo results archive to the storage directory:

    > **Warning:** This may override existing trial results in the storage directory. Experiment with un-archiving in a separate, empty directory if you are not sure.

    ```bash
    source ${REPODIR}/aidc/.env
    mkdir -p ${STORAGE}
    cd ${STORAGE}/..
    tar xzf ${REPODIR}/downloads/demo.${VERSION}.tar.gz
    ```
