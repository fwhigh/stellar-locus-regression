function isnumber, var

  if size(var,/tname) eq "INT" or size(var,/tname) eq "LONG" or $
     size(var,/tname) eq "UINT" or size(var,/tname) eq "ULONG" or $
     size(var,/tname) eq "LONG64" or size(var,/tname) eq "ULONG64" or $
     size(var,/tname) eq "FLOAT" or size(var,/tname) eq "DOUBLE" or $
     size(var,/tname) eq "BYTE" then $
        return,1 else return,0

end

pro slr_check4option, file_option, $
                      par, $
                      index, $
                      isrequired=isrequired, $
                      boolean=boolean, $
                      isthere=isthere

  if size(file_option,/tname) eq "UNDEFINED" then begin
     if keyword_set(isrequired) then $
        message,"Must provide input parameter: "+par
     isthere=0
  endif else begin
     file_pars=strlowcase(tag_names(file_option))
     index=where(file_pars eq par,count)
     if count eq 1 then isthere=1 else isthere=0
     if ~isthere and keyword_set(isrequired) then $
        message,"Must provide input parameter: "+par
     if keyword_set(boolean) then begin
        if fix(file_option.(index)) ne 0 and fix(file_option.(index)) ne 1 then $
           message,"Input parameter "+par+" must be 0 or 1"
     endif
  endelse

end

function slr_options, file=file, $
                      _EXTRA = ex

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


;;;
;;; BEGIN FILE PARSE
;;;

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
     file_par=push_arr(file_par,pair[0])
     file_val=push_arr(file_val,pair[1])
  ENDWHILE 
  close,lun

  file_option=create_struct(       "version",slr_version())

  for ii=0,n_elements(file_par)-1 do begin
     file_option=create_struct(file_option,file_par[ii],file_val[ii])
  endfor

  option=create_struct(       "version",slr_version())

;;; Verbosity
  this_par="verbose"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=fix(ex.(here2)) else val=fix(file_option.(here1))
  option=create_struct(option,this_par,val)

  if option.verbose ge 1 then begin
     message,"Using config file "+file,/info
  endif

  this_par="debug"
  slr_check4option,file_option,this_par,here1,/isrequired,/boolean
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=fix(ex.(here2)) else val=fix(file_option.(here1))
  option=create_struct(option,this_par,val)

  this_par="force"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=fix(ex.(here2)) else val=fix(file_option.(here1))
  option=create_struct(option,this_par,val)

;;; Colors 2 calibrate
  this_par="colors2calibrate"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then begin
     val=slr_color_string_to_struct_tag($
         strsplit(ex.(here2),',',/extract),bands=bands,isknown=isknown)
  endif else begin
     val=slr_color_string_to_struct_tag($
         strsplit(file_option.(here1),',',/extract),bands=bands,isknown=isknown)
  endelse
  if total(isknown) ne n_elements(val) then $
     message,"Don't recognize color(s): "+$
             strjoin(val[where(~isknown)],',')
  if n_elements(val) lt 2 then $
     message,"Must provide at least 2 colors2calibrate"
  option=create_struct(option,this_par,val)
  option=create_struct(option,"bands",bands)
  n_colors=n_elements(option.colors2calibrate)
  n_bands=n_elements(option.bands)

  this_par="kappa_fix"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then begin
     val=ex.(here2)
     if ~isnumber(val) then $
           message,this_par+" must be a vector of numbers"
  endif else begin
     val=fix(strsplit(file_option.(here1),',',/extract))
  endelse
  if n_elements(val) ne n_colors then $
     message,"N("+this_par+") must equal N(colors2calibrate)"
  option=create_struct(option,this_par,val)

  this_par="kappa_guess"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then begin
     val=ex.(here2)
     if ~isnumber(val) then $
           message,this_par+" must be a vector of numbers"
  endif else begin
     val=float(strsplit(file_option.(here1),',',/extract))
  endelse
  if n_elements(val) ne n_colors then $
     message,"N("+this_par+") must equal N(colors2calibrate)"
  option=create_struct(option,this_par,val)

  this_par="kappa_guess_err"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then begin
     val=ex.(here2)
     if ~isnumber(val) then $
           message,this_par+" must be a vector of numbers"
  endif else begin
     val=float(strsplit(file_option.(here1),',',/extract))
  endelse
  if n_elements(val) ne n_colors then $
     message,"N("+this_par+") must equal N(colors2calibrate)"
  option=create_struct(option,this_par,val)

  this_par="kappa_guess_range"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then begin
     val=ex.(here2)
     if ~isnumber(val) then $
           message,this_par+" must be a vector of numbers"
  endif else begin
     val=float(strsplit(file_option.(here1),',',/extract))
  endelse
  if n_elements(option.kappa_fix) ne n_colors then $
     message,"N("+this_par+") must equal N(colors2calibrate)"
  option=create_struct(option,this_par,val)

