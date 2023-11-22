#!/bin/bash
### Pour mariadb -p$PASSW 5.0 peut être moins

input=$1;

HOST=`cat /etc/mythtv/config.xml | grep -oP '(?<=<Host>)[^<]+'`
USER=`cat /etc/mythtv/config.xml | grep -oP '(?<=<UserName>)[^<]+'`
PASSW=`cat /etc/mythtv/config.xml | grep -oP '(?<=<Password>)[^<]+'`
DATABASE=`cat /etc/mythtv/config.xml | grep -oP '(?<=<DatabaseName>)[^<]+'`
HOSTNAME=`hostname`

export mariadb_PWD=$PASSW

# echo $USER
# echo $PASSW
# echo $HOST

THUMB_TIME=00:01:00
THUMB_NB=45
THUMB_DIR=`echo "SELECT s.dirname FROM storagegroup s where s.groupname='Coverart';" | mariadb -p$PASSW -N --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST`
FANART_DIR=`echo "SELECT s.dirname FROM storagegroup s where s.groupname='Fanart';" | mariadb -p$PASSW -N --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST`
SCREEN_DIR=`echo "SELECT s.dirname FROM storagegroup s where s.groupname='Screenshots';" | mariadb -p$PASSW -N --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST`
BANNER_DIR=`echo "SELECT s.dirname FROM storagegroup s where s.groupname='Banners';" | mariadb -p$PASSW -N --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST`
VIDEO_DIR=`echo "SELECT s.dirname FROM storagegroup s where s.groupname='Videos';" | mariadb -p$PASSW -N --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST`
# mkdir $THUMB_DIR

echo "DROP TABLE IF EXISTS $DATABASE.tmpvideoID;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;

### Crée et affecte les couvertures
AJOUT_COVER()
{
filename="$1"
THUMB_PATH="${THUMB_DIR}00_`basename "${filename}"`.jpg"
echo ==\>\> 
echo ==\>\> CREATION de $THUMB_PATH
echo ==\>\> $filename
echo ==\>\> 

 if [ ! -f "${THUMB_PATH}" ]; then
   mythpreviewgen --infile "${VIDEO_DIR}/${filename}" --outfile "$THUMB_PATH"
   echo ${THUMB_PATH}
 fi
 if [ ! -f "${THUMB_PATH}" ]; then
   sudo -u myt cvlc "${VIDEO_DIR}${filename}" --no-audio --video-filter=scene --vout=dummy --no-audio --start-time=20 --stop-time=30 --scene-format=jpg --scene-prefix=snap --scene-path=. && mv -f snap00051.jpg "$THUMB_PATH"
   echo ${THUMB_PATH}
 fi
 if [ ! -f "${THUMB_PATH}" ]; then
   THUMB_PATH=${THUMB_DIR}"0 0.jpg"
   echo "$THUMB_PATH"  
   echo "$THUMB_PATH"  
 fi
if [ -f "${THUMB_PATH}" ]; then
  echo "UPDATE  videometadata SET coverfile=replace(\"${THUMB_PATH}\",'$THUMB_DIR',''),inetref=99999999  WHERE filename=\"${filename}\" ;" | mariadb -p$PASSW -N --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
fi
echo ${THUMB_PATH}
}

CORRECT_CAR()
{
  echo "update tmpvideoID set filename=replace(filename,'Ã®','î') where filename like '%Ã®%';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
  echo "update tmpvideoID set filename=replace(filename,'Ãª','ê') where filename like '%Ãª%';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
  echo "update tmpvideoID set filename=replace(filename,'Ã¨','è') where filename like '%Ã¨%';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
  echo "update tmpvideoID set filename=replace(filename,'Ã©','é') where filename like '%Ã©%';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
  echo "update tmpvideoID set filename=replace(filename,'Ã´','ô') where filename like '%Ã´%';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
  echo "update tmpvideoID set filename=replace(filename,'Ã ','à') where filename like '%Ã %';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
  echo "update tmpvideoID set filename=replace(filename,'Ã¹','ù') where filename like '%à¹%';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
  echo "update tmpvideoID set filename=replace(filename,'Ã§','ç') where filename like '%à§%';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
  echo "update tmpvideoID set filename=replace(filename,'Ã‰','É') where filename like '%à‰%';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
  echo "update tmpvideoID set filename=replace(filename,'Ã€','À') where filename like '%à€%';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
  echo "update tmpvideoID set filename=replace(filename,'Ã«','ë') where filename like '%à«%';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
  echo "update tmpvideoID set filename=replace(filename,'Ã¯','ï') where filename like '%à¯%';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
  echo "update tmpvideoID set filename=replace(filename,'Â','') where filename like '%Â%';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST 
}

