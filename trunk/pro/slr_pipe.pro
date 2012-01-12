pro slr_pipe, infile=infile,$
              outfile=outfile,$
              configfile=configfile, $
              kappa_out=kappa_out, $
              kappa_err_out=kappa_err_out, $
              use_synthetic=use_synthetic,$
              _EXTRA = ex 

;$Rev:: 76            $:  Revision of last commit
;$Author:: fwhigh     $:  Author of last commit
;$Date:: 2009-02-04 1#$:  Date of last commit
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
;  slr_pipe
;
; PURPOSE:
;  The basic SLR pipeline to calibrate colors.
;
; EXPLANATION:
;  This is the main procedure that takes in data and calibrates it. In
;  practice, it is the program that wrappers will directly invoke.
;
; CALLING SEQUENCE:
;  slr_pipe,infile=infile,outfile=outfile,configfile=configfile,$
;   kappa_out=kappa_out,kappa_err_out=kappa_err_out,$
;   _EXTRA=ex
;
; INPUTS:
;  infile (string)    Input colortable file.
;
; OPTIONAL INPUTS:
;  configfile (string) File to get default configuration.
;  outfile    (string) File to write calibrated colors/mags to.  Must
;                      be provided if "write_ctab" is set.
;  *** You can provide any parameter that appears in the default
;  config file here as well. This is done by specifying the parameter
;  name verbatim, followed by the value. Parameters supplied on the
;  IDL commandline overwrite those appearing in the config file. These
;  parameters are passed immediately to slr_options via _EXTRA
;  keywords.  Lists must be passed in IDL format, not as strings of
;  comma separated values. See EXAMPLES.
;
; OUTPUTS:
;
; OPIONAL OUTPUTS:
;  kappa_out     (float array)  Output kappa
;  kappa_err_out (float array)  Error on kappa
;       
; NOTES:
;
; EXAMPLES:
;  The follow runs SLR on the example data, with some tweaked config
;  parameters, and gives access to the output calibrations "kappa".
;  % cd $SLR_INSTALL/example_data; idl
;  IDL> slr_pipe,infile='low_reddening.ctab',$
;  IDL> max_weighted_locus_dist=10,$
;  IDL> cutdiskstars=1,zeelow=100,$
;  IDL> nbootstrap=0,$
;  IDL> kappa_out=kappa_out
;  ...
;  IDL> print,kappa_out
;
; PROCEDURES USED:
;  slr_options
;  slr_get_data
;  slr_locus_line_calibration
;  slr_write_data
;       
; HISTORY:
;       Written by:     FW High Jan 2009
;-

  COMPILE_OPT idl2, HIDDEN
;on_error, 2

  start_time=systime(1)

;;; Get global default options, then set some of your own.
  if not keyword_set(configfile) then begin
     configfile=getenv('SLR_CONFIG_FILE')
  endif
  option=slr_options(file=configfile,$
                     _extra=ex)

  if not keyword_set(infile) then begin
     infile=getenv('SLR_COLORTABLE_IN')
  endif
  if infile eq '' then begin
     message,"You must specify an input colortable with the "+$
             "environment variable SLR_COLORTABLE_IN"
 endif

if not keyword_set(use_synthetic) then use_synthetic=0


  message,'Regressing data',/info
;;; Initialize data with low Galactic dust extinction
  slr_get_data,$
     file=infile,$
     force=option.force,$
     option=option,$
     data=data,$
    use_synthetic=use_synthetic

;;; Regress the data to the Covey median locus
  if ~option.transform_only then begin
     fitpar=data.fitpar
     slr_locus_line_calibration,$
        data=data,$
        option=option,$
        fitpar=fitpar,$
        galext_mean=galext_mean,$
        galext_stddev=galext_stddev,$
        bootstrap=(option.nbootstrap ne 0),$
        use_synthetic=use_synthetic
     data.fitpar=fitpar
  endif
  kappa_out=data.fitpar.kappa.val
  kappa_err_out=data.fitpar.kappa.err

;; ;;; Print the results
;;   print,'Resulting kappa vector:'
;;   for jj=0,n_elements(data.fitpar.colornames)-1 do begin
;;      print,' kappa ',data.fitpar.colornames[jj],' = ',$
;;            string(data.fitpar.kappa.val[jj],format='(F8.3)'),$
;;            ' +/-',string(data.fitpar.kappa.err[jj],format='(F7.3)')
;;   endfor

;;; Print the results
  fitpar=data.fitpar
  kappa=fitpar.kappa.val
  for jj=0,n_elements(fitpar.colornames)-1 do begin
     if fitpar.kappa.fixed[jj] then $
        fixed='(fixed)' else $
           fixed='(free) '
     slr_log,data.logfile,$
             'kappa '+slr_struct_tag_to_color_string(fitpar.colornames[jj])+$
             ' '+fixed+' '+string(kappa[jj],format='(F)')
     if keyword_set(reddening) then begin
        galext_mean=push_arr(galext_mean,mean(reddening[*,jj]))
        galext_stddev=push_arr(galext_stddev,stddev(reddening[*,jj]))
     endif
  endfor

  for jj=0,n_elements(fitpar.colornames)-1 do begin
     slr_log,data.logfile,$
             'kappa '+$
             slr_struct_tag_to_color_string(fitpar.colornames[jj])+$
             ' uncertainty '+$
             string(fitpar.kappa.err[jj],format='(F)')
  endfor

  if fitpar.b.bands[0] then begin
     lines='Color terms used (fixed):'
     for ii=0,n_elements(fitpar.b.val)-1 do begin
        lines=push_arr($
              lines,$
              slr_struct_tag_to_band_string(fitpar.b.bands[ii])+' = (...) +'+$
              string(fitpar.b.val[ii],format='(F7.3)')+$
              ' ('+$
              slr_struct_tag_to_color_string(fitpar.b.mult[ii],join='-')+$
              ')')
     endfor
  endif else begin
     lines='No color terms used'
  endelse

  slr_log,data.logfile,$
          lines


;;; Write calibrated data to file
  if option.write_ctab then begin
     if not keyword_set(outfile) then begin
        outfile=getenv('SLR_COLORTABLE_OUT')
     endif
     if outfile eq '' then begin
        outfile=slr_get_ctab_filename(infile,/out)
     endif

     slr_write_data,$
        option=option,$
        fitpar=data.fitpar,$
        data=data,$
        file=outfile
  endif

  message,"SLR successfully completed in "+$
          strtrim(string(SYSTIME(1)-start_time,format='(F10.3)'),2)+$
          ' seconds',/info
end
