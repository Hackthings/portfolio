#!/usr/bin/env bash

ROOT=$(pwd)
LATEX_DIR="$ROOT/latex-s2"
WIKI_DIR="$ROOT/wiki-s2"

echo "Running compile at $ROOT"

#
# Runs pandoc to compile our portfolio
#
function run_pandoc() {
  echo "Running pandoc for $1..."
  pandoc "$WIKI_DIR/$1.md" --template ./template.latex -V toc -V -s --number-sections -V links-as-notes -V papersize=a4 -V indent -V fontsize=12pt -o "$LATEX_DIR/$1.pdf"
}

#
# Runs tex output
#
function generate_tex() {
  echo "Generating tex for $1..."
  pandoc "$WIKI_DIR/$1.md" --template ./template.latex -V toc -V -s --number-sections -V links-as-notes -V papersize=a4 -V indent -V fontsize=12pt -o "$LATEX_DIR/$1.tex"
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
git submodule update --remote wiki-s2

# if [ "$1" == "all" ]; then
#   # Run pandoc...
#   run_pandoc "S2-Who-Did-What"
#   run_pandoc "Assessment-Criteria-Agreement"
#   generate_tex "S2-Project-Plan"
#   run_pandoc "S2-SDLC-Plan"
#   run_pandoc "S2-SRS"
#   run_pandoc "S2-Wireframes"
#   generate_tex "S2-Usability-Testing-Report"
#   run_pandoc "S2-User-Manual"
  # run_pandoc "S2-Source-Code-Dump"
#   generate_tex "S2-API-Web-Changes"
#   run_pandoc "S2-Meeting-Minutes"
# fi
# if [ "$1" == "pdf" ] || [ "$1" == "all" ]; then
#   # compile_pdf "Requirements-Documentation"
#   compile_pdf "S2-Technical-Manual"
#   # compile_pdf "Project-Plan"
#   # compile_pdf "Group-Contact-Details"
#   # compile_pdf "Design-Prototype"
# elif [ "$1" != "tex" ]; then
#   run_pandoc $1
# fi

# Always recompile the PDF
compile_pdf "Portfolio"
open "$LATEX_DIR/Portfolio.pdf"
