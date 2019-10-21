![avatar](https://avatars3.githubusercontent.com/u/640101?s=80&v=4)
# pr.pl v0.0.3

`prpl` exposes simple PCRE stream processing to the CLI. It is intended as a **barebone, primitive** substitute for `grep`, `sed` and `awk`.

![seanmorris-prpl](https://img.shields.io/badge/seanmorris-prpl-purple?style=for-the-badge) [![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fseanmorris%2Fprpl%2Fbadge%3Fref%3Dmaster&style=for-the-badge)](https://actions-badge.atrox.dev/seanmorris/prpl/goto?ref=master) ![Size badge](https://img.shields.io/github/languages/code-size/seanmorris/prpl?style=for-the-badge)

![](https://seanmorr.is/Static/Dynamic/5da3a9a569a9a.1571006885.4328.jpeg)

## Usage

```prpl [-v] PATTERN [file, file...]```

`prpl` takes a PCRE match or substitution pattern as the first param, and optionally a list of files. If no files are passed, `prpl` will process `STDIN`. If no modifiers are needed, the closing delimiter may be omitted.

`prpl` process input line-by-line and will always print results to `STDOUT`.

`prpl` is case sensitive, by default.

#### Matching

`prpl` will run a match operation if the regular expression supplied is prefixed with an `m`, like so: `m/prpl/`. The leading `m` may be omitted, as `prpl` performs matching by default.

Running a match operation will return only matching lines. Matches can be inverted with the `-v` option.

This will print all lines in the file `README.md` that contain the test "prpl":

```bash
$ prpl '/prpl/' README.md
```

This will print out all files in the current directory with a `.PL` extension:

```bash
$ ls | prpl '/\.PL$/'
```

Using the `/i` modifier, this will run the same operation without case sensitivity:

```bash
$ ls | prpl '/\.PL$/i'
```

#### Inverting matches

This will print all files without the `.PL` extension, without case sensitivity:

```bash
$ ls | prpl -v '/\.PL$/i'
```

#### Replacing

`prpl` will run a replacement operation if the regular expression supplied is prefixed with an `s`, like so: `s/prpl/PRPL/`.

Modifiers, and closing delimiters are optional. The replacement is optional if the replacement is a **single** delete but not for **global** deletes: (`s/prpl` vs `s/prpl//g`);

Replacement operations will print all supplied lines, with substitutions applied.

This will print all lines in the file `README.md` replacing "prpl" with "PRPL" **once per line**:

```bash
$ prpl '/prpl/PRPL/' README.md
```
Using the `/g` modifier, this will print all lines in the file `README.md` replacing "prpl" with "PRPL" **for all appearances**:

```bash
$ prpl '/prpl/g' README.md
```

Inversion is not compatible with replacement operations. Attempting to do so will simply cause the input to pass through unmodified, with warnings generated to `STDERR`.

#### Running Perl Code

Replacements can use the `/e` modifier. This allows us to evaluate the replacement as per code before returning it.

The command below will take each file in a directory, and replace it with a file with a capitalize extension.

This command will run the perl `uc` function on the second matched group, and return the uppercase version of it. It also uses the `/x` modifier, which causes the regex enegine to ignore whitespace and make our expressions a little more readable:

```bash
$ ls -p | prpl -v 'm:\W$' | prpl 's/ (.+?) \. (.+) / "mv $1.$2 $1." . uc($2) /xe' | bash
```

#### Transliteration

Transliteration may be applied with the `y` prefix.

This will capitalize all lowercase characters passed in:

```bash
$ prpl 'y/a-z/A-Z/' README.md
```

Here's a simple ROT13 implementation:

```bash
$ prpl 'y/A-Za-z/N-ZA-Mn-za-m/' README.md
```

This will run the operation twice, returning the original text:

```bash
$ prpl 'y/A-Za-z/N-ZA-Mn-za-m/' README.md | prpl 'y/A-Za-z/N-ZA-Mn-za-m/'
```

Inversion is not supported for transliteration and will have the same result as an attempt to invert a substitution.

#### Alternate Delimiters

You can substitute characters like : or % to improve readability.

These are all the same command:

```bash
$ prpl /match/ README.md
$ prpl :match: README.md
$ prpl %match% README.md
```

#### Dropping the quotes

You don't explicitly NEED single quotes around your expression, unless you're using spaces or escapes. Single quotes will ensure your backslashes are preserved to the regex engine.

```bash
$ prpl /\w/ README.md    # prpl receives /w/
$ prpl '/\w/' README.md  # prpl correctly receives /\w/
```
```bash
$ prpl /\d{4}/   README.md  # prpl receives /d{4}/
$ prpl '/\d{4}/' README.md  # prpl correctly receives /\d{4}/
```

```bash
$ ls |  /\.md/  # prpl receives /.md/
$ ls | '/\.md/' # prpl correctly receives /\.md/
```

#### Shorthand

`prpl` will run a match if the regex supplied begins with a delimiter or an `m`.

You don't need to specify a closing delimiter for any operaion, unless you need modifiers.

Matches can be made very terse with these rules.

```bash
$ prpl ':e' README #Find all lines with lowercase e's.
```

## Installation

### Web Install

Simply run the following command to install `prpl`:

```bash
$ curl https://raw.githubusercontent.com/seanmorris/prpl/master/web-install.sh | sudo bash
```

Or check the project out and install it locally:

### Local Install

```bash
$ git clone https://github.com/seanmorris/prpl.git
$ cd prpl
$ sudo bash install.sh
```

### Testing 

[![Build Status](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fseanmorris%2Fprpl%2Fbadge%3Fref%3Dmaster&style=flat-square)](https://actions-badge.atrox.dev/seanmorris/prpl/goto?ref=master)

Tests are automatically executed by github on push. Their status is reported by the badge directly above, as well as in the header of this README.

Tests & syntax checks are also automatically executed in a git pre-commit hook. The commit is rejected if any of these fail.

You can view the latest test output [here](https://actions-badge.atrox.dev/seanmorris/prpl/goto?ref=master).

Example output:

```txt
$./test.sh
 Prpl © Copyright 2019 Sean Morris

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 Visit https://github.com/seanmorris/prpl for help, or to contribute.

Starting tests...
3367 test passed. 0 tests failed.
```

`prpl` can compare its behavior with `grep` and `sed`. Just navigate to the test directory of the project and run `bash test.sh`.

You can add grep tests to `grepTests.txt`. They'll be tested for regex matech against a list of 77,022 American words. Please do not include delimiters here, as `grep` doesn't use them. They'll be added for `prpl.` `sed` tests should be supplied in similar form in `setTests.txt`, **with** their delimiters and leading `s`'s.

## License 

`prpl` &copy; Sean Morris 2019

All code in this package is relased under the [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) licence.
