pro slr_demo

;$Rev::               $:  Revision of last commit
;$Author::            $:  Author of last commit
;$Date::              $:  Date of last commit
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
;  slr_demo
;
; PURPOSE:
;  Demonstrate the SLR package out of the box.
;
; EXPLANATION:
;  Uses data in example_data.  Requires a proper installation to run
;  successfully. 
;
; CALLING SEQUENCE:
;  slr_demo
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

 compile_opt idl2, hidden

 start_time=systime(1)

;;; Get global default options, then set some yourself.
option=slr_options()
option.plot=1
option.postscript=0
option.interactive=1
option.use_ir=0
option.verbose=1
option.weighted_residual=0
option.animate_regression=1



message,'Regressing low extinction data',/info

;;; Initialize data with low Galactic dust extinction
slr_get_data,$
   file='lowext_stars3_fwhigh.ctab',$
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
      

slr_write_data,$
   option=option,$
   kappa=low_kappa,$
   kap_err=low_kappa_err,$
   data=low_dust_data
   





message,'Regressing high extinction data',/info

;;; Initialize data with high Galactic dust extinction
slr_get_data,$
   file='hiext_stars3_fwhigh.ctab',$
   force=option.force,$
   option=option,$
   data=high_dust_data

;;; Regress the data to the Covey median locus
slr_locus_line_calibration,$
   data=high_dust_data,$
   option=option,$
   kappa=high_kappa,$
   kap_err=high_kappa_err,$
   galext_mean=high_galext_mean,$
   galext_stddev=high_galext_stddev,$
   bootstrap=(option.nbootstrap ne 0)

print,'Best fit kappa'
print,' kappa(g-r) = ',string(high_kappa[0],format='(F8.3)'),$
   ' +/-',string(high_kappa_err[0],format='(F7.3)')
print,' kappa(r-i) = ',string(high_kappa[1],format='(F8.3)'),$
   ' +/-',string(high_kappa_err[1],format='(F7.3)')
print,' kappa(i-z) = ',string(high_kappa[2],format='(F8.3)'),$
   ' +/-',string(high_kappa_err[2],format='(F7.3)')
print,'Compare to predicted Galactic extinction values'
print,' E(g-r) = ',string(high_galext_mean[0],format='(F8.3)'),$
      ' +/-',string(high_galext_stddev[0],format='(F7.3)')
print,' E(r-i) = ',string(high_galext_mean[1],format='(F8.3)'),$
      ' +/-',string(high_galext_stddev[1],format='(F7.3)')
print,' E(i-z) = ',string(high_galext_mean[2],format='(F8.3)'),$
      ' +/-',string(high_galext_stddev[2],format='(F7.3)')

slr_write_data,$
   option=option,$
   kappa=high_kappa,$
   kap_err=high_kappa_err,$
   data=high_dust_data


message,"SLR successfully completed in "+$
        strtrim(string(SYSTIME(1)-start_time,format='(F10.3)'),2)+$
        ' seconds',/info

end
