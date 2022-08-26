#######################################################
echo "version 4.00"
#######################################################
export PATH=$PATH:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin:/usr/local/sbin:/usr/local/bin:/usr/path:/volume2/docker/utils/path:$HOME/.local/bin:$HOME/bin:/home/markus/.cargo/bin:/home/abraxas/.cargo/bin:/home/abraxas/.local/bin/:/home/abraxas/.cargo/bin:/home/linuxbrew/.linuxbrew/bin:/volume1/homes/abraxas678/bin:/usr/local/bin:$PATH
ts=$(date +"%s")
MY_FLOW_ID=$ts

mkdir $HOME/tmp >/dev/null 2>/dev/null
echo "CURRENT USER: $USER" 
read -t 1 me

[[ $USER != "abraxas" ]] && [[ ! $(id -u abraxas) ]] && sudo adduser abraxas && sudo passwd abraxas && sudo usermod -aG sudo abraxas && su abraxas
[[ $USER != "abraxas" ]] && su abraxas
echo "CURRENT USER: $USER"
[[ $USER != "abraxas" ]]  && read -p BUTTON me || read -t 2 me

if [[ -d start2 ]]
then
  mv start2 start2-backup-$ts
fi

cd $HOME
sudo apt-get install wget git -y
git config --global user.name abraxas678
git config --global user.email abraxas678@gmail.com
git clone https://raw.githubusercontent.com/abraxas678/start2/main/start.sh
source $HOME/start2/path.dat
git clone https://github.com/leahneukirchen/nq
cp ./nq/nq /usr/bin && cp ./nq/fq /usr/bin && cp ./nq/tq /usr/bin
sudo apt-get install python3-pip nano -y
python -m pip install rich-cli

