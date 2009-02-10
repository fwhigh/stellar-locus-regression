pro slr_write_data, file=file,$
                    option=option,$
                    data=data,$
                    kappa=kappa,$
                    kap_err=kappa_err,$
                    colorterms=colorterms

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

  compile_opt idl2, hidden
  on_error,2

  if not keyword_set(option) then begin
     message,"Must supply options"
  endif

  ctab_in_file=data.filename
  if keyword_set(file) then begin
     ctab_out_file=file
  endif else begin
     ctab_out_file=slr_get_ctab_filename(data.filename,/out)
  endelse

  ctab=data.locus.ctab

  data=[[ctab.g-ctab.r],$
        [ctab.r-ctab.i],$
        [ctab.i-ctab.z]]
  if not keyword_set(kap_err) then kap_err=replicate(0.,3)
  data_err=[[sqrt(ctab.g_err^2+ctab.r_err^2+kap_err[0]^2)],$
            [sqrt(ctab.r_err^2+ctab.i_err^2+kap_err[0]^2)],$
            [sqrt(ctab.i_err^2+ctab.z_err^2+kap_err[0]^2)]]

  message,'Not correcting for color terms',/info
  data_calib=slr_color_transform(data,$
                                 kappa=kappa,$
                                 /inverse)
  


  ctab_addendum=create_struct("gr"    ,data[*,0],$
                              "gr_err",data_err[*,0],$
                              "ri"    ,data[*,1],$
                              "ri_err",data_err[*,1],$
                              "iz"    ,data[*,2],$
                              "iz_err",data_err[*,2])                              

  if option.verbose ge 1 then $
     message,'Writing '+ctab_out_file,/info
  slr_append_colortable,ctab_in_file,$
                        ctab_out_file,$
                        ctab_addendum
                        
end