### MAIN
echo "Refresh Videometadata Browse (---------------------------------------------)"
echo "Refresh Videometadata Browse (-- Start  `date +'%y/%m/%d-%H:%M.%S'` -----------------)"

# Affiches : copie par saison
echo "Refresh Videometadata Browse (-- Part 1 `date +'%y/%m/%d-%H:%M.%S'` - ?? affiches ---)"

#fixe banner coverfile et fannar par serie episode saison 
echo "update mythconverg.videometadata v,mythconverg.videometadata t set v.coverfile=t.coverfile where t.filename like '%SERIE%' and t.coverfile<>'' and v.filename like '%SERIE%' and v.coverfile='' and t.title=v.title and t.season=v.season;" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
echo "update mythconverg.videometadata v,mythconverg.videometadata t set v.banner=t.banner where t.filename like '%SERIE%' and t.banner<>'' and v.filename like '%SERIE%' and v.banner='' and t.title=v.title and t.season=v.season;" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
echo "update mythconverg.videometadata v,mythconverg.videometadata t set v.fanart=t.fanart where t.filename like '%SERIE%' and t.fanart<>'' and v.filename like '%SERIE%' and v.fanart='' and t.title=v.title and t.season=v.season;" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
echo "update mythconverg.videometadata v,mythconverg.videometadata t set v.coverfile=t.coverfile where t.filename like '%SERIE%' and t.coverfile<>'' and v.filename like '%SERIE%' and v.coverfile='' and t.title=v.title;" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
echo "update mythconverg.videometadata v,mythconverg.videometadata t set v.banner=t.banner where t.filename like '%SERIE%' and t.banner<>'' and v.filename like '%SERIE%' and v.banner='' and t.title=v.title;" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
echo "update mythconverg.videometadata v,mythconverg.videometadata t set v.fanart=t.fanart where t.filename like '%SERIE%' and t.fanart<>'' and v.filename like '%SERIE%' and v.fanart='' and t.title=v.title;" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
echo "update mythconverg.videometadata v set v.title=replace(v.title,':','-') where v.filename like '%SERIE%';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST


### Recherche des couvertures manquantes
echo "select v.filename from videometadata v 
   WHERE IFNULL(v.coverfile,'')='' and LOWER(right(v.filename,3)) not like 'ifo' 
   and LOWER(right(v.filename,3)) not like 'bup' and LOWER(right(v.filename,3)) not like 'srt' 
   and LOWER(right(v.filename,3)) not like 'idx' and LOWER(right(v.filename,3)) not like 'sub' and LOWER(right(v.filename,3)) not like 'vob'; " | mariadb -p$PASSW -N --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST >list_file.txt

# Affiches : crée les manquantes
  ##echo "Refresh Videometadata Browse (-- Part 2 `date +'%y/%m/%d-%H:%M.%S'` - crée affiche --)"
  echo "Refresh Videometadata Browse (-- Part 2 `date +'%y/%m/%d-%H:%M.%S'` - crée affiche -- inactif)"


  ### Creation et affectation des couvertures manquantes
  oldIFS=$IFS     # sauvegarde du séparateur de champ
  IFS=$'\n'     # nouveau séparateur de champ, le caractère fin de ligne
  for ligne in $(cat list_file.txt)
  do
   AJOUT_COVER "$ligne"
  done
  IFS=$old_IFS     # rétablissement du séparateur de champ par défautwhile read ligne
  rm list_file.txt;

# Enchainement des séries
echo "Refresh Videometadata Browse (-- Part 3 `date +'%y/%m/%d-%H:%M.%S'` - enchaine ------)"


#Nouveau pour filtre non lu
## Amélia non lu #echo "update mythconverg.videometadata t set t.watched=0 where t.showlevel=1 and t.watched=1 and filename like 'SERIE%';"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;

