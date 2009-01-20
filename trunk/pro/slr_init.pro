pro slr_init, rawfield=rawfield,$
              calfield=calfield,$
              force=force, $
              option=option, $
              caldat=caldat, $
              rawdat=rawdat

;  common slr_globals, stl, caldat, rawdat

  if not keyword_set(calfield) then begin
     use_cal='lowext_stars3_fwhigh'
  endif else use_cal=calfield
  calfield=use_cal
  if not keyword_set(rawfield) then begin
     use_raw='s3' & instrument='imacs'
  endif else use_raw=rawfield

  option=create_struct(       "use_cal",use_cal)
  option=create_struct(option,"use_raw",use_raw)
  option=create_struct(option,"use_ir",0)
  option=create_struct(option,"postscript",0)
  option=create_struct(option,"plot",1)
  option=create_struct(option,"interactive",1)
  option=create_struct(option,"verbose",1)
  option=create_struct(option,"debug",0)
  option=create_struct(option,"do_hard_ones",1)
  option=create_struct(option,"get_color_offset",1)
  option=create_struct(option,"get_color_terms",0)
  option=create_struct(option,"match_objects",1)
  option=create_struct(option,"cut_outliers",0)
;  option=create_struct(option,"instrument",instrument)

  option=create_struct(option,"simulate",0)
  option=create_struct(option,"sample_study",0)
  option=create_struct(option,"max_sample_size",-1)
  option=create_struct(option,"nbootstrap",0)
;  option=create_struct(option,"cutranges",~option.simulate)
  option=create_struct(option,"cutranges",0)
  option=create_struct(option,"basis",1)
  option=create_struct(option,"minimizer",0)
  option=create_struct(option,"line_fittype",3)
  option=create_struct(option,"dist_fittype",0)
  option=create_struct(option,"nbins",25)
  option=create_struct(option,"startfrac",0.1)
  option=create_struct(option,"stopfrac",1.0)
  option=create_struct(option,"fitimp_thresh",0.4)



;;; Define hard data limits
  limits={type:1,$
          tmixed:0,$
          stars_and_gals:0,$
          deredden:0,$
          cutdiskstars:0,$
          beelow:0.,$
          zeelow:100,$
          snlow:10,$
          gsnlow:10,$
          gmax:1e10,$
          rmin:-100,$
          rmax:100,$
          gimin:-100,$
          gimax:100,$
          grmin:-100,$
          grmax:100,$
          rimin:-100,$
          rimax:100,$
          izmin:-100,$
          izmax:100,$
          zJmin:-1000,$
          zJmax:+1000,$
          magerr_floor:0.00,$
          max_locus_dist:1.0,$
          max_weighted_locus_dist:10,$
          kappa_guess:[0.0,-0.5,-1.0,-27.5,-27.5,-27.5,-27.5],$
          kappa_guess_range:[5.,5.,5.,5.,5.,5.,5.]$
         }
  caldat=create_struct("field",use_cal,limits)
  rawdat=create_struct("field",use_raw,limits)

;;; Define the math structures

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










;;; Calibrated
  cal_savefile=slr_datadir()+path_sep()+$
               caldat.field+'_caldat.sav'

  if file_test(cal_savefile) and not keyword_set(force) then begin
     restore,cal_savefile
  endif else if calfield ne 'none' then begin



     ctabfile=slr_get_ctab_filename(caldat.field)
     ctab=read_colortable(ctabfile,/verbose,force=force)

;     if option.use_ir or use_cal eq 'ubercal_lowext2_fwhigh' then begin
     if option.use_ir then begin
        tmassfile_in=slr_get_2mass_filename(caldat.field)
        tmassfile_out=slr_get_2mass_filename(caldat.field,/out)
        if not file_test(tmassfile_in) or not file_test(tmassfile_out) then begin
           slr_write_2mass_tbl,tmassfile_in,caldat.field,ctab
           message,"Go to 2MASS Gator web site to get IR stars",/info
           stop
        endif

        tmasscat=slr_read_2mass_table(tmassfile_out)

        slr_plot_ctab_2mass,ctab,caldat.field,tmasscat,plot=option.plot,$
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

     obji=where(1/ctab.g_err gt caldat.snlow and $
                1/ctab.r_err gt caldat.snlow and $
                1/ctab.i_err gt caldat.snlow and $
                1/ctab.z_err gt caldat.snlow and $
                ctab.g lt caldat.gmax and $
;           ctab.g_galext lt 0.2 and $
                abs(bee) gt caldat.beelow and $
                (caldat.stars_and_gals or $
                 (ctab.type eq caldat.type and ctab.tmixed eq caldat.tmixed)), $
                ngood)

     if ngood le 1 then begin
        message,"No good objects!"
     endif

