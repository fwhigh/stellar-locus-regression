pro slr_get_data, fieldname=fieldname,$
                  option=option,$
                  limits=limits,$
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
;      fieldname=fieldname,option=option,limits=limits,$
;      data=data
;
; INPUTS:
;  fieldname (string)  Name of a field with corresponding colortable
;                      fieldname+'.ctab'
;
; OPTIONAL INPUTS:
;  option (struct)  Global options
;  limits (struct)  Global hard limits on the data
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


;  on_error,2


  if not keyword_set(fieldname) then begin
     message,"Must specify a field name"
  endif
  if not keyword_set(option) then begin
     message,"Using default options",/info
     option=slr_options()
  endif
  if not keyword_set(limits) then begin
     message,"Using default limits",/info
     limits=slr_limits()
  endif
  

;;; Set psym=8 to be a circle for plotting
  usersym, cos(2*!pi*findgen(21)/20), sin(2*!pi*findgen(21)/20), /fill 

;;; Initialize the data structure
  data=create_struct("field",fieldname,limits)

;;; Define the math default structures
  math_step1={type:0,$
              dim:3,$
              kappa:{n:3,$
                     names:['k1','k2','k3'],$
                     guess:limits.kappa_guess[0:2],$
                     range:limits.kappa_guess_range[0:2],$
                     val  :limits.kappa_guess[0:2],$
                     fixed:[   0,   0,   0]},$
              m:{n:4,$
                 names:['bg','br','bi','bz'],$
                 guess:[  0.,  0.,  0.,  0.],$
                 range:[  1.,  1.,  1.,  1.],$
                 val  :[  0.,  0.,  0.,  0.],$
                 fixed:[   1,   1,   1,   1]}$
             }
  math_step2={type:3,$
              dim:4,$
              kappa:{n:4,$
                     names:['k1','k2','k3','k4'],$
                     guess:limits.kappa_guess[0:3],$
                     range:limits.kappa_guess_range[0:3],$
                     val  :limits.kappa_guess[0:3],$
                     fixed:[   1,   1,   1,   0]},$
              m:{n:4,$
                 names:['bg','br','bi','bz'],$
                 guess:[  0.,  0.,  0.,  0.],$
                 range:[  1.,  1.,  1.,  1.],$
                 val  :[  0.,  0.,  0.,  0.],$
                 fixed:[   1,   1,   1,   1]}$
             }
  math_step3={type:0,$
              dim:3,$
              kappa:{n:3,$
                     names:['k1','k2','k3'],$
                     guess:limits.kappa_guess[0:2],$
                     range:limits.kappa_guess_range[0:2],$
                     val  :limits.kappa_guess[0:2],$
                     fixed:[   1,   1,   1]},$
              m:{n:4,$
                 names:['bg','br','bi','bz'],$
                 guess:[  0.,  0.,  0.,  0.],$
                 range:[  0.1,  0.1,  0.1,  0.1],$
                 val  :[  0.,  0.,  0.,  0.],$
                 fixed:[   0,   0,   0,   0]}$
             }
  math_step4={type:0,$
              dim:3,$
              kappa:{n:3,$
                     names:['k1','k2','k3'],$
                     guess:limits.kappa_guess[0:2],$
                     range:limits.kappa_guess_range[0:2],$
                     val  :limits.kappa_guess[0:2],$
                     fixed:[   0,   0,   0]},$
              m:{n:4,$
                 names:['bg','br','bi','bz'],$
                 guess:[  0.,  0.,  0.,  0.],$
                 range:[  0.3,  0.3,  0.3,  0.3],$
                 val  :[  0.,  0.,  0.,   0],$
                 fixed:[   0,   0,   0,   0]}$
             }
  math_step5={type:5,$
              dim:3,$
              kappa:{n:3,$
                     names:['k1','k2','k3'],$
                     guess:limits.kappa_guess[0:2],$
                     range:limits.kappa_guess_range[0:2],$
                     val  :limits.kappa_guess[0:2],$
                     fixed:[   0,   0,   0]},$
              m:{n:3,$
                 names:['bg','br','bi'],$
                 guess:[  0.,  0.,  0.],$
                 range:[  0.3,  0.3,  0.3],$
                 val  :[  0.,  0.,  0.],$
                 fixed:[   0,   0,   0]}$
             }
  math_step6={type:5,$
              dim:3,$
              kappa:{n:3,$
                     names:['k1','k2','k3'],$
                     guess:limits.kappa_guess[0:2],$
                     range:limits.kappa_guess_range[0:2],$
                     val  :limits.kappa_guess[0:2],$
                     fixed:[   0,   0,   0]},$
              m:{n:3,$
                 names:['bg','br','bi'],$
                 guess:[  0.,  0.,  0.],$
                 range:[  0.3,  0.3,  0.3],$
                 val  :[  0.,  0.,  0.],$
                 fixed:[   1,   1,   1]}$
             }
  math_step7={type:6,$
              dim:4,$
              kappa:{n:4,$
                     names:['k1','k2','k3','k4'],$
                     guess:limits.kappa_guess[0:3],$
                     range:limits.kappa_guess_range[0:3],$
                     val  :limits.kappa_guess[0:3],$
                     fixed:[   1,   1,   1,   0]},$
              m:{n:4,$
                 names:['bg','br','bi','bz'],$
                 guess:[  0.,  0.,  0.,  0.],$
                 range:[  1.,  1.,  1.,  1.],$
                 val  :[  0.,  0.,  0.,  0.],$
                 fixed:[   1,   1,   1,   1]}$
             }
  math_step8={type:7,$
              dim:7,$
              kappa:{n:7,$
                     names:['k1','k2','k3','k4','k5','k6','k7'],$
                     guess:limits.kappa_guess[0:6],$
                     range:limits.kappa_guess_range[0:6],$
                     val  :limits.kappa_guess[0:6],$
                     fixed:[   1,   1,   1,   0,0,0,0]},$
              m:{n:4,$
                 names:['bg','br','bi','bz'],$
                 guess:[  0.,  0.,  0.,  0.],$
                 range:[  1.,  1.,  1.,  1.],$
                 val  :[  0.,  0.,  0.,  0.],$
                 fixed:[   1,   1,   1,   1]}$
             }



  savefile=slr_datadir()+path_sep()+$
           data.field+'_data.sav'

  if file_test(savefile) and not keyword_set(force) then begin
     restore,savefile
  endif else if fieldname ne 'none' then begin



     ctabfile=slr_get_ctab_filename(data.field)
     ctab=slr_read_colortable(ctabfile,/verbose,force=force)

