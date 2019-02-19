#!/usr/bin/env bash
### maybe i should check if this is enabled somehow and then run it?
AMIFORWARDING=`sysctl net.ipv4.conf.all.forwarding | grep 1`
ISIPTABLESSET=`sudo iptables -S | grep -F "-P FORWARD ACCEPT"`

if [ -z "${AMIFORWARDING}" ]
then
  echo "forwarding in sysctl does not seem to be set. setting it right now"
  sudo sysctl net.ipv4.conf.all.forwarding=1 >/dev/null
else
  echo "forwarding rule seems to be set"
fi
if [ -z "${ISIPTABLESSET}" ]
then
  echo "forwarding rules do not seem to be set. setting them right now"
  sudo iptables -P FORWARD ACCEPT
else
  echo "forwarding rule seems to be set"
fi
