function slr_datadir

;+
; NAME:
;  slr_datadir
;
; PURPOSE:
;  Return the generic, root data directory for Stellar Locus
;  Regression.
;
; EXPLANATION:
;  This routine makes data access uniform, such that you can run IDL
;  from any directory and still read/write data from/to the same
;  place.  Returns the value of $SLR_DATA, which should be set in an
;  shell startup file. 
;
; CALLING SEQUENCE:
;  dir=slr_datadir()
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;  dir (string)   The dirctory.
;
; OPIONAL OUTPUTS:
;       
; NOTES:
;
; EXAMPLES:
;  filename=slr_datadir()+path_sep()+'somefield.ctab'
;
; PROCEDURES USED:
;       
; HISTORY:
;       Written by:     FW High 2008
;
;-

return,getenv('SLR_DATA')

end
