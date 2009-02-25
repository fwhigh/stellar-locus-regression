pro slr_write_data, file=file,$
                    option=option,$
                    data=data,$
                    kappa=kappa,$
                    kap_err=kappa_err

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
  if not keyword_set(kappa) then begin
     message,"Must supply kappa"
  endif

  ctab_in_file=data.filename
  if keyword_set(file) then begin
     ctab_out_file=file
  endif else begin
     ctab_out_file=slr_get_ctab_filename(data.filename,/out)
  endelse

  ctab=data.ctab

  colors=slr_get_data_array(data,option,$
                            /alli,$
                            err=colors_err)
  if not keyword_set(kappa_err) then $
     message,"Must provide kap_err"
;     kappa_err=replicate(0.,n_elements(ctab.ra))
  for ii=0,n_elements(kappa)-1 do begin
     colors_err[*,ii]=sqrt(colors_err[*,ii]^2+kappa_err[ii]^2)
  endfor

;  message,'Not correcting for color terms',/info
;  kappa=slr_fitpar_struct_to_kappa(fitpar,p,p_counter=p_counter)
;  m_op =slr_fitpar_struct_to_colorterm_matrix(fitpar,p,p_counter=p_counter)
  m_op=slr_colorterm_matrix(option.colorterms,data.fitpar0)
  colors_calib=slr_color_transform(colors,$
                                 kappa=kappa,$
                                 m_op=m_op,$
                                 /inverse)

  for ii=0,n_elements(option.colors2calibrate)-1 do begin
     ctab_addendum=create_struct($
                   option.colors2calibrate[ii],colors_calib[*,0],$
                   option.colors2calibrate[ii]+"_err",colors_err[*,0])
  endfor

  if option.verbose ge 1 then $
     message,'Writing '+ctab_out_file,/info
  slr_append_colortable,ctab_in_file,$
                        ctab_out_file,$
                        ctab_addendum
                        
end
