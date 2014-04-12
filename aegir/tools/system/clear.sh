#!/bin/bash

SHELL=/bin/bash
PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

find /var/xdrago/log/*.pid -mtime +1 -type f -exec rm -rf {} \; &> /dev/null
if [ -e "/etc/cron.daily/logrotate" ] ; then
  _SYSLOG_SIZE_TEST=$(du -s -h /var/log/syslog)
  if [[ "$_SYSLOG_SIZE_TEST" =~ "G" ]] ; then
    echo $_SYSLOG_SIZE_TEST too big
    bash /etc/cron.daily/logrotate
    echo system logs rotated
  fi
fi
if [ -e "/root/.high_traffic.cnf" ] ; then
  echo rotate > /var/log/nginx/access.log
fi
if [ -e "/var/run/boa_run.pid" ] ; then
  sleep 1
else
  rm -f /tmp/*error*
fi
if [ -e "/etc/resolvconf/run/interface/lo.pdnsd" ] ; then
  rm -f /etc/resolvconf/run/interface/eth*
  resolvconf -u &> /dev/null
fi
if [ -d "/dev/disk" ] ; then
  _IF_CDP=$(ps aux | grep '[c]dp_io' | awk '{print $2}')
  if [ -z "$_IF_CDP" ] && [ ! -e "/root/.no.swap.clear.cnf" ] ; then
    swapoff -a
    swapon -a
  fi
fi
touch /var/xdrago/log/clear.done
exit 0
###EOF2014###
