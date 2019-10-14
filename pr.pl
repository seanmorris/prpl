#!/usr/bin/env perl

# Prpl © Copyright 2019 Sean Morris
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Visit https://github.com/seanmorris/prpl for help, or to contribute.

use strict;
use warnings;

my $pattern;
my $replace;
my $operation;
my $delimiter;
my $expression;
my $modifiers = '';
my %flags = ('v', 0);

while($ARGV[0] && $ARGV[0] =~ /^-(.)/)
{
	shift @ARGV;
	$flags{ $1 } = 1;
}

if($flags{ 'i' })
{
	print "\n";
	open(my $script, $0);

	my $line = 0;

	for(<$script>)
	{
		if($line > 0 && /^#((?:\s.+)?)/)
		{
			print $1 . "\n";
		}
		$line++;
	}
	print "\n";

	exit 0;
}

if($flags{ 'h' })
{
	print "Usage:\n";
	print "prpl [-v] PATTERN [file, file...]\n";
	print "\n";
	print "-v Invert match (return only non-matching lines)\n";
	print "   Available for matching only, will throw warnings for\n";
	print "   replacements or transliteration.\n";
	print "\n   PATTERN is a PCRE matching pattern prefixed with...";
	print "\n";
	print "\n      m for matching        - /.+?/ (optional, matching is default)";
	print "\n      s for replacement     - s/gr[ae]y/black/";
	print "\n      m for transliteration - y/A-Za-z/N-ZA-Mn-za-m/";
	print "\n";
	print "\n";
	print "-h Print this help message.\n";
	print "\n";
	print "-i Print version & copyright information.\n";
	print "\n";

	exit 0;
}

if(!$ARGV[0])
{
	die "No pattern supplied.\n";
}

my $input = shift(@ARGV);
my @files = @ARGV;

if(!@files)
{
	@files = ('/dev/stdin');
}

$input =~ /([smy]?)((.).+)/;

$operation  = $1 || 'm';
$delimiter  = $3 || '/';
$expression = $2 || '';

($_, $pattern, $replace, $modifiers) = split(/(?<!\\) $delimiter/x, $expression);

$pattern = $pattern || '$^';

if($operation eq 'm')
{
	$modifiers = $replace;
	$replace   = 0;
}
elsif(!$replace)
{
	$replace = '';
}

$modifiers = $modifiers || '';

for(@files)
{
	open(my $file, $_);

	while(<$file>)
	{
		chomp;

		if($operation eq 'm')
		{
			if(eval qq(m#$pattern#$modifiers))
			{
				if(!$flags{ 'v' })
				{
					print; print "\n";
				}
			}
			else
			{
				if($flags{ 'v' })
				{
					print; print "\n";
				}
			}
		}

		if($operation eq 's' || $operation eq 'y')
		{
			if($flags{ 'i' })
			{
				warn "Cannot invert substitution. Printing original line.\n";
				print; print "\n";
				next;
			}

			eval qq($operation#$pattern#$replace#$modifiers);

			print; print "\n";
		}
	}
}
