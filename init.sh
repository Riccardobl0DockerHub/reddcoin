#!/bin/bash
rm "${DATA_DIR}/bootstrap.dat.old"
if [ ! -f "${DATA_DIR}/bootstrapped" ];
 then
    d=$PWD
    cd /tmp/
    wget "${BOOTSTRAP}" -O bootstrap.dat.xz 
    hash="`sha256sum bootstrap.dat.xz| cut -d ' ' -f 1`" 
     if [ "$hash" != "${BOOTSTRAP_HASH}" ]; then  
        echo "bootstrap.dat.xz hash does not match. ${BOOTSTRAP_HASH} != $hash"
        exit 1 
    fi 
    xz -d bootstrap.dat.xz
    mv bootstrap.dat ${DATA_DIR}
    echo "1">"${DATA_DIR}/bootstrapped"
    cd $PWD
    /opt/reddcoin/bin/64/reddcoind -conf="${DATA_DIR}/reddcoin.conf" -loadblock="${DATA_DIR}/bootstrap.dat" -datadir="${DATA_DIR}"  -printtoconsole $@
fi
/opt/reddcoin/bin/64/reddcoind -conf="${DATA_DIR}/reddcoin.conf"  -datadir="${DATA_DIR}" -printtoconsole $@