echo "CREATE TABLE  $DATABASE.tmpAvoir (
  folder varchar(255)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;
echo "insert into $DATABASE.tmpAvoir (select distinct mid(REVERSE(t.filename),instr(REVERSE(t.filename),'/')) FROM $DATABASE.videometadata t where t.filename like '%SERIE%' AND t.category=4)"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;
echo "update $DATABASE.videometadata t set t.watched=0,t.category=2 where mid(REVERSE(t.filename),instr(REVERSE(t.filename),'/')) in (select distinct tt.folder FROM $DATABASE.tmpAvoir tt);"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;
echo "DROP TABLE $DATABASE.tmpAvoir;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;

echo "CREATE TABLE  $DATABASE.tmpvideoID (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  intid int(10) unsigned NOT NULL,
  childid int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
insert into tmpvideoID (intid) (SELECT  v.intid
FROM videometadata v where LOWER(right(v.filename,3)) not in ('ifo','bup','srt','idx','sub') 
and (v.filename like '%SERIE%' or UPPER(v.filename) like 'VIDEOS%')  
order by v.filename);
update tmpvideoID v,tmpvideoID vv set v.childid=vv.intid where vv.id=1;
update tmpvideoID v,tmpvideoID vv set v.childid=vv.intid where v.id=vv.id-1;
update videometadata v,tmpvideoID vi set v.childid=vi.childid where v.intid=vi.intid;
DROP TABLE $DATABASE.tmpvideoID;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;

#gestion categories et browse
echo "Refresh Videometadata Browse (-- Part 4 `date +'%y/%m/%d-%H:%M.%S'` - list-----------)"

echo "UPDATE mythconverg.videometadata v SET browse=1 WHERE browse=0;" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST 

echo "Refresh Videometadata Browse (-- Part 5 `date +'%y/%m/%d-%H:%M.%S'` - Category    ---)"
# INSERT INTO `mythconverg`.`videocategory` (`intid`, `category`) VALUES ('1', 'vu');
# INSERT INTO `mythconverg`.`videocategory` (`intid`, `category`) VALUES ('2', 'non vu');
# INSERT INTO `mythconverg`.`videocategory` (`intid`, `category`) VALUES ('3', 'rescent');
# INSERT INTO `mythconverg`.`videocategory` (`intid`, `category`) VALUES ('4', '**à voir**');
# INSERT INTO `mythconverg`.`videocategory` (`intid`, `category`) VALUES ('5', '_à virer_');
echo "UPDATE mythconverg.videometadata SET videometadata.category = 1 WHERE videometadata.category not in (1,4,5) AND videometadata.watched <> 0;" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST 
echo "UPDATE mythconverg.videometadata SET videometadata.category = 2 WHERE videometadata.watched = 0 AND videometadata.category not in (4,5);" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST 
echo "UPDATE mythconverg.videometadata SET videometadata.category = 3 WHERE videometadata.watched = 0 AND videometadata.category not in (4,5) AND UPPER(videometadata.filename) like '%SERIES/%' ORDER BY videometadata.insertdate DESC LIMIT 10;" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
echo "UPDATE mythconverg.videometadata SET videometadata.category = 3 WHERE videometadata.watched = 0 AND videometadata.category not in (4,5) AND UPPER(videometadata.filename) like '%SERIES(DA)/%' ORDER BY videometadata.insertdate DESC LIMIT 20;" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
echo "UPDATE mythconverg.videometadata SET videometadata.category = 3 WHERE videometadata.watched = 0 AND videometadata.category not in (4,5) AND UPPER(videometadata.filename) like '%FILMS/%' ORDER BY videometadata.insertdate DESC LIMIT 20;" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
echo "UPDATE mythconverg.videometadata SET videometadata.category = 3 WHERE videometadata.watched = 0 AND videometadata.category not in (4,5) AND UPPER(videometadata.filename) like '%FILMS(DA)/%' ORDER BY videometadata.insertdate DESC LIMIT 10;" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
echo "UPDATE mythconverg.videometadata SET videometadata.category = 3 WHERE videometadata.watched = 0 AND videometadata.category not in (4,5) AND UPPER(videometadata.filename) like '%SHOW/%' ORDER BY videometadata.insertdate DESC LIMIT 20;" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
echo "UPDATE mythconverg.videometadata SET videometadata.watched = 0 WHERE videometadata.filename like '%Clips/%' AND  videometadata.watched <> 0;" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
#echo "UPDATE mythconverg.videometadata v SET v.browse='0' WHERE v.browse='1';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST 
#echo "UPDATE mythconverg.videometadata v SET v.browse='1' WHERE v.category in ('2','3','4');" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST 
echo "UPDATE mythconverg.videometadata SET browse= 0 where left(filename,4) in ('VIDE','SHOW') ;" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST


