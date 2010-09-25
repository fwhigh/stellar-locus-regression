function slr_get_ctab_filename, field,$
                                out=out,$
                                twomass=twomass,$
                                dir=dir

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
;  slr_get_ctab_filename
;
; PURPOSE:
;  Get the colortable filename given a field.
;
; EXPLANATION:
;       
;
; CALLING SEQUENCE:
;       
;
; INPUTS:
; 
;      
;
; OPTIONAL INPUTS:
;
;
;
; OUTPUTS:
;       
;
; OPIONAL OUTPUTS:
;       
;       
; NOTES:
;
;
; EXAMPLES:
;
; PROCEDURES USED:
;       
; HISTORY:
;       Written by:     FW High 2008
;
;-

  compile_opt idl2, hidden
  on_error,2

  if keyword_set(out) then begin
     ext=strip_ext(field,/get)
     if ext eq 'ctab' then begin
        file=strip_ext(field)+'.slr.ctab'
     endif else begin
        file=field+'.slr.ctab'
     endelse
     return,file
  endif

  if keyword_set(twomass) then begin
     ext=strip_ext(field,/get)
     if ext eq 'ctab' then begin
        file=strip_ext(field)+'.2mass.ctab'
     endif else begin
        file=field+'.2mass.ctab'
     endelse
     return,file
  endif


  if not keyword_set(dir) then begin
     file=field+'.ctab'
  endif else begin
     file=dir+path_sep()+field+'.ctab'
  endelse
  if file_test(file) then begin
     return, file
  endif else begin
     message,"Colortable "+file+" not found"
  endelse
end
