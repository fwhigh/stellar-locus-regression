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

  B=fitpar.b.matrix

  colors_calib=slr_color_transform(colors,$
                                   kappa=kappa,$
                                   B=B,$
                                   /inverse,debug=0)

  here=where(~finite(colors_calib),count)
  if count ge 1 then $
     colors_err[here]=!values.f_nan

  for ii=0,n_elements(fitpar.colornames)-1 do begin
     if tag_exist(ctab,fitpar.colornames[ii]) then begin
        tagi=where(tag_names(ctab) eq strlowcase(fitpar.colornames[ii]))
        ctab.(tagi)=colors_calib[*,ii]
        tagi=where(tag_names(ctab) eq strlowcase(fitpar.colornames[ii]+'_err'))
        ctab.(tagi)=colors_err[*,ii]
     endif else begin
        ctab=create_struct($
             ctab,$
             fitpar.colornames[ii],colors_calib[*,ii],$
             fitpar.colornames[ii]+'_err',colors_err[*,ii])
     endelse
  endfor

  id_length=max([3,strlen(ctab.id)])+1
  header=['ID','RA','Dec','type','tmixed',$
          fitpar.colornames,$
          fitpar.colornames+'_err']
  headerformat=['A'+strtrim(id_length-1,2),$
                'A10','A10','A10','A10',$
                replicate('A9',2*n_elements(fitpar.colornames))]
  format=['A'+strtrim(id_length,2),$
          'F10.5','F10.5','I10','I10',$
          replicate('F9.3',2*n_elements(fitpar.colornames))]

  if option.mags2write[0] ne '' then begin
     for jj=0,n_elements(option.mags2write)-1 do begin
        band=option.mags2write[jj]
        bandi=where(fitpar.bandnames eq band)

        if option.mag_zeropoints[jj] ne '0' then begin
;        cali=where(fitpar.colornames eq 'isdss_Jtmass',count)
           cali=where(fitpar.colornames eq option.mag_zeropoints[jj],count)
           kap=(kappa[cali])[0]

           mag_calib=mags[*,bandi]-kap
           mag_err=mags_err[*,bandi]
           
           if fitpar.b.bands[0] then begin
              for ii=0,n_elements(fitpar.b.val)-1 do begin
                 if fitpar.b.bands[ii] ne band then continue
                 colorterm=fitpar.b.val[ii]
                 colormult=fitpar.b.mult[ii]
                 colori=where(fitpar.colornames eq colormult)
              endfor
              mag_calib-=colorterm*colors_calib[*,colori]
           endif else begin
              
           endelse
        endif else begin

           mag_calib=mags[*,bandi]
           mag_err=mags_err[*,bandi]

        endelse

        here=where(strlowcase(tag_names(ctab)) eq $
                   strlowcase(band))
        ctab.(here)=mag_calib
        here=where(strlowcase(tag_names(ctab)) eq $
                   strlowcase(band+"_err"))
        ctab.(here)=mag_err

        header=[header,$
                fitpar.bandnames[bandi],$
                fitpar.bandnames[bandi]+'_err']
        headerformat=[headerformat,$
                      replicate('A9',2)]
        format=[format,$
                replicate('F9.3',2)]

     endfor
  endif


  if 0 then begin
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
  endif


  for ii=0,n_elements(fitpar.colornames)-1 do begin
     ctab_addendum=create_struct($
                   fitpar.colornames[ii],colors_calib[*,0],$
                   fitpar.colornames[ii]+"_err",colors_err[*,0])
  endfor



  if option.verbose ge 1 then $
     message,'Writing '+ctab_out_file,/info

  if keyword_set(append_colors_only) then begin
     message,"This bit is not used"
     frmt_struct={header:[fitpar.colornames,$
                          fitpar.colornames+'_err'],$
                  headerformat:[replicate('A8',2*n_elements(fitpar.colornames))],$
                  format:[replicate('F8.3',2*n_elements(fitpar.colornames))]$
                 }

     print,"Appending ",ctab_out_file
  endif else begin

     frmt_struct={header:header,$
                  headerformat:headerformat,$
                  format:format}     
  endelse

  infile=ctab_out_file
  slr_append_colortable,ctab_out_file,$
                        ctab,$
                        frmt_struct,$
                        infile=infile,$
                        append=append_colors_only


end
