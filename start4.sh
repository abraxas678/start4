clear
#######################################################
echo "version 4.06"
#######################################################
export PATH=$PATH:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin:/usr/local/sbin:/usr/local/bin:/usr/path:/volume2/docker/utils/path:$HOME/.local/bin:$HOME/bin:/home/markus/.cargo/bin:/home/abraxas/.cargo/bin:/home/abraxas/.local/bin/:/home/abraxas/.cargo/bin:/home/linuxbrew/.linuxbrew/bin:/volume1/homes/abraxas678/bin:/usr/local/bin:$PATH
ts=$(date +"%s")
MY_FLOW_ID=$ts
mkdir $HOME/tmp/$ts
cd $HOME/tmp/$ts

[[ ! -d  $HOME/tmp ]] && mkdir $HOME/tmp
[[ ! -d  $HOME/github ]] && mkdir $HOME/github

##########################################################################################    USER SETUP/
echo "CURRENT USER: $USER"; read -t 1 me
[[ $USER != "abraxas" ]] && [[ ! $(id -u abraxas) ]] && sudo adduser abraxas && sudo usermod -aG sudo abraxas && su abraxas
[[ $USER != "abraxas" ]] && su abraxas
[[ $USER != "abraxas" ]]  && read -p BUTTON me || read -t 2 me
##########################################################################################    /USER SETUP

