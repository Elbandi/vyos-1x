#!/bin/sh

CACHE="/var/spool/squid"

if systemctl is-active --quiet squid; then 
   systemctl stop squid
   if cli-shell-api existsActive service webproxy url-filtering \
                       squidguard vyattaguard https-filter; then
     echo Stopping VyattaGuard https filter...
      kill `cat /var/run/vgd_https.pid 2> /dev/null` 2> /dev/null
   fi
   if [ -d "$CACHE" ]
   then
   mv $CACHE $CACHE.old
   mkdir $CACHE
   chown -R proxy:proxy $CACHE
   squid -z
   systemctl start squid
   rm -rf $CACHE.old
   fi
   if cli-shell-api existsActive service webproxy url-filtering \
                       squidguard vyattaguard https-filter; then
      echo Starting VyattaGuard https filter...
      /opt/vyatta/sbin/vgd_https -D -q 1 -p /var/run/vgd_https.pid
   fi
else
   if [ -d "$CACHE" ]
   then
   mv $CACHE $CACHE.old
   mkdir $CACHE
   chown -R proxy:proxy $CACHE
   squid -z
   rm -rf $CACHE.old
   fi
fi