;     if option.use_ir or fieldname eq 'ubercal_lowext2_fwhigh' then begin
     if option.use_ir then begin
        tmassfile_in=slr_get_2mass_filename(data.field)
        tmassfile_out=slr_get_2mass_filename(data.field,/out)
        if not file_test(tmassfile_in) or not file_test(tmassfile_out) then begin
           slr_write_2mass_tbl,tmassfile_in,data.field,ctab
           message,"Go to 2MASS Gator web site to get IR stars",/info
           stop
        endif

        tmasscat=slr_read_2mass_table(tmassfile_out)

        slr_plot_ctab_2mass,ctab,data.field,tmasscat,plot=option.plot,$
                            interactive=option.interactive

        irobji=where(finite(tmasscat.J_msigcom) and $
;                  finite(tmasscat.H_msigcom) and $
;                  finite(tmasscat.K_msigcom) and $
;                  finite(tmasscat.j_h) and $
;                  finite(tmasscat.H_K) and $
                     tmasscat.j_h ne 0.,$ ; and $
;                  abs((ctab.dec[tmasscat.cntr_u-1]-tmasscat.dec)*3600.) lt 0.6, $
                     ircount  )
;;      if ircount eq 0 then stop
        if option.verbose ge 1 then begin
           print,ircount,' good IR mags out of ',n_elements(tmasscat.J_m),' IR objs'
        endif
        
        tmassi=(tmasscat.cntr_u-1)[irobji]

     endif else begin
        tmassi=lindgen(n_elements(ctab.g))
     endelse

     euler_2000_fast, ctab.ra, ctab.dec, $
                      ell, bee, 1
     extinction_a=dust_getval(ell,bee,/interp)
     k_ext=(slr_sfd_coeff())[1:*]

     obji=where(1/ctab.g_err gt data.snlow and $
                1/ctab.r_err gt data.snlow and $
                1/ctab.i_err gt data.snlow and $
                1/ctab.z_err gt data.snlow and $
                ctab.g lt data.gmax and $
;           ctab.g_galext lt 0.2 and $
                abs(bee) gt data.beelow and $
                (data.stars_and_gals or $
                 (ctab.type eq data.type and ctab.tmixed eq data.tmixed)), $
                ngood)

     if ngood le 1 then begin
        message,"No good objects!"
     endif

