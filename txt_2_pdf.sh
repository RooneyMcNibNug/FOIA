#!/bin/bash

STAMP=`date '+%m_%d__%H_%M_%S'`

echo Please input the filename - minus .txt - you wish to convert to .pdf

read varname

enscript -p output.ps $varname.txt
sed -i '/fmodstr/d' output.ps
ps2pdf output.ps $STAMP.pdf
