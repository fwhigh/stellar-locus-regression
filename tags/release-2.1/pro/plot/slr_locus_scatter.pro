pro slr_locus_scatter,x,y,$
                      xtitle=xtitle,ytitle=ytitle,title=title,$
                      xrange=xrange,yrange=yrange,$
                      xstyle=xstyle,ystyle=ystyle,$
                      charsize=charsize,$
                      psym=psym,symsize=symsize,$
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
;  slr_locus_scatter
;
; PURPOSE:
;  Scatter-plot a stellar locus.
;
; EXPLANATION:
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
;
;-

 compile_opt idl2, hidden
 on_error, 2

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
