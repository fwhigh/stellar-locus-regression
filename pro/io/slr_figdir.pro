function slr_figdir

;+
; NAME:
;  slr_figdir
;
; PURPOSE:
;  Return the generic, root figure directory for Stellar Locus Regression.
;
; EXPLANATION:
;  This routine lets you put SLR figures always in the same place.
;  This routine does not create the directory.
;
; CALLING SEQUENCE:
;  dir=slr_figdir()
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
;  filename=slr_figdir()+path_sep()+'someplot.ps'
;
; PROCEDURES USED:
;       
; HISTORY:
;       Written by:     FW High 2008
;
;-

return,slr_datadir()+path_sep()+'fig'

end
