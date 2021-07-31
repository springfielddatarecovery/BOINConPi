#!/bin/bash
#BOINC on Pi Script
#to run: use the following command:
#sudo wget 'https://raw.githubusercontent.com/springfielddatarecovery/BOINConPi/main/boinconpi.sh';sudo chmod +x boinconpi.sh;./boinconpi.sh
echo "Welcome to BOINC on Pi! We're going to make it as simple as possible to install BOINC on your Pi."
echo "We have picked some safe, sane defaults for BOINC, but you are welcome to customize the installation if you'd like"
customize () {
  CUSTOMIZE=1
  #customize core selection
  while true; do
    read -p "What is the maximum % of cores BOINC should be allowed to run on? For example, if you want to run 3 cores on a 4 core system, put in 75. This rounds down. Default is 99 (all minus one)" yn
    case $yn in
        [1234567890]* ) MAXCOREPERCENT=$yn;;
        * ) echo "Please enter a number";;
    esac
  done
  #customize CPU allocation
  while true; do
    read -p "What is the maximum % of CPU BOINC should use? Default is 75" yn
    case $yn in
        [1234567890]* ) MAXCPU=$yn;;
        * ) echo "Please enter a number";;
    esac
  done
  while true; do
    read -p "If non-BOINC CPU usage is above this %, pause BOINC. Default is 25" yn
    case $yn in
        [1234567890]* ) RUNONLYWHENCPUBELOW=$yn;;
        * ) echo "Please enter a number";;
    esac
  done
  #Ask about RAM
  while true; do
    read -p "What is the maximum % of RAM/memory that BOINC should use? Default is 75, we don't suggest going above 90" yn
    case $yn in
        [1234567890]* ) MAXMEMPERCENT=$yn;;
        * ) echo "Please enter a number";;
    esac
  done
  #Ask about storage
  ehco "We will now ask some questions about storage. BOINC will choose the least space allowed by these various options"
  while true; do
    read -p "What is the maximum amount of space in GB that BOINC should be allowed to use? Default is 3, <1 will probably be too small for any projects to run" yn
    case $yn in
        [1234567890]* ) MAXSTORAGEINGB=$yn;;
        * ) echo "Please enter a number";;
    esac
  done
  while true; do
    read -p "What is the maximum % of total storage BOINC can use? Default is 50% to account for small SD cards" yn
    case $yn in
        [1234567890]* ) MAXSTORAGEPERCENT=$yn;;
        * ) echo "Please enter a number";;
    esac
  done
  while true; do
    read -p "No matter what, BOINC should make sure this many GB are left free. Default is 2" yn
    case $yn in
        [1234567890]* ) LEAVEGBFREE=$yn;;
        * ) echo "Please enter a number";;
    esac
  done
}
customizeaccount () {
  while true; do
    read -p "Will you be using BAM (BOINC Account Manager) or a different account manager? Y for BAM, N for different" yn
    case $yn in
        [Yy]* ) true;;
        [Nn]* ) read -p "What is your account manager URL e-mail address?" BAMURL;;
        * ) echo "Please answer Y or N.";;
    esac
