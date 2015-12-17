#!/bin/bash

# Remove previous session
if [ -e /etc/tripwire/data2.txt ]; then
  rm /etc/tripwire/data2.txt
  echo "File from previous session is removed."
fi

# Perform post-Migration Tripwire
echo "Performing Tripwire check.."
sleep 1
cd /usr/sbin
if tripwire --check | grep "No violations."; then
  if tripwire --check | grep "No Errors"; then
    echo "No violations" >> /etc/tripwire/data2.txt
  else echo "Yes violations" >> /etc/tripwire/data2.txt
  fi
else echo "Yes violations" >> /etc/tripwire/data2.txt
fi

# Save Tripwire to a variable
ARG2=$(cat /etc/tripwire/data2.txt | od -t x1)
echo "Data fingerprint: $ARG2"
sleep 1

echo -n "Enter PCR number to extend [0-23]: "
read pcr_resp
echo "Will extend to PCR number $pcr_resp .."
sleep 1

# Extend PCR with Tripwire measurement result
java edu.mit.csail.tpmj.tools.TPMExtend $pcr_resp [$ARG2]
# Read new PCR
java edu.mit.csail.tpmj.tools.TPMReadPCRs | grep -F "PCR [$pcr_resp]"
##java edu.mit.csail.tpmj.tools.TPMLoadKey aikkey1.key
#KEY_HANDLER=$(java edu.mit.csail.tpmj.tools.TPMQuote pcrquote 0x1000000 aikkey1pwd | grep "KeyHandle")
# Sign PCR with an AIK key
echo -n "Enter name for PCR quote: "
read quot_resp
cd /etc/tripwire
java edu.mit.csail.tpmj.tools.TPMQuote $quot_resp 0x1000000 aikkey1pwd

# Send quoted PCR and AIK to Verifier
sshpass -p "Illidan" scp "$quot_resp".quot "$quot_resp".sig aikkey1.key root@192.168.0.163:/etc/jikken-post

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #

# Pass handle to Verifier
# Verification occurs here

# ---------------------------------------------------------------------------- #
# ---------------------------------------------------------------------------- #
