TOKEN=$1
MINION_ID=$2
MINION_IP=$3
NUM_MINIONS=$4

INSTANCE_PREFIX=swarm
MINION_TAG="${INSTANCE_PREFIX}-minion"
MINION_NAMES=($(eval echo ${INSTANCE_PREFIX}-minion-{1..${NUM_MINIONS}}))
MINION_IP_RANGES=($(eval echo "10.245.{2..${NUM_MINIONS}}.2/24"))
SCRIPT_ROOT=$(dirname "${BASH_SOURCE}")

#echo "proxy=http://9.187.160.169:80" >> /etc/yum.conf

if ! which docker >/dev/null 2>&1; then
	yum -y install docker-io
	service docker stop
	#echo 'OPTIONS="--selinux-enabled -H 0.0.0.0:2375 -H unix:///var/run/docker.sock --insecure-registry jadetest.cn.ibm.com:5000"' > /etc/sysconfig/docker
	cp /vagrant/docker /usr/bin/docker	
fi

if ! which ovs-vsctl >/dev/null 2>&1; then	
	yum -y install openvswitch
fi

if ! which brctl >/dev/null 2>&1; then	
	yum -y install bridge-utils
fi

if ! which iptables >/dev/null 2>&1; then	
	yum -y install iptables-services
fi

# run the networking setup
"${SCRIPT_ROOT}/provision-network.sh" $@
/kubernetes-vagrant/network_closure.sh

usermod -a -G docker vagrant

service iptables restart
service openvswitch start
systemctl restart network.service || true
service docker restart
docker version
cp /vagrant/swarm /usr/bin/swarm
nohup swarm join token://$TOKEN --addr $MINION_IP:2375 &
