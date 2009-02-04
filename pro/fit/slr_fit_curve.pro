function curve_dist_func, p

  common curve_fit_func_xy, x, x_err, y, y_err, gof_arr, basis, this_fittype, colorterms, animate, weighted
  common curve_fit_test_par, fittype, A2_mean, A3_mean, math

  n_dim=n_elements(x[0,*])
  n_dat=n_elements(x[*,0])

  p_counter=0
  kappa=slr_math_struct_to_kappa(math,p,p_counter=p_counter)
;  m_op =slr_math_struct_to_colorterm_matrix(math,p,p_counter=p_counter)
  m_op =identity(n_dim)
  x_transform=slr_color_transform(x,kappa=kappa,m_op=m_op,/inverse)

  if size(y,/tname) eq 'UNDEFINED' then begin
     cat=slr_read_covey_median_locus()
     if 0 then print,'Reading Covey'
     if n_dim eq 3 then begin
        y=[[cat.gr],[cat.ri],[cat.iz]]
        y_err=[[cat.gr_err],[cat.ri_err],[cat.iz_err]]

        if n_elements(colorterms) eq 4 then begin
           color_matrix=slr_colorterm_matrix(colorterms,type=0)
        endif else if n_elements(colorterms) eq 3 then begin
           color_matrix=slr_colorterm_matrix(colorterms,type=5)
        endif else begin
           message,"Wrong number of color coefficients"
        endelse
        
     endif else if n_dim eq 4 then begin
        y=[[cat.gr],[cat.ri],[cat.iz],$
           [cat.zJ]]
        y_err=[[cat.gr_err],[cat.ri_err],[cat.iz_err],$
               [cat.zJ_err^2]]
        
        if n_elements(colorterms) eq 4 then begin
           color_matrix=slr_colorterm_matrix(colorterms,type=3)
;           color_matrix=slr_colorterm_matrix(colorterms,type=7)
        endif else if n_elements(colorterms) eq 3 then begin
           color_matrix=slr_colorterm_matrix(colorterms,type=6)
        endif else begin
           message,"Wrong number of color coefficients"
        endelse
     endif else if n_dim eq 7 then begin
;     anl=slr_covey_analytic_locus(gi=cat.gi)
        y=[[cat.gr],[cat.ri],[cat.iz],$
           [cat.zJ],$
           [cat.iz+cat.zJ],$
           [cat.ri+cat.iz+cat.zJ],$
           [cat.gr+cat.ri+cat.iz+cat.zJ]]
;     y=[[anl.gr],[anl.ri],[anl.iz],[anl.zJ]]
;;; HACK!!!
        y_err=[[cat.gr_err],[cat.ri_err],[cat.iz_err],$
               [cat.zJ_err^2],$
               [cat.zJ_err^2],$
               [cat.zJ_err^2],$
               [cat.zJ_err^2]              ]
        
;    y=[[cat.gr],[cat.ri],[cat.iz],[cat.iz+cat.zJ-cat.JH]]
;    y_err=[[cat.gr_err],[cat.ri_err],[cat.iz_err],[sqrt(cat.iz_err^2+cat.zJ_err^2+cat.JH_err^2)]]
        
        if n_elements(colorterms) eq 4 then begin
