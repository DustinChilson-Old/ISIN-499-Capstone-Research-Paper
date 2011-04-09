#!/bin/sh
echo Spell Checking!
aspell check intro.tex
aspell check social.tex
aspell check paper.tex
aspell check tagged.tex
aspell check tools.tex
echo Creating Document!
pdflatex -interaction=batchmode -no-shell-escape paper.tex > /dev/null

echo Adding Bibliography!
bibtex -terse paper.aux > paperbib.log
pdflatex -interaction=batchmode -no-shell-escape paper.tex > /dev/null
pdflatex -interaction=batchmode -no-shell-escape paper.tex > /dev/null

rm *.aux paper.bbl paper.blg paper.log paperbib.log
rm paper.bib.bak paper.ent paper.fff paper.ttt paper.tex.bak

/usr/bin/osascript \
  -e "set theFile to POSIX file \"paper.pdf\" as alias" \
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
