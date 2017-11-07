#!/bin/bash

function printUsage {
    echo "Usage: $0 filename.txt"
    echo "File contains one full name per line, formatted as: Firstname Lastname"
}

function createUserName () {
  local begin="${1:0:3}"
  local end="${2:0:2}"
  local num=$(((RANDOM%900+100)))
  local username=`echo "$begin$end$num" | tr [:upper:] [:lower:]`
  while [ `grep -c "^$username:" /etc/passwd` -eq 1 ]; do
    num=$(((RANDOM%900+100)))
    username=`echo "$begin$end$num" | tr [:upper:] [:lower:]`
  done
  echo $username
}

function createUserPassword () {
  echo $(date +%s | sha256sum | base64 | head -c 32)
}

function addUser () {
  adduser $1 --gecos "first last, roomnumber, workphone, homephone" --disabled-password
  echo "$1:$2" | chpasswd
}

[ "$1" ] && [ -e "$1" ] || { printUsage; exit 1;} #file exists?

echo "username  | password"
echo "----------+---------------------------------"
while IFS=" " read fname lname; do
  user="$(createUserName $fname $lname)"
  passwd="$(createUserPassword)"
  echo "$(addUser $user $passwd)" > /dev/null
  echo "$user  | $passwd"
done < "$1"
