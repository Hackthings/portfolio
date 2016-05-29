#!/usr/bin/env bash

LATEX_DIR="latex"
WIKI_DIR="wiki"

#
# Runs pandoc to compile our portfolio
#
function run_pandoc() {
  echo "Running pandoc for $1..."
  pandoc "$WIKI_DIR/$1.md" --template ./template.latex -V toc -V -s --number-sections -V links-as-notes -V papersize=a4 -o "$LATEX_DIR/$1.pdf"
}

#
# Compiles our final PDF
#
function complile_pdf() {
  cd $LATEX_DIR
  pdflatex -shell-escape Portfolio.tex -o ..
  cd ..
  open Portfolio.pdf
}

# Update git submodule always
git submodule update
git submodule foreach git pull origin master

if [ "$1" == "all" ]; then
  # Run pandoc...
  run_pandoc "Alex's-Worklog"
  run_pandoc "Assessment-Criteria-Agreement"
  run_pandoc "Contributing-Web"
  run_pandoc "Contributing-API"
  run_pandoc "Design-Prototype"
  run_pandoc "Jake's-Worklog"
  run_pandoc "Lachlan's-Worklog"
  run_pandoc "Meeting-Minutes"
  run_pandoc "Presentation-Video"
  run_pandoc "Project-Tools"
  run_pandoc "Project-Plan"
  run_pandoc "Requirements-Documentation"
  run_pandoc "Reuben's-Worklog"
  run_pandoc "SDLC-Plan"
  # Copy altered
  cp ./latex/Group-Contact-Details/Group-Contact-Details.pdf ./latex/Group-Contact-Details.pdf
elif [ "$1" != "tex" ]; then
  run_pandoc $1
fi

# Always recompile the PDF
complile_pdf
