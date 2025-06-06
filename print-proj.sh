#!/bin/bash
for item in *;
do
  cat "$item" > output.txt
done
