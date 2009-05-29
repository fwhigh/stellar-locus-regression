function colortable_column_format

  compile_opt idl2, hidden

  types={$
        Xpos           : 4 ,$
        Ypos           : 4 ,$
        chisqr         : 4 ,$
        chisqrnorm     : 4 ,$
        ncolors        : 4 ,$
        flag           : 7 ,$
        FWHM           : 4 ,$
        FWHM1          : 4 ,$
        FWHM2          : 4 ,$
        angle          : 4 ,$
        elongation     : 4 ,$
        extendedness   : 4 ,$
        M              : 4 ,$
        dM             : 4 ,$
        flux           : 4 ,$
        dflux          : 4 ,$
        peakflux       : 4 ,$
        Nmask          : 3 ,$
        mask           : 7 ,$
        sky            : 4 ,$
        sigx           : 4 ,$
        sigxy          : 4 ,$
        sigy           : 4 ,$
        class          : 4 ,$
        type           : 7 ,$
        NUMBER         : 3 ,$
        X_IMAGE        : 4 ,$
        Y_IMAGE        : 4 ,$
        X_WORLD        : 4 ,$
        Y_WORLD        : 4 ,$
        XMIN_IMAGE     : 3 ,$
        XMAX_IMAGE     : 3 ,$
        YMIN_IMAGE     : 3 ,$
        YMAX_IMAGE     : 3 ,$
        A_IMAGE        : 4 ,$
        B_IMAGE        : 4 ,$
        THETA_IMAGE    : 4 ,$
        FWHM_IMAGE     : 4 ,$
        FWHM_WORLD     : 4 ,$
        MAG_AUTO       : 4 ,$
        MAGERR_AUTO    : 4 ,$
        FLUX_AUTO      : 4 ,$
        FLUXERR_AUTO   : 4 ,$
        MU_MAX         : 4 ,$
        amp            : 7 ,$
        filter         : 7 ,$
        matchindex     : 3 ,$
        isstar         : 3 ,$
        dither         : 7 ,$
        dophotfwhm     : 4 ,$
        ID             : 7 ,$
        X              : 5 ,$
        Y              : 5 ,$
        X_err          : 5 ,$
        Y_err          : 5 ,$
        u              : 4 ,$
        g              : 4 ,$
        r              : 4 ,$
        i              : 4 ,$
        z              : 4 ,$
        B              : 4 ,$
        V              : 4 ,$
        J              : 4 ,$
        H              : 4 ,$
        K              : 4 ,$
        dJ             : 4 ,$
        dH             : 4 ,$
        dK             : 4 ,$
        names          : 7 ,$
        u_err          : 4 ,$
        g_err          : 4 ,$
        r_err          : 4 ,$
        i_err          : 4 ,$
        z_err          : 4 ,$
        B_err          : 4 ,$
        V_err          : 4 ,$
        J_err          : 4 ,$
        H_err          : 4 ,$
        K_err          : 4 ,$
        gr             : 4 ,$
        gi             : 4 ,$
        gz             : 4 ,$
        ri             : 4 ,$
        rz             : 4 ,$
        iz             : 4 ,$
        iJ             : 4 ,$
        zJ             : 4 ,$
        gr_err         : 4 ,$
        gi_err         : 4 ,$
        gz_err         : 4 ,$
        ri_err         : 4 ,$
        rz_err         : 4 ,$
        iz_err         : 4 ,$
        iJ_err         : 4 ,$
        zJ_err         : 4 ,$
        tmixed         : 2 ,$
        sdss_type      : 4 ,$
        sed_type       : 4 ,$
        sed_type_err   : 4 ,$
        photoz         : 4 ,$
        photoz_err     : 4 ,$
        specz          : 4 ,$
        specz_err      : 4 ,$
        redshift       : 4 ,$
        redsh          : 4 ,$
        redsh_err      : 4 ,$
        u_galext       : 4 ,$
        g_galext       : 4 ,$
        r_galext       : 4 ,$
        i_galext       : 4 ,$
        z_galext       : 4 ,$
        dphotoz_minus  : 4 ,$
        dphotoz_plus   : 4 ,$
        delta_redshift : 4 ,$
        delta_redshift_norm : 4 ,$
        X2g_r          : 4 ,$
        X2r_i          : 4 ,$
        X2i_z          : 4 ,$
        X2g_i          : 4 ,$
        X2             : 4 ,$
        RA             : 4 ,$
        Dec            : 4 ,$
        g_seflag       : 3 ,$
        r_seflag       : 3 ,$
        i_seflag       : 3 ,$
        z_seflag       : 3 }

  return,types

