#!/bin/bash
yum -y install ipvsadm
ipvsadm -A -t 192.168.4.5:80 -s wrr
ipvsadm -a -t 192.168.4.5:80 -r 192.168.2.100 -w 1 -m
ipvsadm -a -t 192.168.4.5:80 -r 192.168.2.200 -w 1 -m
ipvsadm -Ln
ipvsadm-save -n > /etc/sysconfig/ipvsadm