;           color_matrix=slr_colorterm_matrix(colorterms,type=3)
           color_matrix=slr_colorterm_matrix(colorterms,type=7)
        endif else if n_elements(colorterms) eq 3 then begin
           color_matrix=slr_colorterm_matrix(colorterms,type=6)
        endif else begin
           message,"Wrong number of color coefficients"
        endelse
     endif else begin
        stop
     endelse

     if 0 then begin
        print,'Transforming Covey'
        print,color_matrix
        print
        print,kappa
     endif
     y=slr_color_transform(y,kappa=replicate(0.,n_dim),$
                           m_op=color_matrix)
     
  endif

  gof=slr_distance_residual(x_transform,x_err,y,y_err,weighted=weighted)

  if 0 then begin

     contour=0 & scatter=~contour
     djs_contour=0
     charsize=0.8
     symsize1=0.4
     symsize2=0.4
     color2=200
     histbin1=0.1
     histbin2=0.1
     nlevels=5.

     loadct,12,/silent
     erase & multiplot,[2,2],/dox,/doy,gap=0.05
     if n_elements(gof_arr) ge 2 then plot,gof_arr,/ylog
     multiplot,/dox,/doy
     ploterror,y[*,0],y[*,1],y_err[*,0],y_err[*,1],/nohat,psym=3
     slr_plot_locus,x_transform[*,0],x_transform[*,1],$
                    /overplot,scatter=scatter,contour=contour,djs_contour=djs_contour,$
                    histbin=histbin2,nlevels=nlevels,$
                    psym=8,symsize=symsize2,$
                    color=200
     multiplot,/dox,/doy
     ploterror,y[*,1],y[*,2],y_err[*,1],y_err[*,2],/nohat,psym=3
     slr_plot_locus,x_transform[*,1],x_transform[*,2],$
                    /overplot,scatter=scatter,contour=contour,djs_contour=djs_contour,$
                    histbin=histbin2,nlevels=nlevels,$
                    psym=8,symsize=symsize2,$
                    color=200
     if n_dim ge 4 then begin
        multiplot,/dox,/doy
        ploterror,y[*,2],y[*,3],y_err[*,2],y_err[*,3],/nohat,psym=3
        slr_plot_locus,x_transform[*,2],x_transform[*,3],$
                       /overplot,scatter=scatter,contour=contour,djs_contour=djs_contour,$
                       histbin=histbin2,nlevels=nlevels,$
                       psym=8,symsize=symsize2,$
                       color=200
     endif
     multiplot,/default

  endif


  if 1 then begin

     if n_dim ge 4 then begin
        if n_dat le 500 and animate then begin
;;            erase & multiplot,[2,3],/dox,/doy
;;            plot,x_transform[*,0]+x_transform[*,1],x_transform[*,0],psym=3
;;            oplot,y[*,0]+y[*,1],y[*,0]

;;            multiplot,/dox,/doy
;;            plot,x_transform[*,0]+x_transform[*,1],x_transform[*,2],psym=3
;;            oplot,y[*,0]+y[*,1],y[*,2]

;;            multiplot,/dox,/doy
;;            plot,x_transform[*,0]+x_transform[*,1],x_transform[*,3],psym=3
;;            oplot,y[*,0]+y[*,1],y[*,3]

;;            multiplot,/dox,/doy
;;            plot,x_transform[*,0]+x_transform[*,1],x_transform[*,4],psym=3
;;            oplot,y[*,0]+y[*,1],y[*,4]

;;            multiplot,/dox,/doy
;;            plot,x_transform[*,0]+x_transform[*,1],x_transform[*,5],psym=3
;;            oplot,y[*,0]+y[*,1],y[*,5]

;;            multiplot,/dox,/doy
;;            plot,x_transform[*,0]+x_transform[*,1],x_transform[*,6],psym=3
;;            oplot,y[*,0]+y[*,1],y[*,6]

;;            multiplot,/default