done

  echo "We will now gather some information about your BAM account. If you want to use your weak authenticator, just answer with it for you username and password."
    read -p "What is your BAM e-mail address?" USERNAME
    read -p "What is your BAM password?" PASSWORD

}
customizeresearch () {
  RESEARCHCUSTOMIZED=1
  echo "Alright, let's customize your areas of research!"
  echo "Math projects are set to 'priority zero' by default. This means that your pi will only crunch these projects if all other projects are out of work"
  echo "If you say NO to any of these areas of research, they will be disabled entirely."
  echo "Keep in mind that not all projects or categories will have workunits for your model of Pi. For this reason, we suggest leaving them all enabled"
  while true; do
    read -p "Do you want to support medical research projects (Rosetta, siDock, etc)?" yn
    case $yn in
        [Yy]* ) MEDICALENABLED=1;;
        [Nn]* ) MEDICALENABLED=0;;
        * ) echo "Please answer Y or N.";;
    esac
  done
  while true; do
    read -p "Do you want to support physics & astrophysics research projects (Cosmology, Universe, LHC, etc)?" yn
    case $yn in
        [Yy]* ) PHYSICSENABLED=1;;
        [Nn]* ) PHYSICSENABLED=0;;
        * ) echo "Please answer Y or N.";;
    esac
  done
  while true; do
    read -p "Do you want to support mathematical research (Collatz conjecture, YAFU, etc)?" yn
    case $yn in
        [Yy]* ) MATHENABLED=1;;
        [Nn]* ) MATHENABLED=0;;
        * ) echo "Please answer Y or N.";;
    esac
  done
  while true; do
    read -p "Do you want to support AI/Artificial Intelligence research (MLC, etc)?" yn
    case $yn in
        [Yy]* ) AIENABLED=1;;
        [Nn]* ) AIENABLED=0;;
        * ) echo "Please answer Y or N.";;
    esac
  done
  while true; do
    read -p "Do you want to support umbrella research projects (TN-GRID, BOINC@TACC, etc)? These are projects sponsored by universities that enable researchers to crunch data having to develop their own seperate BOINC projects" yn
    case $yn in
        [Yy]* ) UMBRELLAENABLED=1;;
        [Nn]* ) UMBRELLAENABLED=0;;
        * ) echo "Please answer Y or N.";;
    esac
  done
}
applycustomizations (){
  touch /var/lib/boinc-client/global_prefs_override.xml
  echo "<global_preferences>" >> /var/lib/boinc-client/global_prefs_override.xml
  echo "<max_ncpus_pct>$MAXCOREPERCENT</max_ncpus_pct>" >> /var/lib/boinc-client/global_prefs_override.xml
  echo "<cpu_usage_limit>$MAXCPU</cpu_usage_limit>" >> /var/lib/boinc-client/global_prefs_override.xml
  echo "<suspend_cpu_usage>$RUNONLYWHENCPUBELOW</suspend_cpu_usage" >> /var/lib/boinc-client/global_prefs_override.xml
  echo "<ram_max_used_busy_pct>$MAXMEMPERCENT</ram_max_used_busy_pct>" >> /var/lib/boinc-client/global_prefs_override.xml
  echo "<ram_max_used_idle_pct>$MAXMEMPERCENT</ram_max_used_idle_pct>" >> /var/lib/boinc-client/global_prefs_override.xml
  echo "<disk_max_used_gb>$MAXSTORAGEINGB</disk_max_used_gb>" >> /var/lib/boinc-client/global_prefs_override.xml
  echo "<disk_max_used_pct>$MAXSTORAGEPERCENT</disk_max_used_pct>" >> /var/lib/boinc-client/global_prefs_override.xml
  echo  "<disk_min_free_gb>$LEAVEGBFREE</disk_min_free_gb>" >> /var/lib/boinc-client/global_prefs_override.xml
  echo "</global_preferences>" >> /var/lib/boinc-client/global_prefs_override.xml
}
applyresearchcustomizations(){
  if [ "$MEDICALENABLED" -eq "0" ]; then
    for t in "${MEDICALPROJECTS[@]}"; do
  boimccmd --project "$t" detach
  echo "Disabling project $t"
done
  fi
  if [ "$PHYSICSENABLED" -eq "0" ]; then
    for t in "${PHYSICSPROJECTS[@]}"; do
  boimccmd --project "$t" detach
  echo "Disabling project $t"
done
  fi
    if [ "$MATHENABLED" -eq "0" ]; then
    for t in "${MATHPROJECTS[@]}"; do
  boimccmd --project "$t" detach
  echo "Disabling project $t"
done
  fi
      if [ "$AIENABLED" -eq "0" ]; then
    for t in "${AIPROJECTS[@]}"; do
  boimccmd --project "$t" detach
  echo "Disabling project $t"
done
  fi
  if [ "$UMBRELLAENABLED" -eq "0" ]; then
    for t in "${UMBRELLAPROJECTS[@]}"; do
  boimccmd --project "$t" detach
  echo "Disabling project $t"
done
  fi
}
#define starting variables
BAMURL='https://bam.boincstats.com/'
CUSTOMIZE=0
MAXCPU=75
MAXCOREPERCENT=99
MAXMEMPERCENT=75
RUNONLYWHENCPUBELOW=25
MAXSTORAGEINGB=3
LEAVEGBFREE=2
MAXSTORAGEPERCENT=50
USERNAME="241025_ea687b5f3122c834e30719fc557ea186"
PASSWORD="241025_ea687b5f3122c834e30719fc557ea186"
DEFAULTUSERNAME=$USERNAME
DEFAULTPASSWORD=$PASSWORD
DEFAULTBAMURL=$BAMURL
RESEARCHCUSTOMIZED=0
MEDICALPROJECTS=("https://www.gpugrid.net/" "https://boinc.bakerlab.org/rosetta/" "https://www.sidock.si/sidock/")
PHYSICSPROJECTS=("http://asteroidsathome.net/boinc/" "http://www.cosmologyathome.org/" "https://lhcathome.cern.ch/lhcathome/" "https://milkyway.cs.rpi.edu/milkyway/" "https://boinc.nanohub.org/nanoHUB_at_home/" "https://universeathome.pl/universe/")
MATHPROJECTS=("https://sech.me/boinc/Amicable/" "https://escatter11.fullerton.edu/nfs/" "https://numberfields.asu.edu/NumberFields/" "https://boinc.progger.info/odlk/" "https://www.rechenkraft.net/yoyo/")
UMBRELLAPROJECTS=("http://www.worldcommunitygrid.org")
AIPROJECTS=("https://www.mlcathome.org/mlcathome/")
LOGFILE="/tmp/boincinstaller.log"
#Ask if user wants to customize install
while true; do
    read -p "Would you like to customize the BOINC computing settings? Type Y or N followed by enter to proceed. Don't worry, you'll get to customize projects later if you'd like" yn
    case $yn in
        [Yy]* ) customize;;
        [Nn]* ) break;;
        * ) echo "Please answer Y or N";;
    esac