;     euler_2000_fast, ctab.ra, ctab.dec, $
;                      ell, bee, 1
;     extinction_a=dust_getval(ell,bee,/interp)
;     k_ext=(slr_sfd_coeff())[1:*]

     g    =ctab.g
     g_err=sqrt(ctab.g_err^2+data.magerr_floor^2)
     r    =ctab.r
     r_err=sqrt(ctab.r_err^2+data.magerr_floor^2)
     i    =ctab.i
     i_err=sqrt(ctab.i_err^2+data.magerr_floor^2)
     z    =ctab.z
     z_err=sqrt(ctab.z_err^2+data.magerr_floor^2)
     if option.use_ir then begin
        euler_2000_fast, tmasscat.ra, tmasscat.dec, $
                         irell, irbee, 1
        irextinction_a=dust_getval(ell,bee,/interp)
        tmasscat.J_m = tmasscat.J_m
        tmasscat.H_m = tmasscat.H_m
        tmasscat.K_m = tmasscat.K_m
     endif

     if option.verbose ge 1 then begin
        print,'Galactic latitude',$
              mean(bee),'+/-',stddev(bee)
        print,'Galactic longitude',$
              mean(ell),'+/-',stddev(ell)
        print,'cal mean galext in g-r',$
              mean((extinction_a*k_ext[0]-extinction_a*k_ext[1])[obji]),$
              '+/-',stddev((extinction_a*k_ext[0]-extinction_a*k_ext[1])[obji])
        print,'cal mean galext in r-i',$
              mean((extinction_a*k_ext[1]-extinction_a*k_ext[2])[obji]),$
              '+/-',stddev((extinction_a*k_ext[1]-extinction_a*k_ext[2])[obji])
        print,'cal mean galext in i-z',$
              mean((extinction_a*k_ext[2]-extinction_a*k_ext[3])[obji]),$
              '+/-',stddev((extinction_a*k_ext[2]-extinction_a*k_ext[3])[obji])
        if option.use_ir  then begin
           print,'cal mean galext in z-J',$
                 mean((extinction_a*k_ext[3]-extinction_a*k_ext[4])[obji]),$
                 '+/-',stddev((extinction_a*k_ext[3]-extinction_a*k_ext[4])[obji])
        endif
        print,'cal mean galext in g-i',$
              mean((extinction_a*k_ext[0]-extinction_a*k_ext[2])[obji]),$
              '+/-',stddev((extinction_a*k_ext[0]-extinction_a*k_ext[2])[obji])
     endif

