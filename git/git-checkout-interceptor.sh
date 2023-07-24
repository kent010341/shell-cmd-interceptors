#!/bin/bash
#
# git checkout interceptor
#
# This script is used for fetching remote branch before trying to checkout to an un-fetched branch.
# Only work when there's no option provided.
#
# MIT License
#
# Copyright (c) 2023 Kent010341
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# only work with no option
if [[ $# -ne 2 ]]; then
  exit 0
else
  branch_name=$2

  if [[ "$branch_name" == "-" ]]; then
    exit 0
  fi
  # check if it's already at the target branch. If so, exit.
  if [[ "$(git symbolic-ref --short HEAD 2>/dev/null)" == "$branch_name" ]]; then
    echo "Already at the branch $branch_name"
    exit 1
  fi

  # check if there's a fetched remote branch. If so, checkout to it.
  if ! git show-ref --verify -q "refs/heads/$branch_name"; then
    echo "Can't find $branch_name at local branches. Processing git fetch."
    git fetch

    # check if remote branch fetched
    if ! git show-ref --verify -q "refs/remotes/origin/$branch_name"; then
      echo "Can't find $branch_name at remote branches!"
      exit 1
    fi
  fi
fi
