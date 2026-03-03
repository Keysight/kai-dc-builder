DISTRO_TYPE=""

function check_os {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" = "debian" ]; then
            DISTRO_TYPE="debian"
        elif [ "$ID" = "ubuntu" ]; then
            DISTRO_TYPE="ubuntu"
        elif [ "$ID" = "fedora" ]; then
            DISTRO_TYPE="fedora"
        elif [[ "$ID" = "rocky" || "$ID" = "rhel" || "$ID" = "centos" ]]; then
            DISTRO_TYPE="rhel"
        else
            echo "This is not a supported OS. (Debian, Ubuntu, Fedora, Rocky, CentOS, RHEL)"
        fi
    else
        echo "Cannot determine the operating system"
    fi
}

function install-docker {
    # when this script is used to install just docker
    # we need to run check_os to detect the distro
    if [ -z "${DISTRO_TYPE}" ]; then
        check_os
    fi

    if [ "${DISTRO_TYPE}" = "debian" ]; then
        install-docker-debian
    elif [ "${DISTRO_TYPE}" = "ubuntu" ]; then
        install-docker-ubuntu
    elif [ "${DISTRO_TYPE}" = "rhel" ]; then
        install-docker-rhel
    elif [ "${DISTRO_TYPE}" = "fedora" ]; then
        install-docker-fedora
    fi
}

function install-docker-debian {
    # using instructions from:
    # https://docs.docker.com/engine/install/debian/#install-using-the-repository
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove -y $pkg; done

    # Add Docker's official GPG key:
    sudo apt-get update -y
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y

    sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

function install-docker-ubuntu {
    # using instructions from:
    # https://docs.docker.com/engine/install/debian/#install-using-the-repository
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done

    # Add Docker's official GPG key:
    sudo apt-get update -y
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y

    sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

function install-docker-rhel {
    # using instructions from:
    # https://docs.docker.com/engine/install/rhel/#install-using-the-repository
    sudo yum remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine \
                  podman \
                  runc

    sudo yum install -y yum-utils
    sudo yum-config-manager -y --add-repo https://download.docker.com/linux/rhel/docker-ce.repo

    sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # diverges from the instructions. This means docker daemon starts on each boot.
    sudo systemctl enable --now docker
}

function install-docker-fedora {
    # using instructions from:
    # https://docs.docker.com/engine/install/rhel/#install-using-the-repository
    sudo dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager -y --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # diverges from the instructions. This means docker daemon starts on each boot.
    sudo systemctl enable --now docker
}

function post-install-docker {
    # instructions from:
    # https://docs.docker.com/engine/install/linux-postinstall/
    sudo groupadd docker
    sudo usermod -aG docker "$SUDO_USER"
}

function all {
    # check OS to determine distro
    check_os

    install-docker
    post-install-docker
}

"$@"