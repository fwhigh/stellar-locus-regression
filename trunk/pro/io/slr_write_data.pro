pro slr_write_data, file=file,$
                    option=option,$
                    data=data,$
                    fitpar=fitpar,$
                    append_colors_only=append_colors_only

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
;  slr_write_data
;
; PURPOSE:
;  Append calibrated colors to an input colortable.
;
; EXPLANATION:
;  The "write" version of slr_get_data.
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
;       Written by:     FW High 2009
;
;-

;  compile_opt idl2, hidden
;  on_error,2

  if not keyword_set(option) then begin
     message,"Must supply options"
  endif
  if not keyword_set(fitpar) then begin
     message,"Must supply fitpar"
  endif

  kappa=fitpar.kappa.val
  kappa_err=fitpar.kappa.err

  ctab_in_file=data.filename
  if keyword_set(file) then begin
     ctab_out_file=file
  endif else begin
     ctab_out_file=slr_get_ctab_filename(data.filename,/out)
  endelse

  ctab=data.ctab

  colors=slr_get_data_array(data,option,fitpar,$
                            /alli,$
                            color_err=colors_err,$
                            magnitudes=mags,mag_err=mags_err)
  for ii=0,n_elements(kappa)-1 do begin
     colors_err[*,ii]=sqrt(colors_err[*,ii]^2+kappa_err[ii]^2)
  endfor
stop
  B=fitpar.b.matrix

  colors_calib=slr_color_transform(colors,$
                                   kappa=kappa,$
                                   B=B,$
                                   /inverse,debug=0)

  here=where(~finite(colors_calib),count)
  if count ge 1 then $
     colors_err[here]=!values.f_nan


;  mags_calib=slr_mag_transform(mags,colors,$
;                               kappa=kappa,$
;                               B=B,$
;                               /inverse)

  bandi=where(fitpar.bandnames eq 'isdss')
  cti=where(fitpar.b.bands eq 'isdss',count)
  if count eq 1 then begin
     ct=(fitpar.b.val[cti])[0]
     colori=where(fitpar.colornames eq (fitpar.b.mult[cti])[0])
  endif else begin
     ct=0.0
     colori=0
  endelse
  cali=where(fitpar.colornames eq 'isdss_Jtmass',count)
  if count eq 1 then begin
     ikap=(kappa[cali])[0]
  endif else begin
     ikap=0.0
  endelse

  i_calib=mags[*,bandi]-ikap-ct*colors_calib[*,colori]
  i_err=mags_err[*,bandi]
  badi=where(~finite(i_calib),count)
  if count ge 1 then $
     i_err[badi]=!values.f_nan

  for ii=0,n_elements(fitpar.colornames)-1 do begin
     ctab_addendum=create_struct($
                   fitpar.colornames[ii],colors_calib[*,0],$
                   fitpar.colornames[ii]+"_err",colors_err[*,0])
  endfor



  if option.verbose ge 1 then $
     message,'Writing '+ctab_out_file,/info

  for ii=0,n_elements(fitpar.colornames)-1 do begin
     ctab=create_struct($
          ctab,$
          fitpar.colornames[ii],colors_calib[*,ii],$
          fitpar.colornames[ii]+'_err',colors_err[*,ii])
     here=where(strlowcase(tag_names(ctab)) eq $
                strlowcase((fitpar.bandnames[bandi])[0]))
     ctab.(here)=i_calib
     here=where(strlowcase(tag_names(ctab)) eq $
                strlowcase((fitpar.bandnames[bandi])[0]+"_err"))
     ctab.(here)=i_err
  endfor


  if keyword_set(append_colors_only) then begin

     frmt_struct={header:[fitpar.colornames,$
                          fitpar.colornames+'_err'],$
                  headerformat:[replicate('A8',2*n_elements(fitpar.colornames))],$
                  format:[replicate('F8.3',2*n_elements(fitpar.colornames))]$
                 }

     print,"Appending ",ctab_out_file
  endif else begin
     id_length=max([3,strlen(ctab.id)])+1

     frmt_struct={$
                 header:['ID','RA','Dec','type','tmixed',$
                         fitpar.colornames,$
                         fitpar.colornames+'_err',$
                         fitpar.bandnames[bandi],$
                         fitpar.bandnames[bandi]+'_err'],$
                 headerformat:['A'+strtrim(id_length-1,2),$
                               'A10','A10','A10','A10',$
                               replicate('A8',2*n_elements(fitpar.colornames)),$
                               replicate('A8',2*n_elements(fitpar.bandnames[bandi]))$
                              ],$
                 format:['A'+strtrim(id_length,2),$
                         'F10.5','F10.5','I10','I10',$
                         replicate('F8.3',2*n_elements(fitpar.colornames)),$
                         replicate('F8.3',2*n_elements(fitpar.bandnames[bandi]))]$
                 }
     
  endelse


  infile=ctab_out_file
  slr_append_colortable,ctab_out_file,$
                        ctab,$
                        frmt_struct,$
                        infile=infile,$
                        append=append_colors_only

end
