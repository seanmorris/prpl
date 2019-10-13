#!/usr/bin/env bash

if [[ ! $(which perl) ]]; then
	echo "Executable 'perl' not find. Please install perl first."
	exit 1;
fi;

cat ./pr.pl \
	| sh -c "cat > /usr/local/bin/prpl && chmod +x /usr/local/bin/prpl"
