function slr_get_data_array, cat, option, $
                             err=err, $
                             mag=mag, $
                             output_indices=ind, $
                             input_indices=in_ind

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
;  slr_get_data_array
;
; PURPOSE:
;  Get the array of SLR color-data vectors.
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

ind=slr_get_good_indices(cat,option,input_indices=in_ind,tmass_indices=tind)

if option.verbose ge 1 and option.deredden then begin
   message,"Dereddening",/info
endif



if option.use_ir then begin
;;     for jj=0,n_elements(ind)-1 do begin
;;         here=where(cat.locus.tmassi eq ind[jj],count)
;;         if count eq 0 then continue
;;         if count gt 1 then continue
;;         tind=push_arr(tind,here)
;;         sind=push_arr(sind,ind[jj])
;;     endfor
    dat=[[(cat.locus.g-cat.locus.r-(cat.locus.g_galext-cat.locus.r_galext)*option.deredden)[ind]],$
         [(cat.locus.r-cat.locus.i-(cat.locus.r_galext-cat.locus.i_galext)*option.deredden)[ind]],$
         [(cat.locus.i-cat.locus.z-(cat.locus.i_galext-cat.locus.z_galext)*option.deredden)[ind]],$
         [(cat.locus.z[ind]-cat.locus.J[tind])],$
         [(cat.locus.i[ind]-cat.locus.J[tind])],$
         [(cat.locus.r[ind]-cat.locus.J[tind])],$
         [(cat.locus.g[ind]-cat.locus.J[tind])]]
    err=[[(sqrt(cat.locus.g_err^2+cat.locus.r_err^2))[ind]],$
         [(sqrt(cat.locus.r_err^2+cat.locus.i_err^2))[ind]],$
         [(sqrt(cat.locus.i_err^2+cat.locus.z_err^2))[ind]],$
         [(sqrt(cat.locus.z_err[ind]^2+cat.locus.J_err[tind]^2))],$
         [(sqrt(cat.locus.i_err[ind]^2+cat.locus.J_err[tind]^2))],$
         [(sqrt(cat.locus.r_err[ind]^2+cat.locus.J_err[tind]^2))],$
         [(sqrt(cat.locus.g_err[ind]^2+cat.locus.J_err[tind]^2))]]
    mag=[[(cat.locus.g-(cat.locus.g_galext)*option.deredden)[ind]],$
         [(cat.locus.r-(cat.locus.r_galext)*option.deredden)[ind]],$
         [(cat.locus.i-(cat.locus.i_galext)*option.deredden)[ind]],$
         [(cat.locus.z-(cat.locus.z_galext)*option.deredden)[ind]],$
         [(cat.locus.J[tind])]]
;;     ind=sind
endif else begin
    dat=[[(cat.locus.g-cat.locus.r-(cat.locus.g_galext-cat.locus.r_galext)*option.deredden)[ind]],$
         [(cat.locus.r-cat.locus.i-(cat.locus.r_galext-cat.locus.i_galext)*option.deredden)[ind]],$
         [(cat.locus.i-cat.locus.z-(cat.locus.i_galext-cat.locus.z_galext)*option.deredden)[ind]]]
    err=[[(sqrt(cat.locus.g_err^2+cat.locus.r_err^2))[ind]],$
         [(sqrt(cat.locus.r_err^2+cat.locus.i_err^2))[ind]],$
         [(sqrt(cat.locus.i_err^2+cat.locus.z_err^2))[ind]]]
    mag=[[(cat.locus.g-(cat.locus.g_galext)*option.deredden)[ind]],$
         [(cat.locus.r-(cat.locus.r_galext)*option.deredden)[ind]],$
         [(cat.locus.i-(cat.locus.i_galext)*option.deredden)[ind]],$
         [(cat.locus.z-(cat.locus.z_galext)*option.deredden)[ind]]]
    output_indices=ind
endelse

;; if option.simulate then begin
;;    message,"Out of date!"
;;     if option.dist_fittype eq 0 then begin
;;         use_fittype=0
;;         p_in=[gr_shift,ri_shift,iz_shift,z_zpt]
;;     endif else if option.dist_fittype eq 1 or option.dist_fittype eq 2 then begin
;;         use_fittype=1
;;         p_in=[gr_shift,ri_shift,iz_shift,z_zpt,colcoeff_g,colcoeff_r,colcoeff_i,colcoeff_z]
;;     endif else begin
;;         message,"Huh?"
;;     endelse
;;     dat=slr_color_transform(dat,$
;;                             p_in,$
;;                             use_fittype,option.basis)
;; endif

return,dat

end
