#!/bin/bash

# Thanks https://github.com/modernish/modernish/blob/e1af50de312ff334cbfae712c1c5b4eeff810a82/bin/modernish#L291C1-L291C29
shopt -s expand_aliases
alias success='{ let "$?==0"; }'
