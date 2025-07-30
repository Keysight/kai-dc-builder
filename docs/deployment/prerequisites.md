# Prerequisites

## Controller

To deploy the DSE Controller, you need to prepare the following:

* `x64 host` – a bare metal host or a virtual machine
* `8 CPU cores`, `8 GB RAM`, `80 GB storage`, if local file system is used for DSE storage
* `Linux OS`: `Ubuntu 22.04 LTS`, `Debian 12`, `RHEL 9.4`, `Rocky Linux 9.4`, `CentOS Stream 9`

## Keysight Hardware

Use this option if you plan to use AresONE hardware to emulate RoCEv2 NICs:

* [AresONE-S (400GE)][aresone_s_product_page] and [AresONE-M (800GE)][aresone_m_product_page] hardware models are supported
* To use more than one AresONE hardware unit in a trial, you need to connect them with sync cables or synchronize via [Metronome Timing System][metronome_product_page].

[aresone_s_product_page]: https://www.keysight.com/us/en/products/network-test/network-test-hardware/aresone-s-400ge.html
[aresone_m_product_page]: https://www.keysight.com/us/en/products/network-test/network-test-hardware/aresone-800ge.html
[metronome_product_page]: https://www.keysight.com/us/en/products/network-test/network-test-hardware/metronome-timing-system.html

## Servers with RDMA NICs

Use this option if you plan to use x86 servers with RDMA NICs to run Data Flow Emulation (DFE). Server requirements:

* `x86-64` host with 1 to 4 RDMA NICs connected via PCIe Gen5
* Recommended `16 CPU cores`, `32 GB RAM` (preliminary information) <!--TODO: add requirements for DFE with Keysight Software-->
* RDMA RoCEv2 NICs: `NVIDIA Connect-X 5/6/7`, `Broadcom Thor/Thor2`. Other RoCEv2 NICs may work, but were not tested.
* `Linux OS`: `Ubuntu 22.04 LTS`, `Debian 12`, `RHEL 9.4`, `Rocky Linux 9.4`, `CentOS Stream 9`
* It is critical to have high precision time synchronization between the DFE hosts for accurate measurements. It is recommended to use PTP for this purpose.
* On RHEL-based systems – install EPEL Repo:

    ```bash
    sudo dnf install -y epel-release
    ```

