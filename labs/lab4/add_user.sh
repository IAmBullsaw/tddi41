#! /bin/bash

function printUsage {
    echo "Usage: $0 filename.txt"
    echo "File contains one full name per line, formatted as: Firstname Lastname"
}

function getRandomHash {
    echo "$(( ( RANDOM % 9 ) +1 ))$(( ( RANDOM % 9 ) +1 ))$(( ( RANDOM % 9 ) +1 ))"
}

function getRandomNumber {
    echo "$(( ( RANDOM % 9 ) +1 ))"
}

function getRandomLetter {
    echo "a"
}

function getUserName {
    local front="${1:0:3}"
    local end="${2:0:2}"
    local rand=001
    #$(getRandomHash)
    echo "$front$end$rand" | tr [:upper:] [:lower:]
}

function getPassword {
    local pass=""
    local length=10
    for i in `seq 0 $length`; do
        if [ $(( $RANDOM % 1 )) ]; then
            pass="$pass$(getRandomNumber)"
        else
            pass="$pass$(getRandomLetter)"
        fi
    done
    echo $pass
}

[ "$1" ] && [ -e "$1" ] || { printUsage; exit 1;} #file exists?

while IFS=" " read fname lname; do
    uname=$(getUserName $fname $lname)
    passw=$(getPassword)
    echo "$uname $passw $getRandomLetter"
done < "$1"
