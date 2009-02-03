function slr_atmext_coeff

;+
; NAME:
;  slr_atmext_coeff
;
; PURPOSE:
;  Get the CTIO atmospheric extinction coefficients.
;
; EXPLANATION:
;  From the Smith et al. series of papers on Southern ugriz
;  standards. 
;
; CALLING SEQUENCE:
;  k=slr_atmext_coeff()
;
; INPUTS:
;      
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
;       Written by:     FW High 2008
;
;-

; Smith et al 2006
;return,[0.181,0.095,0.089,0.053]

; Smith et al 2003
return,[0.172,0.093,0.052,0.044]

end
