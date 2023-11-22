#!/bin/sh

HOST=`cat /etc/mythtv/config.xml | grep -oP '(?<=<Host>)[^<]+'`
USER=`cat /etc/mythtv/config.xml | grep -oP '(?<=<UserName>)[^<]+'`
PASSW=`cat /etc/mythtv/config.xml | grep -oP '(?<=<Password>)[^<]+'`
DATABASE=`cat /etc/mythtv/config.xml | grep -oP '(?<=<DatabaseName>)[^<]+'`

#openssl rsa -in ~/.mythtv/RAOPKey.rsa -outform der | sha1sum

script_dir=$(dirname $0);
cd $script_dir;

echo "#!/bin/sh" > ChangeBackground.sh
echo "SELECT concat('PATHFILE=',storagegroup.dirname) as '' FROM mythconverg.storagegroup where storagegroup.groupname='Photographs';" | mysql -N --default-character-set=utf8 -u $USER --password=$PASSW -D $DATABASE -h $HOST >> ChangeBackground.sh

echo "SELECT concat('FILENAME=\"',gallery_files.filename,'\"') as '' FROM mythconverg.gallery_files where gallery_files.extension='jpg' AND gallery_files.filename like '2%' ORDER BY RAND() LIMIT 1;" | mysql -N --default-character-set=utf8 -u $USER --password=$PASSW -D $DATABASE -h $HOST >> ChangeBackground.sh

echo "cp \"\${PATHFILE}/\${FILENAME}\" ~/.mythtv/themes/PatAbstractWide/images/background.jpg" >> ChangeBackground.sh
echo "rm ~/.mythtv/cache/themecache/PatAbstractWide*/images-background.jpg*" >> ChangeBackground.sh
echo "cp ~/.mythtv/themes/PatMenu/extras_menu.ini.xml ~/.mythtv/themes/PatMenu/extras_menu.xml;" >> ChangeBackground.sh
echo "sed -i -e \"s,Image_initiale,\${FILENAME},g\" ~/.mythtv/themes/PatMenu/extras_menu.xml;" >> ChangeBackground.sh
chmod 777 ChangeBackground.sh;
./ChangeBackground.sh;

rm ~/.mythtv/cache/themecache/PatAbstractWide*/images-scripts*
cd ~/.mythtv/themes/PatAbstractWide/images/default_background/
mv scripts9.jpg scripts0.jpg
mv scripts8.jpg scripts9.jpg
mv scripts7.jpg scripts8.jpg
mv scripts6.jpg scripts7.jpg
mv scripts5.jpg scripts6.jpg
mv scripts4.jpg scripts5.jpg
mv scripts3.jpg scripts4.jpg
mv scripts2.jpg scripts3.jpg
cp -f scripts1.jpg ../scripts.jpg
mv scripts1.jpg scripts2.jpg
mv scripts0.jpg scripts1.jpg

pkill -f mythfrontend
killall mythfrontend
pkill -f mythfrontend.real
killall mythfrontend.real

#killall mythfrontend.start
#/media/data2000/DOCS/DOCSPat/scripts/lubuntu/mythfrontend.start

#/usr/bin/mythfrontend.real --syslog local7
/usr/bin/mythfrontend --service
