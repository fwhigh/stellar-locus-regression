pro slr_locus_line_calibration,$
   option=option, $
   data=data, $
   kappa=kappa, $
   kap_err=kap_err, $
   galext_mean=galext_mean, $
   galext_stddev=galext_stddev, $
   bootstrap=bootstrap, $
   obji_in=obji_in, $
   obji_out=obji_out, $
   errflag=errflag, $
   colorterms=colorterms, $
   tostd=tostd,$
   nstars=nstars

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
;  slr_locus_line_calibration
;
; PURPOSE:
;  Do a Stellar Locus Calibration using a line as the standard locus.
;
; EXPLANATION:
;  Regress data to the locus line, and get the best-fit parameters to
;  calibrate cataloged data.
;
; CALLING SEQUENCE:
;  slr_locus_line_calibration,$
;   option=option,data=data,kappa=kappa,$
;   kappa_err=kappa_err,galext_mean=galext_mean,$
;   galext_stddev=galext_stddev, $
;   bootstrap=bootstrap,obji_in=obji_in,obji_out=obji_out, $
;   errflag=errflag, $
;   /colorterms,tostd=tostd
;
; INPUTS:
;  option (struct)   Options from slr_init.pro
;  data (struct)     Stellar data from slr_init.pro
;      
;
; OPTIONAL INPUTS:
;  obji_in (int arr)   Array of "good" indices to be used initially.
;
;
; OUTPUTS:
;
;
; OPIONAL OUTPUTS:
;  kappa (float arr)      Vector of best-fit color translations
;                         kappa. 
;  kappa_err (float arr)  Corresponding errors.
;  galext_mean (float arr)  Mean reddening vector for the "good"
;                           data. 
;  galext_mean (float arr)  Standard deviation of the reddening vector
;                           for the "good" data. 
;  bootstrap (bit)   Estimate errors with the bootstap?  Number of
;                    bootstraps taken from option.nbootstrap 
;  obji_out (int arr)   Array of "good" indices after regression is
;                       done. 
;  errflag (int)  NOT USED.
;  colorterms (float arr)  Fixed color terms to be used in the fit.
;       
; NOTES:
;
;
; EXAMPLES:
;  slr_locus_line_calibration,$
;         option=option,data=data,kappa=kappa
;
; PROCEDURES USED:
;  A lot.
;       
; HISTORY:
;       Written by:     FW High 2008
;
;-

 compile_opt idl2, hidden

  if not keyword_set(colorterms) then $
     colorterms=replicate(0.,4)

  errflag=0
  use_ir=option.use_ir
  bootstrap=keyword_set(bootstrap)
  n_bootstrap=option.nbootstrap

  if option.get_kappa then begin
     option.use_ir=0

     if option.verbose ge 1 then $
        message,"Fitting",/info
     x1_dat=slr_get_data_array(data,option,err=x1_err,$
                               output_indices=ind1,$
                               input_indices=obji_in)
;     data.math1.m.val=colorterms
     slr_fit_curve,x_dat=x1_dat,$
                   x_err=x1_err,$
                   math=data.math1,$
                   colorterms=colorterms,$
                   max_locus_dist=option.max_locus_dist,$
                   max_weighted_locus_dist=option.max_weighted_locus_dist,$
                   weighted_residual=0,$
