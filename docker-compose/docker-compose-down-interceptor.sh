#!/bin/bash
#
# Docker compose down interceptor
#
# This script is used for making docker compose able to down one container,
# and won't affect other command.
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

# check if the docker-compose command exist since some environment use 'docker compose'
use_docker=true
if command -v docker-compose > /dev/null; then
  use_docker=false
fi

args=()
keyword_args=()

# check index of 'down' keyword
keyword_index=-1

for (( i=1; i<=$#; i++ )); do
  # arg="${args[$i]}"
  arg="${!i}"
  if [[ "$arg" == "down" ]]; then
    keyword_index=$i
    break
  fi
done

# if it's not 'down' command, just run it
if [[ $keyword_index -le 0 ]]; then
  if [[ "$use_docker" == "true" ]]; then
    command docker compose $@
  else
    command docker-compose $@
  fi
else
  for (( i=1; i<keyword_index; i++ )); do
    args+=("${!i}")
  done

  for (( i=keyword_index+1; i<=$#; i++ )); do
    arg="${!i}"
    # check if it starts with '-'
    if [[ "${arg:0:1}" != "-" ]]; then
      container="$arg"
    else
      keyword_args+=("$arg")
    fi
  done

  if [[ -z "$container" ]]; then
    if [[ "$use_docker" == "true" ]]; then
      command docker compose $@
    else
      command docker-compose $@
    fi
  else
    if [[ "$use_docker" == "true" ]]; then
      command docker compose "${args[@]}" stop "$container" "${keyword_args[@]}"
      command docker compose "${args[@]}" rm "$container" "${keyword_args[@]}"
    else
      command docker-compose "${args[@]}" stop "$container" "${keyword_args[@]}"
      command docker-compose "${args[@]}" rm "$container" "${keyword_args[@]}"
    fi
  fi
fi
