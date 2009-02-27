function slr_options, file=file

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
;  slr_options
;
; PURPOSE:
;  Return a structure containing the default global options.
;
; EXPLANATION:
;  It's always nice to have common options set in one place.
;  This is that place.  This does NOT make use of common blocks, but
;  rather returns a structure which must be passed to and recognized
;  by the SLR subroutines.
;
; CALLING SEQUENCE:
;  options=slr_options()
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
;  Written by:     FW High 2008
;  2/09 FWH Options now come from an external config file
;
;-

;  compile_opt idl2, hidden
;  on_error,2

  if not keyword_set(file) then begin
     file=getenv('SLR_INSTALL')+path_sep()+$
          'config'+path_sep()+'default_slr.config'
;     message,"Using default config file "+file,/info
  endif
  if not file_test(file) then begin
     message,"Config file "+file+" not found"
  endif

  acceptable_bands=slr_acceptable_bands()

  if 0 then begin
     readcol,file,$
             par,val,$
             /silent,$
             delimiter=' ',$
             comment='#',$
             format='(A,A)'
  endif else begin
     lun=3
     openr,lun,file
     line=''
     WHILE ~ EOF(lun) DO BEGIN 
        READF, lun, line 
        commenti=strpos(line,'#')
        if commenti eq 0 then continue
        if commenti eq -1 then commenti=strlen(line)
        line=strmid(line,0,commenti)
        pair=strsplit(line,/extract)
        par=push_arr(par,pair[0])
        val=push_arr(val,pair[1])
     ENDWHILE 


     close,lun
  endelse

  option=create_struct(       "version",slr_version())
  for ii=0,n_elements(par)-1 do begin
     case par[ii] of 
        "use_ir":begin
           option=create_struct(option,par[ii],fix(val[ii]))
           if option.use_ir then $
              message,"Infrared regression not yet implemented",/info
        end
        "force":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "postscript":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "plot":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "interactive":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "animate_regression":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "weighted_residual":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "verbose":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "debug":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "nbootstrap":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "get_kappa":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "type":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "tmixed":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "deredden":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "have_sfd":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "cutdiskstars":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "beelow":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "zeelow":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "snlow":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "gsnlow":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "gmax":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "rmin":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "rmax":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "magerr_floor":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "max_locus_dist":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "max_weighted_locus_dist":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "use_fitpar":begin
           option=create_struct(option,par[ii],fix(val[ii]))
        end
        "color_min":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],float(tmpval))
        end
        "color_max":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],float(tmpval))
        end
        "mag_min":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],float(tmpval))
        end
        "mag_max":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],float(tmpval))
        end
        "kappa_fix":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],fix(tmpval))
        end
        "abs_kappa_fix":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],fix(tmpval))
        end
        "kappa_guess":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],float(tmpval))
        end
        "abs_kappa_guess":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],float(tmpval))
        end
        "kappa_guess_err":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],float(tmpval))
        end
        "abs_kappa_guess_err":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],float(tmpval))
        end
        "kappa_guess_range":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],float(tmpval))
        end
        "abs_kappa_guess_range":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],float(tmpval))
        end
        "colorterms":begin
           tmpval=strsplit(val[ii],',',/extract)
           if tmpval[0] eq 'none' then tmpval=0
           option=create_struct(option,par[ii],float(tmpval))
        end
        "abs_colorterms":begin
           tmpval=strsplit(val[ii],',',/extract)
           if tmpval[0] eq 'none' then tmpval=0
           option=create_struct(option,par[ii],float(tmpval))
        end
        "colortermbands":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],tmpval)
        end
        "abs_colortermbands":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],tmpval)
        end
        "colormult":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],tmpval)
        end
        "abs_colormult":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],tmpval)
        end
        "colors2calibrate":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],tmpval)
        end
        "abs_colors2calibrate":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],tmpval)
        end
;;         "bands":begin
;;            tmpval=strsplit(val[ii],',',/extract)
;;            option=create_struct(option,par[ii],tmpval)
;;            bands=['u','g','r','i','z','J','H','K']
;;            for jj=0,n_elements(option.bands)-1 do begin
;;               if total(bands eq option.bands[jj]) eq 0 then begin
;;                  message,"Band "+option.bands[jj]+" can't be used",/info
;;                  message,"Must use g,r,i,z, and/or J"
;;               endif
;;            endfor
;;         end
        else:begin
           message,"Input parameter "+par[ii]+" unknown"
        end
     endcase
  endfor

  if option.verbose ge 1 then begin
     message,"Using config file "+file,/info
  endif

  if option.have_sfd then begin
     if ~slr_have_sfd() then begin
        message,"Can't locate SFD maps"
     endif
  endif


;;; Initial colors and bands.

  delvarx,bands
  option.colors2calibrate=$
     slr_color_string_to_struct_tag(option.colors2calibrate,$
                                    bands=bands)
  option=create_struct(option,'bands',bands)
  if option.colortermbands[0] eq 'none' or $
     option.colormult[0] eq 'none' then begin
     option.colorterms[*]=0
     option.colortermbands[*]=''
     option.colormult[*]=''
  endif else begin
     option.colortermbands=slr_band_string_to_struct_tag($
                           option.colortermbands)
     option.colormult=slr_color_string_to_struct_tag($
                      option.colormult)
  endelse


