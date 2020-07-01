# Domoticz docker container Raspberry pi 4
This is a docker-container running Domoticz on a raspberry pi 4

## Build and start the container
When starting for the first time do:

	docker-compose up -d

This will take a while to build the domoticz container. Then when the container is up and running
it can be stopped and started with:

	docker-compose stop
	docker-compose start

## Aeotec Z-Wave USB controller
On a raspberry pi 4 there are issues with the Aeotec Z-Wave USB stick. You will need a very 
cheap USB-hub between your RPI 4 USB port and the Aeotec stick (I used an old keyboard with 
USB-ports!). On older RPI versions this is not an issue.


 
