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
                            err=colors_err)
  for ii=0,n_elements(kappa)-1 do begin
     colors_err[*,ii]=sqrt(colors_err[*,ii]^2+kappa_err[ii]^2)
  endfor

  B=slr_colorterm_matrix(fitpar.b.val,fitpar)
  colors_calib=slr_color_transform(colors,$
                                   kappa=kappa,$
                                   B=B,$
                                   /inverse)
  here=where(~finite(colors_calib),count)
  if count ge 1 then $
     colors_err[here]=!values.f_nan

  for ii=0,n_elements(fitpar.colornames)-1 do begin
     ctab_addendum=create_struct($
                   fitpar.colornames[ii],colors_calib[*,0],$
                   fitpar.colornames[ii]+"_err",colors_err[*,0])
  endfor

  if option.verbose ge 1 then $
     message,'Writing '+ctab_out_file,/info
;  slr_append_colortable,ctab_in_file,$
;                        ctab_out_file,$
;                        ctab_addendum



  for ii=0,n_elements(fitpar.colornames)-1 do begin
     ctab=create_struct($
          ctab,$
          fitpar.colornames[ii],colors_calib[*,ii],$
          fitpar.colornames[ii]+'_err',colors_err[*,ii])
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
                 header:['ID','RA','Dec',$
                         fitpar.colornames,$
                         fitpar.colornames+'_err'],$
                 headerformat:['A'+strtrim(id_length-1,2),$
                               'A10','A10',$
                               replicate('A8',2*n_elements(fitpar.colornames))],$
                 format:['A'+strtrim(id_length,2),$
                         'F10.5','F10.5',$
                         replicate('F8.3',2*n_elements(fitpar.colornames))]$
                 }
     
  endelse

  if 1 then begin

     infile=ctab_out_file
     slr_append_colortable,ctab_out_file,$
                           ctab,$
                           frmt_struct,$
                           infile=infile,$
                           append=append_colors_only


  endif else begin

     
     openw,lun,ctab_out_file,/get_lun
     format='("#",'+strjoin(frmt_struct.headerformat,',')+')'
     printf,lun,frmt_struct.header,format=format

     n_total=n_elements(ctab.ra)
     tags=tag_names(ctab)
     for ii=0L,n_total-1 do begin
        delvarx,line
        for jj=0,n_elements(frmt_struct.header)-1 do begin
           here=where(strlowcase(tags) eq strlowcase(frmt_struct.header[jj]))
           val=string(ctab.(here)[ii],format='('+frmt_struct.format[jj]+')')
           if ~finite(val) then val=string('-',format='(A8)')
           line=push_arr(line,val)
        endfor
        printf,lun,strjoin(line)
     endfor
     close,lun

  endelse

end
