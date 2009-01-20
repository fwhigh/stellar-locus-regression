function slr_read_covey_locus, force=force

;+
; NAME:
;  slr_read_covey_locus
;
; PURPOSE:
;  Return the stellar data of Covey et al. (2008), available at
;  Kevin Covey's website.
;
; EXPLANATION:
;  Reads Covey's file superclean.fits and puts it into a structure.
;  When run for the first time, this routine also saves the catalog in
;  an IDL save file.  All subsequent calls (or if /force is set) will
;  read the .sav file and not the .fits file, but will return the same
;  data.  This is considerably faster.  The file superclean.fits is
;  assumed to be in $SLR_DATA/covey.
;
; CALLING SEQUENCE:
;  catalog=slr_read_covey_locus()
;
; INPUTS:
;
; OPTIONAL INPUTS:
;  force (bit)   Force a read of the .fits file rather than the .sav
;                file?  Default 0.
;
; OUTPUTS:
;  catalog (structure)   Catalog of the stellar data
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

file=slr_datadir()+path_sep()+'covey'+path_sep()+'superclean.fits'
savefile=file+'.sav'
if file_test(savefile) then begin
   restore,savefile
endif else begin
   cat=mrdfits(file,1)
   save,file=savefile
endelse

return,cat

end