;;; Initialize abs colors and bands.
  if option.abs_colors2calibrate[0] eq 'none' then begin
     option.abs_colors2calibrate=''
     option=create_struct(option,'abs_bands','')
  endif else begin
     delvarx,abs_bands
     option.abs_colors2calibrate=$
        slr_color_string_to_struct_tag(option.abs_colors2calibrate,$
                                       bands=abs_bands)
     option=create_struct(option,'abs_bands',abs_bands)
  endelse
  if option.abs_colortermbands[0] eq 'none' or $
     option.abs_colormult[0] eq 'none' then begin
     option.abs_colorterms[*]=0
     option.abs_colortermbands[*]=''
     option.abs_colormult[*]=''
  endif else begin
     option.abs_colortermbands=slr_band_string_to_struct_tag($
                               option.abs_colortermbands)
     option.abs_colormult=slr_color_string_to_struct_tag($
                          option.abs_colormult)
  endelse

;;; Initialize all colors and bands.
  all_colors2calibrate=[option.colors2calibrate,$
                        option.abs_colors2calibrate]
  sorti=uniq(all_colors2calibrate,sort(all_colors2calibrate))
  all_colors2calibrate=$
     all_colors2calibrate[sorti]
  all_kappa_guess=[option.kappa_guess,$
                   option.abs_kappa_guess]
  all_kappa_guess=all_kappa_guess[sorti]
  all_kappa_guess_range=[option.kappa_guess_range,$
                   option.abs_kappa_guess_range]
  all_kappa_guess_range=all_kappa_guess_range[sorti]
  all_kappa_guess_err=[option.kappa_guess_err,$
                   option.abs_kappa_guess_err]
  all_kappa_guess_err=all_kappa_guess_err[sorti]
  all_kappa_fix=[option.kappa_fix,$
                   option.abs_kappa_fix]
  all_kappa_fix=all_kappa_fix[sorti]

  all_bands=[option.bands,$
             option.abs_bands]
  all_bands=$
     all_bands[uniq(all_bands,sort(all_bands))]

  all_colortermbands=[option.colortermbands,$
                      option.abs_colortermbands]
  sorti=uniq(all_colortermbands,sort(all_colortermbands))
  all_colortermbands=all_colortermbands[sorti]
  all_colorterms=[option.colorterms,$
                  option.abs_colorterms]
  all_colorterms=all_colorterms[sorti]
  all_colormult=[option.colormult,$
                 option.abs_colormult]
  all_colormult=all_colormult[sorti]
  
  option=create_struct(option,$
                       'all_colors2calibrate',all_colors2calibrate,$
                       'all_kappa_guess',all_kappa_guess,$
                       'all_kappa_guess_range',all_kappa_guess_range,$
                       'all_kappa_guess_err',all_kappa_guess_err,$
                       'all_kappa_fix',all_kappa_fix,$
                       'all_bands',all_bands,$
                       'all_colortermbands',all_colortermbands,$
                       'all_colorterms',all_colorterms,$
                       'all_colormult',all_colormult)
;;;
;;; Do preliminary checks on inputs.
;;;

;;; Check colors
  n_colors=n_elements(option.colors2calibrate)
  if n_elements(option.kappa_fix) ne n_colors then $
     message,"N(kappa_fix) must equal N(colors2calibrate)"
  if n_elements(option.kappa_guess) ne n_colors then $
     message,"N(kappa_guess) must must equal N(colors2calibrate)"
  if n_elements(option.kappa_guess_err) ne n_colors then $
     message,"N(kappa_guess_err) must must equal N(colors2calibrate)"
  if n_elements(option.kappa_guess_range) ne n_colors then $
     message,"N(kappa_guess_range) must equal N(colors2calibrate)"
  if n_elements(option.colorterms) ne n_elements(option.colortermbands) then $
     message,"N(colortermbands) must equal N(colorterms)"
  if n_elements(option.colorterms) ne n_elements(option.colormult) then $
     message,"N(colormult) must equal N(colorterms)"

;;; Check abs colors
  if option.abs_colors2calibrate[0] then begin
     n_abs_colors=n_elements(option.abs_colors2calibrate)
     if n_elements(option.abs_kappa_fix) ne n_abs_colors then $
        message,"N(abs_kappa_fix) must equal N(abs_colors2calibrate)"
     if n_elements(option.abs_kappa_guess) ne n_abs_colors then $
        message,"N(abs_kappa_guess) must must equal N(abs_colors2calibrate)"
     if n_elements(option.abs_kappa_guess_err) ne n_abs_colors then $
        message,"N(abs_kappa_guess_err) must must equal N(abs_colors2calibrate)"
     if n_elements(option.abs_kappa_guess_range) ne n_abs_colors then $
        message,"N(abs_kappa_guess_range) must equal N(abs_colors2calibrate)"
     if n_elements(option.abs_kappa_guess_range) ne n_abs_colors then $
        message,"N(abs_kappa_guess_range) must equal N(abs_colors2calibrate)"
     if n_elements(option.abs_colorterms) ne n_elements(option.abs_colortermbands) then $
        message,"N(abs_colortermbands) must equal N(abs_colorterms)"
     if n_elements(option.abs_colorterms) ne n_elements(option.abs_colormult) then $
        message,"N(abs_colormult) must equal N(abs_colorterms)"
  endif

;;; Check bands
  n_bands=n_elements(option.bands)
  if n_elements(option.mag_min) ne n_bands and $
     n_elements(option.mag_min) ne 1 then $
        message,"N(mag_min) must equal N(bands)"
  if n_elements(option.mag_max) ne n_bands and $
     n_elements(option.mag_max) ne 1 then $
        message,"N(mag_max) must equal N(bands)"

  return,option

end
