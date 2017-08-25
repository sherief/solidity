#!/usr/bin/env bash

#------------------------------------------------------------------------------
# Bash script to run external Solidity tests.
#
# Argument: Path to soljson.js to test.
#
# Requires npm, networking access and git to download the tests.
#
# ------------------------------------------------------------------------------
# This file is part of solidity.
#
# solidity is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# solidity is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with solidity.  If not, see <http://www.gnu.org/licenses/>
#
# (c) 2016 solidity contributors.
#------------------------------------------------------------------------------

set -e

if [ ! -f "$1" ]
then
  echo "Usage: $0 <path to soljson.js>"
  exit 1
fi

SOLJSON="$1"

function test_truffle
{
    name="$1"
    dir="$2"
    repo="$3"
    echo "Running $name tests..."
    git clone --depth 1 "$repo"
    cd "$dir"
    npm install
    cp "$SOLJSON" ./node_modules/solc/soljson.js
    npm run test
    cd ..
}

DIR=$(mktemp -d)
(
    cd "$DIR"

    test_truffle Zeppelin zeppelin-solidity https://github.com/OpenZeppelin/zeppelin-solidity.git
    test_truffle Gnosis gnosis-contracts https://github.com/gnosis/gnosis-contracts.git
)
rm -rf "$DIR"
