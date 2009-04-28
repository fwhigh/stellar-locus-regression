function slr_get_2mass_filename, field, $
                                 out=out, $
                                 web=web

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
;  slr_get_2mass_filename
;
; PURPOSE:
;  Get the 2MASS catalog filename for a corresponding field.
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
;  2/09 FWH files must now contain path
;
;-

if keyword_set(out) then out='_2mass_out' else out=''

if keyword_set(web) then begin
   if keyword_set(out) then begin
      file=field+".WEB2MASS_J"
   endif else begin
      ext=strip_ext(field,/get)
      if ext eq 'ctab' then begin
         file=strip_ext(field)+'.2mass.ctab'
      endif else begin
         file=field+out+'.2mass.ctab'
      endelse
   endelse
   return,file
endif


ext=strip_ext(field,/get)
if ext eq 'ctab' then begin
   file=strip_ext(field)+out+'.tbl'
endif else begin
   file=field+out+'.tbl'
endelse
 
;file=slr_datadir()+path_sep()+field+out+'.tbl'


return,file

end
