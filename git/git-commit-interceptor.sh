#!/bin/bash
#
# git commit interceptor
#
# This script is used for prompt user while trying to commit on master branch, or 
# the commit message isn't valid.
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

source "$INTERCEPTOR_PATH/git/.env"

# shift will affect $@, make a backup
args=("$@")

# get current local branch name
branch_name="$(command git symbolic-ref --short HEAD 2>/dev/null)"

# warn all master commit
if [[ "$branch_name" == "$MASTER_BRANCH_NAME" ]]; then
  echo -e "\033[1;91mYou're trying to commit to $branch_name branch! Continue? (y/N)\033[0m"
  read confirm
  if [[ "$confirm" != "y" ]]; then
    exit 1
  fi
# check if the branch matches the certain branch pattern
elif [[ "$branch_name" =~ $BRANCH_PATTERN ]]; then
  branch_matches=("${BASH_REMATCH[@]}")
  # some OS doesn't store regex matches at 'BASH_REMATCH', they use 'match'
  if [ ${#BASH_REMATCH[@]} -eq 0 ]; then
    branch_matches=("${match[@]}")
  fi

  shift
  # find commit message
  while [[ $# -gt 0 ]]; do
    case "$1" in
      "-m")
        shift
        commit_msg="$@"
        break
      ;;
    esac
  done
  # check if commit message is valid
  if [[ ! -z "$MESSAGE_PATTERN" ]]; then
    if [[ "$commit_msg" =~ $MESSAGE_PATTERN ]]; then
      msg_matches=("${BASH_REMATCH[@]}")
      # some OS doesn't store regex matches at 'BASH_REMATCH', they use 'match'
      if [ ${#BASH_REMATCH[@]} -eq 0 ]; then
        msg_matches=("${match[@]}")
      fi
    else
      echo -e "\033[1;91mCommit message is with the wrong pattern! Continue? (y/N)\033[0m"
      read confirm
      if [[ "$confirm" != "y" ]]; then
        exit 1
      fi
    fi

    # validate group 1 of commit message to specified branch group if is set
    if [[ ! -z "$VALIDATE_MESSAGE_GROUP_1_TO_BRANCH_GROUP" ]]; then
      if [[ $VALIDATE_MESSAGE_GROUP_1_TO_BRANCH_GROUP -lt 0 ]]; then
        echo -e "\033[1;91mVariable $VALIDATE_MESSAGE_GROUP_1_TO_BRANCH_GROUP should greater than or equal to 0"
        exit 1
      fi
      msg_group="${msg_matches[1]}"
      branch_group="${branch_matches[$VALIDATE_MESSAGE_GROUP_1_TO_BRANCH_GROUP]}"
      if [[ "$msg_group" != "$branch_group" ]]; then
        echo -e "\033[1;91mThe group 1 of commit message '$msg_group' does not match the group $VALIDATE_MESSAGE_GROUP_1_TO_BRANCH_GROUP of branch '$branch_group'! Continue? (y/N)\033[0m"
        read confirm
        if [[ "$confirm" != "y" ]]; then
          exit 1
        fi
      fi
    fi
  fi
fi
