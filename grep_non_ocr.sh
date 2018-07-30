#! /bin/bash

### This is a script to search directories in linux for non searchable (non-OCR'd) pdfs and automatically OCR ones that are not
### searchable using ocrmypdf. Prerequisites to run this include ocrmypdf (apt-get install ocrmypdf or pip3 install ocrmypdf),
### tesseract, and qpdf.

if [[ ! "$#" = "1" ]]
  then
      echo "Usage: $0 /path/to/PDFs"
      exit 1
fi

PDFDIRECTORY="$1"

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
          echo "NO OCR: $FILE"
      else
          echo "OCR: $FILE"
    fi
        if [ $echo "NO OCR: $FILE" ]
          then
              ocrmypdf OCRd_$FILE
    fi

done < <(find "$PDFDIRECTORY" -type f -name '*.pdf' -print0)

echo "Done with checking - moving to next step."
if [[ "$READ_ERROR" = "1" ]]
  then
      echo "An error occured."
fi

