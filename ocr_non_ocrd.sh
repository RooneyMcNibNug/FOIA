#! /bin/bash

### This is a script to run against a directory in linux to search for all pdfs then automatically OCR (make searchable) ones that aren't already
### by running ocrmypdf. Prerequisites to run this include ocrmypdf (apt-get install ocrmypdf or pip3 install ocrmypdf), tesseract, 
### and qpdf. This is a hastily cobbled together attempt to convert non-OCR responsive FOIA documents - commonly scanned from original
### copies of their respective documents - searchable, and doing so in a more efficient manner.

if [[ ! "$#" = "1" ]]
  then
      echo "Usage: $0 /directory/of/PDFs"
      exit 1
fi

PDFDIR="$1"
RED='\033[0;31m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'

while IFS= read -r -d $'\0' FILE; do
    PDFFONTS="$(pdffonts "$FILE" 2>/dev/null)"
    RET_PDFFONTS="$?"
    FONTS="$(( $(echo "$PDFFONTS" | wc -l) - 2 ))"
    if [[ ! "$RET_PDFFONTS" = "0" ]]
      then
          READ_ERROR=1
          echo "Error while reading $FILE. Skipped and moving to next one."
          continue
    fi
    if [[ "$FONTS" = "0" ]]
      then
          echo -e "${RED}NO OCR:${NO_COLOR} $FILE"
          ocrmypdf "${FILE}" "${FILE%.*}_OCRd"
      else
          echo -e "${GREEN}OCR:${NO_COLOR} $FILE"
    fi

done < <(find "$PDFDIR" -type f -name '*.pdf' -print0)

    if [[ "$READ_ERROR" = "1" ]]
      then
          echo "An error occured."
    fi

