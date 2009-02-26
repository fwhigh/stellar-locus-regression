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
;  Reads stellar data from colortables, gets SFD Galactic extinction
;  values for each position, and initializes some other things.  For
;  large data sets, the initial execution of this procedure is slow,
;  but every time after it is faster thanks to the use of IDL .sav
;  files. 
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


  if file_test(savefile) and not keyword_set(force) then begin
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
           print,'cal mean galext in g-r',$
                 mean((extinction_a*k_ext[1]-extinction_a*k_ext[2])),$
                 '+/-',stddev((extinction_a*k_ext[1]-extinction_a*k_ext[2]))
           print,'cal mean galext in r-i',$
                 mean((extinction_a*k_ext[2]-extinction_a*k_ext[3])),$
                 '+/-',stddev((extinction_a*k_ext[2]-extinction_a*k_ext[3]))
           print,'cal mean galext in i-z',$
                 mean((extinction_a*k_ext[3]-extinction_a*k_ext[4])),$
                 '+/-',stddev((extinction_a*k_ext[3]-extinction_a*k_ext[4]))
           if option.use_ir  then begin
              print,'cal mean galext in z-J',$
                    mean((extinction_a*k_ext[4]-extinction_a*k_ext[5])),$
                    '+/-',stddev((extinction_a*k_ext[4]-extinction_a*k_ext[5]))
           endif
           print,'cal mean galext in g-i',$
                 mean((extinction_a*k_ext[1]-extinction_a*k_ext[3])),$
                 '+/-',stddev((extinction_a*k_ext[1]-extinction_a*k_ext[3]))
        endif
     endif

;;;  Photometric parallax, Juric et al 2008
     goodi=where(finite(ctab.r) and finite(ctab.i))
     Zee = slr_galactic_zee1(ctab.r[goodi],ctab.i[goodi],bee)
     disti=where(zee lt option.zeelow)
     Zee = slr_galactic_zee2(ctab.r[goodi],ctab.i[goodi],bee)
     disti=setunion(disti,where(zee lt option.zeelow))
     if option.verbose ge 1 then begin
        print,strtrim(n_elements(disti),2),$
              ' cal objects are in the disk (assuming colors already calibrated)'
     endif

     if option.cutdiskstars then begin
        print,"Cutting disk stars"
        obji=setintersection($
             obji,$
             setdifference(lindgen(n_elements(r)),disti))
     endif

     data=create_struct(data,"ctabfile",file)
     data=create_struct(data,"ctab",ctab)
     data=create_struct(data,"ell",ell)
     data=create_struct(data,"bee",bee)
     data=create_struct(data,"zee",zee)
     if slr_have_sfd() then begin
        data=create_struct(data,"u_galext",extinction_a*k_ext[0])
        data=create_struct(data,"g_galext",extinction_a*k_ext[1])
        data=create_struct(data,"r_galext",extinction_a*k_ext[2])
        data=create_struct(data,"i_galext",extinction_a*k_ext[3])
        data=create_struct(data,"z_galext",extinction_a*k_ext[4])
        data=create_struct(data,"J_galext",extinction_a*k_ext[5])
        data=create_struct(data,"H_galext",extinction_a*k_ext[6])
        data=create_struct(data,"K_galext",extinction_a*k_ext[7])
        data=create_struct(data,"ebv_galext",extinction_a)
     endif


;;; Define the math default structures
     fitpar0={type:0,$
             dim:n_elements(option.colors2calibrate),$
             n_colors:n_elements(option.colors2calibrate),$
             n_bands:n_elements(option.bands),$
             colornames:option.colors2calibrate,$
             bandnames:option.bands,$
             kappa:{n:n_elements(option.colors2calibrate),$
                    names:option.colors2calibrate,$
                    guess:option.kappa_guess,$
                    range:option.kappa_guess_range,$
                    val  :option.kappa_guess,$
                    err  :option.kappa_guess_err,$
                    fixed:option.kappa_fix},$
             b:{n:n_elements(option.colormult),$
                matrix:identity(n_elements(option.colors2calibrate)),$
                bands:option.colortermbands,$
                mult :option.colormult,$
                guess:replicate(0,n_elements(option.colormult)),$
                range:replicate(0,n_elements(option.colormult)),$
                val  :option.colorterms,$
                err  :replicate(0.001,n_elements(option.colorterms)),$
                fixed:replicate(1,n_elements(option.colormult))}$
            }
     fitpar0.b.matrix=slr_colorterm_matrix(fitpar0.b.val,$
                                           fitpar0)
     fitpar1={type:0,$
              dim:n_elements(option.abs_colors2calibrate),$
              n_colors:n_elements(option.abs_colors2calibrate),$
              n_bands:n_elements(option.abs_bands),$
              colornames:option.abs_colors2calibrate,$
              bandnames:option.abs_bands,$
              kappa:{n:n_elements(option.abs_colors2calibrate),$
                     names:option.abs_colors2calibrate,$
                     guess:option.abs_kappa_guess,$
                     range:option.abs_kappa_guess_range,$
                     val  :option.abs_kappa_guess,$
                     err  :option.abs_kappa_guess_err,$
                     fixed:option.abs_kappa_fix},$
              b:{n:n_elements(option.abs_colormult),$
                 matrix:identity(n_elements(option.abs_colors2calibrate)),$
                 bands:option.abs_colortermbands,$
                 mult :option.abs_colormult,$
                 guess:replicate(0,n_elements(option.abs_colormult)),$
                 range:replicate(0,n_elements(option.abs_colormult)),$
                 val  :option.abs_colorterms,$
                 err  :replicate(0.001,n_elements(option.colorterms)),$
                 fixed:replicate(1,n_elements(option.abs_colormult))}$
             }
     fitpar1.b.matrix=slr_colorterm_matrix(fitpar1.b.val,$
                                           fitpar1)

     data=create_struct(data,'fitpar0',fitpar0)
     data=create_struct(data,'fitpar1',fitpar1)

     if option.use_ir then begin
        goodi=slr_get_good_indices(data,option)
        if option.verbose ge 1 then begin
           print,n_elementS(goodi),' good matches in grizJ'
        endif
     endif

     save,file=savefile,data
  endif                         ; Savefile exists

  if option.plot then begin
     goodi=slr_get_good_indices(data,option,data.fitpar0)
     if n_elements(goodi) lt 5e3 then begin
        if 0 then begin
           slr_locus_cubes,field=data.field,$
                           gr=data.ctab.g[goodi]-data.ctab.r[goodi],$
                           ri=data.ctab.r[goodi]-data.ctab.i[goodi],$
                           iz=data.ctab.i[goodi]-data.ctab.z[goodi],$
                           interactive=option.interactive,$
                           postscript=option.postscript
        endif else begin
           datarr=slr_get_data_array(data,option,data.fitpar0,$
                                     err=datarr_err,$
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
        endelse
     endif else begin
;           slr_plot_locus
     endelse
  endif
  


  return

end
