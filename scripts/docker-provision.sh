#!/bin/sh

# APT im nicht-interaktiven Modus 
export DEBIAN_FRONTEND=noninteractiv

# Aktualisierung der Paketdatenbank
apt update
# Paketverarbeitung über HTTPS
apt-get install apt-transport-https ca-certificates curl software-properties-common
# Offizieller GPG Key hinzufügen
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# Set up Repo und Docker hinzufügen
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
# Aktualisierung der Paketdatenbank mit den Docker-Paketen aus dem neuen Repo
apt update
# Repo update und Sicherstellung des Docker Repos
apt-cache policy docker-ce
# Docker installieren
apt-get -y install docker-ce docker-ce-cli containerd.io
# Docker einschalten
systemctl enable --now docker
#Benutzer "Vagrant" hinzufügen
adduser vagrant docker

# Default Route setzen
ip route replace default via 192.168.100.2
ip route del default via 10.0.2.2

# Konfiguration der Namensauflösung
systemctl disable --now systemd-resolved
rm /etc/resolv.conf
echo "nameserver 192.168.100.2" > /etc/resolv.conf
echo "search kurs.iad" >> /etc/resolv.conf