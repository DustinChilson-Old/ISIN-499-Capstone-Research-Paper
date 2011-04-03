#!/bin/sh
echo Spell Checking!
aspell check $2.tex
echo Creating Document!
pdflatex -interaction=batchmode -no-shell-escape $2.tex > /dev/null

echo Adding Bibliography!
bibtex -terse $2.aux > $2bib.log
pdflatex -interaction=batchmode -no-shell-escape $2.tex > /dev/null
pdflatex -interaction=batchmode -no-shell-escape $2.tex > /dev/null

rm *.aux $2.bbl $2.blg $2.log $2bib.log
rm $2.bib.bak $2.ent $2.fff $2.ttt $2.tex.bak

/usr/bin/osascript \
  -e "set theFile to POSIX file \"$2.pdf\" as alias" \
  -e "set thePath to POSIX path of theFile" \
  -e "tell application \"Skim\"" \
  -e "  activate" \
  -e "  set theDocs to get documents whose path is thePath" \
  -e "  try" \
  -e "    if (count of theDocs) > 0 then revert theDocs" \
  -e "  end try" \
  -e "  open theFile" \
  -e "end tell"

echo Done!
