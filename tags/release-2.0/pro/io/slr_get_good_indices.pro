function slr_get_good_indices, cat, option, $
                               input_indices=in_ind, $
                               tmass_indices=tmass_indices

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
;  slr_get_good_indices
;
; PURPOSE:
;  Get the indices of data that survive generic hard data cuts.
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
  on_error, 2

;;   if option.verbose ge 1 then begin
;;      irtesti=where(finite(cat.locus.J_err) and $
;;                    finite(cat.locus.J) and $
;;                    finite(cat.locus.H_err) and $
;;                    finite(cat.locus.H) and $
;;                    finite(cat.locus.J_H) and $
;;                    finite(cat.locus.H_K) and $
;;                    finite(cat.locus.J_H) ne 0.,$
;;                    testcount)
;;      print,testcount,' good ir objs inside get_good_indices out of ',n_elements(cat.locus.J),' IR objs'
;;   endif

  if option.use_ir then begin
     if keyword_set(in_ind) then begin
;        ind=setintersection(cat.locus.obji,in_ind)
        ind=setintersection(option.opti_ir,in_ind)
     endif else begin
        ind=cat.locus.obji
     endelse
     tmpi=setintersection(ind,cat.locus.tmassi)
     delvarx,tind,sind
     for jj=0,n_elements(tmpi)-1 do begin
        here=where(cat.locus.tmassi eq tmpi[jj],count)
        if count ne 1 then continue
        tind=push_arr(tind,here)
        sind=push_arr(sind,tmpi[jj])
     endfor

     goodi=where((cat.locus.g-cat.locus.r)[sind] ge option.grmin and $
                 (cat.locus.g-cat.locus.r)[sind] le option.grmax and $
                 (cat.locus.r-cat.locus.i)[sind] ge option.rimin and $
                 (cat.locus.r-cat.locus.i)[sind] le option.rimax and $
                 (cat.locus.i-cat.locus.z)[sind] ge option.izmin and $
                 (cat.locus.i-cat.locus.z)[sind] le option.izmax and $
                 (cat.locus.z[sind]-cat.locus.J[tind]) ge option.zJmin and $
                 (cat.locus.z[sind]-cat.locus.J[tind]) le option.zJmax and $
                 finite(cat.locus.g_err[sind]) and $
                 finite(cat.locus.g[sind]) and $
                 finite(cat.locus.r_err[sind]) and $
                 finite(cat.locus.r[sind]) and $
                 finite(cat.locus.i_err[sind]) and $
                 finite(cat.locus.i[sind]) and $
                 finite(cat.locus.z_err[sind]) and $
                 finite(cat.locus.z[sind]) and $
                 finite(cat.locus.J_err[tind]) and $
                 finite(cat.locus.J[tind]) and $
;                 finite(cat.locus.H_err[tind]) and $
;                 finite(cat.locus.H[tind]) and $
;                 finite(cat.locus.J_H[tind]) and $
;                 finite(cat.locus.H_K[tind]) and $
                 cat.locus.J_H[tind] ne 0.  ,$
                 count)
     if count eq 0 then begin
        message,'No good objects'
     endif
     ind=sind[goodi]
  endif else begin
     goodi=where((cat.locus.g-cat.locus.r) ge option.grmin and $
                 (cat.locus.g-cat.locus.r) le option.grmax and $
                 (cat.locus.r-cat.locus.i) ge option.rimin and $
                 (cat.locus.r-cat.locus.i) le option.rimax and $
;;                 (((cat.locus.g-cat.locus.i) ge option.gimin and $
;;                   (cat.locus.g-cat.locus.i) le option.gimax) or $
;;                  (cat.locus.r-cat.locus.i) ge 0.7 or $
;;                  (cat.locus.g-cat.locus.r) le 0.35) and $
                 finite(cat.locus.g_err) and finite(cat.locus.g) and $
                 finite(cat.locus.r_err) and finite(cat.locus.r) and $
                 finite(cat.locus.i_err) and finite(cat.locus.i) and $
                 finite(cat.locus.z_err) and finite(cat.locus.z) )
     ind=setintersection(cat.locus.obji,goodi)
     if keyword_set(in_ind) then begin
        ind=setintersection(ind,in_ind)
     endif
  endelse

  if option.use_ir then begin
     delvarx,tind,sind
     for jj=0,n_elements(ind)-1 do begin
        here=where(cat.locus.tmassi eq ind[jj],count)
        if count ne 1 then continue
        tind=push_arr(tind,here)
        sind=push_arr(sind,ind[jj])
     endfor
     tmass_indices=tind
     ind=sind
  endif

  return,ind

end