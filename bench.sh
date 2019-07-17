#!/usr/bin/env bash

# Copyright 2019 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the “License”);
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# <https://apache.org/licenses/LICENSE-2.0>.
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an “AS IS” BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied. See the License for the specific language governing
# permissions and limitations under the License.

# As I normally don't have JSVU set up
export PATH="${HOME}/.jsvu:${PATH}"

ITERATIONS=2000

binaries="
  v8-7.5.288
";
export TIMEFORMAT=%3R;
for bin in $binaries; do
  printf "Benchmarking empty on ${bin}… ";
  time (for i in `seq 1 ${ITERATIONS}`; do $bin out/empty.js; done);
  printf "Benchmarking JS literal on ${bin}… ";
  time (for i in `seq 1 ${ITERATIONS}`; do $bin out/js.js; done);
  printf "Benchmarking JSON.parse on ${bin}… ";
  time (for i in `seq 1 ${ITERATIONS}`; do $bin out/json.js; done);
done;
