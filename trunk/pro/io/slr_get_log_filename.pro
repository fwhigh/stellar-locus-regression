function slr_get_log_filename, field,$
                               out=out,$
                               path=path

;$Rev:: 56            $:  Revision of last commit
;$Author:: fwhigh     $:  Author of last commit
;$Date:: 2009-02-03 2#$:  Date of last commit
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
;  slr_get_log_filename
;
; PURPOSE:
;  Get the log filename given a field.
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
;       Written by:     FW High 2009
;
;-

  compile_opt idl2, hidden
  on_error,2

  if not keyword_set(path) then begin
     file=field+'.slr.log'
  endif else begin
     file=path+path_sep()+field+'.slr.log'
  endelse
  return, file

end