##########################################################################################    NQ/
APP_INSTALL="unzip"; [[ $(which $APP_INSTALL >/dev/null 2>/dev/null) = *"not found"* ]] || sudo apt-get install $APP_INSTALL -y
APP_INSTALL="wget"; [[ $(which $APP_INSTALL >/dev/null 2>/dev/null) = *"not found"* ]] || sudo apt-get install $APP_INSTALL -y
mkdir $HOME/tmp/$ts/nq; cd $HOME/tmp/$ts/nq; wget https://github.com/leahneukirchen/nq/archive/refs/heads/master.zip; unzip master.zip; rm -f master.zip
[[ ! -d $HOME/github ]] && mkdir $HOME/github
[[ ! -d $HOME/github/nq ]] && mkdir $HOME/github/nq
mv $HOME/tmp/$ts/nq/* $HOME/github/nq/
cp ./github/nq /usr/bin && cp ./github/fq /usr/bin && cp ./github/tq /usr/bin
sudo chmod +x /usr/bin/*
##########################################################################################    /NQ

mkdir $HOME/tmp/$ts/python
NQDIR="$HOME/tmp/$ts/python"
[[ $(which "python3") = *"not found"* ]] && nq sudo apt-get install python3-pip -y
[[ $(which "rich") = *"not found"* ]] && nq python -m pip install rich-cli

##########################################################################################    TAILSCALE/
APP_INSTALL="lsof"; [[ $(which $APP_INSTALL >/dev/null 2>/dev/null) = *"not found"* ]] || sudo apt-get install $APP_INSTALL -y
curl -fsSL https://tailscale.com/install.sh | sh | tail -f -n5
sudo tailscale up --ssh
sudo systemctl enable tailscaled
sudo systemctl start tailscaled
MY_TAILSCALE_IP=$(tailscale ip | head -n 1)
echo "#!/bin/bash" >$HOME/tmp/setup4_install_$ts.sh
echo "sudo tailscale file cp $HOME/.config/rclone/rclone.conf $MY_TAILSCALE_IP:" >>$HOME/tmp/setup4_install_$ts.sh
echo "sudo tailscale file cp $HOME/.ssh/age-keys.txt $MY_TAILSCALE_IP:" >>$HOME/tmp/setup4_install_$ts.sh
echo "sudo tailscale file cp $HOME/.ssh/MPW.age  $MY_TAILSCALE_IP:" >>$HOME/tmp/setup4_install_$ts.sh

echo "sudo tailscale file cp $HOME/.ssh/id_ed25519  $MY_TAILSCALE_IP:" >>$HOME/tmp/setup4_install_$ts.sh
echo "sudo tailscale file cp $HOME/.ssh/id_ed25519.pub  $MY_TAILSCALE_IP:" >>$HOME/tmp/setup4_install_$ts.sh
echo "sudo tailscale file cp $HOME/.ssh/MPW.age  $MY_TAILSCALE_IP:" >>$HOME/tmp/setup4_install_$ts.sh


echo "sudo tailscale file cp $HOME/.config/rc.age  $MY_TAILSCALE_IP:" >>$HOME/tmp/setup4_install_$ts.sh
echo "sudo tailscale file cp $HOME/.config/res.age   $MY_TAILSCALE_IP:" >>$HOME/tmp/setup4_install_$ts.sh
echo "sudo tailscale file cp $HOME/.config/syn_pw.age   $MY_TAILSCALE_IP:" >>$HOME/tmp/setup4_install_$ts.sh
echo "sudo tailscale file cp $HOME/.config/res_pw.sh    $MY_TAILSCALE_IP:" >>$HOME/tmp/setup4_install_$ts.sh

echo "sudo tailscale file cp $HOME/.zshrc $MY_TAILSCALE_IP:" >>$HOME/tmp/setup4_install_$ts.sh
echo "sudo tailscale file cp $HOME/.zsh.env $MY_TAILSCALE_IP:" >>$HOME/tmp/setup4_install_$ts.sh
echo "sudo tailscale file cp $HOME/excludes.dat  $MY_TAILSCALE_IP:" >>$HOME/tmp/setup4_install_$ts.sh
echo "sudo tailscale file cp $HOME/myfilter.txt  $MY_TAILSCALE_IP:" >>$HOME/tmp/setup4_install_$ts.sh
echo "sudo tailscale file cp $HOME/.bashrc $MY_TAILSCALE_IP:" >>$HOME/tmp/setup4_install_$ts.sh
##########################################################################################    /TAILSCALE

nq -w
frage

APP_INSTALL="nano"; [[ $(which $APP_INSTALL >/dev/null 2>/dev/null) = *"not found"* ]] || nq sudo apt-get install $APP_INSTALL -y
APP_INSTALL="git"; [[ $(which $APP_INSTALL >/dev/null 2>/dev/null) = *"not found"* ]] || nq sudo apt-get install $APP_INSTALL -y && git config --global user.name abraxas678 && git config --global user.email abraxas678@gmail.com
ng -w

[[ ! -d $HOME/start4-backup ]] && mkdir $HOME/start4-backup
[[ -d $HOME/start4 ]] &&  mv  $HOME/start4 $HOME/start4-backup/start4-backup-$ts
cd $HOME/tmp/$ts
git clone https://raw.githubusercontent.com/abraxas678/start4/main/start4.sh $HOME/tmp/$ts/start4
mv $HOME/tmp/$ts/start4 $HOME/start4; source $HOME/start4/path.dat


if [[ 1 -eq 0 ]]; then

echo "#####################################################################"
echo "                      CHECKING HARDWARE"
echo "#####################################################################"
echo; sleep 2
###   df /home grösser 50GB?
chmod +x $HOME/start2/*.sh
[[ $(df -h /home  |awk '{ print $2 }' |tail -n1 | sed 's/G//' | sed 's/\./,/') -lt 50 ]] && /bin/bash $HOME/start2/new-disk.sh


echo "#####################################################################"
echo "              COLLECTING INSTALLATION PREFERENCES"
echo "#####################################################################"
echo; sleep 2
x=0; tput sc; while [[ $x -eq 0 ]]; do
  echo; printf "DEFINE SPEED (default=2): "; read myspeed; echo
  echo "speed [$myspeed]"
  [[ ${#myspeed} -gt 0 ]] && x=1 || tput rc
done
[[ $(echo $RESTIC_PASSWORD | md5sum) != *"81a8c96e402c1647469856787d5c8503"* ]] && echo && printf "restic password: >>> " && read -n 4 myresticpw && export RESTIC_PASSWORD=$myresticpw
x=0; tput sc; while [[ $x -eq 0 ]]; do
  [[ ${#myresticpw} -gt 0 ]] && x=1 || echo; tput rc; read -p "restic pw: " myresticpw
done
export RESTIC_REPOSITORY=rclone:gd:restic
x=0; tput sc; while [[ $x -eq 0 ]]; do
  read -p "RC PW: " rcpw 
  [[ ${#rcpw} -gt 0 ]] && x=1 || tput rc
done
echo $rcpw > ~/rcpw



countdown 20
[[ $(/home/linuxbrew/.linuxbrew/bin/pueue -V) = *"Pueue client"* ]] && MY_PUEUE_INST=1 || MY_PUEUE_INST=0
echo; echo MY_PUEUE_INST $MY_PUEUE_INST
countdown 3
[[ $MY_PUEUE_INST -eq 1 ]] && pueue-init
[[ $MY_PUEUE_INST -eq 1 ]] && /home/linuxbrew/.linuxbrew/bin/pueue add -g system-setup -- rclone copy df:bin/ $HOME/bin -P --update --password-command="cat /home/abraxas/rcpw"

echo "#####################################################################"
echo "                   SYSTEM UPDATE AND UPGRADE"
echo "#####################################################################"
echo; sleep 2
echo; echo "sudo apt-get update && sudo apt-get upgrade -y"; 
countdown 3 
[[ $MY_PUEUE_INST -eq 1 ]] && /home/linuxbrew/.linuxbrew/bin/pueue parallel 1 -g system-setup
[[ $MY_PUEUE_INST -eq 1 ]] && /home/linuxbrew/.linuxbrew/bin/pueue start -g system-setup
[[ $MY_PUEUE_INST -eq 1 ]] && /home/linuxbrew/.linuxbrew/bin/pueue add -g system-setup -- sudo apt-get update && sudo apt-get upgrade -y ||  sudo apt-get update && sudo apt-get upgrade -y
echo; countdown 2
[[ $MY_PUEUE_INST -eq 1 ]] && /home/linuxbrew/.linuxbrew/bin/pueue add -g system-setup -- sudo apt-get install python3-pip firefox-esr -y || sudo apt-get install python3-pip firefox-esr -y
echo; countdown 2

fi
