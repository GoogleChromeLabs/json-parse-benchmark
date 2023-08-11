# `JSON.parse` benchmark

See [the cost of parsing JSON](https://v8.dev/blog/cost-of-javascript-2019#json).

## Instructions

Clone this repository, and then run these commands:

```bash
npm install
export PATH="${HOME}/.jsvu/bin:${PATH}"
npm run bench
```

## Analysis

[`JetStream2/SeaMonster/inspector-json-payload.js`](https://raw.githubusercontent.com/WebKit/webkit/ffdd2799d3237993354978b9d0cdd1d248fe3787/PerformanceTests/JetStream2/SeaMonster/inspector-json-payload.js) contains a 7.33-MB JavaScript array literal containing 846 object literals. This entire array literal can be [serialized to JSON](https://github.com/GoogleChromeLabs/json-parse-benchmark/blob/c0dec965dfbb6e30f077974ce172296f1f90d5da/build.js#L18) and [turned into a 8.2-MB JavaScript string literal](https://github.com/GoogleChromeLabs/json-parse-benchmark/blob/c0dec965dfbb6e30f077974ce172296f1f90d5da/build.js#L19), which can be [passed to `JSON.parse()`](https://github.com/GoogleChromeLabs/json-parse-benchmark/blob/c0dec965dfbb6e30f077974ce172296f1f90d5da/build.js#L22) to produce an equivalent array.

This repository tests each approach in 100 different contexts in the dumbest possible way, i.e. by simply invoking `d8` a 100 times per script. That is, we perform 100 cold loads, and measure everything (parsing, compilation, and execution) until the program halts.

On my workstation (HP Z840 with 2 × 14-core Intel Xeon E5-2690 v4 processors @ 2.6GHz, 35MB Cache + 128GB DDR4 2400MHz RAM), I got the following results:

|                        | JS literal | `JSON.parse` | Speed-up |
| ---------------------- | ---------: | -----------: | -------: |
| V8 v7.5                |   23.765 s |     15.766 s |     1.5× |
| V8 v7.6                |   23.639 s |     14.102 s |     1.7× |
| V8 v7.7                |   23.489 s |     13.886 s |     1.7× |
| Chakra v1.11.10.0      |   24.999 s |     16.547 s |     1.5× |
| JavaScriptCore v246878 |   28.503 s |     14.315 s |     2.0× |
| SpiderMonkey v68.0b13  |   25.554 s |     21.174 s |     1.2× |

For V8 specifically, you can get detailed metrics for a single run by using `--runtime-call-stats`:

```
$ v8 --runtime-call-stats out/js.js | grep Parse
                                      ParseProgram    124.33ms  47.00%         1   0.00%

$ v8 --runtime-call-stats out/json.js | grep Parse
                                         JsonParse     47.67ms  28.29%         1   0.07%
                                      ParseProgram     43.17ms  25.62%         1   0.07%
```

## Licensing

The source files in this repository are released under the Apache 2.0 license, as detailed in the LICENSE file.

The scripts in this repository dynamically download [`JetStream2/SeaMonster/inspector-json-payload.js`](https://raw.githubusercontent.com/WebKit/WebKit/ab7171c1d63acb8c77216b5a11f98323b56b998b/PerformanceTests/JetStream2/SeaMonster/inspector-json-payload.js), which has its own license:

```
/*
 * Copyright (C) 2018 Apple Inc. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY APPLE INC. AND ITS CONTRIBUTORS ``AS IS''
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL APPLE INC. OR ITS CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 * THE POSSIBILITY OF SUCH DAMAGE.
*/
```

This license also applies to the generated `*.js` files produced by the scripts in this repository.
