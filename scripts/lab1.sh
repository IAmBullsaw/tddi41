#! /bin/bash

function printUsage() {
    echo "-> usage:";
    echo "-> $0 -ho(stname) -ip(addres) -ne(tmask) -su(bnet) -ga(teway) -v(erbose)"
    # echo "-> $0 Hostname Ipnumber Netmask Subgroup Gateway";
}

[ $# -gt 4 ] || { printUsage; exit -1; }

VERBOSE=5 # start at 2 since stdout=1 stderr=2

declare -A LOG_LEVELS
# https://en.wikipedia.org/wiki/Syslog#Severity_level
LOG_LEVELS=([0]="emerg" [1]="alert" [2]="crit" [3]="err" [4]="warning" [5]="notice" [6]="info" [7]="debug")
function .log () {
    local LEVEL=${1}
    shift
    if [ ${VERBOSE} -ge ${LEVEL} ]; then
        echo "-> [${LOG_LEVELS[$LEVEL]}]" "$@"
    fi
}

GWFLAG=false
while getopts 'h:i:n:s:g:vw' flag; do
    case "${flag}" in
        h) HOSTNAME="${OPTARG}" ;;
        i) IPADDRESS="${OPTARG}" ;;
        n) NETMASK="${OPTARG}" ;;
        s) SUBGROUP="${OPTARG}" ;;
        g) GATEWAY="${OPTARG}" ;;
        v) ((VERBOSE=VERBOSE+1)) ;;
        w) GWFLAG=true ;;
        *) error "Unexpected option $(flag)" ;;
    esac
done

if [ $GWFLAG = true ]; then
    command -v iptables || { error '-> flag -w requires iptables to be installed. run apt install iptables'; exit -2: }
fi

echo "-> Performing lab1 ..."

.log 6 "Hostname: $HOSTNAME"
.log 6 "IP: $IPADDRESS"
.log 6 "Subgroup: $SUBGROUP"
.log 6 "Gateway: $GATEWAY"
read -n 1 -p "-> Really continue? (y/n) " answer # The "Är det it slutgiltiga svar?"
echo ""
[ "$answer" == "y"  ] || { exit 0; }
echo "-> Here we go!"
echo "$HOSTNAME" > /etc/hostname # Set hostname
echo "$IPADRESS $HOSTNAME.$SUBGROUP $HOSTNAME" >> /etc/hosts # Append this to hosts
IFFACE='eth0'
[ $GWFLAG = true ] && { IFFACE='eth1'; echo -e "\nauto eth0\niface eth0 inet dhcp\n" >> /etc/network/interfaces; }
echo -e "\n auto $IFFACE\niface $IFFACE inet static\naddress $IPADDRESS\nnetmask $NETMASK\ngateway $GATEWAY\n" >> /etc/network/interfaces
.log 7 `cat /etc/hostname`
.log 7 `cat /etc/hosts`
.log 7 `cat /etc/network/interfaces`

.log 6 'ifdowning and upping.'
ifdown -a && ifup -a

if [ $GWFLAG = true ]; then
    .log 6 'enabling forwarding'
    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE # MASQUERAAAAAAAAAAAAADE
    iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
fi

echo "-> lab1 done."
