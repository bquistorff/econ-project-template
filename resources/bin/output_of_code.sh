#!/bin/bash
# Shows the outputs of a code file (using the .dep file)
# Usage:
# $ output_of_code.sh fake1
# $ output_of_code.sh fake1 | xargs git status -s
# $ output_of_code.sh fake1 | xargs svn status
cat code/.$1.dep | head -2 | tail -1 | sed -e 's/\(.\+\):.\+/\1/g'
