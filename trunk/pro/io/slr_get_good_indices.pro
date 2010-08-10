function slr_get_good_indices, cat, option, fitpar, $
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

if not keyword_set(fitpar) then $
  message,"Must provide fitpar"

ind=lindgen(n_elements(cat.ctab.ra))

;;; Get the magnitudes
tags=tag_names(cat.ctab)
for ii=0,n_elements(fitpar.bandnames)-1 do begin
    if ~tag_exist(cat.ctab,fitpar.bandnames[ii]) then begin
        message,"Data for band "+fitpar.bandnames[ii]+" not provided"
    endif
    tagi=where(strlowcase(tags) eq $
               strlowcase(fitpar.bandnames[ii]),$
               count)
    tagi_err=where(strlowcase(tags) eq $
                   strlowcase(fitpar.bandnames[ii])+'_err',$
                   count)
    mag_min=option.mag_min[ii]           
    mag_max=option.mag_max[ii]           
    ind=setintersection($
                         ind,$
                         where(1/cat.ctab.(tagi_err) gt option.snlow[ii] and $
                               cat.ctab.(tagi) gt mag_min and cat.ctab.(tagi) gt -90 and $
                               cat.ctab.(tagi) lt mag_max and cat.ctab.(tagi) lt 90 and $
                               finite(cat.ctab.(tagi)) and finite(cat.ctab.(tagi_err)) and $
                               cat.ctab.(tagi) ne -99 and cat.ctab.(tagi_err) ne -99,$
                               count))
    if count eq 0 or ind[0] eq -1 then begin
        message,'No good objects in '+fitpar.bandnames[ii]
    endif else begin
        print,n_elements(ind),' after including '+fitpar.bandnames[ii]
    endelse
endfor

;;; Make further cuts
if count eq 0 or ind[0] eq -1 then begin
    message,'No good objects! Failed selecting on magnitude and SNR'
endif

cat_tags=tag_names(cat)
ctab_tags=tag_names(cat.ctab)
for ii=0,n_elements(fitpar.colornames)-1 do begin
    band1=(strsplit(fitpar.colornames[ii],'_',/extract))[0]
    band2=(strsplit(fitpar.colornames[ii],'_',/extract))[1]
    if ~tag_exist(cat.ctab,band1) then begin
        message,"Data for band "+band1+" not provided"
    endif
    if ~tag_exist(cat.ctab,band2) then begin
        message,"Data for band "+band2+" not provided"
    endif
    mag1=where(strlowcase(ctab_tags) eq $
               strlowcase(band1),$
               count)
    mag1_err=where(strlowcase(ctab_tags) eq $
                   strlowcase(band1)+'_err',$
                   count)
    mag1_galext=where(strlowcase(cat_tags) eq $
                      strlowcase(band1)+'_galext',$
                      count)
    mag2=where(strlowcase(ctab_tags) eq $
               strlowcase(band2),$
               count)
    mag2_err=where(strlowcase(ctab_tags) eq $
                   strlowcase(band2)+'_err',$
                   count)
    mag2_galext=where(strlowcase(cat_tags) eq $
                      strlowcase(band2)+'_galext',$
                      count)
    ind=setintersection($
                         ind,$
                         where(cat.ctab.(mag1)-cat.ctab.(mag2) gt option.color_min[ii] and $
                               cat.ctab.(mag1)-cat.ctab.(mag2) lt option.color_max[ii],$
                               count))
    if count eq 0 or ind[0] eq -1 then begin
        message,'No good objects in '+fitpar.bandnames[ii]
    endif else begin
        print,n_elements(ind),' after including '+band1+'-'+band2
    endelse

endfor

if 1 then begin
    tmpi=where(abs(cat.bee) gt option.beelow and $
               (cat.ctab.type eq option.type), $
               count)
    ind=setintersection(ind,tmpi)
    if count eq 0 or ind[0] eq -1 then begin
        message,'No good objects! Failed after selecting on bee, type'
    endif
    if option.tmixed eq 0 then begin
        tmpi=where(cat.ctab.tmixed eq option.tmixed, $
                   count)
    endif else if option.tmixed eq 1 then begin
;;; Anything is ok!
        tmpi=ind
    endif
    ind=setintersection(ind,tmpi)
    if count eq 0 or ind[0] eq -1 then begin
        message,'No good objects! Failed after selecting on tmixed'
    endif
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

;;; Intersect with input indices
if keyword_set(in_ind) then begin
    ind=setintersection(ind,in_ind)
    if ind[0] eq -1 then begin
        message,'No good objects 3'
    endif
endif

if ind[0] eq -1 then begin
    message,'No good objects!  Failed'
endif

return,ind

end
