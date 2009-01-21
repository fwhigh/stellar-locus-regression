pro slr_demo

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


;;; Get global default options, then set some of your own.
option=slr_options()
option.plot=1
option.postscript=0
option.interactive=1
option.use_ir=0
option.verbose=1

;;; Get global default hard limits on the data
limits=slr_limits()

;;; Initialize data with low Galactic dust extinction
slr_get_data,$
   fieldname='lowext_stars3_fwhigh',$
   option=option,$
   limits=limits,$
   data=low_dust_data

   
;;; Regress the data to the Covey median locus
slr_locus_line_calibration,$
   data=low_dust_data,$
   option=option,$
   kappa=low_kappa,$
   kap_err=low_kappa_err,$
   galext_mean=low_galext_mean,$
   galext_stddev=low_galext_stddev


;;; Initialize data with high Galactic dust extinction
slr_get_data,$
   fieldname='hiext_stars3_fwhigh',$
   option=option,$
   limits=limits,$
   data=high_dust_data

;;; Regress the data to the Covey median locus
slr_locus_line_calibration,$
   data=high_dust_data,$
   option=option,$
   kappa=high_kappa,$
   kap_err=high_kappa_err,$
   galext_mean=high_galext_mean,$
   galext_stddev=high_galext_stddev



end
