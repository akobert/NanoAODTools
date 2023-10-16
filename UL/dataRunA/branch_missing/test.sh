#!/bin/bash

filename=test.txt

lin=6


file=$(sed -n $(echo $(($lin+1)))p $filename)

echo $file
