#!/usr/bin/sh

#Adapted by Ben Schmidt from Barry Hubbard's code at 
#http://www.barryhubbard.com/articles/37-general/74-converting-a-pdf-to-text-in-linux 
#to convert into a folder of text files, each one representing a page.

#This takes pdfs from the pdfs folder, writes tif files to the images folder, and writes text to the texts folder.
#each pdf gets a _folder_ in each of the other two.
mkdir -p texts
mkdir -p images

#Make a folder
filename=`echo $1 | sed 's/.pdf//' | sed 's/.*\///'`
mkdir -p texts/$filename
mkdir -p images/$filename

#Print the name of the dude we're working on.
echo $filename
echo "\n\n"

#First, convert the pdf to a set of numbered tif  files. That takes a little while, so I'm using the existence
#of the first page as a rough gauge of whether it's there.
if [ ! -f images/$filename/scan_1.tif ]; #Only redo the ghostscript if the file doesn't exist;
then
    if [ -f pdfs/$filename.pdf ]
    then
        gs -dNOPAUSE -dBATCH -sDEVICE=tiffg4 -sOutputFile=images/$filename/scan_%d.tif pdfs/$filename.pdf
    else
        gs -dNOPAUSE -dBATCH -sDEVICE=tiffg4 -sOutputFile=images/$filename/scan_%d.tif $filename.pdf
    fi
fi


#Then ocr the pages, one at a time.
i=1
while [ $i -ge 0 ]
do
    if [ -e images/$filename/scan_$i.tif ]
    then
        if [ ! -e texts/$filename/$i.txt ] #now doesn't overwrite
        then
            tesseract images/$filename/scan_$i.tif texts/$filename/$i
        #add the text to the result.txt file
        fi
        i=$(( $i + 1 ))
    else #Break if the tif file doesn't exist.
        i=-100
    fi
done