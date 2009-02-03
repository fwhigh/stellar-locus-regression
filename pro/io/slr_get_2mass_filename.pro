function slr_get_2mass_filename, field, out=out

;+
; NAME:
;  slr_get_2mass_filename
;
; PURPOSE:
;  Get the 2MASS catalog filename for a corresponding field.
;
; EXPLANATION:
;       
;
; CALLING SEQUENCE:
;       
;
; INPUTS:
; 
;      
;
; OPTIONAL INPUTS:
;
;
;
; OUTPUTS:
;       
;
; OPIONAL OUTPUTS:
;       
;       
; NOTES:
;
;
; EXAMPLES:
;
; PROCEDURES USED:
;       
; HISTORY:
;       Written by:     FW High 2008
;
;-

if keyword_set(out) then out='_2mass_out' else out=''

file=slr_datadir()+path_sep()+field+out+'.tbl'
return,file

end
