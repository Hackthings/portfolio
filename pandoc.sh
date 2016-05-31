#!/usr/bin/env bash

ROOT=$(pwd)
LATEX_DIR="$ROOT/latex"
WIKI_DIR="$ROOT/wiki"

echo "Running compile at $ROOT"

#
# Runs pandoc to compile our portfolio
#
function run_pandoc() {
  echo "Running pandoc for $1..."
  pandoc "$WIKI_DIR/$1.md" --template ./template.latex -V toc -V -s --number-sections -V links-as-notes -V papersize=a4 -V indent -V fontsize=12pt -o "$LATEX_DIR/$1.pdf"
}

#
# Compiles our final PDF
#
function compile_pdf() {
  if [ "$1" == "Portfolio" ]; then
    DIR="$LATEX_DIR"
  else
    DIR="$LATEX_DIR/$1"
  fi
  TEX_FILE="$DIR/$1.tex"
  OUT_PDF="$DIR/$1.pdf"
  CP_PDF="$LATEX_DIR/$1.pdf"
  cd "$DIR"
  echo "Compiling LaTeX at $TEX_FILE"
  rm OUT_PDF
  pdflatex -shell-escape "$TEX_FILE" -o .
  if [ "$1" != "Portfolio" ]; then
    echo "Copying $OUT_PDF to $CP_PDF"
    cp "$OUT_PDF" "$CP_PDF"
  fi
  cd "$ROOT"
}

# Update git submodule always
git submodule update
git submodule foreach git pull origin master

if [ "$1" == "all" ]; then
  # Run pandoc...
  run_pandoc "Alex's-Worklog"
  run_pandoc "Assessment-Criteria-Agreement"
  run_pandoc "Contributing-Web"
  run_pandoc "Jake's-Worklog"
  run_pandoc "Lachlan's-Worklog"
  run_pandoc "Meeting-Minutes"
  run_pandoc "Presentation-Video"
  run_pandoc "Project-Tools"
  run_pandoc "Reuben's-Worklog"
  run_pandoc "SDLC-Plan"
fi
if [ "$1" == "pdf" ] || [ "$1" == "all" ]; then
  compile_pdf "Requirements-Documentation"
  compile_pdf "Contributing-API"
  compile_pdf "Project-Plan"
  compile_pdf "Group-Contact-Details"
  compile_pdf "Design-Prototype"
elif [ "$1" != "tex" ]; then
  run_pandoc $1
fi

# Always recompile the PDF
compile_pdf "Portfolio"
open "$LATEX_DIR/Portfolio.pdf"
