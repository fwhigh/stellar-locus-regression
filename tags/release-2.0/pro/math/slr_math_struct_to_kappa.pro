function slr_math_struct_to_kappa, math, p,$
                               p_counter=p_counter

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
;  slr_math_struct_to_kappa
;
; PURPOSE:
;  Get the entries of the kappa vector from a math structure.
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
;       Written by:     FW High 2008
;
;-

kappa_out=replicate(0.,math.kappa.n)
for ii=0,math.kappa.n-1 do begin
    if math.kappa.fixed[ii] then begin
        kappa_out[ii]=math.kappa.val[ii]
    endif else begin
        kappa_out[ii]=p[p_counter]
        p_counter=p_counter+1
    endelse
endfor

return,kappa_out

end
