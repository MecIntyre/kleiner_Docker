#!/bin/sh

# APT im nicht-interaktiven Modus 
export DEBIAN_FRONTEND=noninteractiv

# Paketverarbeitung über HTTPS
apt-get -y install apt-transport-https ca-certificates curl \
  gnupg lsb-release

# Offizieller GPG Key zur Zertifizierung hinzufügen
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up Repo und Docker hinzufügen
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Aktualisierung der Paketdatenbank mit den Docker-Paketen aus dem neuen Repo
apt-get update

# Docker, Docker-Compose und Git installieren
apt-get -y install docker-ce docker-ce-cli containerd.io \
  git docker-compose

# Docker einschalten
systemctl enable --now docker

# Benutzer "Vagrant" hinzufügen
adduser vagrant docker

# Default Route setzen
ip route replace default via 192.168.100.2
ip route del default via 10.0.2.2

# Konfiguration der Namensauflösung
systemctl disable --now systemd-resolved
rm /etc/resolv.conf
echo "nameserver 192.168.100.2" > /etc/resolv.conf
echo "search kurs.iad" >> /etc/resolv.conf

# Ordner für Github Repo erstellen und betreten
mkdir -p /home/git && cd /home/git

# Github Repo downloaden und fehlender Ordner "Model" erstellen
git clone https://github.com/MecIntyre/chatbot_docker.git
cd chatbot_docker && mkdir v3/model

# Chatbot starten
docker-compose up -d
