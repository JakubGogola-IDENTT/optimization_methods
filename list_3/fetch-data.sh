#!/bin/bash

rm -rf data
mkdir data

for i in {1..12}
do
    echo "Fetching gap$i.txt..."
    wget "http://people.brunel.ac.uk/~mastjjb/jeb/orlib/files/gap$i.txt" -P data 2>/dev/null
    echo "File fetched"
done

for ch in {a..d}
do
    echo "Fetching gap$ch.txt..."
    wget "http://people.brunel.ac.uk/~mastjjb/jeb/orlib/files/gap$ch.txt" -P data 2>/dev/null 
    echo "File fetched"
done
