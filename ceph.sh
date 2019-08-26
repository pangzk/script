#!/bin/bash
#	环境准备
#  client   eth0:192.168.4.10/24
#  node1    eth0:192.168.4.11/24
#  node2    eth0:192.168.4.12/24
#  node3    eth0:192.168.4.13/24
#
#首先部署ftp包
# mkdir  /var/ftp/ceph
# mount ceph10.iso /var/ftp/ceph/
 ssh-keygen   -f /root/.ssh/id_rsa    -N ''

 for i in 10  11  12  13
 do
     ssh-copy-id  192.168.4.$i
 done
      
echo 192.168.4.10  client >>  /etc/hosts 
echo 192.168.4.11  node1  >>  /etc/hosts 
echo 192.168.4.12  node2  >>  /etc/hosts 
echo 192.168.4.13  node3  >>  /etc/hosts 

echo '[mon]
name=mon
baseurl=ftp://192.168.4.254/ceph/MON
gpgcheck=0
[osd]
name=osd
baseurl=ftp://192.168.4.254/ceph/OSD
gpgcheck=0
[tools]
name=tools
baseurl=ftp://192.168.4.254/ceph/Tools
gpgcheck=0' >  /etc/yum.repos.d/ceph.repo


sed -i "/gateway /s/gateway/192.168.4.254/"  /etc/chrony.conf

 for i in client node1  node2  node3
do
scp  /etc/hosts   $i:/etc/
scp  /etc/yum.repos.d/ceph.repo   $i:/etc/yum.repos.d/
scp /etc/chrony.conf $i:/etc/
ssh  $i  "systemctl restart chronyd"


done

#安装部署软件ceph-deploy
yum -y install ceph-deploy
 mkdir ceph-cluster
 cd ceph-cluster/

#1）创建Ceph集群配置,在ceph-cluster目录下生成Ceph配置文件。在ceph.conf配置文件中定义monitor主机是谁。
 ceph-deploy new node1 node2 node3

#2）给所有节点安装ceph相关软件包。
for i in node1 node2 node3
do
    ssh  $i "yum -y install ceph-mon ceph-osd ceph-mds ceph-radosgw"
done 

#3）初始化所有节点的mon服务，也就是启动mon服务（主机名解析必须对）。
 ceph-deploy mon create-initial

#步骤三：创建OSD
#备注：vdb1和vdb2这两个分区用来做存储服务器的journal缓存盘。
 for i in node1 node2 node3
do
     ssh $i "parted /dev/vdb mklabel gpt"
     ssh $i "parted /dev/vdb mkpart primary 1 50%"
     ssh $i "parted /dev/vdb mkpart primary 50% 100%"
 done


#2）磁盘分区后的默认权限无法让ceph软件对其进行读写操作，需要修改权限。node1、node2、node3都需要操作，这里以node1为例。
echo `ENV{DEVNAME}=="/dev/vdb1",OWNER="ceph",GROUP="ceph"
ENV{DEVNAME}=="/dev/vdb2",OWNER="ceph",GROUP="ceph"`>  /etc/udev/rules.d/70-vdb.rules

 for i in node1 node2 node3
do
     ssh $i "chown  ceph.ceph  /dev/vdb1"
     ssh $i "chown  ceph.ceph  /dev/vdb2"
     scp  /etc/udev/rules.d/70-vdb.rules  $i:/etc/udev/rules.d/70-vdb.rules
done

ceph-deploy disk  zap  node1:vdc   node1:vdd    
ceph-deploy disk  zap  node2:vdc   node2:vdd
ceph-deploy disk  zap  node3:vdc   node3:vdd   

 ceph-deploy osd create  node1:vdc:/dev/vdb1 node1:vdd:/dev/vdb2  
 ceph-deploy osd create  node2:vdc:/dev/vdb1 node2:vdd:/dev/vdb2
 ceph-deploy osd create   node3:vdc:/dev/vdb1 node3:vdd:/dev/vdb2 

sleep  10
 ceph  -s  > /dev/null
sleep  5
 ceph  -s












