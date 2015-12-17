#!/bin/bash

# Remove previous session
echo "Checking for previous files.."
sleep 1
if [ -e /etc/tripwire/data1.txt ]; then
  rm /etc/tripwire/data1.txt
  echo "Files from previous session removed."
# echo "Got file."
#  exit
fi

# Perform Tripwire
echo "Performing Tripwire check.."; sleep 1
cd /usr/sbin
if tripwire --check | grep "No violations."; then
  if tripwire --check | grep "No Errors"; then
    echo "No violations" >> /etc/tripwire/data1.txt
  else echo "Yes violations" >> /etc/tripwire/data1.txt
  fi
else echo "Yes violations" >> /etc/tripwire/data1.txt
fi
echo "Tripwire check has ended."; sleep 1

# Save Tripwire to a variable
ARG1=$(cat /etc/tripwire/data1.txt | od -t x1)
echo "Data fingerprint: $ARG1"
sleep 1

echo -n "Enter PCR number to extend [0-23]: "
read pcr_resp
echo "Will extend to PCR number $pcr_resp .."
sleep 1

# Extend PCR with Tripwire measurement result
java edu.mit.csail.tpmj.tools.TPMExtend $pcr_resp [$ARG1]
# Read new PCR
java edu.mit.csail.tpmj.tools.TPMReadPCRs | grep -F "PCR [$pcr_resp]"
##java edu.mit.csail.tpmj.tools.TPMLoadKey aikkey1.key
#KEY_HANDLER=$(java edu.mit.csail.tpmj.tools.TPMQuote pcrquote 0x1000000 aikkey1pwd | grep "KeyHandle")
# Sign PCR with an AIK key
echo -n "Enter name for PCR quote: "
read quot_resp
export quot_resp
#echo -n "Enter key for signing: "
#read sign_resp
# Quote PCR
cd /etc/tripwire
java edu.mit.csail.tpmj.tools.TPMQuote $quot_resp 0x1000000 aikkey1pwd

#Send quoted PCR and AIK to Verifier
sshpass -p "Illidan" scp "$quot_resp".quot "$quot_resp".sig aikkey1.key root@192.168.0.163:/etc/jikken

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

# Pass handle to Verifier 
# Migration occurs here

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #
