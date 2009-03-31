pro slr_get_data, file=file,$
                  option=option,$
                  force=force,$
                  data=data

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
;  slr_get_data
;
; PURPOSE:
;  Get the stellar data from colortables optimally.
;
; EXPLANATION: 
;  Reads stellar data from colortables, optionally gets SFD Galactic
;  extinction values for each position, and initializes some other
;  things.  For large data sets, the initial execution of this
;  procedure is slow, but every time after it is faster thanks to the
;  use of IDL .sav files.
;
; CALLING SEQUENCE:
;  slr_get_data,$
;      file=file,option=option,$
;      data=data
;
; INPUTS:
;  file (string)  Name of a field with corresponding colortable
;                      file+'.ctab'
;
; OPTIONAL INPUTS:
;  option (struct)  Global options
;  force (bit)      Force to read the ascii rather than the .sav file?
;                   Default 0.
;
; OUTPUTS:
;  data (struct)  The data.
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
;
;-


;  compile_opt idl2, hidden
;  on_error,2

  if not keyword_set(file) then begin
     message,"Must specify a colortable"
  endif
  if ~file_test(file) then begin
     message,"Colortable "+file+" doesn't exist"
  endif
  if not keyword_set(option) then begin
     message,"Using default options",/info
     option=slr_options()
  endif
  if n_elements(force) eq 0 then force=1 else begin
     if keyword_set(force) then force=1 else force=0
  endelse

;;; Set psym=8 to be a circle for plotting
  usersym, cos(2*!pi*findgen(21)/20), sin(2*!pi*findgen(21)/20), /fill 

  fieldname=slr_colortable_file_to_fieldname(file)

;;; Initialize the data structure
  data=create_struct("field",fieldname)



  savefile=file+'.data.sav'

;;; Initialize the log file
  logfile=slr_get_log_filename(data.field)
  data=create_struct(data,"logfile",logfile)
  slr_log,data.logfile,$
          ["Stellar Locus Regression v"+option.version,$
           "High et al. 2009, AJ submitted",$
           "This run started "+systime()],$
          initialize=0


  if file_test(savefile) and ~force then begin
     restore,savefile
  endif else if fieldname ne 'none' then begin

     data=create_struct(data,"filename",file)
     ctab=slr_read_colortable(file,/verbose,force=force)

     euler_2000_fast, ctab.ra, ctab.dec, $
                      ell, bee, 1
     if slr_have_sfd() then begin
        extinction_a=dust_getval(ell,bee,/interp)
        k_ext=slr_sfd_coeff()

        if option.verbose ge 1 then begin
           print,'Galactic latitude',$
                 mean(bee),'+/-',stddev(bee)
           print,'Galactic longitude',$
                 mean(ell),'+/-',stddev(ell)
        endif
     endif

     data=create_struct(data,"ctabfile",file)
     data=create_struct(data,"ctab",ctab)
     data=create_struct(data,"ell",ell)
     data=create_struct(data,"bee",bee)
;;;  Photometric parallax, Juric et al 2008
     if tag_exist(ctab,'rsdss') and tag_exist(ctab,'isdss') then begin
        goodi=where(finite(ctab.rsdss) and finite(ctab.isdss))
        Zee = slr_galactic_zee1(ctab.rsdss[goodi],ctab.isdss[goodi],bee)
        disti=where(zee lt option.zeelow)
        Zee = slr_galactic_zee2(ctab.rsdss[goodi],ctab.isdss[goodi],bee)
        disti=setunion(disti,where(zee lt option.zeelow))
        if option.verbose ge 1 then begin
           print,strtrim(n_elements(disti),2),$
                 ' cal objects are in the disk (assuming colors already calibrated)'
        endif
        data=create_struct(data,"zee",zee)
     endif

     if slr_have_sfd() then begin
        data=create_struct(data,"usdss_galext",extinction_a*k_ext[0])
        data=create_struct(data,"gsdss_galext",extinction_a*k_ext[1])
        data=create_struct(data,"rsdss_galext",extinction_a*k_ext[2])
        data=create_struct(data,"isdss_galext",extinction_a*k_ext[3])
        data=create_struct(data,"zsdss_galext",extinction_a*k_ext[4])
        data=create_struct(data,"Jtmass_galext",extinction_a*k_ext[5])
        data=create_struct(data,"Htmass_galext",extinction_a*k_ext[6])
        data=create_struct(data,"Ktmass_galext",extinction_a*k_ext[7])
        data=create_struct(data,"ebv_galext",extinction_a)

        if option.verbose ge 1 then begin
           print,'Median E(B-V) = '+$
                 string(median(extinction_a),format='(F5.3)')+$
                 ' +/- '+$
                 string(stddev(extinction_a),format='(F5.3)')
        endif
     endif


