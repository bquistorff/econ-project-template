#! /bin/bash
# Windows setup
function cleanup {
  rm -f pll_gateway.sh
}
trap cleanup EXIT
rm -f pll_gateway.sh
touch pll_gateway.sh
tail -f pll_gateway.sh | bash

