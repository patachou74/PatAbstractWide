#!/bin/bash
### Pour MYSQL 5.0 peut être moins
## récupe les variables

HOST=`cat /etc/mythtv/config.xml | grep -oP '(?<=<Host>)[^<]+'`
USER=`cat /etc/mythtv/config.xml | grep -oP '(?<=<UserName>)[^<]+'`
PASSW=`cat /etc/mythtv/config.xml | grep -oP '(?<=<Password>)[^<]+'`
DATABASE=`cat /etc/mythtv/config.xml | grep -oP '(?<=<DatabaseName>)[^<]+'`
HOSTNAME=`hostname`

# echo $USER
# echo $PASSW
# echo $HOST

### MAIN
clear
  echo "acteur?"
  read input


echo "SELECT videocast.cast,' : ',videometadata.title FROM mythconverg.videocast,mythconverg.videometadatacast,mythconverg.videometadata where upper(videocast.cast) like '%${input^^}%' AND videocast.intid=videometadatacast.idcast AND videometadatacast.idvideo=videometadata.intid order by videocast.cast,videometadata.title;"| /usr/bin/mariadb --default-character-set=utf8 -u $USER --password=$PASSW -D $DATABASE -h $HOST;
