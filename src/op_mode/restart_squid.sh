#!/bin/sh

if cli-shell-api existsEffective service webproxy; then
    echo "Restarting the webproxy service"
    systemctl restart squid
    if cli-shell-api existsActive service webproxy url-filtering \
                        squidguard vyattaguard https-filter; then
        echo Stopping VyattaGuard https filter...
        kill `cat /var/run/vgd_https.pid 2> /dev/null` 2> /dev/null
        echo Starting VyattaGuard https filter...
        /opt/vyatta/sbin/vgd_https -D -q 1 -p /var/run/vgd_https.pid
    fi
else
    echo "webproxy service is not configured"
fi
