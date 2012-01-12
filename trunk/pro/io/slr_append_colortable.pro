pro slr_append_colortable, ctab_out_file,$
                           ctab, $
                           frmt_struct, $
                           infile=ctab_in_file, $
                           append=append

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
;  on_error,2

  fieldlength='8'

  if keyword_set(append) then begin
     if ctab_in_file eq ctab_out_file then begin
        ctab_out_file+='.tmp'
     endif
  endif

  tmptags=tag_names(ctab)
  delvarx,tags
  for i=0L,n_elements(tmptags)-1 do begin
     if tmptags[i] ne 'CATALOG_TYPE' and $
        tmptags[i] ne 'HEADER' then begin
        tags=push_arr(tags,tmptags[i])
        if size(n_total,/tname) eq 'UNDEFINED' then $
           n_total=n_elements(ctab.(i))
     endif
  endfor

  if n_elements(tags) eq 0 then $
     message,'No good tags to append'

  IN=5
  OUT=6
  if keyword_set(append) then openr,IN,ctab_in_file
  openw,OUT,ctab_out_file
  header=''
  if keyword_set(append) then begin 
     readf,IN,header
     comment=''
  endif else comment='"#",'
  format='('+comment+strjoin(frmt_struct.headerformat,',')+')'
  header+=string($
          slr_struct_tag_to_band_string($
          slr_struct_tag_to_color_string($
          frmt_struct.header)),$
          format=format)
  printf,OUT,header

  for ii=0L,n_total-1 do begin
     delvarx,vals,format,line
     line=''
     if keyword_set(append) then readf,IN,line
     for jj=0,n_elements(frmt_struct.header)-1 do begin
        here=where(strlowcase(tmptags) eq strlowcase(frmt_struct.header[jj]))
        val=string(ctab.(here)[ii],format='('+frmt_struct.format[jj]+')')
;        if val eq '-' then val=string('-',format='(A9)')
        if val eq '-' then val=string('99.000',format='(A9)')
        if size(ctab.(here)[ii],/tname) ne 'STRING' then begin
;           if ~finite(ctab.(here)[ii]) then val=string('-',format='(A9)')
           if ~finite(ctab.(here)[ii]) then val=string('99.000',format='(A9)')
        endif
        line+=val
     endfor
;     line='' &  readf,IN,line
;     line+=strjoin(vals)
     printf,OUT,line
  endfor
  
  if keyword_set(append) then close,IN
  close,OUT

  if keyword_set(append) then begin
     if ctab_in_file+'.tmp' eq ctab_out_file then begin
        file_move,ctab_out_file,strip_ext(ctab_out_file),/overwrite
     endif
  endif

end