# controle parental
echo "Refresh Videometadata Browse (-- Part 6 `date +'%y/%m/%d-%H:%M.%S'` - Contro.Parent.-)"

echo "UPDATE mythconverg.videometadata v SET v.showlevel = 2 WHERE v.showlevel = 1 AND left(v.filename,instr(v.filename,'/')-1) in ('SHOW','VIDEOS_divers');" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
echo "UPDATE mythconverg.videometadata v SET v.showlevel = 2 WHERE v.showlevel = 1 AND v.filename like '%SERIES%' and v.filename not like '%Les Contes de Grimm%';" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST
echo "UPDATE mythconverg.videometadata v SET v.showlevel = 2 WHERE v.showlevel = 1 AND left(v.filename,instr(v.filename,'/')-1) in ('SERIES','FILMS','SERIES(DA)') AND v.insertdate = now();" | mariadb -p$PASSW  --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST

echo "CREATE TABLE  $DATABASE.tmpvideoID (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  intid int(10) unsigned NOT NULL,
  childid int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
insert into tmpvideoID (intid) (SELECT  v.intid
FROM videometadata v where v.showlevel = 1 AND LOWER(right(v.filename,3)) not in ('ifo','bup','srt','idx','sub') 
 and (UPPER(v.filename) like '%SERIES%' or UPPER(v.filename) like 'VIDEOS%')  
order by v.filename);
update tmpvideoID v,tmpvideoID vv set v.childid=vv.intid where vv.id=1;
update tmpvideoID v,tmpvideoID vv set v.childid=vv.intid where v.id=vv.id-1;
update videometadata v,tmpvideoID vi set v.childid=vi.childid where v.intid=vi.intid;
DROP TABLE $DATABASE.tmpvideoID;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;


# DOUBLONS
echo "Refresh Videometadata Browse (-- Part 7 `date +'%y/%m/%d-%H:%M.%S'` - doublon     ---)"

echo "select title, count(1)  as TT ,min(filename),max(filename)from videometadata where (filename like 'DVD/%' or filename like 'FILM%') group by title having TT>1;" | mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST >film_doublon.txt
cat film_doublon.txt;

#rename title : -> -
echo "UPDATE mythconverg.videometadata t set t.title = replace(t.title,':','-') where t.title like '%:%' and t.filename like '%SERI%';" | mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST 

# NETTOYAGE
echo "Refresh Videometadata Browse (-- Part 8 `date +'%y/%m/%d-%H:%M.%S'` - rm affiches ---)"


### rm les couvertures non utilisées
echo "# coverfile..."
ls "$THUMB_DIR" >/tmp/tmp.txt;
echo ''>rm_covertmp.sh;
echo "CREATE TABLE  $DATABASE.tmpvideoID (
  filename TEXT
) ENGINE=MyISAM DEFAULT CHARSET=latin1;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;
echo "LOAD DATA LOCAL INFILE '/tmp/tmp.txt' INTO TABLE mythconverg.tmpvideoID LINES TERMINATED BY '\n' ;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST ;
CORRECT_CAR
echo "SELECT concat(\"rm -f \"\"\",\"$THUMB_DIR\",tmpvideoID.filename,\"\"\"\") as '' FROM mythconverg.tmpvideoID left join mythconverg.videometadata on tmpvideoID.filename=videometadata.coverfile where videometadata.coverfile is null;" | mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST >>rm_covertmp.sh
echo "DROP TABLE $DATABASE.tmpvideoID;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;
rm /tmp/tmp.txt;
chmod 777  rm_covertmp.sh;
cat  rm_covertmp.sh;