;                   weighted_residual=option.weighted_residual,$
                   fittype=0,$
                   xtitles=data.locus.xtitles,$
                   field=data.field,$
                   interactive=option.interactive,$
                   debug=option.debug,$
                   verbose=option.verbose,$
                   plot=option.plot,$
                   animate_regression=option.animate_regression,$
                   postscript=option.postscript,$
                   bestfit=calibfit1,$
                   /benchmark
     if option.verbose ge 2 then $
        print,'Intermediate kappa = ',calibfit1.p
     if option.verbose ge 2 then $
        print,'n stars used = ',n_elements(ind1)
     ind1_better=ind1[calibfit1.goodi]
     data.math1.kappa.guess[0:2]=calibfit1.p
     data.math1.kappa.val[0:2]=calibfit1.p
     data.math2.kappa.guess[0:2]=calibfit1.p
     data.math2.kappa.val[0:2]=calibfit1.p


     if option.verbose ge 1 then $
        message,"Cutting outliers, fitting again",/info
     x1_dat=slr_get_data_array(data,option,err=x1_err,$
                               input_indices=ind1_better,$
                               output_indices=ind1)
     slr_fit_curve,x_dat=x1_dat,$
                   x_err=x1_err,$
                   math=data.math1,$
                   colorterms=colorterms,$
                   max_locus_dist=option.max_locus_dist,$
                   weighted_residual=option.weighted_residual,$
                   fittype=0,$
                   xtitles=data.locus.xtitles,$
                   field=data.field,$
                   interactive=option.interactive,$
                   debug=option.debug,$
                   verbose=option.verbose,$
                   plot=option.plot,$
                   animate_regression=option.animate_regression,$
                   postscript=option.postscript,$
                   bestfit=calibfit1,$
                   /benchmark
     data.math1.kappa.guess[0:2]=calibfit1.p
     data.math1.kappa.val[0:2]=calibfit1.p
     data.math2.kappa.guess[0:2]=calibfit1.p
     data.math2.kappa.val[0:2]=calibfit1.p
     data.math7.kappa.val[0:2]=calibfit1.p
     data.math8.kappa.val[0:2]=calibfit1.p

     if n_elements(ind1_better) lt 3 then begin
        message,"Not enough good ones"
        errflag=1
        return
     endif

     if option.verbose ge 2 then $
        print,'Final kappa = ',calibfit1.p
     if option.verbose ge 2 then $
        print,'n stars used = ',n_elements(ind1_better)
     nstars=n_elements(ind1_better)

     kappa=calibfit1.p

     slr_log,data.logfile,'kappa_gr '+string(kappa[0],format='(F)')
     slr_log,data.logfile,'kappa_ri '+string(kappa[1],format='(F)')
     slr_log,data.logfile,'kappa_iz '+string(kappa[2],format='(F)')

     obji_out=ind1_better
     galext_mean=[mean((data.locus.g_galext-data.locus.r_galext)[ind1_better]),$
                  mean((data.locus.r_galext-data.locus.i_galext)[ind1_better]),$
                  mean((data.locus.i_galext-data.locus.z_galext)[ind1_better])]
     galext_stddev=[stddev((data.locus.g_galext-data.locus.r_galext)[ind1_better]),$
                    stddev((data.locus.r_galext-data.locus.i_galext)[ind1_better]),$
                    stddev((data.locus.i_galext-data.locus.z_galext)[ind1_better])]
     

;     kap_err=replicate(0.,n_elements(kappa))
     if bootstrap then begin
        start_time=systime(1)
        if option.verbose ge 1 then begin
           message,"Bootstrapping "+strtrim(n_bootstrap,2)+" times to estimate errors.",/info
        endif
         delvarx,p_bootstrap
        x1_orig=x1_dat
        x1_err_orig=x1_err
        n_data=n_elements(x1_orig[*,0])
        n_iter=n_bootstrap
        delvarx,p_bootstrap
        for i=0,n_iter-1 do begin
           seed=i+1
           if ((i+1) mod 20) eq 0 and option.verbose ge 2 then $
              print,'Iteration ',i+1,'/',n_iter
;           IMSL_RANDOMOPT, Set = i+1
;           b1ind=imsl_random(n_data,/discrete_unif,parameters=n_data)-1
           b1ind=floor(randomu(seed,n_data)*n_data)
           b1ind=b1ind[sort(b1ind)]
           x1_dat=x1_orig[b1ind,*]
           x1_err=x1_err_orig[b1ind,*]

           slr_fit_curve,x_dat=x1_dat,$
                         x_err=x1_err,$
                         math=data.math1,$
                         colorterms=colorterms,$
                         max_locus_dist=option.max_locus_dist,$
                         weighted_residual=option.weighted_residual,$
                         fittype=0,$
                         xtitles=data.locus.xtitles,$
                         field=data.field,$
                         interactive=option.interactive,$
                         debug=option.debug,$
                         verbose=option.verbose,$
;                         plot=option.plot,$
                         plot=0,$
                         postscript=option.postscript,$
                         bestfit=bootfit
           
;           print,'p out',bootfit.p

           if i eq 0 then begin
              p_bootstrap=bootfit.p
           endif else begin
              p_bootstrap=[[p_bootstrap],[bootfit.p]]
           endelse
        endfor
        kap_err=[stddev(p_bootstrap[0,*]),$
                 stddev(p_bootstrap[1,*]),$
                 stddev(p_bootstrap[2,*])]
