function slr_struct_tag_to_color_string, $
   string, $
   join=join, $
   bands=bands, $
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

  delvarx,bands

  if not keyword_set(join) then join=''

  acceptable_bands=slr_acceptable_bands($
                   john_bands=john_bands,$
                   sdss_bands=sdss_bands,$
                   tmass_bands=tmass_bands)

  for ii=0,n_elements(string)-1 do begin 
     delvarx,isknown1,isknown2
     strarr=strsplit(string[ii],'_',/extract)
     if n_elements(strarr) ne 2 and n_elements(strarr) ne 3 then begin
        tmptag=string[ii]
     endif else begin
        band1=slr_struct_tag_to_band_string($
              strarr[0],$
              isknown=isknown1)
        band2=slr_struct_tag_to_band_string($
              strarr[1],$
              isknown=isknown2)
        if n_elements(strarr) eq 3 then begin
           suffix='_err'
        endif else suffix=''
        if total(isknown1) ne 1 or total(isknown2) ne 1 then begin
           tmptag=string[ii]
        endif else begin
           tmptag=strjoin([band1,band2],join)+suffix
           bands=push_arr(bands,[band1,band2])
        endelse
     endelse
     tag=push_arr(tag,tmptag)
                          
  endfor

  if n_elements(bands) ne 0 then $
     bands=bands[uniq(bands,sort(bands))]

return,tag

end
