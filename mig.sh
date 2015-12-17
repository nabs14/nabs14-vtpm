#!/bin/bash

# Migration
#echo -n "Enter username for ssh: "
#read USERNAME
echo -n "Enter source host: "
read SRC_HOST
echo -n "Enter destination host: "
read DST_HOST
USERNAME=root

# Perform Migration
echo "VM list for Source Host:"
XLIST_SCR1="xl list"
ssh -l ${USERNAME} ${SRC_HOST} "${XLIST_SCR1}"

echo "VM list for Destination Host:"
XLIST_SCR2="xl list"
ssh -l ${USERNAME} ${DST_HOST} "${XLIST_SCR2}"

echo "Enter VM and config file for migration: "
read vm_resp cfg_resp
MIG_SCR="cd /xen_img/; xl migrate -C $cfg_resp --debug $vm_resp $DST_HOST;"
ssh -l ${USERNAME} ${SRC_HOST} "${MIG_SCR}"
