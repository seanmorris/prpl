#!/usr/bin/env bash
cat ./pr.pl \
	| sh -c "cat > /usr/local/bin/prpl && chmod +x /usr/local/bin/prpl"
