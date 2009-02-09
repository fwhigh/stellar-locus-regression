#!/bin/tcsh -f

if ($#argv < 1) then
    echo "Usage: $0 <fieldname>"
    echo "Performs SLR on <fieldname>.ctab using configuration from <configfile>"
    exit 0
endif

setenv SLR_FIELDNAME $1
setenv SLR_CONFIG_FILE $2

echo slr.csh $SLR_FIELDNAME $SLR_CONFIG_FILE

idl -e slr_pipe

unsetenv SLR_FIELDNAME
unsetenv SLR_CONFIG_FILE
