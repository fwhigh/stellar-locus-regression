pro slr_write_data, $;fieldname=fieldname,$
                    option=option,$
;                    limits=limits,$
                    force=force,$
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

  on_error,2

;  if not keyword_set(fieldname) then begin
;     message,"Must specify a field name"
;  endif else if fieldname eq 'none' then begin
;     message,"Can't write colortable for field "+fieldname
;  endif
  if not keyword_set(option) then begin
     message,"Must supply options"
  endif
;  if not keyword_set(limits) then begin
;     message,"Using default limits",/info
;     limits=slr_limits()
;  endif

  ctab_in_file=slr_get_ctab_filename(data.field)
  ctab_out_file=slr_get_ctab_filename(data.filename,/out)

  ctab=data.locus.ctab

  data=[[ctab.g-ctab.r],$
        [ctab.r-ctab.i],$
        [ctab.i-ctab.z]]

  message,'WARNING: Not correcting for color terms',/info
  data_calib=slr_color_transform(data,$
                                 kappa=kappa,$
                                 /inverse)

  ctab_addendum=create_struct("gr"   ,data[*,0],$
                              "gr_err",data[*,0],$
                              "ri"   ,data[*,1],$
                              "ri_err",data[*,1],$
                              "iz"   ,data[*,2],$
                              "iz_err",data[*,2])                              
                              

  slr_append_colortable,ctab_in_file,$
                        ctab_out_file,$
                        ctab_addendum
                        
end
