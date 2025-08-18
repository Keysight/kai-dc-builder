# Licensing

## Licensed Capabilities

The following capabilities of the KAI DC Builder require a valid license:

  | Capability                                        | Licenses Required            | Quantity           |
  |------------------------------------------         |------------------------------|--------------------|
  | Run Collective Benchmarks App trial               |  Collective Benchmarks App   | Uncounted          |
  | Run Workload Emulation App trial                  |  Workload Emulation App      | Uncounted          |
  | Emulate RDMA NICs with Keysight Hardware          |  Data Flow Emulation – Universal Transport Endpoints | Number of concurrent endpoints (NICs) |
  | Use RDMA NICs with Keysight Software              |  Data Flow Emulation – Universal Transport Endpoints | Number of concurrent endpoints (NICs) |

See the [KAI Data Center Builder Data Sheet][kai-dcb-datasheet] for more information about ordering the licenses.

Without a valid license, apps in the KAI DC Builder can be used to view the results of the previous trials.

## License Server

In order to use capabilities that require a valid license, you need to deploy a [Keysight License Server][support-license-server] version `4.4.0` or later. The license server enables licenses to float and not be tied to a specific KAI DC Builder instance. The DSE Controller from each KAI DC Builder deployment must be able to reach the License server.

### Requirements

The license server is a virtual machine and it is distributed as OVA and QCOW2 images. You only need one of them depending on your hypervisor, downloading may need credentials for the [support website][support-license-server].

To make a decision where to deploy the License Server VM, take into the account the following requirements:

* For VMware ESXi, use the `OVA` image
* For Linux-based QEMU or KVM, use the `QCOW2` image
* `2 vCPU` cores
* `8GB RAM` for ESXi, `4GB RAM` for QEMU/KVM
* `100GB` storage
* `1 vNIC` for network connectivity. Note that DHCP is the preferred option, and this is also how the VM is configured to obtain its IP address.

### Deployment

To deploy the License Server VM, follow standard procedures for your hypervisor. For example, in VMware ESXi, you can use the vSphere Client to import the OVA file and deploy the VM. For QEMU/KVM, you can use `virt-manager` or `virsh` commands to create a new VM from the QCOW2 image.

### Connectivity

Network connectivity requirements for the License Server VM:

1. Internet access from the VM over `HTTPS (TCP/443)` is desirable for online license activation, but not strictly required. Offline activation method is available if Internet connectivity is not possible.
2. Access from a user to the License Server VM over `HTTPS (TCP/443)` for license operations (activation, deactivation, reservation, sync).
3. Access from a DSE Controller that needs a license to the License Server VM over `gRPC (TCP/7443)` for license checkout and check-in.

Here is an example of how different components communicate with the License Server:

![License Server Connectivity](../assets/license-server.drawio.svg)

### Configuration

If your network doesn't provide DHCP, you can configure a static IP address for the License Server VM. Access the License Server VM console and go through two-step login process:

* First prompt: `console` (no password)
* Second promt: `admin`/`admin`
* Run the following commands to configure a static IP address, where `x.x.x.x` is the IP address, `yy` is the prefix length, `z.z.z.z` is the default gateway, `a.a.a.a` and `b.b.b.b` are DNS servers:

```Shell
kcos networking ip set mgmt0 x.x.x.x/yy z.z.z.z
kcos networking dns-servers add a.a.a.a b.b.b.b
```

## License Activation

Now you shall be able to activate licenses for the KAI DC Builder. Go to `https://your-license-server-hostname` to access the application. Enter credentials: `admin`/`admin` to login.

If you have an activation code, click "Activate Licenses" to perform an online activation, enter the code and click "Activate". For offline mode, choose "Offline Operations" instead.

You can also use a command-line session, via console or SSH, to perform license operations. Run `kcos licensing --help` to see the list of available commands.

## DSE Configuration

To connect the DSE Controller to the License Server VM(s), provide the location of the license servers to the controller instance during the launch using:

```
--license_servers server1 server2
```

The argument accepts a space-separated list of hostnames or IP addresses of the License Servers, up to four. The controller will try to connect to the License Servers in the order they are specified in the list. If the first License Server is not available, or doesn't have enough available licenses to run the test, the controller will try to connect to the next one in the list.

The [Docker Compose][deployment-compose] deployment method provided in this repository already includes the License Server configuration. You can find it in you local copy of the `.env` file under the `LICENSE_SERVERS` variable. You have to set it to the hostnames or IP addresses of your License Server VMs, for example:

```
LICENSE_SERVERS="--license_servers server1 server2"
```

[support-license-server]: https://support.ixiacom.com/keng-license-server-software-downloads-documentation
[kai-dcb-datasheet]: https://www.keysight.com/us/en/assets/3125-1348/data-sheets/Keysight-AI-Data-Center-Builder.pdf
[deployment-compose]: compose.md
[deployment-env]: ../aidc/env.latest
