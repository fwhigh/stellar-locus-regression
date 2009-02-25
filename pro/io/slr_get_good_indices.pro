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
;  2/09 FWH IR now integrated with the colortable data, much cleaner
;           now
;-

;  compile_opt idl2, hidden
;  on_error, 2

  ind=lindgen(n_elements(cat.ctab.ra))

;;; Get the magnitudes
  tags=tag_names(cat.ctab)
  for ii=0,n_elements(option.bands)-1 do begin
     if ~tag_exist(cat.ctab,option.bands[ii]) then begin
        message,"Data for band "+option.bands[ii]+" not provided"
     endif
     tagi=where(strlowcase(tags) eq $
                strlowcase(option.bands[ii]),$
                count)
     tagi_err=where(strlowcase(tags) eq $
                    strlowcase(option.bands[ii])+'_err',$
                    count)
     if n_elements(option.mag_min) eq 1 then $
        mag_min=option.mag_min[0] else $
           mag_min=option.mag_min[ii]           
     if n_elements(option.mag_max) eq 1 then $
        mag_max=option.mag_max[0] else $
           mag_max=option.mag_max[ii]           
     ind=setintersection($
         ind,$
         where(1/cat.ctab.(tagi_err) gt option.snlow and $
               cat.ctab.(tagi) gt mag_min and $
               cat.ctab.(tagi) lt mag_max and $
               finite(cat.ctab.(tagi)) and finite(cat.ctab.(tagi_err)) and $
               cat.ctab.(tagi) ne -99 and cat.ctab.(tagi_err) ne -99,$
               count))
     if count eq 0 or ind[0] eq -1 then begin
        message,'No good objects in '+option.bands[ii]
     endif
  endfor

;;; Make further cuts
  ind=setintersection($
      ind,$
      where(abs(cat.bee) gt option.beelow and $
            (cat.ctab.type eq option.type and cat.ctab.tmixed eq option.tmixed), $
            count))
  if count eq 0 then begin
     message,'No good objects 1'
  endif
  if option.cutdiskstars then begin
     ind=setintersection($
         ind,$
         where(abs(cat.zee) gt option.zeelow,$
               count))
     if count eq 0 then begin
        message,'No good objects 1'
     endif
  endif

;;; This will be obsolete soon
  if option.use_ir then begin
     ind=setintersection(ind,$
                         where((cat.ctab.z-cat.ctab.J) ge option.zJmin and $
                               (cat.ctab.z-cat.ctab.J) le option.zJmax and $
                               finite(cat.ctab.J_err) and cat.ctab.J_err ne -99 and $
                               finite(cat.ctab.J) and cat.ctab.J ne -99, $
                               count))
     if count eq 0 or ind[0] eq -1 then begin
        message,'No good objects 2'
     endif
  endif

;;; Intersect with input indices
  if keyword_set(in_ind) then begin
     ind=setintersection(ind,in_ind)
     if ind[0] eq -1 then begin
        message,'No good objects 3'
     endif
  endif

  return,ind

end
