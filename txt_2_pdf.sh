#Quick way to convert a .txt to a .pdf with enscript & ghostscript. 
#This is for a single file input, but plan to creating an all-directory
#script to convert all files within then run pdfunite.

#!/bin/bash

STAMP=`date '+%m_%d__%H_%M_%S'`

echo Please input the filename - minus .txt - you wish to convert to .pdf

read varname

enscript -p output.ps $varname.txt
sed -i '/fmodstr/d' output.ps #remove postscript timestamp to avoid confusion
ps2pdf output.ps $STAMP.pdf
