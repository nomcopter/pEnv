#!/bin/bash

echo

for i in $(seq 0 255)
do
    tput setab $i

    [ $i -lt 16 ] && padding=3 || padding=4

    printf "%${padding}s" $i

    # Arbitrary newlines
    if [ $i -eq 7 -o $i -eq 15 -o $i -eq 231 ]; then
        echo 
    fi
    # I wanted two here
    if [ $i -eq 15 ]; then
        echo 
    fi
    # Newline every six for the big block
    if [ $i -gt 20 -a $((($i - 15) % 6)) -eq 0 ]; then
        echo 
    fi
done
