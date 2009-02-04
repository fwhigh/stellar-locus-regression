pro slr_plot_locus,x,y,$
                   scatter=scatter,contour=contour,djs_contour=djs_contour,$
                   ctable=ctable,$
                   cubes=cubes,$
                   levels=levels,nopoints=nopoints,$
                   xtitle=xtitle,ytitle=ytitle,title=title,$
                   xrange=xrange,yrange=yrange,$
                   xstyle=xstyle,ystyle=ystyle,$
                   charsize=charsize,thick=thick,$
                   fill=fill,linecolor=linecolor,$
                   psym=psym,symsize=symsize,$
                   histbin=histbin,nlevels=nlevels,$
                   overplot=overplot,color=color

  if keyword_set(scatter) then begin
     slr_locus_scatter,x,y,$
                       xtitle=xtitle,ytitle=ytitle,title=title,$
                       xrange=xrange,yrange=yrange,$
                       xstyle=xstyle,ystyle=ystyle,$
                       charsize=charsize,$
                       psym=psym,symsize=symsize,$
                       overplot=overplot,color=color
  endif
  if keyword_set(contour) then begin
     if keyword_set(djs_contour) then begin
        djs_contourpts,$
           x,y,$
           levels=levels,nlevels=nlevels,$
           ilow=ilow,level0=level0,$
           ctable=ctable,nopoints=nopoints,$
           psym=psym,symsize=symsize,$
           bin1=histbin,bin2=histbin,$
           xtitle=xtitle,ytitle=ytitle,title=title,$
           font=1,$
           xstyle=xstyle,ystyle=ystyle,$
           xrange=xrange,yrange=yrange,$
           charsize=charsize,$
           thick=thick,$
           /loglevels,$
           fill=fill,linecolor=linecolor,$
           overplot=overplot,$
           color=color
;;         if ilow[0] ne -1 then begin
;;            ihigh=setdifference(lindgen(n_elements(x)),ilow)
;;         endif else begin
;;            ihigh=lindgen(n_elements(x))
;;         endelse
;;         stop
     endif else begin
        slr_locus_contour,x,y,$
                          xtitle=xtitle,ytitle=ytitle,title=title,$
                          xstyle=xstyle,ystyle=ystyle,$
                          xrange=xrange,yrange=yrange,$
                          charsize=charsize,$
                          histbin=histbin,nlevels=nlevels,$
                          overplot=overplot,color=color
     endelse
  endif

  if keyword_set(cubes) then begin



  endif

end
