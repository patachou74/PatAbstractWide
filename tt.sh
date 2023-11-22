#!/bin/sh

input=$1;
script_dir=$(dirname $0);
cd $script_dir;
clear
if [ "$input" = "" ]; then
  echo "==========================="
  echo "= DEVICE     : ON     OFF ="
  echo "==========================="
  echo "= màj        : u      -   ="
  echo "= nettoyage  : c      -   ="
  echo "= acteur-film: af     -   ="
  echo "= mythtv     : my     ym  =" 
  echo "= deluge     : de     ed  ="
  echo "= mount usb  : mt     tm  ="
  echo "= apache2    : ap     pa  ="
  echo "= VPN        : vp     pv  ="
  echo "= protege    : c5     c7  ="
  echo "= profile    : p      pp  ="
  echo "= BoostReboot: b      bb  ="
  echo "= backup     : bk     -   ="
  echo "= scan video : v      -   ="
  echo "= statut     : s      -   ="
  echo "= rar log    : rl     -   =" 
  echo "= clear samba: sm         ="
  echo "= mode deluge: md         ="
  echo "= SAVE       : SAVE       ="
  echo "= rvb        : rvb        ="
  echo "= Agent      : ag     ga  ="
  echo "==========================="

  read input
fi


if [ "$input" = "sm" ] || [ "$input" = "SM" ]; then
{
  sudo systemctl stop winbind.service
  sudo systemctl stop smbd.service
  sudo cp -rf /var/lib/samba /var/lib/samba.old
  sudo net cache flush
  sudo rm -f /var/lib/samba/*.tdb
  sudo rm -f /var/lib/samba/group_mapping.ldb
  sudo systemctl start smbd.service
  sudo systemctl start winbind.service
}

elif [ "$input" = "AG" ] || [ "$input" = "ag" ]; then
{
  echo "sudo systemctl restart AgentDVR.service"
  sudo systemctl restart AgentDVR.service;
}

elif [ "$input" = "GA" ] || [ "$input" = "ga" ]; then
{
  echo "sudo systemctl stop AgentDVR.service"
  sudo systemctl stop AgentDVR.service;
}

elif [ "$input" = "RVB" ] || [ "$input" = "rvb" ]; then
{
  cd
  /home/myt/.mythtv/themes/PatAbstractWide/rvb.sh;
}
elif [ "$input" = "md" ] || [ "$input" = "MD" ]; then
{

  export drive=`blkid |grep TOR|sed 's/:.*$//'`
  echo "mount -t ext4  $drive /home/deluge"
  sudo mount -t ext4  $drive /home/deluge
  echo "systemctl restart deluge-web"
  sudo systemctl restart deluge-web
  echo "systemctl restart deluged"
  sudo systemctl restart deluged
  echo "umount /media/4TB"
  sudo umount /media/4TB
  echo "umount /media/4T"
  sudo umount /media/4T
  echo "killall mythfrontend"
  sudo killall mythfrontend
  sudo killall mythfrontend.real
  killall lxqt-session
}

elif [ "$input" = "mt" ] || [ "$input" = "MT" ]; then
{

  echo  "sudo mount -t ext4 /dev/sde1 /media/2G"
  sudo mount -t ext4 /dev/sde1 /media/2G
  echo  "sudo mount -t ext4 /dev/sdf1 /media/2G"
  sudo mount -t ext4 /dev/sdf1 /media/2G
  echo  "sudo mount --bind /media/2G/deluge /home/deluge"
  sudo mount --bind /media/2G/deluge /home/deluge
}

elif [ "$input" = "de" ] || [ "$input" = "DE" ]; then
{
  export drive=`blkid |grep TOR|sed 's/:.*$//'`
  echo "mount -t ext4  $drive /home/deluge"
  sudo mount -t ext4  $drive /home/deluge
  echo "systemctl restart deluged"
  sudo systemctl restart deluged
  echo "systemctl restart deluge-web"
  sudo systemctl restart deluge-web
  sudo systemctl status deluged ; sudo systemctl status deluge-web.service
}
elif [ "$input" = "ed" ] || [ "$input" = "ED" ]; then
{
  echo "systemctl stop deluge-web"
  sudo systemctl stop deluge-web
  echo "systemctl stop deluged"
  sudo systemctl stop deluged
}


elif [ "$input" = "af" ] || [ "$input" = "AF" ]; then
{
    /home/myt/.mythtv/themes/PatAbstractWide/acteur-film.sh;
}
elif [ "$input" = "u" ] || [ "$input" = "U" ]; then
{
    sudo apt-get update
    sudo apt-get -y dist-upgrade
    sleep 10
    sudo apt autoremove
}
elif [ "$input" = "c" ] || [ "$input" = "C" ]; then
{
    cd  
    sudo /home/myt/.mythtv/themes/PatAbstractWide/CleanLog.sh;
}
elif [ "$input" = "c7" ] || [ "$input" = "C7" ]; then
{
  echo "chmod -R 777 /media/3T/DOCS/*"
  sudo chmod -R 777 /media/3T/DOCS/*
  echo "chown -R www-data:www-data /media/3T/DOCS/*"
  sudo chown -R www-data:www-data /media/3T/DOCS/*
}
elif [ "$input" = "c5" ] || [ "$input" = "c5" ]; then
{
  echo "chmod -R 755 /media/data2000/DOCS/MUSICS  PHOTOS  VIDEOS"
  chmod -R 755 /media/4TB/videos/*
  chmod -R 755 /media/3T/DOCS/PHOTOS/*
  chmod -R 755 /media/3T/DOCS/MUSICS/*
  echo "chown -R www-data:www-data /media/3T/DOCS/*"
  sudo chown -R www-data:www-data /media/3T/DOCS/*
}

elif [ "$input" = "p" ] || [ "$input" = "P" ]; then
{
  sed -i -e "s/quiet splash/quiet splash profile/g" /etc/default/grub;
  grep "quiet splash" /etc/default/grub;
  update-grub2;
}
elif [ "$input" = "pp" ] || [ "$input" = "PP" ]; then
{
  sed -i -e "s/quiet splash profile/quiet splash/g" /etc/default/grub;
  grep "quiet splash" /etc/default/grub;
  update-grub2; 
}


elif [ "$input" = "ap" ] || [ "$input" = "AP" ]; then
{
  echo "systemctl restart apache2"
  systemctl restart apache2
}
elif [ "$input" = "pa" ] || [ "$input" = "PA" ]; then
{
  echo "systemctl stop apache2"
  systemctl stop apache2
}
elif [ "$input" = "vp" ] || [ "$input" = "VP" ]; then
{
  echo "systemctl restart openvpn"
  systemctl restart openvpn
}
elif [ "$input" = "pv" ] || [ "$input" = "PV" ]; then
{
  echo "systemctl stop openvpn"
  systemctl stop openvpn
}
elif [ "$input" = "bb" ] || [ "$input" = "BB" ]; then
{
  sudo reboot
}
elif [ "$input" = "my" ] || [ "$input" = "MY" ]; then
{
  systemctl restart mythtv-backend
}
elif [ "$input" = "ym" ] || [ "$input" = "YM" ]; then
{
  echo "sudo systemctl stop mythtv-backend"
  systemctl stop mythtv-backend
  echo "sudo killall mythfrontend.real"
  sudo killall mythfrontend.real
  echo "sudo killall mythfrontend"
  sudo killall mythfrontend
}
elif [ "$input" = "bk" ] || [ "$input" = "BK" ]; then
{
  cd /media/3T/db_backups/;
  rm themes.rar;
  rar a themes.rar /home/myt/.mythtv/themes;
  rm banners.rar;
  rar a banners.rar /var/lib/mythtv/banners;
  rm coverart.rar;
  rar a coverart.rar /var/lib/mythtv/coverart;
  rm fanart.rar;
  rar a fanart.rar /var/lib/mythtv/fanart;
  rm screenshots.rar;
  rar a screenshots.rar /var/lib/mythtv/screenshots;
  echo "Backup database";
  mariadb-dump -u root --password=*** mythconverg > /media/3T/db_backups/myth.sql;
}
elif [ "$input" = "v" ] || [ "$input" = "V" ]; then
{
  mythutil --scanvideos
}

elif [ "$input" = "s" ] || [ "$input" = "S" ]; then
{
#  echo iostat;
  echo top;
#  iostat;
  top;
#  iostat -x; 
}
elif [ "$input" = "rl" ] || [ "$input" = "RL" ]; then
{
  rar a -r /media/3T/DOCS/log.rar /var/log
   echo "/media/3T/DOCS/log.rar"
}

elif [ "$input" = "SAVE" ] || [ "$input" = "save" ]; then
{
 export drive=`blkid |grep SAVE|sed 's/:.*$//'`
 echo "mount -t ext4  $drive /media/SAVE"
 sudo mount -t ext4  $drive /media/SAVE
 sudo  chmod  775 /media/SAVE

 echo "rsync -av --delete /media/4TB/videos/VIDEOS_maison /media/SAVE/"
 sudo rsync -av --delete /media/4TB/videos/VIDEOS_maison /media/SAVE/
 echo "rsync -av --delete /media/3T/DOCS/PHOTOS /media/SAVE/"
 sudo rsync -av --delete /media/3T/DOCS/PHOTOS /media/SAVE/
 echo "rsync -av --delete /media/3T/db_backups /media/SAVE/"
 sudo rsync -av --delete /media/3T/db_backups /media/SAVE/
 echo "rsync -av --delete /media/3T/DOCS/MUSICS /media/SAVE/"
 sudo rsync -av --delete /media/3T/DOCS/MUSICS /media/SAVE/
 echo "rsync -av --delete /srv/nextcloud /media/SAVE/"
 sudo rsync -av --delete /srv/nextcloud  /media/SAVE/
 echo "rsync -av --delete --exclude='*appdata_ocfpkfpa8mhj/preview/*'  /media/3T/data /media/SAVE/"
 sudo rsync -av --delete  --exclude='*appdata_ocfpkfpa8mhj/preview/*' /media/3T/data  /media/SAVE/

 sudo df -h |grep Filesystem
 sudo df -h |grep SAVE

 echo "umount /media/SAVE"
 sudo umount /media/SAVE

}

else
{
  echo "wrong input";sleep 4
}
fi
