#This is meant to have the PWD be in the project root.
#It is included from the base makefile

-include writeups/.*.dep

HAVE_LATEXMK := $(shell command -v latexmk 2>/dev/null)

ifneq "$(HAVE_LATEXMK)" ""
  include writeups/writeups-latexmk.mk
else
  include writeups/writeups-nolatexmk.mk
endif
