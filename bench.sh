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

binaries="
  v8-7.5.288
  v8-7.6.303
  v8
  chakra
  javascriptcore
  spidermonkey
";
TIMEFORMAT=%lR;
for bin in $binaries; do
  printf "Benchmarking JS literal on ${bin}… ";
  time (for i in {1..100}; do $bin out/js.js; done);
  printf "Benchmarking JSON.parse on ${bin}… ";
  time (for i in {1..100}; do $bin out/json.js; done);
  if [[ $bin == v8* ]]; then
    printf "Benchmarking JS literal with cold loads on ${bin}…\n";
    time $bin realm-js.js --nocompilation-cache;
    printf "Benchmarking JSON.parse with cold loads on ${bin}…\n";
    time $bin realm-json.js --nocompilation-cache;
    printf "Benchmarking JS literal with warm loads on ${bin}…\n";
    time $bin realm-js.js;
    printf "Benchmarking JSON.parse with warm loads on ${bin}…\n";
    time $bin realm-json.js;
  fi;
done;
