function slr_sfd_coeff

;+
; NAME:
;  slr_sfd_coeff
;
; PURPOSE:
;  Return the Schlegel, Finkbeiner & Davis 1998 Galactic extinction
;  coefficients 
;
; EXPLANATION:
;  Use this routine to get the SFD extinction coefficients.  See Table
;  6 of Schlegel, Finkbeiner & Davis (1998).
;
; CALLING SEQUENCE:
;  coeff=slr_sfd_coeff()
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;  coeff (float array)  Array of SFD coefficients
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
;-

; ugrizJHK
galext=[5.115,3.793,2.751,2.086,1.479,$
        0.902,0.576,0.367]

return,galext


end
