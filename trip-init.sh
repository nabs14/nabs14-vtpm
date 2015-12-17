  echo $?; exit
fi
echo "End of Premig Phase.."; sleep 1
# Mig
echo -n "Begin mig phase? [Y/N]: "
read mig_resp
if [ $mig_resp = "Y" ]; then
  echo "Beginning mig Phase.."; sleep 1
  cd $SCR_DIR; . mig.sh
elif [ $mig_resp = "N" ]; then
  echo "Halt."
  exit
else echo "Please enter 'Y' or 'N'"
  exit
fi
echo "End of Mig Phase.."; sleep 2
# Postmig
echo -n "Begin postmig phase? [Y/N]: "
read postm_resp
if [ $postm_resp = "Y" ]; then
  echo "Beginning Postmig Phase.."; sleep 1
  echo "Connecting to $VTPM_VM.."; sleep 2
  ssh -l ${SSH_USER} ${VTPM_VM} "${INIT_POSTMIG}"
  echo "Disconnected from $VTPM_VM.."; sleep 1
elif [ $postm_resp = "N" ]; then
  echo "Halt."; echo $?; exit
else echo "Please enter 'Y' or 'N'"
  echo $?; exit
fi
echo "End of Postmig Phase.."; sleep 1
#echo "Verify Phase.."; sleep 2
#cd $SCR_DIR; . verify.sh
#echo "End of Verify Phase.."; sleep 2
# Mig
echo -n "Begin verify phase? [Y/N]: "
read verify_resp
if [ $verify_resp = "Y" ]; then
  echo "Beginning verify Phase.."; sleep 1
  cd $SCR_DIR; . verify.sh
elif [ $verify_resp = "N" ]; then
  echo "Halt."
  exit
else echo "Please enter 'Y' or 'N'"
  exit
fi
echo "End of verify Phase.."; sleep 2
