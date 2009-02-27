function slr_struct_tag_to_band_string, $
   string, $
   isknown=isknown, $
   iserror=iserror

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
;  slr_struct_tag_to_band_string
;
; PURPOSE:
;  Convert a structure tag to a known passband string if the tag is recognized as as corresponding to a filter.
;
; EXPLANATION:
;
; CALLING SEQUENCE:
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
;       Written by:     FW High 2009
;
;-

; compile_opt idl2, hidden
; on_error, 2

  if n_elements(string) ne 1 then $
     message,"Supply only one scalar string"

  acceptable_bands=slr_acceptable_bands($
                   john_bands=john_bands,$
                   sdss_bands=sdss_bands,$
                   tmass_bands=tmass_bands)

  isknown=1
  iserror=0
  if total(john_bands+'john' eq string) eq 1 then begin
     tag=john_bands[where(john_bands+'john' eq string)]
  endif else if total(sdss_bands+'sdss' eq string) eq 1 then begin
     tag=sdss_bands[where(sdss_bands+'sdss' eq string)]
  endif else if total(tmass_bands+'tmass' eq string) eq 1 then begin
     tag=tmass_bands[where(tmass_bands+'tmass' eq string)]
  endif else if total(john_bands+'john_err' eq string) then begin
     tag=john_bands[where(john_bands+'john_err' eq string)]+'_err'
     iserror=1
  endif else if total(sdss_bands+'sdss_err' eq string) then begin
     tag=sdss_bands[where(sdss_bands+'sdss_err' eq string)]+'_err'
     iserror=1
  endif else if total(tmass_bands+'tmass_err' eq string) then begin
     tag=tmass_bands[where(tmass_bands+'tmass_err' eq string)]+'_err'
     iserror=1
  endif else begin
     tag=string
     isknown=0
  endelse

return,tag

end
