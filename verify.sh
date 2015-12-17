POSTMIG_DIR="/etc/jikken-post"
SIGN_KEY="aikkey1.key"
PCR1=0; PCRA=0; PCR2=0; PCRB=0

echo "Enter quote1 to verify: "
read verquot1_resp
echo "Enter quote2 to verify: "
read verquot2_resp
echo "Enter number for both extended PCR: "
read pcr_resp1 pcr_resp2
echo "Verifying pre ($pcr_resp1) and post ($pcr_resp2) PCR values.."
sleep 2

PCR1=$((pcr_resp1 + 1)); PCRA=$((PCR1 + 1))
#echo $PCR1 $PCRA
PCR2=$((pcr_resp2 + 1)); PCRB=$((PCR2 + 1))
#echo $PCR2 $PCRB
RES_SCR="cd /xen_img/; xl migrate -C $cfg_resp --debug $vm_resp $SCR_HOST;"

# Verify Quote1
cd $PREMIG_DIR
CMP1=$(java edu.mit.csail.tpmj.tools.TPMVerifyQuote "$verquot1_resp" $SIGN_KEY | grep -A $PCR1 "PcrValues" | awk "NR==$PCRA{print;exit}")

# Verify Quote2
cd $POSTMIG_DIR
CMP2=$(java edu.mit.csail.tpmj.tools.TPMVerifyQuote "$verquot2_resp" $SIGN_KEY | grep -A $PCR2 "PcrValues" | awk "NR==$PCRB{print;exit}")

# Compare
echo "Pre-migration: $CMP1"
echo "Post-migration: $CMP2"
if [ "$CMP1" != "$CMP2" ]; then
  echo "PCR mismatch!"
  echo "halt shori here"
  ssh -l ${USERNAME} ${DST_HOST} "${RES_SCR}"
  ssh -l ${USERNAME} ${DST_HOST} "${XLIST_SCR2}"
elif [ "$CMP1" = "$CMP2" ]; then
  echo "PCR matches!"
  echo "resume shori here"
#  ssh -l ${} ${} "${}"
fi

#java edu.mit.csail.tpmj.tools.TPMVerifyQuote pcrquote aikkey1.key
# Resumption or Halt
# res.sh
