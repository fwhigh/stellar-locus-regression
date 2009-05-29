function curve_dist_func, p

  common curve_fit_func_xy, x, x_err, y, y_err, gof_arr, basis, this_fittype, colorterms, animate, weighted
  common curve_fit_test_par, fittype, A2_mean, A3_mean, fitpar

  n_dim=n_elements(x[0,*])
  n_dat=n_elements(x[*,0])

  p_counter=0
  kappa=slr_fitpar_struct_to_kappa(fitpar,p,p_counter=p_counter)
;  B =slr_fitpar_struct_to_colorterm_matrix(fitpar,p,p_counter=p_counter)
  unit_matrix =identity(n_dim)
  x_transform=slr_color_transform(x,kappa=kappa,B=unit_matrix,/inverse)

  if size(y,/tname) eq 'UNDEFINED' then begin

     y=slr_get_covey_data(fitpar.kappa.names,$
                          err=y_err)

     if size(y,/tname) eq 'UNDEFINED' then $
        message,"No standard colors!"
     if n_elements(y[0,*]) ne n_dim then $
        message,"Standard locus dimensionality not equal to instrumental locus"

;     color_matrix=slr_fitpar_struct_to_colorterm_matrix($
;                  fitpar,p,p_counter=p_counter)
     color_matrix=fitpar.b.matrix

     if 0 then begin
        print,'Transforming Covey'
        print,"Colorterm matrix B ="
        print,transpose(color_matrix)
        print
        print,"Initial kappa ="
        print,transpose(kappa)
     endif
     y=slr_color_transform(y,kappa=replicate(0.,n_dim),$
                           B=color_matrix)
     
  endif

  gof=slr_distance_residual(x_transform,x_err,y,y_err,weighted=weighted)

  if n_dat le 800 and animate then begin
     scatter=1
     contour=~scatter
     fill=1
     linecolor=200
     symcolor=200 
     histbin=0.05
     symsize=0.3
     buffer=0.5
     
     loadct,12,/silent

     erase & multiplot,[(n_dim-1)>2,2],/dox,/doy,gap=0.05,$
                       mtitle='!6Regressing data'
     for ii=0,n_dim-2 do begin
        plot,y[*,ii],y[*,ii+1],/nodata,$
             xtitle=fitpar.colornames[ii],ytitle=fitpar.colornames[ii+1],$
             xrange=minmax(y[*,ii])+[-1,1]*buffer,$
             yrange=minmax(y[*,ii+1])+[-1,1]*buffer                   
        oplot,y[*,ii],y[*,ii+1],thick=2,color=linecolor
        slr_plot_locus,$
           x_transform[*,ii],x_transform[*,ii+1],$
           /over,$
           contour=contour,scatter=scatter,djs_contour=contour,$
           fill=fill,linecolor=linecolor,ctable=ctable,$
           psym=8,symsize=symsize,charsize=charsize,$
           nlevels=nlevels,histbin=histbin    
        
        multiplot,/dox,/doy

     endfor
     
     if n_elements(gof_arr) ge 2 then begin
        plot,findgen(n_elements(gof_arr)),$
             gof_arr,$
             /xstyle,/ystyle,/ylog,$
             xtitle='!6Iteration',$
             ytitle='!6Goodness of Fit'
     endif                 
     
     multiplot,/default
     loadct,0,/silent
     
     
     wait,0.001
     
  endif

  
  gof_arr=push_arr(gof_arr,gof)
  return,gof

end


pro slr_fit_curve, x_dat=x_dat,$
                   x_err=x_dat_err,$
                   colorterms=colorterms_in,$
                   fitpar=fitpar,$
                   max_locus_dist=max_locus_dist,$
                   max_weighted_locus_dist=max_weighted_locus_dist,$
                   weighted_residual=weighted_residual,$
                   xtitles=xtitles,$
                   field=field,$
                   fittype=fittype,$
                   plot=plot,$
                   animate_regression=animate_regression,$
                   postscript=postscript,$
                   interactive=interactive,$
                   debug=debug,$
                   verbose=verbose,$
                   bestfit=bestfit, $
                   benchmark=benchmark

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
;  slr_fit_curve
;
; PURPOSE:
;  Regress color data points to an empirical curve.
;
; EXPLANATION:
;       
;
; CALLING SEQUENCE:
;       
;
; INPUTS:
; 
;      
;
; OPTIONAL INPUTS:
;
;
;
; OUTPUTS:
;       
;
; OPIONAL OUTPUTS:
;       
;       
; NOTES:
;
;
; EXAMPLES:
;
; PROCEDURES USED:
;       
; HISTORY:
;       Written by:     FW High 2008
;
;-

  common curve_fit_func_xy, x, x_err, y, y_err, gof_arr, basis, this_fittype, colorterms, animate, weighted
  common curve_fit_test_par, this_fittype2, A2_mean, A3_mean, fitpar_str

  delvarx,y,y_err
  x=x_dat
  x_err=x_dat_err
  this_fittype=fittype
  this_fittype2=fittype
  basis=1
  fitpar_str=fitpar
  colorterms=colorterms_in
  animate=keyword_set(animate_regression)
  weighted=keyword_set(weighted_residual)

  if not keyword_set(verbose) then verbose=0

;  if keyword_set(plot) and ~keyword_set(postscript) then $
;     window,0,xsize=900,ysize=600

  case fittype of
     0:begin
        p0=slr_fitpar_struct_to_guess(fitpar)
        scale=slr_fitpar_struct_to_guess_range(fitpar)
;        print,'p guess ',p0
     end
