#!/bin/bash -e

ACTION=$1
DIR=$2

# config.get :: IO (Maybe Config, ConfigSpec)
# config.set :: Config -> IO ()

# read config file and return
if [ "$ACTION" = "get" ]; then
    cat ${DIR}/start9/config.yaml
# read config, set value, and return updated
elif ["$ACTION" = "set"]; then
    if [ -s ${DIR}/start9/config.yaml ]
    then
        touch ${DIR}/start9/config.yaml
        cat $(<${DIR}/start9/config.yaml)
    else
        cat $(<${DIR}/start9/config.yaml)
    fi
else
	echo 'action type of either "get" or "set" must exist'
	exit 1
fi