# Running with AstraSim Simulation as Test Engine

Use this guide to deploy the DSE Controller with AstraSim simulation as a test engine using Docker Compose.

## Overview

AstraSim is a network simulator that can be used as a test engine for the KAI DC Builder. This deployment configuration uses a specialized Docker Compose file and environment configuration to run the DSE Controller alongside the AstraSim service.

## Prerequisites

- Docker and Docker Compose installed
- Valid license server configuration
- Repository cloned to your local machine

## Configuration Files

This deployment uses two specific files:

- `aidc/compose.astrasim.yml` - Docker Compose configuration for AstraSim deployment
- `aidc/env.astrasim.internal` - Environment variables for AstraSim setup for internal Keysight use

## Environment Configuration

The `env.astrasim.internal` file includes the following AstraSim-specific configurations:

### AstraSim Plugin Configuration

```
PLUGINS="AstraSimPlugin --sim_server_endpoint astrasim:8989 \
                        --astra_sim_backend NS3"
```

This configures the DSE Controller to use the AstraSim plugin with:

   - Simulation server endpoint: `astrasim:8989`
   - Backend: NS3 network simulator

### Feature Flags

```
FEATURES="--feature_flag simulation \
          --feature_flag clos-fabric \
         --feature_flag app-framework"
```

   - The `simulation` feature flag enables the Simulation selection as a Test engine in the physical topology configuration of the DSE Controller.
   - The `clos-fabric` enables you to model the Clos fabric topology in your tests for the simulation backend to use.
   - The `app-framework` enables refactored application framework (required).

### Compose Project Name

```
COMPOSE_PROJECT_NAME=astrasim
```

This ensures the Docker Compose deployment is isolated with a unique project name.

## Starting the Services

Navigate to the `aidc` directory:

```bash
cd ${REPODIR}/aidc
```

Start the DSE Controller and AstraSim service:

```bash
docker compose -f compose.astrasim.yml --env-file env.astrasim.internal up -d
```

This command will:

1. Start the DSE Controller container with AstraSim plugin enabled
2. Start the AstraSim simulation service container
3. Configure networking between the services

## Verifying the Deployment

Display logs to verify the services are running:

```bash
docker compose -f compose.astrasim.yml --env-file env.astrasim.internal logs -f
```

Check that both services are running:

```bash
docker compose -f compose.astrasim.yml --env-file env.astrasim.internal ps
```

## Accessing the DSE Controller

The DSE Controller web UI will be available at [https://localhost](https://localhost) if you've deployed on your local machine.

## Stopping the Services

To stop the AstraSim deployment:

```bash
docker compose -f compose.astrasim.yml --env-file env.astrasim.internal down
```

## Service Architecture

The deployment creates two services:

   1. **dse** - DSE Controller configured with:

      - AstraSim plugin enabled
      - Simulation feature flag active
      - Connection to AstraSim service via hostname `astrasim:8989`

   2. **astrasim** - AstraSim simulation service:

      - Image: `astra_sim_service:latest`
      - Provides network simulation backend for test execution

## Customization

To customize the deployment, you can:

   1. Copy the environment file:

      ```bash
      cp env.astrasim.internal env.astrasim.local
      ```

   2. Modify the configuration in `env.astrasim.local`

   3. Use the custom environment file:

      ```bash
      docker compose -f compose.astrasim.yml --env-file env.astrasim.local up -d
      ```

## Troubleshooting

### License Server Issues

Ensure the `LICENSE_SERVERS` variable in `env.astrasim.internal` is configured correctly:

```bash
LICENSE_SERVERS="--license_servers license_server_name_or_ip"
```

### AstraSim Connection Issues

If the DSE Controller cannot connect to AstraSim:

1. Verify both containers are on the same Docker network
2. Check AstraSim service logs for errors
3. Ensure the endpoint `astrasim:8989` is reachable from the DSE container

## See Also

- [Running via Docker Compose](compose.md) - Standard Docker Compose deployment
- [Configure](configure.md) - Environment file configuration guide
- [Prerequisites](prerequisites.md) - System prerequisites