;;     1:begin
;;        message,'Not used'
;;         p0=replicate(0d,2*n_elements(x[0,*]+1))
;;         for index=0,n_elements(x[0,*])-1 do scale=push_arr(scale,max([x[*,index]])-min([x[*,index]]))
;;         scale=push_arr(scale,replicate(0.3,4))
;;     end
;;     2:begin
;;         message,"Not done"
;;         p0=replicate(0d,4)
;;         scale=replicate(0.3,4)
;;      end
     else:begin
        message,"Don't recognize fittype "+string(fittype)
     end
  endcase
  function_name='curve_dist_func'
  ftol=1e-6

  start_time=systime(1)
  p = amoeba(ftol,scale=scale,p0=p0,function_name=function_name)
  stop_time=systime(1)
  if keyword_set(benchmark) then begin
     if verbose ge 1 then begin
        message,"Fit completed in "+$
                strtrim(string(stop_time-start_time,format='(F10.3)'),2)+$
                ' seconds',/info
     endif
  endif
  if p[0] eq -1 then begin
     print,'Did not converge!!'
     p=replicate(0.,n_elements(x_dat[0,*]))
  endif


;print,'result p',p
  p_counter=0
  kappa=slr_fitpar_struct_to_kappa(fitpar,p,p_counter=p_counter)
;  colorterm_matrix=slr_fitpar_struct_to_colorterm_matrix($
;                   fitpar,p,p_counter=p_counter)
  colorterm_matrix=fitpar.b.matrix
  x_transform=slr_color_transform(x,kappa=kappa,B=colorterm_matrix,/inverse)
  fitpar.kappa.val=kappa
  fitpar.kappa.guess=kappa

  y=slr_get_covey_data(fitpar.kappa.names,$
                       err=y_err)

  gof2=slr_distance_residual(x_transform,x_err,y,y_err,weighted=weighted)
  best_gof=slr_distance_residual(x_transform,x_err,y,y_err,$
                                 /get_goodi,goodi=goodi,$
                                 weighted=weighted,$
                                 wthresh=max_weighted_locus_dist,$
                                 thresh=max_locus_dist)
  if size(goodi,/tname) ne 'UNDEFINED' then begin
     badi=setdifference(lindgen(n_elements(x_transform[*,0])),goodi)
  endif else begin
     goodi=lindgen(n_elements(x_transform[*,0]))
     badi=[-1]
  endelse

  if plot then begin
     if keyword_set(postscript) then begin
        ops,file=field+'_slr_fit.eps',/encap,/color,csize=0.8
     endif

     n_dim=n_elements(x[0,*])
     n_dat=n_elements(x[*,0])

     scatter=1
     contour=~scatter
     fill=1
     linecolor=200
     symcolor=200 
     histbin=0.05
     symsize=0.3
     buffer=0.5

     loadct,12,/silent

     erase & multiplot,[(n_dim-1)>2,2],/dox,/doy,gap=0.05,$
                       mtitle='!6Regression Results'
     for ii=0,n_dim-2 do begin
        plot,y[*,ii],y[*,ii+1],/nodata,$
             xtitle=fitpar.colornames[ii],$
             ytitle=fitpar.colornames[ii+1],$
             xrange=minmax(y[*,ii])+[-1,1]*buffer,$
             yrange=minmax(y[*,ii+1])+[-1,1]*buffer                   
        oplot,y[*,ii],y[*,ii+1],thick=2,color=linecolor
        slr_plot_locus,$
           x_transform[*,ii],x_transform[*,ii+1],$
           /over,$
           contour=contour,scatter=scatter,djs_contour=contour,$
           fill=fill,linecolor=linecolor,ctable=ctable,$
           psym=8,symsize=symsize,charsize=charsize,$
           nlevels=nlevels,histbin=histbin    
        
        multiplot,/dox,/doy

     endfor

     if n_elements(gof_arr) ge 2 then begin
        plot,findgen(n_elements(gof_arr)),$
             gof_arr,$
             /xstyle,/ystyle,/ylog,$
             xtitle='!6Iteration',$
             ytitle='!6Goodness of Fit'
     endif                 
     loadct,0,/silent
     
     multiplot
     
     plot,[0,1],[0,1],/nodata,$
          title='!8INFO!6',$
          xtickname=replicate(' ',20),$
          ytickname=replicate(' ',20),$
          xticks=1,yticks=1,xminor=1,yminor=1,xstyle=4,ystyle=4
     if ~keyword_set(weighted) then $
        prefix='Un-weighted' else $
           prefix='Weighted'
     ct_string=''
     if finite(colorterms[0]) then begin
        for ii=0,n_elements(colorterms)-1 do $
           ct_string+=' '+strtrim(string(colorterms[ii],format='(F10.3)'),2)
     endif else ct_string+=' none'
     par_string=''
     for ii=0,n_elements(p)-1 do $
        par_string+=' '+strtrim(string(p[ii],format='(F10.3)'),2)
     xyouts,0.0,0.9,$
            'Fit completed in'+$
            ' '+strtrim(string(stop_time-start_time,format='(F10.3)'),2)+$
            ' seconds'+$
            '!c!c'+$
            prefix+' fit was performed'+$
            '!c!c'+$
            '!6Color terms applied (fixed):!c'+$
            ' '+ct_string+$
            '!c!c'+$
            'Best fit parameters:!c'+$
            '  '+par_string+$
            '!c!c'+$
            'Optimal goodness-of-fit:'+$
            ' '+strtrim(string(best_gof,format='(F10.3)'),2)
     

     multiplot,/default
     loadct,0,/silent

     if keyword_set(postscript) then begin
        cps
     endif
     if keyword_set(interactive) then begin
        junk='' & read,'Hit enter',junk
     endif

  endif

  bestfit={p:p,$
           goodi:goodi}


  delvarx,gof_arr


end
