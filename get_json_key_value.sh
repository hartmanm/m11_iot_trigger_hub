#!/bin/bash

# Copyright (c) 2022 Michael Neill Hartman. All rights reserved.
# mnh_license@proton.me
# https://github.com/hartmanm

# get_json_key_value

TARGET_JSON_FULLPATH=${1}
TARGET_KEY=${2}

KEY_LIST=`                      \
 cat -n ${TARGET_JSON_FULLPATH} | \
 tr ':' ' '                     | \
 awk '{print $1"^"$2}'          | \
 tr -d '"'                      | \
 tr -d '{'                      | \
 tr -d '}'                      `

# short circuit if key is not in json
[[ `echo ${KEY_LIST} | tr '^' ' ' | grep -w ${TARGET_KEY}` != "" ]] && {
TARGET_LINE_NUMBER=`  \
 echo ${KEY_LIST}     | \
 tr ' ' '\n'          | \
 grep ${TARGET_KEY}   | \
 tr '^' ' '           | \
 awk '{print $1}'     `
TARGET_VALUE=`
 head -$TARGET_LINE_NUMBER ${TARGET_JSON_FULLPATH} | \
 tail -1                                           | \
 tr ':' ' '                                        | \
 awk '{print $2}'                                  | \
 tr -d ','                                         `
echo ${TARGET_VALUE:1:-1}
}

# bash get_json_key_value `pwd`/m11.json START

# bash get_json_key_value `pwd`/m11.json USE_FIREFOX_OR_CHROME

# bash get_json_key_value `pwd`/m11.json LOCAL_COMMAND_LISTENER_PORT
