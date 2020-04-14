#!/bin/bash
# cs:go server script


# This short script helps managing source engine servers by simplifying the launch parameters and updating the server files using steamcmd.
# The script should be run from inside the installed game directory which is supposedly a subdir inside the steamcmd folder.
# For updating the server files, you should start the script with the 'update' flag, e.g: './script update'

update=0
# check if the server needs to be updated (manually)
if [ "$1" == "update" ]
then
	update=1
fi

# set the server directory
server_dir="csgo"
# set the app_id of the server (cs:go - 740, tf2 - 232250, hl2:dm - 232370)
app_id="740"
# set the base port of the server - steam port will be -15, clientport -10
port="17427"
# set the number of max players
maxplayers="20"
# set the game name (csgo, tf2, hl2dm)
game="csgo"
# set the starting map
map="de_dust2"
# steam token id for the server browser - you can get the token here: https://steamcommunity.com/dev/managegameservers
steamtoken=""

# set the steam port
#sport=$(($port-15))
# set the client port
#cport=$(($port-10))


# check if there's already a screen open with the server folder's name
screen_id=( $(screen -ls | grep -i $server_dir) )

if [ "$?" -eq "0" ]
then
# kill the screen
        screen -X -S $(echo "$screen_id" | grep -oP '.*?(?=\.)') kill
	if [ "$update" -eq "1" ]
	then
        	../steamcmd.sh +login anonymous +force_install_dir ./$server_dir/ +app_update $app_id +quit
		if [ "$?" -eq "0" ]; then echo "The server update was successful"; fi
	fi
        screen -dmS $server_dir ./srcds_run -game $game -tickrate 128 -console -usercon -port $port +map $map +maxplayers $maxplayers +sv_setsteamaccount $steamtoken # -sport $sport -cport $cport
else
	if [ "$update" -eq "1" ]
	then
        	../steamcmd.sh +login anonymous +force_install_dir ./$server_dir/ +app_update $app_id +quit
	fi
        screen -dmS $server_dir ./srcds_run -game $game -tickrate 128 -console -usercon -port $port +map $map +maxplayers $maxplayers +sv_setsteamaccount $steamtoken # -sport $sport -cport $cport
fi
