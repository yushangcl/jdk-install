#!/bin/bash

# shellcheck disable=SC2046
# shellcheck disable=SC2006
rclone copy -P -v --transfers=2  --log-file=logs/upload.log $1 app_eu:/Applications/Github/app > logs/rclone.log 2>&1