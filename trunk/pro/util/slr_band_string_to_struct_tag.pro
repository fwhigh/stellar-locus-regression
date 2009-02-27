function slr_band_string_to_struct_tag, $
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
;  slr_band_string_to_struct_tag
;
; PURPOSE:
;  Convert a known passband string to a structure tag if the string is recognized as corresponding to a filter.
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

  delvarx,isknown
  for ii=0,n_elements(string)-1 do begin 
     if total(john_bands eq string[ii]) eq 1 then begin
        tmptag=string[ii]+'john'
        isknown=push_arr(isknown,1)
     endif else if total(sdss_bands eq string[ii]) eq 1 then begin
        tmptag=string[ii]+'sdss'
        isknown=push_arr(isknown,1)
     endif else if total(tmass_bands eq string[ii]) eq 1 then begin
        tmptag=string[ii]+'tmass'
        isknown=push_arr(isknown,1)
     endif else if total(john_bands+'_err' eq string[ii]) then begin
        tmptag=john_bands[where(john_bands+'_err' eq string[ii])]+'john_err'
        isknown=push_arr(isknown,1)
     endif else if total(sdss_bands+'_err' eq string[ii]) then begin
        tmptag=sdss_bands[where(sdss_bands+'_err' eq string[ii])]+'sdss_err'
        isknown=push_arr(isknown,1)
     endif else if total(tmass_bands+'_err' eq string[ii]) then begin
        tmptag=tmass_bands[where(tmass_bands+'_err' eq string[ii])]+'tmass_err'
        isknown=push_arr(isknown,1)
     endif else begin
        tmptag=string[ii]
        isknown=push_arr(isknown,0)
     endelse
     tag=push_arr(tag,tmptag)
endfor

return,tag

end
