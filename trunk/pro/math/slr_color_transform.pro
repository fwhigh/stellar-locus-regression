function slr_color_transform, x2,$
                              kappa=kappa,$
                              B=B,$
                              inverse=inverse,$
                              debug=debug

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
;  slr_color_transform
;
; PURPOSE:
;  Return astronomical colors transformed by translations, scalings, shears, and rotations.
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

n_dim=n_elements(x2[0,*])
n_dat=n_elements(x2[*,0])

if n_elements(kappa) ne n_dim then $
   message,'Constant array must have same dimensions as color vector'
if not keyword_set(B) then B=identity(n_dim)

if keyword_set(inverse) then begin

;   B_use = imsl_inv(B)
   B_use = matrix_power(B,-1)

   x2_tr=x2/x2-1
   x2_test=x2
   here=where(~finite(x2_test),count)
   if count ge 1 then $
      x2_test[here]=1e10
   if keyword_set(debug) then $
      pm,B_use
   for ii=0,n_dat-1 do begin
;      if keyword_set(debug) then begin
;         print
;         pm,x2[ii,*]-kappa
;         pm,x2_test[ii,*]-kappa
;      endif
      x2_tr[ii,*] = matrix_multiply(B_use,x2_test[ii,*]-kappa,/btranspose)
;      if keyword_set(debug) then begin
;         pm,x2_tr[ii,*]
;         junk='' & read,'Hit enter',junk
;      endif
   endfor
   here=where(abs(x2_tr) gt 1e4,count)
   if count ge 1 then $
      x2_tr[here]=!values.f_nan

endif else begin

   B_use = B

   x2_tr=x2/x2-1
   for ii=0,n_dat-1 do begin
      x2_tr[ii,*] = kappa+matrix_multiply(B_use,x2[ii,*],/btranspose)
   endfor

endelse

return,x2_tr

end
