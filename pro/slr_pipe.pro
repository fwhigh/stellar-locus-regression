pro slr_pipe

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
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;
; OPIONAL OUTPUTS:
;       
; NOTES:
;
; EXAMPLES:
;
; PROCEDURES USED:
;       
; HISTORY:
;       Written by:     FW High Jan 2009
;
;-

COMPILE_OPT idl2, HIDDEN
on_error, 2

start_time=systime(1)

;;; Get global default options, then set some of your own.
option=slr_options(file=getenv('SLR_CONFIG_FILE'))

infile=getenv('SLR_COLORTABLE_IN')
if infile eq '' then begin
   message,"You must specify a colortable with the "+$
           "environment variable SLR_COLORTABLE_IN"
endif

message,'Regressing data',/info

;;; Initialize data with low Galactic dust extinction
slr_get_data,$
   file=infile,$
   force=option.force,$
   option=option,$
   data=low_dust_data

   
;;; Regress the data to the Covey median locus
slr_locus_line_calibration,$
   data=low_dust_data,$
   option=option,$
   kappa=low_kappa,$
   kap_err=low_kappa_err,$
   galext_mean=low_galext_mean,$
   galext_stddev=low_galext_stddev,$
   bootstrap=(option.nbootstrap ne 0)


print,'Best fit kappa'
print,' kappa(g-r) = ',string(low_kappa[0],format='(F8.3)'),$
   ' +/-',string(low_kappa_err[0],format='(F7.3)')
print,' kappa(r-i) = ',string(low_kappa[1],format='(F8.3)'),$
   ' +/-',string(low_kappa_err[1],format='(F7.3)')
print,' kappa(i-z) = ',string(low_kappa[2],format='(F8.3)'),$
   ' +/-',string(low_kappa_err[2],format='(F7.3)')
print,'Compare to predicted Galactic extinction values'
print,' E(g-r) = ',string(low_galext_mean[0],format='(F8.3)'),$
      ' +/-',string(low_galext_stddev[0],format='(F7.3)')
print,' E(r-i) = ',string(low_galext_mean[1],format='(F8.3)'),$
      ' +/-',string(low_galext_stddev[1],format='(F7.3)')
print,' E(i-z) = ',string(low_galext_mean[2],format='(F8.3)'),$
      ' +/-',string(low_galext_stddev[2],format='(F7.3)')
      
outfile=getenv('SLR_COLORTABLE_OUT')

slr_write_data,$
   option=option,$
   kappa=low_kappa,$
   kap_err=low_kappa_err,$
   data=low_dust_data,$
   file=outfile
   

message,"SLR successfully completed in "+$
        strtrim(string(SYSTIME(1)-start_time,format='(F10.3)'),2)+$
        ' seconds',/info

end