;;            wait,0.1
           if 0 then begin
              slr_locus_cubes,field='fit',$
                              gr=x_transform[*,0],$
                              ri=x_transform[*,1],$
                              iz=x_transform[*,2],$
                              zJ=x_transform[*,3],$
                              covey_gr=y[*,0],$
                              covey_ri=y[*,1],$
                              covey_iz=y[*,2],$
                              covey_zJ=y[*,3],$
                              /ironly,$
                              interactive=interactive,$
                              postscript=postscript
           endif else begin
              scatter=1
              contour=~scatter
              fill=1
              linecolor=150
              histbin=0.05
              symsize=0.2

              multiplot,[2,1],/dox,/doy
              slr_plot_locus,$
                 x_transform[*,0],x_transform[*,1],$
                 contour=contour,scatter=scatter,djs_contour=contour,$
                 fill=fill,linecolor=linecolor,ctable=ctable,$
                 psym=8,symsize=symsize,charsize=charsize,$
                 xtitle='!8g - r!6',ytitle='!8r - i!6',$
                 nlevels=nlevels,histbin=histbin    
              oplot,y[*,0],y[*,1],thick=2

              multiplot

              slr_plot_locus,$
                 x_transform[*,2],x_transform[*,1],$
                 contour=contour,scatter=scatter,djs_contour=contour,$
                 fill=fill,linecolor=linecolor,ctable=ctable,$
                 psym=8,symsize=symsize,charsize=charsize,$
                 xtitle='!8g - r!6',ytitle='!8r - i!6',$
                 nlevels=nlevels,histbin=histbin    
              oplot,y[*,2],y[*,1],thick=2

              multiplot,/default

           endelse
        endif
     endif else begin
        if n_dat le 800 and animate then begin
           if 0 then begin
              slr_locus_cubes,field='fit',$
                              gr=x_transform[*,0],$
                              ri=x_transform[*,1],$
                              iz=x_transform[*,2],$
                              covey_gr=y[*,0],$
                              covey_ri=y[*,1],$
                              covey_iz=y[*,2],$
                              /fix_plot_limits,$
                              interactive=interactive,$
                              postscript=postscript
              wait,0.001
           endif else begin
              scatter=1
              contour=~scatter
              fill=1
              linecolor=150
              histbin=0.05
              symsize=0.2
              buffer=0.5

              erase & multiplot,[2,2],/dox,/doy,ygap=0.05
              slr_plot_locus,$
                 x_transform[*,0],x_transform[*,1],$
                 contour=contour,scatter=scatter,djs_contour=contour,$
                 fill=fill,linecolor=linecolor,ctable=ctable,$
                 psym=8,symsize=symsize,charsize=charsize,$
                 xtitle='!8g - r!6',ytitle='!8r - i!6',$
                 xrange=minmax(y[*,0])+[-1,1]*buffer,$
                 yrange=minmax(y[*,1])+[-1,1]*buffer,$
                 nlevels=nlevels,histbin=histbin    
              oplot,y[*,0],y[*,1],thick=2

              multiplot,/dox

              slr_plot_locus,$
                 x_transform[*,2],x_transform[*,1],$
                 contour=contour,scatter=scatter,djs_contour=contour,$
                 fill=fill,linecolor=linecolor,ctable=ctable,$
                 psym=8,symsize=symsize,charsize=charsize,$
                 xtitle='!8i - z!6',$
                 xrange=minmax(y[*,2])+[-1,1]*buffer,$
                 yrange=minmax(y[*,1])+[-1,1]*buffer,$
                 nlevels=nlevels,histbin=histbin    
              oplot,y[*,2],y[*,1],thick=2

              multiplot,/dox,/doy

              if n_elements(gof_arr) ge 2 then begin
                 plot,findgen(n_elements(gof_arr)),$
                      gof_arr,$
                      /xstyle,/ystyle,/ylog,$
                      xtitle='!6Iteration',$
                      ytitle='!6Goodness of Fit'
              endif                 

              multiplot,/default


              wait,0.001

           endelse
        endif
     endelse

  endif

  gof_arr=push_arr(gof_arr,gof)
  return,gof

end


pro slr_fit_curve, x_dat=x_dat,$
                   x_err=x_dat_err,$
                   colorterms=colorterms_in,$
                   math=math,$
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
                   bestfit=bestfit

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
  common curve_fit_test_par, this_fittype2, A2_mean, A3_mean, math_str

  delvarx,y,y_err
  x=x_dat
  x_err=x_dat_err
  this_fittype=fittype
  this_fittype2=fittype
  basis=1
  math_str=math
  colorterms=colorterms_in
  animate=keyword_set(animate_regression)
  weighted=keyword_set(weighted_residual)

  if not keyword_set(verbose) then verbose=0

  case fittype of
     0:begin
        p0=slr_math_struct_to_guess(math)
        scale=slr_math_struct_to_guess_range(math)
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

  p = amoeba(ftol,scale=scale,p0=p0,function_name=function_name)
  if p[0] eq -1 then begin
     print,'Did not converge!!'
     p=replicate(0.,n_elements(x_dat[0,*]))
  endif


