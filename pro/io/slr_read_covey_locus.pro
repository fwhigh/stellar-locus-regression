function slr_read_covey_locus, force=force

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
;  slr_read_covey_locus
;
; PURPOSE:
;  Return the stellar data of Covey et al. (2008), available at
;  Kevin Covey's website.
;
; EXPLANATION:
;  Reads Covey's file superclean.fits and puts it into a structure.
;  When run for the first time, this routine also saves the catalog in
;  an IDL save file.  All subsequent calls (if force is not set) will
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
;                file?  The latter is faster.  Default 0.
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
if file_test(savefile) and ~keyword_set(force) then begin
   restore,savefile
endif else begin
   cat=mrdfits(file,1)
   save,file=savefile
endelse

return,cat

end