;;; Color terms
  this_par="colorterms"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then begin
     val=ex.(here2)
     if size(val,/tname) eq "STRING" then  begin
        
     endif else begin
        if ~isnumber(val) then $
           message,this_par+" must be a vector of numbers or 'none'"
     endelse
  endif else begin
     val=file_option.(here1)
  endelse
  val=strsplit(val,',',/extract)
  if n_elements(val) eq 1 then begin
     if val eq 'none' then $
        val=!values.f_nan; else $
;           message,"Don't understand value of "+this_par
  endif
  val=float(val)
  option=create_struct(option,this_par,val)
  n_colorterms=n_elements(option.colorterms)

  this_par="colortermbands"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if n_colorterms eq 1 and ~finite(option.colorterms[0]) then begin
     val=''
  endif else begin
     if isthere then begin
        val=strsplit(ex.(here2),',',/extract)
     endif else begin
        val=strsplit(file_option.(here1),',',/extract)
     endelse
     val=slr_band_string_to_struct_tag(val,isknown=isknown)
     if n_elements(val) ne n_colorterms then $
        message,"N("+this_par+") must equal N(colorsterms)"
     if total(isknown) ne n_colorterms then $
        message,"Don't know colorterm band(s): "+$
                strjoin(val[where(~isknown)],',')
     for ii=0,n_elements(val)-1 do begin
        if total(option.bands eq val[ii]) eq 0 then $
           message,"The colorterm band "+val[ii]+$
                   " doesn't appear in colors2calibrate"
     endfor
  endelse
     option=create_struct(option,this_par,val)

  this_par="colormult"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if n_colorterms eq 1 and ~finite(option.colorterms[0]) then begin
     val=''
  endif else begin
     if isthere then begin
        val=strsplit(ex.(here2),',',/extract)
     endif else begin
        val=strsplit(file_option.(here1),',',/extract)
     endelse
    val=slr_color_string_to_struct_tag(val,isknown=isknown)
    if n_elements(val) ne n_colorterms then $
       message,"N("+this_par+") must equal N(colorsterms)"
    if total(isknown) ne n_colorterms then $
       message,"Don't know colorterm multiplier(s): "+$
               strjoin(val[where(~isknown)],',')
     for ii=0,n_elements(val)-1 do begin
        if total(option.colors2calibrate eq val[ii]) eq 0 then $
           message,"The colorterm multiplier "+val[ii]+$
                   " doesn't appear in colors2calibrate"
     endfor
  endelse
  option=create_struct(option,this_par,val)


;;; Plotting
  this_par="plot"
  slr_check4option,file_option,this_par,here1,/isrequired,/boolean
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=fix(ex.(here2)) else val=fix(file_option.(here1))
  option=create_struct(option,this_par,val)

  this_par="postscript"
  slr_check4option,file_option,this_par,here1,/isrequired,/boolean
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=fix(ex.(here2)) else val=fix(file_option.(here1))
  option=create_struct(option,this_par,val)

  this_par="animate_regression"
  slr_check4option,file_option,this_par,here1,/isrequired,/boolean
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=fix(ex.(here2)) else val=fix(file_option.(here1))
  option=create_struct(option,this_par,val)

  this_par="interactive"
  slr_check4option,file_option,this_par,here1,/isrequired,/boolean
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=fix(ex.(here2)) else val=fix(file_option.(here1))
  option=create_struct(option,this_par,val)

;;; Fitting 
  this_par="transform_only"
  slr_check4option,file_option,this_par,here1,/isrequired,/boolean
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=fix(ex.(here2)) else val=fix(file_option.(here1))
  option=create_struct(option,this_par,val)

  this_par="weighted_residual"
  slr_check4option,file_option,this_par,here1,/isrequired,/boolean
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=fix(ex.(here2)) else val=fix(file_option.(here1))
  option=create_struct(option,this_par,val)

  this_par="nbootstrap"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=fix(ex.(here2)) else val=fix(file_option.(here1))
  option=create_struct(option,this_par,val)


;;; SFD
  this_par="have_sfd"
  slr_check4option,file_option,this_par,here1,/isrequired,/boolean
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=fix(ex.(here2)) else val=fix(file_option.(here1))
  option=create_struct(option,this_par,val)
  if option.have_sfd then begin
     if ~slr_have_sfd() then begin
        message,"Can't locate SFD maps"
     endif
  endif