;print,'result p',p
  p_counter=0
  kappa=slr_math_struct_to_kappa(math,p,p_counter=p_counter)
  m_op =slr_math_struct_to_colorterm_matrix(math,p,p_counter=p_counter)
  x_transform=slr_color_transform(x,kappa=kappa,m_op=m_op,/inverse)


  best_gof=slr_distance_residual(x_transform,x_err,y,y_err,$
                                 /get_goodi,goodi=goodi,$
                                 wthresh=max_weighted_locus_dist,$
                                 thresh=max_locus_dist)
  if size(goodi,/tname) ne 'UNDEFINED' then begin
     badi=setdifference(lindgen(n_elements(x_transform[*,0])),goodi)
  endif else begin
     goodi=lindgen(n_elements(x_transform[*,0]))
     badi=[-1]
  endelse

  if plot then begin
     n_dim=n_elements(x[0,*])
     n_dat=n_elements(x[*,0])
     if n_dat le 5000 then begin
        cat=slr_read_covey_median_locus()
        if n_dim eq 3 then begin
           y=[[cat.gr],[cat.ri],[cat.iz]]
           y_err=[[cat.gr_err],[cat.ri_err],[cat.iz_err]]
           if n_elements(colorterms) eq 4 then begin
              color_matrix=slr_colorterm_matrix(colorterms,type=0)
           endif else if n_elements(colorterms) eq 3 then begin
              color_matrix=slr_colorterm_matrix(colorterms,type=5)
           endif else begin
              message,"Wrong number of color coefficients"
           endelse
;        y=slr_color_transform(y,kappa=replicate(0.0,n_dim),$
;                              m_op=color_matrix)
;        print,'Color term matrix',color_matrix
;        print,'kappa',kappa
           x_transform=slr_color_transform(x,kappa=kappa,$
                                           m_op=color_matrix,/inverse)
           if 0 then begin
           slr_locus_cubes,field=field,$
                           gr=x_transform[*,0],$
                           ri=x_transform[*,1],$
                           iz=x_transform[*,2],$
                           covey_gr=y[*,0],$
                           covey_ri=y[*,1],$
                           covey_iz=y[*,2],$
                           interactive=interactive,$
                           postscript=postscript
        endif else begin
              scatter=1
              contour=~scatter
              fill=1
              linecolor=150
              histbin=0.05
              symsize=0.2
              buffer=0.5

              erase & multiplot,[2,2],/dox,/doy,ygap=0.05
              slr_plot_locus,$
                 x_transform[*,0],x_transform[*,1],$
                 contour=contour,scatter=scatter,djs_contour=contour,$
                 fill=fill,linecolor=linecolor,ctable=ctable,$
                 psym=8,symsize=symsize,charsize=charsize,$
                 xtitle='!8g - r!6',ytitle='!8r - i!6',$
                 xrange=minmax(y[*,0])+[-1,1]*buffer,$
                 yrange=minmax(y[*,1])+[-1,1]*buffer,$
                 nlevels=nlevels,histbin=histbin    
              oplot,y[*,0],y[*,1],thick=2

              multiplot,/dox

              slr_plot_locus,$
                 x_transform[*,2],x_transform[*,1],$
                 contour=contour,scatter=scatter,djs_contour=contour,$
                 fill=fill,linecolor=linecolor,ctable=ctable,$
                 psym=8,symsize=symsize,charsize=charsize,$
                 xtitle='!8i - z!6',$
                 xrange=minmax(y[*,2])+[-1,1]*buffer,$
                 yrange=minmax(y[*,1])+[-1,1]*buffer,$
                 nlevels=nlevels,histbin=histbin    
              oplot,y[*,2],y[*,1],thick=2

              multiplot,/dox,/doy

              if n_elements(gof_arr) ge 2 then begin
                 plot,findgen(n_elements(gof_arr)),$
                      gof_arr,$
                      /xstyle,/ystyle,/ylog,$
                      xtitle='!6Iteration',$
                      ytitle='!6Goodness of Fit'
              endif                 

              multiplot,/default


              if keyword_set(interactive) then begin
                 junk='' & read,'Hit enter',junk
              endif
