# AxpertPi

An easy to use script to install https://github.com/ned-kelly/docker-voltronic-homeassistant.

## Prerequisites

- Raspberry Pi 2/3/4 ( only tested on 3 and 4 )
- Docker-compose
- [Voltronic/Axpert/MPPSolar] based inverter that you want to monitor

## Configuration & Standing Up

1. Download Raspberry Pi Imager from https://www.raspberrypi.org/downloads/
2. Flash either Raspberry Pi OS or Raspberry Pi OS Lite onto an sd card.
3. Copy the following files to the boot partition of your sd card: ssh, wpa_supplicant.conf
4. Change wpa_supplicant.conf and replace the following credentials with your wifi name, password and country code :
```
country=ZA
ssid=“mywifi"
psk="mypassword"
```

5. SSH into your pi and run the following command:
```
curl -s https://raw.githubusercontent.com/BionicWeb/AxpertPi/master/axpertpi.sh?$(date +%s) | sudo bash
```

6. If you have a different inverter than the Axpert King 5KW, set the configuration files in the `config/` directory:

```bash
cd /opt/ha-inverter-mqtt-agent

# Configure the 'device=' directive (in inverter.conf) to suit for RS232 or USB.. 
sudo nano config/inverter.conf

# These settings are specif to an Axpert King 5Kw, please change for your inverter if different. See Point 10 below.
# This allows you to modify the buffersize for the qpiri command
qpiri=104

# This allows you to modify the buffersize for the qpiws command
qpiws=40

# This allows you to modify the buffersize for the qmod command
qmod=5

# This allows you to modify the buffersize for the qpigs command
qpigs=110
```

7. Then, plug in your Serial or USB cable to the Inverter & stand up the container:
8. Open your browser and navigate to your pi's ip example: http://192.168.1.50:8123 (You can find your pi's ip by using fing https://www.fing.com/products/fing-app)
9. Login to home assistant with username pi and password raspberry. (Please change this in home assistant)
   If the data does not appear to update in home assistant go to the left menu -> Configuration -> Entities
   It should then start updating in the dashboard, I am not sure why this sometimes happen on the very first boot.
10. If you have a different inverter use:
```bash
sudo docker exec -it voltronic-mqtt bash -c '/opt/inverter-cli/bin/inverter_poller -d -1'
SHOWS:
Tue Mar 31 14:33:29 2020 INVERTER: QPIRI reply size (102 bytes)
Tue Mar 31 14:33:29 2020 INVERTER: QPIRI: incorrect start/stop bytes. Buffer: (230.0 …
Tue Mar 31 14:33:29 2020 INVERTER: Current CRC: B4 DA
Tue Mar 31 14:33:29 2020 INVERTER: QPIWS reply size (36 bytes)
Tue Mar 31 14:33:29 2020 INVERTER: QPIWS: incorrect start/stop bytes. Buffer: (…
Tue Mar 31 14:33:34 2020 INVERTER: Current CRC: F8 54
```
Note the QPIRI reply size (102 bytes) as an example, use the 102 value in /opt/ha-inverter-mqtt-agent/config/inverter.conf, example qpiri=102 and for each command respectively.
