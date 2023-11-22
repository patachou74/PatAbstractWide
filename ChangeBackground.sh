#!/bin/sh
PATHFILE=/media/3T/DOCS/PHOTOS
FILENAME="2011/2011 06 23 Luxembourg/20110624 124923 028.JPG"
cp "${PATHFILE}/${FILENAME}" ~/.mythtv/themes/PatAbstractWide/images/background.jpg
rm ~/.mythtv/cache/themecache/PatAbstractWide*/images-background.jpg*
cp ~/.mythtv/themes/PatMenu/extras_menu.ini.xml ~/.mythtv/themes/PatMenu/extras_menu.xml;
sed -i -e "s,Image_initiale,${FILENAME},g" ~/.mythtv/themes/PatMenu/extras_menu.xml;
