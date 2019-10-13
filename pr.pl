#!/usr/bin/env perl
use strict;
use warnings;

my $pattern;
my $replace;
my $operation;
my $delimiter;
my $expression;
my $modifiers = '';
my %flags = ('i', 0); 

while($ARGV[0] =~ /^-(.)/)
{
	shift @ARGV;
	$flags{ $1 } = 1;
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

$input =~ /([sm]?)((.).+)/;

$operation  = $1 || 'm';
$delimiter  = $3;
$expression = $2;

($_, $pattern, $replace, $modifiers) = split($delimiter, $expression);

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
			if(eval qq(m/$pattern/$modifiers))
			{
				if(!$flags{ 'i' })
				{
					print; print "\n";
				}
			}
			else
			{
				if($flags{ 'i' })
				{
					print; print "\n";					
				}
			}
		}

		if($operation eq 's')
		{
			if($flags{ 'i' })
			{
				warn "Cannot invert substitution. Printing original line.\n";
				print; print "\n";
				next;
			}

			eval qq(s/$pattern/$replace/$modifiers);

			print; print "\n";
		}
	}
}
