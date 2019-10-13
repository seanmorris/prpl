#!/usr/bin/env bash
curl https://raw.githubusercontent.com/seanmorris/prpl/master/pr.pl \
	| sh -c "cat > /usr/local/bin/prpl && chmod +x /usr/local/bin/prpl"
