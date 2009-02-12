#!/bin/tcsh -f

if ($#argv < 2) then
    echo "Stellar Locus Regression 2.0"
    echo "High et al. 2009, AJ submitted"
    echo "fwhigh@gmail.com"
    echo "stellar-locus-regression.googlecode.com"
    echo
    echo "Usage: slr.csh <colortable_in> <colortable_out> [<configfile>]"
    echo "  <colortable_in> is a colortable formatted for SLR"
    echo "  <colortable_out> is <colortable_in> with SLR calibrations appended"
    echo "  <configfile> is an optional configuration file"
    exit 0
endif

setenv SLR_COLORTABLE_IN $1
setenv SLR_COLORTABLE_OUT $2
setenv SLR_CONFIG_FILE $3

idl -e slr_pipe

unsetenv SLR_COLORTABLE_IN
unsetenv SLR_COLORTABLE_OUT
unsetenv SLR_CONFIG_FILE

exit 0
