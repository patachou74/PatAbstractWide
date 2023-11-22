#!/bin/sh
maison=$HOME;

HOST=`cat /etc/mythtv/config.xml | grep -oP '(?<=<Host>)[^<]+'`
USER=`cat /etc/mythtv/config.xml | grep -oP '(?<=<UserName>)[^<]+'`
PASSW=`cat /etc/mythtv/config.xml | grep -oP '(?<=<Password>)[^<]+'`
DATABASE=`cat /etc/mythtv/config.xml | grep -oP '(?<=<DatabaseName>)[^<]+'`
HOSTNAME=`hostname`

echo "Clear system";
apt-get clean;
apt-get -y autoclean;
apt-get -y autoremove;
#apt-get -y purge `deborphan`;
#dpkg -y --purge `dpkg -l | egrep "^rc" | cut -d' ' -f3`;
journalctl --vacuum-time=2d;


echo "commit";
echo "commit;"| /usr/bin/mariadb --default-character-set=utf8 -u root --password=*** --database=mythconverg;

echo "mythutil";
mythutil --clearbookmarks 
mythutil --clearcutlist
mythutil --clearseektable
mythutil --clearskiplist
mythutil --clearcache
mythutil --cleareit  

echo "Clean database";
/usr/bin/mariadb-check -u root --password=*** --auto-repair --optimize --all-databases;

echo "Clear log";
find /var/log  -name *.gz > CleanLog.log;
find /var/log  -name *.gz -exec rm -f {} \;
find /var/log  -name *.old >> CleanLog.log;
find /var/log  -name *.old -exec rm -f {} \;
find /var/log  -name *.1.log >> CleanLog.log;
find /var/log  -name *.2.log >> CleanLog.log;
find /var/log  -name *.3.log >> CleanLog.log;
find /var/log  -name *.4.log >> CleanLog.log;
find /var/log  -name *.5.log >> CleanLog.log;
find /var/log  -name *.6.log >> CleanLog.log;
find /var/log  -name *.1.log -exec rm -f {} \;
find /var/log  -name *.2.log -exec rm -f {} \;
find /var/log  -name *.3.log -exec rm -f {} \;
find /var/log  -name *.4.log -exec rm -f {} \;
find /var/log  -name *.5.log -exec rm -f {} \;
find /var/log  -name *.1 >> CleanLog.log;
find /var/log  -name *.2 >> CleanLog.log;
find /var/log  -name *.3 >> CleanLog.log;
find /var/log  -name *.4 >> CleanLog.log;
find /var/log  -name *.5 >> CleanLog.log;
find /var/log  -name *.6 >> CleanLog.log;
find /var/log  -name *.1 -exec rm -f {} \;
find /var/log  -name *.2 -exec rm -f {} \;
find /var/log  -name *.3 -exec rm -f {} \;
find /var/log  -name *.4 -exec rm -f {} \;
find /var/log  -name *.5 -exec rm -f {} \;
find /var/log  -name *.6 -exec rm -f {} \;
echo '' | tee /var/log/mythtv/mythfrontend.log;
echo '' | tee /var/log/mythtv/mythbackend.log;
echo '' | tee /var/log/mythtv/mythpreviewgen.log;
echo '' | tee /var/log/alternatives.log;
echo '' | tee /var/log/auth.log;
echo '' | tee /var/log/boot.log;
echo '' | tee /var/log/bootstrap.log;
echo '' | tee /var/log/dpkg.log;
echo '' | tee /var/log/faillog;
echo '' | tee /var/log/kern.log;
echo '' | tee /var/log/lastlog;
echo '' | tee /var/log/mail.log;
echo '' | tee /var/log/syslog;
echo '' | tee /var/log/mediatomb.log;
echo '' | tee /var/log/udev;
# echo '' | tee /var/log/mldonkey/mlnet.log;
echo '' | tee /var/log/apache2/access.log;
echo '' | tee /var/log/apache2/error.log;

# echo "Clear .goutputstream in "$maison;
# cd $maison;
# rm .goutputstream*;
# echo "Clear .adobe in "$maison;
# rm -Rf .adobe;
# echo "Clear .cache in "$maison;
# rm -Rf .cache;
# echo "Clear .macromedia in "$maison;
# rm -Rf .macromedia;
# echo "Clear .thumbnails in "$maison;
# rm -Rf .thumbnails;

# echo "Clear tmp";
# ls /tmp/* >> CleanLog.log;
# rm -Rf /tmp/*;

echo "search Trash";
echo "sudo find / -name '.Trash*'";
#find / -name .Trash-1000 >> CleanLog.log;
#find / -name .Trash-1000 -exec rm -rf {} \;

