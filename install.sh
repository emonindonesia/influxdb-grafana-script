#!/bin/bash

echo "====================================="
echo "==---------------------------------=="
echo "== Grafana & InfluxDB Installation =="
echo "==        For Ubuntu        		 =="
echo "==                                 =="
echo "==       From eMonIndonesia        =="
echo "==                                 =="
echo "==   							     =="
echo "==---------------------------------=="
echo "====================================="

echo " "
echo "Installing Grafana..."

WANIP=`dig @resolver1.opendns.com A myip.opendns.com +short -4`
var1="Step 1: Point your browser to http://" 
var2=":3000" 
#read  -rd '' WANIP <<< "$WANIP"
echo $var1$WANIP$var2 

wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

apt update && sudo apt install -y grafana

systemctl unmask grafana-server.service
systemctl start grafana-server
systemctl enable grafana-server.service

echo " "
echo "Installing InfluxDB..."

wget -qO- https://repos.influxdata.com/influxdb.key | sudo apt-key add -
source /etc/os-release
echo "deb https://repos.influxdata.com/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

apt-get update && apt-get install influxdb

sudo systemctl unmask influxdb.service
sudo systemctl start influxdb
sudo systemctl enable influxdb.service

echo " "
read -p "Installation complete, press ENTER to continue with setup..." null

echo "========================="
echo "= Set up a new database ="
echo "========================="
echo " "
echo "Enter your desired values (no spaces)..."

read -p "Enter a name for the database: " dbname
read -p "Enter a username for the database: " usrname
read -p "Enter a password for the database: " pssword

echo "Creating database..."
influx -execute "create database $dbname"
echo "Setting database..."
influx -execute "use $dbname"
echo "Setting privileges..."
influx -execute "create user "$usrname" with password '"$pssword"' with all privileges"
influx -execute "grant all privileges on $dbname to $usrname"
echo " "
influx -execute "show users"
echo "....DONE!"


echo " "
echo "======================="
echo "How to setup Grafana..."
echo "======================="
#echo "Step 1: Point your browser to http://<your-ip>:3000"
echo $var1$WANIP$var2 
echo "Step 2: Log in with the default Grafana user & pass" 
echo "        user: admin"
echo "        pass: admin"
echo "Step 3: Change default Grafana login"
echo "Step 4: Add Data Source in Configuration, choose InfluxDB"
echo "step 5: Set HTTP url"
echo "        URL: http://localhost:8086"
echo "Step 6: Set InfluxDB Details..."
echo "        Database: $dbname"
echo "        User: $usrname"
echo "        Password: $pssword"
echo "        HTTP Method: GET"
echo "Step 7: Click Save & Test"
echo "========================="
echo " "
echo "Thanks for using the eMon Indonesia Grafana & InfluxDB installation script!"
echo "https://www.emonindonesia.com"
