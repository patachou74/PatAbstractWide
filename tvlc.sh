#!/bin/sh
input=$* ;

# input="/myth://Videos@192.168.1.60/SERIES/Arrow/Arrow.S01E09.mkv"
# input="myth://Videos@rodrinux/FILMS(DA)/A.Christmas.carol.avi"

FILM=`echo ${input#*@}`;
FILM=`echo ${FILM#*/}`;
#FILM=/var/lib/mythtv/videos/${FILM}
FILM=/media/4TB/videos/${FILM}
echo `date "+%Y-%m-%d %H:%M:%S"` > /home/myt/vlc.log
echo $FILM  >> /home/myt/vlc.log
# exit

# cvlc -f /"$FILM"  >> /home/myt/Bureau/vlc.log
DISPLAY=:0 /snap/bin/vlc -f "$FILM"

#changer quitter en s et quitter en fin de paylist
#cvlc://quit 
