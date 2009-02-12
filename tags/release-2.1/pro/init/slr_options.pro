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

  compile_opt idl2, hidden

  on_error,2

  if not keyword_set(file) then begin
     file=getenv('SLR_INSTALL')+path_sep()+$
                 'config'+path_sep()+'default_slr.config'
;     message,"Using default config file "+file,/info
  endif
  if not file_test(file) then begin
     message,"Config file "+file+" not found"
  endif

  readcol,file,$
          par,val,$
          /silent,$
          delimiter=' ',$
          comment='#',$
          format='(A,A)'

  option=create_struct(       "version",'2.0')
  for ii=0,n_elements(par)-1 do begin
     case par[ii] of 
        "use_ir":begin
           option=create_struct(option,par[ii],fix(val[ii]))
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
        "gimin":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "gimax":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "grmin":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "grmax":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "rimin":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "rimax":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "izmin":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "izmax":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "zJmin":begin
           option=create_struct(option,par[ii],float(val[ii]))
        end
        "zJmax":begin
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
        "kappa_guess":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],float(tmpval))
        end
        "kappa_guess_range":begin
           tmpval=strsplit(val[ii],',',/extract)
           option=create_struct(option,par[ii],float(tmpval))
        end
        else:begin
           message,"Input parameter "+par[ii]+" unknown"
        end
     endcase
  endfor

  if option.verbose ge 1 then begin
     message,"Using config file "+file,/info
  endif

  return,option

end