done
#Ask about project selection
while true; do
    read -p "Do you have a BAM (BOINC Account Manager account) or other account manager you'd like to use? Say N to crunch as a guest" yn
    case $yn in
        [Yy]* ) customizeaccount;;
        [Nn]* ) true;;
        * ) echo "Please answer Y or N.";;
    esac
done
#Ask about project selection
echo "By default, we prioritize projects in the following order: Medical research -> Physics/Astrophysics -> Math"
while true; do
    read -p "Would you like to customize research areas? Otherwise we can pick a good mix of project to contribute to." yn
    case $yn in
        [Yy]* ) customizeresearch;;
        [Nn]* ) true;;
        * ) echo "Please answer Y or N.";;
    esac
done
echo "Alrightey, let's get to the fun part, installing BOINC!"
apt -y update
apt -y install boinc boinc-client-opencl boinc-client-nvidia >> "$LOFGILE"
apt -y install boinctui >> $LOGFILE
echo "Contacting BOINC servers.."
#attach to account manager
boinccmd --acct_mgr attach "$BAMURL" "$USERNAME" "$PASSWORD" >> "$LOGFILE" 2>&1
boinccmd --acct_mgr sync >> $LOGFILE 2>&1
#verify account manager successfully attached
if boinccmd --acct_mgr info | grep -q "$BAMURL"; then
  true
  else echo "Problem attaching to account manager. Will be crunching as guest!"
  boinccmd --acct_mgr attach "$DEFAULTBAMURL" "$DEFAULTUSERNAME" "$DEFAULTPASSWORD" >> $LOGFILE 2>&1
  boinccmd --acct_mgr sync >> $LOGFILE 2>&1
fi
#apply BOINC customizations
if [ "$CUSTOMIZE" -eq "1" ]; then
   applycustomizations;
fi
#apply research customizations
if [ "$RESEARCHCUSTOMIZED" -eq "1" ]; then
   applyresearchcustomizations;
fi
echo "Applying your customizations..."
echo "Coordinating with the aliens..."
echo "Dodging cosmic radiation..."
echo "Curing cancer along the way..."
#get BAM host id, disabled bc doesnt seem to link to BAM properly
HOSTID=$(cat /var/lib/boinc-client/acct_mgr_reply.xml|grep -o -P '(?<=<message>BAM! Host: ).*(?=</message\>)')
echo "All done! Now that BOINC is installed, you can monitor it with the boinctui command. If you have a GUI/desktop on your Pi, you can also open BOINC Manager from your application menu"
echo "If you noticed any errors with the installation, please let us know by emailing office{at}springfielddatarecovery.com"
echo "You can also view stats for your Pi at https://www.boincstats.com/stats/-1/host/detail/$HOSTID"
