pro slr_locus_scatter,x,y,$
                      xtitle=xtitle,ytitle=ytitle,title=title,$
                      xrange=xrange,yrange=yrange,$
                      xstyle=xstyle,ystyle=ystyle,$
                      charsize=charsize,$
                      psym=psym,symsize=symsize,$
                      overplot=overplot,color=color
  min1=min(x)
  max1=max(x)
  min2=min(y)
  max2=max(y)

  z=alog10(hist_2d(x,y,$
                   bin1=histbin,min1=min1,max1=max1,$
                   bin2=histbin,min2=min2,max2=max2)) > 0
  if not keyword_set(overplot) then begin
     plot,x,y,$
          psym=psym,symsize=symsize,$
          color=color,$
          xrange=xrange,$
          yrange=yrange,$
          xstyle=xstyle,ystyle=ystyle,$
          charsize=charsize,$
          title=title,$
          ytitle=ytitle,$
          xtitle=xtitle
  endif else begin
     oplot,x,y,$
          psym=psym,symsize=symsize,$
          color=color
  endelse


end