end

function get_cat_template, file, $
                           header=header, $
                           literal=literal

  compile_opt idl2, hidden

; Initialize
  template = { version       : 1.0 ,$
               datastart     : 0L  ,$
               delimiter     : 32B ,$
               missingvalue  : !values.f_nan ,$
;             missingvalue  : '' ,$
               commentsymbol : '#' }
  types=colortable_column_format()

  lun=11
  openr,lun,file
  line=''
  readf, lun, line
  if strmid(line,0,1) eq '#' then begin
     header=line
     line=strmid(line,1)
     fieldnames=strsplit(line,' ',/extract)
  endif else begin
     message,"No comment line as expected"
  endelse
  data_line='' & readf,lun,data_line
  close,lun

  coord_type=4
  if strpos(data_line,':') ne -1 then coord_type=7

  for i=0,n_elements(fieldnames)-1 do begin
     j=strpos(fieldnames[i],'-')
     if j ge 0 then begin
        fieldnames[i]=$
           strmid(fieldnames[i],0,j)+'_'+$
           strmid(fieldnames[i],j+1)
     endif
  endfor

; Get the field locations
  line=strcompress(line)
  i=-1
  while (strpos(line,' ',i+1) ne -1) do begin
     i=strpos(line,' ',i+1)
     if size(fieldlocations,/tname) eq 'UNDEFINED' then $
        fieldlocations=[i+1] else $
           fieldlocations=[fieldlocations,i+1]
  endwhile

; Get the field types
  tags=tag_names(types)
  delvarx,fieldtypes
  if keyword_set(literal) then begin
     fieldtypes=replicate(7,n_elements(fieldnames))
  endif else begin
     for i=0,n_elements(fieldnames)-1 do begin
        here=where(strlowcase(tags) eq strlowcase(fieldnames[i]),$
                   n_matches)
        if n_matches eq 0 then begin
           type=7               ; string is default
        endif else type=types.(here)
        if strlowcase(fieldnames[i]) eq 'ra' or strlowcase(fieldnames[i]) eq 'dec' then begin
           type=coord_type
        endif
        fieldtypes=push_arr(fieldtypes,type)
     endfor
  endelse

; Get the field groups
  fieldgroups=lindgen(n_elements(fieldnames))

; Get the field count
  fieldcount=n_elements(fieldnames)

; Make the structure
  template=create_struct('fieldcount',fieldcount,$
                         'fieldtypes',fieldtypes,$
                         'fieldnames',fieldnames,$
                         'fieldlocations',fieldlocations,$
                         'fieldgroups',fieldgroups,$
                         template)

  return,template

end

function slr_read_colortable, file,$
                              verbose=verbose, $
                              force=force, $
                              literal=literal

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
;  slr_read_colortable
;
; PURPOSE:
;  Read a colortable for SLR.
;
; EXPLANATION:
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
;       Written by:     FW High 2008
;  2/09 FWH Added header keyword
;           Removed
;
;-

;  compile_opt idl2, hidden
;  on_error, 2

  if not keyword_set(verbose) then verbose=0
  
  if verbose ge 1 then $
     message,"Reading color table "+file,/info
  savefile=file+'.sav'
  if file_test(savefile) and ~keyword_set(force) then begin
     if verbose ge 1 then $
        print,"Restoring "+savefile
     restore,savefile 
  endif else begin
     template=get_cat_template(file,header=header,literal=literal)
     tmpcat=read_ascii(file,template=template)
     
     tags=(strsplit(header,/extract))[1:*]
     cat=create_struct('catalog_type','colortable',$
                       'header',header)
     for ii=0,n_elements(tags)-1 do begin
        name=slr_band_string_to_struct_tag($
             slr_color_string_to_struct_tag($
             tags[ii]))
        cat=create_struct(cat,$
                          name,tmpcat.(ii))
     endfor
     save,file=savefile
  endelse

  return,cat

end
