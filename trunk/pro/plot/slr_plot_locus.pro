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
;  slr_plot_locus
;
; PURPOSE:
;  Plot a color-color locus of stellar data points.
;
; EXPLANATION:
;  There are different ways to represent the locus, appropriate for
;  different situations.  This wraps them all together.
;
; CALLING SEQUENCE:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
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
;       Written by:     FW High 2009
;-

 compile_opt idl2, hidden
 on_error, 2

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