;;;  Photometric parallax, Juric et al 2008
     Zee = slr_galactic_zee1(r,i,bee)
     disti=where(zee lt data.zeelow)
     Zee = slr_galactic_zee2(r,i,bee)
     disti=setunion(disti,where(zee lt data.zeelow))
     if option.verbose ge 1 then begin
        print,n_elements(disti),' cal objects are in the disk'
     endif

     if data.cutdiskstars then begin
        print,"Cutting disk stars"
        obji=setintersection(obji,$
                             setdifference(lindgen(n_elements(r)),disti))
     endif

     locus={ctabfile:ctabfile,$
            ctab:ctab,$
            g:g,$
            g_err:g_err,$
            r:r,$
            r_err:r_err,$
            i:i,$
            i_err:i_err,$
            z:z,$
            z_err:z_err,$
            ell:ell,$
            bee:bee,$
;        g_galext:ctab.g_galext,$
;        r_galext:ctab.r_galext,$
;        i_galext:ctab.i_galext,$
;        z_galext:ctab.z_galext,$
            g_galext:extinction_a*k_ext[0],$
            r_galext:extinction_a*k_ext[1],$
            i_galext:extinction_a*k_ext[2],$
            z_galext:extinction_a*k_ext[3],$
            ebv_galext:extinction_a,$
            obji:obji,$
            tmassi:tmassi}

     xtitles=['g - r','r - i','i - z']

     if option.use_ir then begin
        
        irlocus={J:    tmasscat.J_m[irobji],$
                 J_err:tmasscat.J_msigcom[irobji],$
                 H:    tmasscat.H_m[irobji],$
                 H_err:tmasscat.H_msigcom[irobji],$
                 K:    tmasscat.K_m[irobji],$
                 K_err:tmasscat.K_msigcom[irobji],$
                 J_H:  tmasscat.J_H[irobji],$
                 H_K:  tmasscat.H_K[irobji],$
                 J_galext:extinction_a*k_ext[4] }

        xtitles=push_arr(xtitles,['i - 2J + H'])

        locus=create_struct(locus,irlocus)
     endif

     locus=create_struct(locus,'xtitles',xtitles)

     data=create_struct(data,"locus",locus)

;;; Get the initial math for calibrated data

     data=create_struct(data,"math1",math_step1)
     data=create_struct(data,"math2",math_step2)
     data=create_struct(data,"math3",math_step3)
     data=create_struct(data,"math4",math_step4)
     data=create_struct(data,"math5",math_step5)
     data=create_struct(data,"math6",math_step6)
     data=create_struct(data,"math7",math_step7)
     data=create_struct(data,"math8",math_step8)

     case option.dist_fittype of
        0:begin
           data.math1.kappa.guess=data.kappa_guess[0:2]
           data.math1.kappa.range=data.kappa_guess_range[0:2]
           data.math1.kappa.val  =data.kappa_guess[0:2]

           data.math2.kappa.guess=data.kappa_guess[0:3]
           data.math2.kappa.range=data.kappa_guess_range[0:3]
           data.math2.kappa.val  =data.kappa_guess[0:3]

           data.math3.kappa.guess=data.kappa_guess[0:2]
           data.math3.kappa.range=data.kappa_guess_range[0:2]
           data.math3.kappa.val  =data.kappa_guess[0:2]

        end
        else:begin
           message,"Don't know dist_fittype "+strtrim(option.dist_fittype,2)
        end
     endcase

     if option.use_ir then begin
        delvarx,tind
        alli=slr_get_good_indices(data,option,tmass_indices=tind)
        if option.verbose ge 1 then begin
           print,n_elementS(alli),' good matches in grizJ'
        endif

        data=create_struct(data,"opti_ir",alli)
        data=create_struct(data,"iri_ir",tind)
     endif

     save,file=savefile,data
  endif                         ; Savefile exists

     if option.plot then begin
        if n_elements(data.locus.obji) lt 5e3 then begin
           if option.use_ir then begin
              slr_locus_cubes,field=data.field,$
                              gr=data.locus.g[alli]-data.locus.r[alli],$
                              ri=data.locus.r[alli]-data.locus.i[alli],$
                              iz=data.locus.i[alli]-data.locus.z[alli],$
                              zJ=data.locus.z[alli]-data.locus.J[tind],$
                              interactive=option.interactive,$
                              postscript=option.postscript
           endif else begin
              slr_locus_cubes,field=data.field,$
                              gr=data.locus.g[data.locus.obji]-data.locus.r[data.locus.obji],$
                              ri=data.locus.r[data.locus.obji]-data.locus.i[data.locus.obji],$
                              iz=data.locus.i[data.locus.obji]-data.locus.z[data.locus.obji],$
                              interactive=option.interactive,$
                              postscript=option.postscript
           endelse
        endif else begin
;           slr_plot_locus
        endelse
     endif
     


  return

end