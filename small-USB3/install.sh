#!/bin/bash

COMPAT_MAJOR=("2")
COMPAT_MINOR=("1.0")

COMPAT_PROFILES=("small")

COMPAT_JETSON=("TX2")

#utility functions
chkroot(){

    if [ $EUID -ne 0 ]
    then
        echo "Please run as sudo or root"
        exit 1
    fi
}

chkhost(){

    if [ $( uname -i | grep -c x86) -lt 1 ]; then
        echo "This version of the small TX2 carrier board BSP must be installed on the x86 Host system"
        exit 1
    fi

}


install_dtb(){

    cp ./kernel/dtb/* ../64_TX2/Linux_for_Tegra_tx2/kernel/dtb/
}

install_kernel(){

    cp ./kernel/*Image ../64_TX2/Linux_for_Tegra_tx2/kernel/
    cp ./kernel/kernel_supplements.tbz2 ../64_TX2/Linux_for_Tegra_tx2/rootfs/
    tar -xjf ../64_TX2/Linux_for_Tegra_tx2/rootfs/kernel_supplements.tbz2 -C ../64_TX2/Linux_for_Tegra_tx2/rootfs/
    rm ../64_TX2/Linux_for_Tegra_tx2/rootfs/kernel_supplements.tbz2
}

install_sh(){
    cp ./flashTX2.sh ../64_TX2/Linux_for_Tegra_tx2/
}

install_ver_file(){

    if [ ! -d "../rootfs/etc/small" ]; then
        mkdir ../64_TX2/Linux_for_Tegra_tx2/rootfs/etc/small
    fi  
}

print_versions(){

    echo "Supported Version Information"

    echo "  Supported CTI Products (profiles): "
    for i in ${COMPAT_PROFILES[@]}; do
        echo "    " $i
    done

    echo "  Supported Linux for Tegra Release Versions: "
    for j in ${COMPAT_MINOR[@]}; do
        echo "    " $COMPAT_MAJOR"."$j
    done

    echo "  Supported Nvidia Jetson Module Hardware: "
    for k in ${COMPAT_JETSON[@]}; do
        echo "    " $k
    done

}

#help functions 

usage(){
    echo -e "  Usage: ./install.sh "
    echo -e "  Below are the compatible L4T versions and board profiles:\n"

    print_versions
}


#start
usage

chkroot

cp conf/* ../64_TX2/Linux_for_Tegra_tx2/

install_dtb

install_kernel

install_ver_file

install_sh

pushd ..

./64_TX2/Linux_for_Tegra_tx2/apply_binaries.sh

popd

# ensure the files finish copying 
sync