endelse
        endif else if n_dim eq 4 then begin
           y=[[cat.gr],[cat.ri],[cat.iz],[cat.zJ]]
           y_err=[[cat.gr_err],[cat.ri_err],[cat.iz_err],[cat.zJ_err^2]]
           if n_elements(colorterms) eq 4 then begin
              color_matrix=identity(n_dim)+$
                           [[ colorterms[0],             0,                           0, 0],$
                            [-colorterms[1], colorterms[1],                           0, 0],$
                            [             0,-colorterms[2], colorterms[2]-colorterms[3], 0],$
                            [             0,             0,                           0, 0]]
           endif else if n_elements(colorterms) eq 3 then begin
              color_matrix=identity(n_dim)+$
                           [[ colorterms[0],             0,             0,         0],$
                            [             0, colorterms[1],             0,         0],$
                            [             0,             0, colorterms[2],         0],$
                            [             0,             0,             0,         0]]
           endif else begin
              message,"Wrong number of color coefficients"
           endelse
           x_transform=slr_color_transform(x,kappa=kappa,$
                                           m_op=color_matrix,/inverse)
           if 0 then begin
           slr_locus_cubes,field=field,$
                           gr=x_transform[*,0],$
                           ri=x_transform[*,1],$
                           iz=x_transform[*,2],$
                           zJ=x_transform[*,3],$
                           interactive=interactive,$
                           postscript=postscript
        endif else begin
              scatter=1
              contour=~scatter
              fill=1
              linecolor=150
              histbin=0.05
              symsize=0.2
              buffer=0.5

              erase & multiplot,[2,2],/dox,/doy,ygap=0.05
              slr_plot_locus,$
                 x_transform[*,0],x_transform[*,1],$
                 contour=contour,scatter=scatter,djs_contour=contour,$
                 fill=fill,linecolor=linecolor,ctable=ctable,$
                 psym=8,symsize=symsize,charsize=charsize,$
                 xtitle='!8g - r!6',ytitle='!8r - i!6',$
                 xrange=minmax(y[*,0])+[-1,1]*buffer,$
                 yrange=minmax(y[*,1])+[-1,1]*buffer,$
                 nlevels=nlevels,histbin=histbin    
              oplot,y[*,0],y[*,1],thick=2

              multiplot

              slr_plot_locus,$
                 x_transform[*,2],x_transform[*,1],$
                 contour=contour,scatter=scatter,djs_contour=contour,$
                 fill=fill,linecolor=linecolor,ctable=ctable,$
                 psym=8,symsize=symsize,charsize=charsize,$
                 xtitle='!8i - z!6',$
                 xrange=minmax(y[*,2])+[-1,1]*buffer,$
                 yrange=minmax(y[*,1])+[-1,1]*buffer,$
                 nlevels=nlevels,histbin=histbin    
              oplot,y[*,2],y[*,1],thick=2

              multiplot,/dox,/doy

              if n_elements(gof_arr) ge 2 then begin
                 plot,findgen(n_elements(gof_arr)),$
                      gof_arr,$
                      /xstyle,/ystyle,/ylog,$
                      xtitle='!6Iteration',$
                      ytitle='!6Goodness of Fit'
              endif                 

              multiplot,/default


              if keyword_set(interactive) then begin
                 junk='' & read,'Hit enter',junk
              endif

        endelse
           
        endif
        
     endif
  endif

  bestfit={p:p,$
           goodi:goodi}


  delvarx,gof_arr


end
