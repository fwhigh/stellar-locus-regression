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

  acceptable_bands=slr_acceptable_bands($
                   john_bands=john_bands,$
                   sdss_bands=sdss_bands,$
                   tmass_bands=tmass_bands)

  delvarx,isknown1,isknown2
  for ii=0,n_elements(string)-1 do begin
     if total(john_bands+'john' eq string[ii]) eq 1 then begin
        tmptag=john_bands[where(john_bands+'john' eq string[ii])]
        isknown=push_arr(isknown,1)
     endif else if total(sdss_bands+'sdss' eq string[ii]) eq 1 then begin
        tmptag=sdss_bands[where(sdss_bands+'sdss' eq string[ii])]
        isknown=push_arr(isknown,1)
     endif else if total(tmass_bands+'tmass' eq string[ii]) eq 1 then begin
        tmptag=tmass_bands[where(tmass_bands+'tmass' eq string[ii])]
        isknown=push_arr(isknown,1)
     endif else if total(john_bands+'john_err' eq string[ii]) then begin
        tmptag=john_bands[where(john_bands+'john_err' eq string[ii])]+'_err'
        isknown=push_arr(isknown,1)
     endif else if total(sdss_bands+'sdss_err' eq string[ii]) then begin
        tmptag=sdss_bands[where(sdss_bands+'sdss_err' eq string[ii])]+'_err'
        isknown=push_arr(isknown,1)
     endif else if total(tmass_bands+'tmass_err' eq string[ii]) then begin
        tmptag=tmass_bands[where(tmass_bands+'tmass_err' eq string[ii])]+'_err'
        isknown=push_arr(isknown,1)
     endif else begin
        tmptag=string[ii]
        isknown=push_arr(isknown,0)
     endelse
     tag=push_arr(tag,tmptag)
  endfor

  return,tag

end
