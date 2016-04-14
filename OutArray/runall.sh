#!/bin/bash

echo "Example in Perl"
perl out.pl
echo

echo "Example in PHP"
php out.php
echo

echo "Example in Java"
javac out.java
java out
echo

echo "Example in C"
gcc -std=c99  -o outc  out.c
./outc
echo

echo "Example in Python"
python out.py
echo

echo "Example in Pascal"
fpc -ooutp out.pas 2>/dev/null 1>&2
./outp
echo

rm -f out.class outc outp