;     euler_2000_fast, ctab.ra, ctab.dec, $
;                      ell, bee, 1
;     extinction_a=dust_getval(ell,bee,/interp)
;     k_ext=(slr_sfd_coeff())[1:*]

     g    =ctab.g
     g_err=sqrt(ctab.g_err^2+caldat.magerr_floor^2)
     r    =ctab.r
     r_err=sqrt(ctab.r_err^2+caldat.magerr_floor^2)
     i    =ctab.i
     i_err=sqrt(ctab.i_err^2+caldat.magerr_floor^2)
     z    =ctab.z
     z_err=sqrt(ctab.z_err^2+caldat.magerr_floor^2)
     if option.use_ir then begin
        euler_2000_fast, tmasscat.ra, tmasscat.dec, $
                         irell, irbee, 1
        irextinction_a=dust_getval(ell,bee,/interp)
        tmasscat.J_m = tmasscat.J_m
        tmasscat.H_m = tmasscat.H_m
        tmasscat.K_m = tmasscat.K_m
     endif

     if option.verbose ge 1 then begin
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
     disti=where(zee lt caldat.zeelow)
     Zee = slr_galactic_zee2(r,i,bee)
     disti=setunion(disti,where(zee lt caldat.zeelow))
     if option.verbose ge 1 then begin
        print,n_elements(disti),' cal objects are in the disk'
     endif

     if caldat.cutdiskstars then begin
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

     caldat=create_struct(caldat,"locus",locus)

;;; Get the initial math for calibrated data

     caldat=create_struct(caldat,"math1",math_step1)
     caldat=create_struct(caldat,"math2",math_step2)
     caldat=create_struct(caldat,"math3",math_step3)
     caldat=create_struct(caldat,"math4",math_step4)
     caldat=create_struct(caldat,"math5",math_step5)
     caldat=create_struct(caldat,"math6",math_step6)
     caldat=create_struct(caldat,"math7",math_step7)
     caldat=create_struct(caldat,"math8",math_step8)

     case option.dist_fittype of
        0:begin
           caldat.math1.kappa.guess=caldat.kappa_guess[0:2]
           caldat.math1.kappa.range=caldat.kappa_guess_range[0:2]
           caldat.math1.kappa.val  =caldat.kappa_guess[0:2]

           caldat.math2.kappa.guess=caldat.kappa_guess[0:3]
           caldat.math2.kappa.range=caldat.kappa_guess_range[0:3]
           caldat.math2.kappa.val  =caldat.kappa_guess[0:3]

           caldat.math3.kappa.guess=caldat.kappa_guess[0:2]
           caldat.math3.kappa.range=caldat.kappa_guess_range[0:2]
           caldat.math3.kappa.val  =caldat.kappa_guess[0:2]

        end
        else:begin
           message,"Don't know dist_fittype "+strtrim(option.dist_fittype,2)
        end
     endcase

     if option.use_ir then begin
        delvarx,tind
        alli=slr_get_good_indices(caldat,option,tmass_indices=tind)
        if option.verbose ge 1 then begin
           print,n_elementS(alli),' good matches in grizJ'
        endif

        caldat=create_struct(caldat,"opti_ir",alli)
        caldat=create_struct(caldat,"iri_ir",tind)
     endif

     if option.plot then begin
        if n_elements(caldat.locus.obji) lt 5e3 then begin
           if option.use_ir then begin
              slr_locus_cubes,field=caldat.field,$
                              gr=caldat.locus.g[alli]-caldat.locus.r[alli],$
                              ri=caldat.locus.r[alli]-caldat.locus.i[alli],$
                              iz=caldat.locus.i[alli]-caldat.locus.z[alli],$
                              zJ=caldat.locus.z[alli]-caldat.locus.J[tind],$
                              interactive=option.interactive,$
                              postscript=option.postscript
           endif else begin
              slr_locus_cubes,field=caldat.field,$
                              gr=caldat.locus.g[caldat.locus.obji]-caldat.locus.r[caldat.locus.obji],$
                              ri=caldat.locus.r[caldat.locus.obji]-caldat.locus.i[caldat.locus.obji],$
                              iz=caldat.locus.i[caldat.locus.obji]-caldat.locus.z[caldat.locus.obji],$
                              interactive=option.interactive,$
                              postscript=option.postscript
           endelse
        endif else begin
;           slr_plot_locus
        endelse
     endif
     
     save,file=cal_savefile,caldat
  endif                      ; Savefile exists
;  endelse                       ; Savefile exists




















