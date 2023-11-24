#!/bin/bash

followers=()
not_following_back=()

json_followers=$1
json_followings=$2

# creating the list of followers
range_followers=$(jq '. | length' "$json_followers")

for ((i=0; i<range_followers; i++))
do
  follower_value=$(jq -r ".[$i].string_list_data[0].value" "$json_followers")
  followers+=("$follower_value")
done

# checking if the people who you are following are following you back
range_followings=$(jq '.relationships_following | length' "$json_followings")

for ((i=0; i<range_followings; i++))
do
  following_value=$(jq -r ".relationships_following[$i].string_list_data[0].value" "$json_followings")
  
  if [[ " ${followers[@]} " != *" $following_value "* ]]; then
    not_following_back+=("$following_value")
  fi
done

echo "The people who don't follow you back are : ${not_following_back[@]}"

if [ "$#" -lt 2 ]; then
  echo "Bad usage for $0 you need to give two files in this order: followers_file.json following_file.json"
fi
