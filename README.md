# pr.pl v0.0.1

`prpl` is a simple PCRE stream processing for the CLI. It is intended as a **barebone, primitive** substitute for `grep`, `sed` and `awk`.

## Usage

```prpl [-v] PATTERN [file, file...]```

`prpl` takes a PCRE match or substitution pattern as the first param, and optionally a list of files. If no files are passed, `prpl` will process `STDIN`. If no modifiers are needed, the closing delimiter may be omitted.

`prpl` process input line-by-line and will always print results to `STDOUT`.

`prpl` is case sensitive, by default.

#### Matching

`prpl` will run a match operation if the regular expression supplied is prefixed with an `m`, like so: `m/prpl/`. The leading `m` may be omitted.

Running a match operation will return only matching lines. Matches can be inverted with the `-v` option.

This will print all lines in the file `README.md` that contain the test "prpl":

```bash
$ prpl '/prpl/' README.md
```

This will print out all files in the current dir with a `.PL` extension:

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

## License 

`prpl` &copy; Sean Morris 2019

All code in this package is relased under the [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0) licence.