;;; Cuts for data
  this_par="type"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=fix(ex.(here2)) else val=fix(file_option.(here1))
  option=create_struct(option,this_par,val)

  this_par="tmixed"
  slr_check4option,file_option,this_par,here1,/isrequired,/boolean
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=fix(ex.(here2)) else val=fix(file_option.(here1))
  option=create_struct(option,this_par,val)

  this_par="deredden"
  slr_check4option,file_option,this_par,here1,/isrequired,/boolean
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=fix(ex.(here2)) else val=fix(file_option.(here1))
  option=create_struct(option,this_par,val)
  if option.deredden and ~option.have_sfd then $
     message,"Can't deredden without SFD maps"

  this_par="cutdiskstars"
  slr_check4option,file_option,this_par,here1,/isrequired,/boolean
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=fix(ex.(here2)) else val=fix(file_option.(here1))
  option=create_struct(option,this_par,val)

  this_par="zeelow"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=float(ex.(here2)) else val=float(file_option.(here1))
  option=create_struct(option,this_par,val)

  this_par="beelow"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=float(ex.(here2)) else val=float(file_option.(here1))
  option=create_struct(option,this_par,val)

  this_par="snlow"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then begin
     val=float(strsplit(ex.(here2),',',/extract))
  endif else begin
     val=float(strsplit(file_option.(here1),',',/extract))
  endelse
  if n_elements(val) eq 1 then begin
     val=replicate(val[0],n_bands)
  endif else if n_elements(val) eq n_bands then begin
     val=val[0]
  endif else begin
     message,"N("+this_par+") must equal N(bands) or 1"
  endelse
  option=create_struct(option,this_par,val)

  this_par="color_min"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then begin
     val=float(strsplit(ex.(here2),',',/extract))
  endif else begin
     val=float(strsplit(file_option.(here1),',',/extract))
  endelse
  if n_elements(val) eq 1 then begin
     val=replicate(val[0],n_bands)
  endif else if n_elements(val) eq n_bands then begin
     val=val[0]
  endif else begin
     message,"N("+this_par+") must equal N(colors) or 1"
  endelse
  option=create_struct(option,this_par,val)

  this_par="color_max"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then begin
     val=float(strsplit(ex.(here2),',',/extract))
  endif else begin
     val=float(strsplit(file_option.(here1),',',/extract))
  endelse
  if n_elements(val) eq 1 then begin
     val=replicate(val[0],n_bands)
  endif else if n_elements(val) eq n_bands then begin
     val=val[0]
  endif else begin
     message,"N("+this_par+") must equal N(colors) or 1"
  endelse
  option=create_struct(option,this_par,val)

  this_par="mag_min"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then begin
     val=float(strsplit(ex.(here2),',',/extract))
  endif else begin
     val=float(strsplit(file_option.(here1),',',/extract))
  endelse
  if n_elements(val) eq 1 then begin
     val=replicate(val[0],n_bands)
  endif else if n_elements(val) eq n_bands then begin
     val=val[0]
  endif else begin
     message,"N("+this_par+") must equal N(bands) or 1"
  endelse
  option=create_struct(option,this_par,val)

  this_par="mag_max"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then begin
     val=float(strsplit(ex.(here2),',',/extract))
  endif else begin
     val=float(strsplit(file_option.(here1),',',/extract))
  endelse
  if n_elements(val) eq 1 then begin
     val=replicate(val[0],n_bands)
  endif else if n_elements(val) eq n_bands then begin
     val=val[0]
  endif else begin
     message,"N("+this_par+") must equal N(bands) or 1"
  endelse
  option=create_struct(option,this_par,val)

  this_par="magerr_floor"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then begin
     val=float(strsplit(ex.(here2),',',/extract))
  endif else begin
     val=float(strsplit(file_option.(here1),',',/extract))
  endelse
  if n_elements(val) eq 1 then begin
     val=replicate(val[0],n_bands)
  endif else if n_elements(val) eq n_bands then begin
     val=val[0]
  endif else begin
     message,"N("+this_par+") must equal N(bands) or 1"
  endelse
  option=create_struct(option,this_par,val)

  this_par="max_locus_dist"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=float(ex.(here2)) else val=float(file_option.(here1))
  option=create_struct(option,this_par,val)

  this_par="max_weighted_locus_dist"
  slr_check4option,file_option,this_par,here1,/isrequired
  slr_check4option,ex,this_par,here2,isthere=isthere
  if isthere then val=float(ex.(here2)) else val=float(file_option.(here1))
  option=create_struct(option,this_par,val)

  return,option

end
