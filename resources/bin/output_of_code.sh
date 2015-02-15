#!/bin/bash
# Shows the outputs of a code file (using the .dep file)
cat code/.$1.dep | head -2 | tail -1 | sed -e 's/\(.\+\):.\+/\1/g'