;        kap_err=[robust_sigma(p_bootstrap[0,*]),$
;                 robust_sigma(p_bootstrap[1,*]),$
;                 robust_sigma(p_bootstrap[2,*])]
;        save,file=slr_datadir()+path_sep()+data.field+'_bootstrap.sav',$
;             data,option,p_bootstrap

        if option.verbose ge 1 then begin
           message,"Bootstrap completed in "+$
                   strtrim(string(SYSTIME(1)-start_time,format='(F10.3)'),2)+$
                   ' seconds',/info
        endif
        if option.verbose ge 2 then $
           print,'Bootstrap error ',kap_err

        slr_log,data.logfile,$
                'Number of bootstraps '+string(n_iter,format='(I)')
        slr_log,data.logfile,'kappa_gr_err '+string(kap_err[0],format='(F)')
        slr_log,data.logfile,'kappa_ri_err '+string(kap_err[1],format='(F)')
        slr_log,data.logfile,'kappa_iz_err '+string(kap_err[2],format='(F)')
     endif else begin
        slr_log,data.logfile,$
                'WARNING: Bootstrap not performed '
        kap_err=[0.0,0.0,0.0]
     endelse





     if use_ir then begin
        option.use_ir=1

        if option.verbose ge 2 then $
           print,'Doing INFRARED'

        x1_dat=slr_get_data_array(data,option,err=x1_err,$
                                  output_indices=ind1,$
                                  input_indices=ind1_better)
        data.math7.kappa.val[0:2]=kappa
        data.math8.kappa.val[0:2]=kappa
        slr_fit_curve,x_dat=x1_dat,$
                      x_err=x1_err,$
;                      math=data.math7,$
                      math=data.math8,$
                      colorterms=colorterms,$
;                      max_locus_dist=data.max_locus_dist,$
;                      max_locus_dist=data.max_locus_dist,$
                      weighted_residual=option.weighted_residual,$
                      fittype=0,$
                      xtitles=data.locus.xtitles,$
                      field=data.field,$
                      interactive=option.interactive,$
                      debug=option.debug,$
                      verbose=option.verbose,$
                      plot=option.plot,$
                      animate_regression=option.animate_regression,$
                      postscript=option.postscript,$
                      bestfit=calibfit1
;  ind1_better=ind1[calibfit1.goodi]
        if option.verbose ge 2 then $
           print,'Final kappa = ',calibfit1.p
        kappa=push_arr(kappa,calibfit1.p)
        galext_mean=push_arr(galext_mean,$
                             mean((data.locus.z_galext-data.locus.J_galext)[ind1_better]))
        galext_stddev=push_arr(galext_stddev,$
                               stddev((data.locus.z_galext-data.locus.J_galext)[ind1_better]))



;        kap_err=replicate(0.,n_elements(kappa))
        if bootstrap then begin
           if option.verbose ge 1 then begin
              print,'Bootstrapping'
           endif
           delvarx,p_bootstrap_ir
           x1_orig=x1_dat
           x1_err_orig=x1_err
           n_data=n_elements(x1_orig[*,0])
           n_iter=n_bootstrap
           delvarx,p_bootstrap
           for i=0,n_iter-1 do begin
              seed=i+1
              if ((i+1) mod 100) eq 0 and option.verbose ge 2 then $
                 print,'Iteration ',i+1,'/',n_iter
;              IMSL_RANDOMOPT, Set = i+1
;              b1ind=imsl_random(n_data,/discrete_unif,parameters=n_data)-1
              b1ind=floor(randomu(seed,n_data)*n_data)
              b1ind=b1ind[sort(b1ind)]
              x1_dat=x1_orig[b1ind,*]
              x1_err=x1_err_orig[b1ind,*]

              slr_fit_curve,x_dat=x1_dat,$
                            x_err=x1_err,$
;                            math=data.math7,$
                            math=data.math8,$
                            colorterms=colorterms,$
;                            max_locus_dist=option.max_locus_dist,$
                            weighted_residual=option.weighted_residual,$
                            fittype=0,$
                            xtitles=data.locus.xtitles,$
                            field=data.field,$
                            interactive=option.interactive,$
                            debug=option.debug,$
                            verbose=option.verbose,$
;                            plot=option.plot,$
                            plot=0,$
                            postscript=option.postscript,$
                            bestfit=bootfit
              
;              print,'p out',bootfit.p

              if i eq 0 then begin
                 p_bootstrap_ir=bootfit.p
              endif else begin
                 p_bootstrap_ir=[[p_bootstrap_ir],[bootfit.p]]
              endelse
           endfor
;           kap_err=push_arr(kap_err,stddev(p_bootstrap_ir))
           kap_err=push_arr(kap_err,stddev(p_bootstrap_ir[0,*]))
           kap_err=push_arr(kap_err,stddev(p_bootstrap_ir[1,*]))
           kap_err=push_arr(kap_err,stddev(p_bootstrap_ir[2,*]))
           kap_err=push_arr(kap_err,stddev(p_bootstrap_ir[3,*]))
           if option.verbose ge 2 then $
              print,'Bootstrap error ',kap_err
;           save,file=slr_datadir()+path_sep()+data.field+'_bootstrap_ir.sav',$
;                data,option,p_bootstrap_ir
        endif else begin
           kap_err=push_arr(kap_err,[1,1,1,1]*0.001)
        endelse


     endif

  endif



end