echo "# banner..."
ls "$BANNER_DIR" >/tmp/tmp.txt;
echo ''>rm_bannertmp.sh;
echo "CREATE TABLE  $DATABASE.tmpvideoID (
  filename TEXT
) ENGINE=MyISAM DEFAULT CHARSET=latin1;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;
echo "LOAD DATA LOCAL INFILE '/tmp/tmp.txt' INTO TABLE mythconverg.tmpvideoID LINES TERMINATED BY '\n' ;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST ;
CORRECT_CAR
echo "SELECT concat(\"rm -f \"\"\",\"$BANNER_DIR\",tmpvideoID.filename,\"\"\"\") as '' FROM mythconverg.tmpvideoID left join mythconverg.videometadata on tmpvideoID.filename=videometadata.banner where videometadata.banner is null;" | mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST >>rm_bannertmp.sh
echo "DROP TABLE $DATABASE.tmpvideoID;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;
rm /tmp/tmp.txt;
chmod 777  rm_bannertmp.sh;
cat  rm_bannertmp.sh;

echo "# screenshot..."
ls "$SCREEN_DIR" >/tmp/tmp.txt;
echo ''>rm_screentmp.sh;
echo "CREATE TABLE  $DATABASE.tmpvideoID (
  filename TEXT
) ENGINE=MyISAM DEFAULT CHARSET=latin1;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;
echo "LOAD DATA LOCAL INFILE '/tmp/tmp.txt' INTO TABLE mythconverg.tmpvideoID LINES TERMINATED BY '\n' ;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST ;
CORRECT_CAR
echo "SELECT concat(\"rm -f \"\"\",\"$SCREEN_DIR\",tmpvideoID.filename,\"\"\"\") as '' FROM mythconverg.tmpvideoID left join mythconverg.videometadata on tmpvideoID.filename=videometadata.screenshot where videometadata.screenshot is null;" | mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST >>rm_screentmp.sh
echo "DROP TABLE $DATABASE.tmpvideoID;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;
rm /tmp/tmp.txt;
chmod 777  rm_screentmp.sh;
cat  rm_screentmp.sh;

echo "# fanart..."
ls "$FANART_DIR" >/tmp/tmp.txt;
echo ''>rm_fanarttmp.sh;
echo "CREATE TABLE  $DATABASE.tmpvideoID (
  filename TEXT
) ENGINE=MyISAM DEFAULT CHARSET=latin1;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;
echo "LOAD DATA LOCAL INFILE '/tmp/tmp.txt' INTO TABLE mythconverg.tmpvideoID LINES TERMINATED BY '\n' ;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST ;
CORRECT_CAR
echo "SELECT concat(\"rm -f \"\"\",\"$FANART_DIR/\",tmpvideoID.filename,\"\"\"\") as '' FROM mythconverg.tmpvideoID left join mythconverg.videometadata on tmpvideoID.filename=videometadata.fanart where videometadata.fanart is null;" | mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST >>rm_fanarttmp.sh
echo "DROP TABLE $DATABASE.tmpvideoID;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST;
rm /tmp/tmp.txt;
chmod 777  rm_fanarttmp.sh;
cat  rm_fanarttmp.sh;

echo "# avirer..."
echo "SELECT concat(\"rm -rf \"\"\",\"$VIDEO_DIR\",videometadata.filename,\"\"\"\") as '' FROM mythconverg.videometadata,mythconverg.videocategory where videocategory.category='à virer' and videocategory.intid=videometadata.category;"| mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST ;


# REMOVE MARKUP
echo "Refresh Videometadata Browse (-- Part 9 `date +'%y/%m/%d-%H:%M.%S'` - remove makup    ---)"

echo "delete FROM mythconverg.filemarkup;" | mariadb -p$PASSW --default-character-set=utf8 -u $USER -D $DATABASE -h $HOST

# FIN
echo "Refresh Videometadata Browse (-- End    `date +'%y/%m/%d-%H:%M.%S'` -----------------)";
echo "Refresh Videometadata Browse (---------------------------------------------)";

#DISPLAY=:0 notify-send -t 3000 "Fini." "<span color='#57dafd' font='50px'><i><b>Database reviewed.</b></i></span>"
mythutil --notification --timeout 3 --message_text "mise à jour video" --origin  "Fini " 
