pro slr_pipe, infile=infile,$
              outfile=outfile,$
              configfile=configfile

;$Rev:: 76            $:  Revision of last commit
;$Author:: fwhigh     $:  Author of last commit
;$Date:: 2009-02-04 1#$:  Date of last commit
;
; Copyright 2009 by F. William High.
;
; This file is part of Stellar Locus Regression (SLR).
;
; SLR is free software: you can redistribute it and/or modify it under
; the terms of the GNU General Public License as published by the Free
; Software Foundation, either version 3 of the License, or (at your
; option) any later version.
;
; SLR is distributed in the hope that it will be useful, but WITHOUT
; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
; License for more details.
;
; You should have received a copy of the GNU General Public License
; along with SLR.  If not, see <http://www.gnu.org/licenses/>.
;
;+
; NAME:
;  slr_pipe
;
; PURPOSE:
;  The basic SLR pipeline to calibrate griz colors.
;
; EXPLANATION:
;  Most useful when invoked from the shell script slr.csh.
;
; CALLING SEQUENCE:
;  slr_pipe
;
; INPUTS:
;  Requires the environment variable SLR_COLORABLE_IN to be set to the
;  input colortable.
;  Requires the environment variable SLR_COLORABLE_OUT to be set to
;  the output colortable.
;
; OPTIONAL INPUTS:
;  You can set SLR_CONFIG_FILE to a custom SLR configuration file.
;
; OUTPUTS:
;  Writes SLR calibrations to the file $SLR_COLORABLE_OUT.
;  Logs SLR calibrations to a log file.
;
; OPIONAL OUTPUTS:
;       
; NOTES:
;
; EXAMPLES:
;  At the commandline:
;   % cd $SLR_INSTALL/example_data
;   % slr.csh lowext_stars3_fwhigh.ctab lowext_stars3_fwhigh.slr.ctab
;  First argument is the input colortable, second is the output.  The
;  calibration results are logged to lowext_stars3_fwhigh.slr.
;
; PROCEDURES USED:
;  slr_options
;  slr_get_data
;  slr_locus_line_calibration
;  slr_write_data
;       
; HISTORY:
;       Written by:     FW High Jan 2009
;-

COMPILE_OPT idl2, HIDDEN
;on_error, 2

start_time=systime(1)

;;; Get global default options, then set some of your own.
if not keyword_set(configfile) then begin
   configfile=getenv('SLR_CONFIG_FILE')
endif
option=slr_options(file=configfile)

if not keyword_set(infile) then begin
   infile=getenv('SLR_COLORTABLE_IN')
endif
if infile eq '' then begin
   message,"You must specify an input colortable with the "+$
           "environment variable SLR_COLORTABLE_IN"
endif

message,'Regressing data',/info

;;; Initialize data with low Galactic dust extinction
slr_get_data,$
   file=infile,$
   force=option.force,$
   option=option,$
   data=data
   
;;; Regress the data to the Covey median locus
slr_locus_line_calibration,$
   data=data,$
   option=option,$
   colorterms=option.colorterms,$
   kappa=kappa,$
   kap_err=kappa_err,$
   galext_mean=galext_mean,$
   galext_stddev=galext_stddev,$
   bootstrap=(option.nbootstrap ne 0)


print,'Best fit kappa'
for ii=0,n_elements(option.colors2calibrate)-1 do begin
   print,' kappa ',option.colors2calibrate[ii],' = ',$
         string(kappa[ii],format='(F8.3)'),$
         ' +/-',string(kappa_err[ii],format='(F7.3)')
endfor
print,'Compare to predicted Galactic extinction values'
for ii=0,n_elements(option.colors2calibrate)-1 do begin
   print,' E ',option.colors2calibrate[ii],' = ',$
         string(galext_mean[ii],format='(F8.3)'),$
         ' +/-',string(galext_stddev[ii],format='(F7.3)')
endfor
      
if not keyword_set(outfile) then begin
   outfile=getenv('SLR_COLORTABLE_OUT')
endif
if outfile eq '' then begin
   outfile=slr_get_ctab_filename(infile,/out)
endif

slr_write_data,$
   option=option,$
   kappa=kappa,$
   kap_err=kappa_err,$
   data=data,$
   file=outfile
   

message,"SLR successfully completed in "+$
        strtrim(string(SYSTIME(1)-start_time,format='(F10.3)'),2)+$
        ' seconds',/info

end
