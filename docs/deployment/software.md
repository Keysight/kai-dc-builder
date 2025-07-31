# Installation on Servers with RDMA NICs

Use this option if you plan to use servers with RDMA NICs to run Data Flow Emulation.

## Redis DB

Install Redis DB on the Primary DFE Host (designate any one of the DFE hosts as Primary):

1. Allow access to port `6379` according to the [architecture](../solution/architecture.md) documentation.

2. Install Redis DB service

    ```bash
    # For Debian-based systems
    sudo apt install redis-server -y
    # For RHEL-based systems
    sudo dnf install -y redis
    ```

3. Allow Redis to accept external connections

    !!! Warning
        This is insecure, use only on lab equipment protected from unauthorized network access.

    ```bash
    REDIS_CONF="/etc/redis/redis.conf"
    sudo cp "$REDIS_CONF" "$REDIS_CONF.bak"
    sudo sed -i 's/^bind .*/bind 0.0.0.0/' "$REDIS_CONF"
    sudo sed -i 's/^protected-mode .*/protected-mode no/' "$REDIS_CONF"
    sudo diff "$REDIS_CONF.bak" "$REDIS_CONF"
    ```

4. Restart Redis service and check if it is listening on `0.0.0.0:6379`

    ```bash
    sudo systemctl enable redis
    sudo systemctl restart redis
    systemctl status redis --no-pager
    netstat -an | grep 6379
    ```

## DFE

Install Data Flow Emulation software on every host that has RDMA NICs you want to use for running KAI DC Builder trials:

1. Download "KAI Data Flow Emulation (DFE) for Keysight Software" component for your Linux distribution. See [Releases](../kaidcb/versions.md) for a download link.

2. Initialize parameters for the DFE installation. Replace `1.0.0-4` with the DFE version you downloaded. Use the Primary DFE Host name or IP instead of `replace_with_hostname_or_ip` below:

    ```bash
    DFEVER=1.0.0-4
    DFE_PRIMARY=replace_with_hostname_or_ip
    ```

3. Install Data Flow Emulation software:

    ```bash
    # For Debian-based systems
    sudo dpkg -i keysight-dataflow-agent_${DFEVER}_amd64.deb
    # For RHEL-based systems
    sudo dnf install -y keysight-dataflow-agent-${DFEVER}.el9.x86_64.rpm
    ```

4. Create a DFE configuration file. If you plan to use IPv6 addresses, set `UseIPv6Addresses=true`:

    ```bash
    sudo bash -c "cat > /etc/dfe/dataflow-host.conf" << EOF
    [General]
    RedisHost=${DFE_PRIMARY}
    RedisPort=6379
    HostId=$(hostname -s)
    RunMode=hardroce
    Environment=host
    UseIPv6Addresses=false
    LogLevel=debug

    [nccl-tests]
    MpirunUser=mpi
    NcclTestsPath=/nccl-tests
    EOF
    ```

5. Check the content of the configuration file, make sure you have correct `RedisHost` and `HostId`:

    ```bash
    cat /etc/dfe/dataflow-host.conf
    ```

6. Start Data Flow Emulation service on every host:

    ```bash
    sudo /opt/keysight/dfe/dfe-host/dataflow_host/dataflow_host --daemon &
    ```

7. Check the logs of the Data Flow Emulation service:

    ```bash
    tail -f /var/log/dfe/dataflow-host.log
    ```
