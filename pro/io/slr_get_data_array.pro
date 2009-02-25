function slr_get_data_array, cat, option, $
                             alli=alli,$
                             err=err, $
                             mag=mag, $
                             reddening=reddening,$
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
;  2/09 FWH Now more general
;
;-

  compile_opt idl2, hidden

  if keyword_set(alli) then begin
     ind=lindgen(n_elements(cat.ctab.ra))
  endif else begin
     ind=slr_get_good_indices(cat,option,input_indices=in_ind,tmass_indices=tind)
  endelse

  if option.verbose ge 1 and option.deredden then begin
     message,"Dereddening",/info
  endif


;;; Get the colors
  cat_tags=tag_names(cat)
  ctab_tags=tag_names(cat.ctab)
  for ii=0,n_elements(option.colors2calibrate)-1 do begin
     band1=(strmid(option.colors2calibrate[ii],0,1))[0]
     band2=(strmid(option.colors2calibrate[ii],1,1))[0]
     if ~tag_exist(cat.ctab,band1) then begin
        message,"Data for band "+option.use_bands[ii]+" not provided"
     endif
     if ~tag_exist(cat.ctab,band2) then begin
        message,"Data for band "+option.use_bands[ii]+" not provided"
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
     print,'here ',band1,band2
     if size(dat,/tname) eq 'UNDEFINED' then begin
        dat=(cat.ctab.(mag1)-cat.(mag1_galext)*option.deredden-$
             (cat.ctab.(mag2)-cat.(mag2_galext)*option.deredden))[ind]
        err=(cat.ctab.(mag1_err)^2+cat.ctab.(mag2_err)^2)[ind]
        mag=(cat.ctab.(mag1))[ind]
        reddening=(cat.(mag1_galext)-cat.(mag2_galext))[ind]
     endif else begin
        dat=[[dat],$
             [(cat.ctab.(mag1)-cat.(mag1_galext)*option.deredden-$
               (cat.ctab.(mag2)-cat.(mag2_galext)*option.deredden))[ind]]]
        err=[[err],$
             [(cat.ctab.(mag1_err)^2+cat.ctab.(mag2_err)^2)[ind]]]
        mag=[[mag],$
             [(cat.ctab.(mag1))[ind]]]
        reddening=[[reddening],$
                   [(cat.(mag1_galext)-cat.(mag2_galext))[ind]]]
        if ii eq (n_elements(option.colors2calibrate)-1) then begin
           mag=[[mag],$
                [(cat.ctab.(mag2))[ind]]]
        endif
     endelse
  endfor

  return,dat

end