;;; Raw data
  raw_savefile=slr_datadir()+path_sep()+$
               rawdat.field+'_rawdat.sav'

  if file_test(raw_savefile) and not keyword_set(force) then begin
     restore,raw_savefile
  endif else begin


     if keyword_set(option.simulate) then begin
        raw=cal
     endif else begin

        ctabfile=slr_get_ctab_filename(rawdat.field)
        ctab=read_colortable(ctabfile,/verbose,force=force)

        if option.use_ir then begin
           tmassfile_in=slr_get_2mass_filename(rawdat.field)
           tmassfile_out=slr_get_2mass_filename(rawdat.field,/out)
           if not file_test(tmassfile_in) or not file_test(tmassfile_out) then begin
              slr_write_2mass_tbl,tmassfile_in,rawdat.field,ctab
              message,"Go to 2MASS Gator web site to get IR stars",/info
              stop
           endif

           tmasscat=slr_read_2mass_table(tmassfile_out)

           slr_plot_ctab_2mass,ctab,rawdat.field,tmasscat,plot=option.plot,$
                               interactive=option.interactive

           irobji=where(finite(tmasscat.J_msigcom) and $
;                     finite(tmasscat.H_msigcom) and $
;                     finite(tmasscat.K_msigcom) and $
;                     finite(tmasscat.j_h) and $
;                     finite(tmasscat.H_K) and $
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

        k_ext=(slr_sfd_coeff())[1:*]
        euler_2000_fast, ctab.ra, ctab.dec, $
                         ell, bee, 1
        if not tag_exist(ctab,'g_galext') then begin
           print,'mean ell, bee',mean(ell),mean(bee)
           extinction_a=dust_getval(ell,bee,/interp)
           k_ext=(slr_sfd_coeff())[1:*]
        endif else begin
           print,'skipping dust_getval'
           extinction_a=ctab.g_galext/k_ext[0]
        endelse

        obji=where(1/ctab.g_err gt rawdat.snlow and $
                   1/ctab.r_err gt rawdat.snlow and $
                   1/ctab.i_err gt rawdat.snlow and $
                   1/ctab.z_err gt rawdat.snlow and $
;                   1/ctab.g_err gt rawdat.gsnlow and $
;               ctab.r gt rawdat.rmin and $
;               ctab.r le rawdat.rmax and $
;               ctab.g_galext gt median(ctab.g_galext)-0.005 and $
;               ctab.g_galext lt median(ctab.g_galext)+0.005 and $
;               ctab.ra gt 247 and ctab.ra lt 248 and $
;               ctab.dec gt 19 and ctab.dec lt 19.5 and $
                   (rawdat.stars_and_gals or $
                    (ctab.type eq caldat.type and ctab.tmixed eq caldat.tmixed)), $
                   n_matches)

        print,'n good raw stars ',n_matches
        if n_matches eq 0 then stop

        g    =ctab.g
        g_err=sqrt(ctab.g_err^2+rawdat.magerr_floor^2)
        r    =ctab.r
        r_err=sqrt(ctab.r_err^2+rawdat.magerr_floor^2)
        i    =ctab.i
        i_err=sqrt(ctab.i_err^2+rawdat.magerr_floor^2)
        z    =ctab.z
        z_err=sqrt(ctab.z_err^2+rawdat.magerr_floor^2)
        if option.use_ir then begin
           euler_2000_fast, tmasscat.ra, tmasscat.dec, $
                            irell, irbee, 1
           irextinction_a=dust_getval(ell,bee,/interp)
           tmasscat.J_m = tmasscat.J_m
           tmasscat.H_m = tmasscat.H_m
           tmasscat.K_m = tmasscat.K_m
        endif

        print,'raw mean galext in g-r',$
              mean((extinction_a*k_ext[0]-extinction_a*k_ext[1])[obji]),$
              '+/-',stddev((extinction_a*k_ext[0]-extinction_a*k_ext[1])[obji])
        print,'raw mean galext in r-i',$
              mean((extinction_a*k_ext[1]-extinction_a*k_ext[2])[obji]),$
              '+/-',stddev((extinction_a*k_ext[1]-extinction_a*k_ext[2])[obji])
        print,'raw mean galext in i-z',$
              mean((extinction_a*k_ext[2]-extinction_a*k_ext[3])[obji]),$
              '+/-',stddev((extinction_a*k_ext[2]-extinction_a*k_ext[3])[obji])
        print,'raw mean galext in g-i',$
              mean((extinction_a*k_ext[0]-extinction_a*k_ext[2])[obji]),$
              '+/-',stddev((extinction_a*k_ext[0]-extinction_a*k_ext[2])[obji])

;;;  Photometric parallax, Juric et al 2008
           r_corr=r-abs(extinction_a*k_ext[1])
           i_corr=i-abs(extinction_a*k_ext[2])
           Zee = slr_galactic_zee1(r_corr,i_corr,bee)
           disti=where(zee lt rawdat.zeelow)
           Zee = slr_galactic_zee2(r_corr,i_corr,bee)
           disti=setunion(where(zee lt rawdat.zeelow),disti)
           if option.verbose ge 1 then begin
              print,n_elements(disti),' raw objects are in the disk'
           endif

           
           if rawdat.cutdiskstars then begin
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
           
           irlocus={J:tmasscat.J_m[irobji],$
                    J_err:tmasscat.J_msigcom[irobji],$
                    H:tmasscat.H_m[irobji],$
                    H_err:tmasscat.H_msigcom[irobji],$
                    K:tmasscat.K_m[irobji],$
                    K_err:tmasscat.K_msigcom[irobji],$
                    J_H:  tmasscat.J_H[irobji],$
                    H_K:  tmasscat.H_K[irobji], $
                    J_galext:extinction_a*k_ext[4] }

           xtitles=push_arr(xtitles,['i - 2J + H'])

           locus=create_struct(locus,irlocus)
        endif

        locus=create_struct(locus,'xtitles',xtitles)

        rawdat=create_struct(rawdat,"locus",locus)

     endelse

;;; Get the initial math for uncalibrated data
     rawdat=create_struct(rawdat,"math1",math_step1)
     rawdat=create_struct(rawdat,"math2",math_step2)
     rawdat=create_struct(rawdat,"math3",math_step3)
     rawdat=create_struct(rawdat,"math4",math_step4)
     rawdat=create_struct(rawdat,"math5",math_step5)
     rawdat=create_struct(rawdat,"math6",math_step6)
     rawdat=create_struct(rawdat,"math7",math_step7)
     rawdat=create_struct(rawdat,"math8",math_step8)
     
     case option.dist_fittype of
        0:begin
           rawdat.math1.kappa.guess=rawdat.kappa_guess[0:2]
           rawdat.math1.kappa.range=rawdat.kappa_guess_range[0:2]
           rawdat.math1.kappa.val  =rawdat.kappa_guess[0:2]

           rawdat.math2.kappa.guess=rawdat.kappa_guess[0:3]
           rawdat.math2.kappa.range=rawdat.kappa_guess_range[0:3]
           rawdat.math2.kappa.val  =rawdat.kappa_guess[0:3]

           rawdat.math3.kappa.guess=rawdat.kappa_guess[0:2]
           rawdat.math3.kappa.range=rawdat.kappa_guess_range[0:2]
           rawdat.math3.kappa.val  =rawdat.kappa_guess[0:2]

           rawdat.math4.kappa.guess=rawdat.kappa_guess[0:2]
           rawdat.math4.kappa.range=rawdat.kappa_guess_range[0:2]
           rawdat.math4.kappa.val  =rawdat.kappa_guess[0:2]

           rawdat.math5.kappa.guess=rawdat.kappa_guess[0:2]
           rawdat.math5.kappa.range=rawdat.kappa_guess_range[0:2]
           rawdat.math5.kappa.val  =rawdat.kappa_guess[0:2]

        end
        else:begin
           message,"Don't know dist_fittype "+strtrim(option.dist_fittype,2)
        end
     endcase

     if option.use_ir then begin
        delvarx,tind
        alli=slr_get_good_indices(rawdat,option,tmass_indices=tind)
        print,n_elements(alli),' good matches in grizJ'
        
        rawdat=create_struct(rawdat,"opti_ir",alli)
        rawdat=create_struct(rawdat,"iri_ir",tind)
     endif

     if option.plot and n_elements(rawdat.locus.obji) le 1e4 then begin
        if option.use_ir then begin
           slr_locus_cubes,field=rawdat.field,$
                           gr=rawdat.locus.g[alli]-rawdat.locus.r[alli],$
                           ri=rawdat.locus.r[alli]-rawdat.locus.i[alli],$
                           iz=rawdat.locus.i[alli]-rawdat.locus.z[alli],$
                           zJ=rawdat.locus.z[alli]-rawdat.locus.J[tind],$
                           interactive=option.interactive,$
                           postscript=option.postscript
        endif else begin
           slr_locus_cubes,field=rawdat.field,$
                           gr=rawdat.locus.g[rawdat.locus.obji]-rawdat.locus.r[rawdat.locus.obji],$
                           ri=rawdat.locus.r[rawdat.locus.obji]-rawdat.locus.i[rawdat.locus.obji],$
                           iz=rawdat.locus.i[rawdat.locus.obji]-rawdat.locus.z[rawdat.locus.obji],$
                           interactive=option.interactive,$
                           postscript=option.postscript
        endelse
     endif

     save,file=raw_savefile,rawdat

  endelse                       ; Savefile exists



  return



end
