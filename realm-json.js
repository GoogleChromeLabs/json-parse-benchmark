// Copyright 2019 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the “License”);
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// <https://apache.org/licenses/LICENSE-2.0>.
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an “AS IS” BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
// implied. See the License for the specific language governing
// permissions and limitations under the License.

const sourceCode = read('./out/json.js');

// Pre-create the realms.
const realms = [];
for (let i = 0; i < 100; i++) {
  realms.push(Realm.create());
}

console.time('In-memory cache');
let result = undefined;
// Evaluate the source code in each realm.
// This hits the in-memory cache.
// Avoid for-of since it's a microbenchmark.
for (let i = 0; i < realms.length; i++) {
  // Assign to an outer binding to ensure there's a side effect and
  // avoid DCE.
  const realm = realms[i];
  result = Realm.eval(realm, sourceCode);
}
console.timeEnd('In-memory cache');
