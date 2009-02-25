pro slr_append_colortable, ctab_in_file, $
                           ctab_out_file,$
                           ctab_add

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
;  slr_append_colortable
;
; PURPOSE:
;  Append SLR calibrations to an existing colortable file.
;
; EXPLANATION:
;  SLR calibrations are appended to the input colortable, leaving the
;  input-portion of the colortable untouched.  Writes the columns
;  "GR", "GR_ERR", "RI", "RI_ERR", "IZ", "IZ_ERR".
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

;  compile_opt idl2, hidden
  on_error,2

  fieldlength='8'

  tmptags=tag_names(ctab_add)
  delvarx,tags
  for i=0L,n_elements(tmptags)-1 do begin
     if tmptags[i] ne 'CATALOG_TYPE' and $
        tmptags[i] ne 'HEADER' then begin
        tags=push_arr(tags,tmptags[i])
        if size(n_total,/tname) eq 'UNDEFINED' then $
           n_total=n_elements(ctab_add.(i))
     endif
  endfor

  if n_elements(tags) eq 0 then $
     message,'No good tags to append'

  openr,IN,ctab_in_file,/get_lun
  openw,OUT,ctab_out_file,/get_lun
  header='' & readf,IN,header
  for ii=0,n_elements(tags)-1 do $
     header+=strlowcase(string(tags[ii],format='(A'+fieldlength+')'))
  printf,OUT,header

  for j=0L,n_total-1 do begin
;     if total(subscript eq j) ne 1 then continue
     delvarx,vals,format,line
     for i=0L,n_elements(tmptags)-1 do begin
        if tmptags[i] ne 'CATALOG_TYPE' and $
           tmptags[i] ne 'HEADER' then begin
           case size(ctab_add.(i)[j],/tname) of
              'FLOAT':format='(F'+fieldlength+'.3)'
              'LONG':format='(I'+fieldlength+')'
              'INT':format='(I'+fieldlength+')'
              'STRING':format='(A'+fieldlength+')'
              else:format='(A'+fieldlength+')'
           endcase
           vals=push_arr(vals,string(ctab_add.(i)[j],format=format))
        endif
     endfor
     line='' &  readf,IN,line
     line+=strjoin(vals)
     printf,OUT,line
  endfor
  
  close,IN
  close,OUT

end
