#!/bin/bash
#A script which updates factorio headless server, should be ran as root and executed via cron on a nightly basis

#Run the update script in flexible mode to see if we need updates
/home/factorio/factorio-updater/update_factorio.py -xFDa /opt/factorio/bin/x64/factorio

if [ "$?" = "2"]; then
    echo "No Updates Nessecary"
    exit 1
if [ "$?" = "3"]; then
    echo "Update available"
    service factorio stop
    if [ "$?" = "0" ]; then
        echo "Factorio server stopped"
        /home/factorio/factorio-updater/update_factorio.py -xDa /opt/factorio/bin/x64/factorio
        if [ "$?" = "1" ]; then
            echo "Failed to update Factorio server"
            exit 1
        fi
    else
        echo "Failed to stop factorio server"
        exit 1
    fi
fi

chown -R factorio /opt/factorio
if [ "$?" = "0" ]; then
    echo "Permissions updated, starting server"
    service factorio start
else
    echo "Failed to update permissions"
    exit 1
fi
