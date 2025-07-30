# Overview

Before preparing the environment to deploy and run the KAI DC Builder, familiarize yourself with the solution [architecture](../solution/architecture.md) to understand the role of each component and how they depend on each other.

* Check [prerequisites](prerequisites.md) to make sure your environment is ready.
* Follow instructions to install software components:
    * [DSE Controller](controller.md) – runs trials via test platforms by emulating AI workloads.
    * [DFE Hardware](hardware.md) – uses AresONE hardware as a test platform.
    * [DFE Software](software.md) – uses servers with RDMA NICs as a test platform.
* Deploy a [License Server](licensing.md) and install the KAI DC Builder licenses.

## Configure

Initialize the [parameters](configure.md) for your KAI DC Builder deployment.

## Run

* [Docker Compose](compose.md) – the preferred method for running KAI DC Builder.
* [Docker Run](docker.md) – if you need to directly experiment with launch parameters.
