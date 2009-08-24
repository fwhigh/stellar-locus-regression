function slr_colortable_file_to_fieldname,$
   colortable_file,$
   path=path

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
;  slr_colortable_file_to_fieldname
;
; PURPOSE:
;  Extract the fieldname from a colortable filename: strip ".ctab" extension if it exists.
;
; EXPLANATION:
;  Works best when you input a colortable file of the form
;  <fieldname>.ctab. If not, then the fieldname returned is the the
;  filename. Removes directory part of the file, too.
;
; CALLING SEQUENCE:
;  field=slr_colortable_file_to_filename(file)
;
; INPUTS:
;  file (string)  A colortable filename.
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;  field (string)  A fieldname extracted from the colortable
;                  filename. 
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
;-

  compile_opt idl2, hidden
  on_error, 2

  ext=strip_ext(colortable_file,/get_ext)

  if ext eq 'ctab' then begin
     field=deslash(strip_ext(colortable_file),path=path)
  endif else begin
     field=deslash(colortable_file,path=path)
  endelse

  return,field
end