;;; Define the math default structures
     fitpar={type:0,$
              dim:n_elements(option.colors2calibrate),$
              n_colors:n_elements(option.colors2calibrate),$
              n_bands:n_elements(option.bands),$
              colornames:option.colors2calibrate,$
              bandnames:option.bands,$
              kappa:{n:n_elements(option.colors2calibrate),$
                     names:option.colors2calibrate,$
                     guess:float(option.kappa_guess),$
                     range:float(option.kappa_guess_range),$
                     val  :float(option.kappa_guess),$
                     err  :float(option.kappa_guess_err),$
                     fixed:option.kappa_fix},$
              b:{n:n_elements(option.colormult),$
                 matrix:identity(n_elements(option.colors2calibrate)),$
                 bands:option.colortermbands,$
                 mult :option.colormult,$
                 guess:replicate(0.,n_elements(option.colormult)),$
                 range:replicate(0.,n_elements(option.colormult)),$
                 val  :float(option.colorterms),$
                 err  :replicate(0.001,n_elements(option.colorterms)),$
                 fixed:replicate(1,n_elements(option.colormult))}$
             }
     fitpar.b.matrix=slr_colorterm_matrix(fitpar.b.val,$
                                           fitpar)
     data=create_struct(data,'fitpar',fitpar)

     save,file=savefile,data
  endif                         ; Savefile exists

  if option.plot then begin
     goodi=slr_get_good_indices(data,option,data.fitpar)

     if n_elements(goodi) lt 5e3 and n_elements(goodi) ge 1 then begin
        datarr=slr_get_data_array(data,option,data.fitpar,$
                                  color_err=datarr_err,$
                                  output_indices=ind)
        covey=slr_read_covey_median_locus()

        scatter=1
        contour=~scatter
        fill=1
        linecolor=150
        histbin=0.05
        symsize=0.2
        n_dim=n_elements(option.colors2calibrate)
        y=slr_get_covey_data(option.colors2calibrate)

        erase & multiplot,[ceil(n_dim/2.),floor(n_dim/2.)],$
                          /dox,/doy,gap=0.05,$
                          mtitle='!6Input data'

        for ii=0,n_dim-2 do begin
           xrange=minmax([datarr[*,ii],y[*,ii]])
           yrange=minmax([datarr[*,ii+1],y[*,ii+1]])
           slr_plot_locus,$
              datarr[*,ii],datarr[*,ii+1],$
              contour=contour,scatter=scatter,djs_contour=contour,$
              fill=fill,linecolor=linecolor,ctable=ctable,$
              psym=8,symsize=symsize,charsize=charsize,$
              xtitle='!8'+option.colors2calibrate[ii]+'!6',$
              ytitle='!8'+option.colors2calibrate[ii+1]+'!6',$
              xrange=xrange,yrange=yrange,$
              nlevels=nlevels,histbin=histbin    
           oplot,y[*,ii],y[*,ii+1],thick=2
           
           multiplot,/dox,/doy
        endfor

        multiplot,/default

        if option.interactive then begin
           junk='' & read,'Hit enter',junk
        endif
     endif else begin
;           slr_plot_locus
     endelse
  endif
  


  return

end
