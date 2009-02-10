function slr_distance_residual, x, x_err, y, y_err, $
                                weighted=weighted, $
                                debug=debug, $
                                get_goodi=get_goodi,goodi=goodi,$
                                wthresh=wthresh,$
                                thresh=thresh

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
;  slr_distance_residual
;
; PURPOSE:
;  Return the sum of hyperdimension color distances between color data and a stellar locus line
;
; DESCRIPTION:
;  
;
; CALLING SEQUENCE:
;  result=slr_distance_residual(x,x_err,y,y_err[,OPTIONAL KEYWORDS])
;
; INPUTS:
;  x     Array of color vectors, the data to be calibrated
;  x_err The corresponding errors
;  y     Array of color vectors representing the stellar locus line
;  y_err The corresponding errors
;
; OPTIONAL INPUTS:
;  /weighted   Weight the distances by the error?
;  /debug      Show extra plots/text for debugging purposes?
;  /get_goodi  Get indices of "good" objects?
;  wthresh     The maximum allowable error-weighted distance to the
;              locus line.  Must set get_goodi.  Default 1000
;  thresh      The maximum allowable distance to the locus line.
;              Must set get_goodi.  Default 1000
;
; OUTPUTS:
;  result  Scalar sum of (optionally weighted) distances between the
;          data and the stellar locus line
;
; OPTIONAL OUTPUTS:
;  goodi       Array of "good" indices, which sasisfy thresh and
;              wthresh conditions.  Must set get_goodi.
;-

  if not keyword_set(thresh) then thresh=1e3
  if not keyword_set(wthresh) then wthresh=1e3

  distance_sum=0.
  n_dim=n_elements(x[0,*])
  n_dat=n_elements(x[*,0])
  delvarx,goodi
  for ind=0,n_dat-1 do begin
     rvec=fltarr(n_elements(y[*,0]),n_dim)
     for jj=0,n_dim-1 do begin
        rvec[*,jj]=x[ind,jj]-y[*,jj]
     endfor
     rnorm=sqrt(total(rvec^2,2))
     rhat=rvec/rvec
     for jj=0,n_dim-1 do begin
        rhat[*,jj]=rvec[*,jj]/rnorm
     endfor
;    rhat[where(rvec eq 0)]=1
     if keyword_set(weighted) or keyword_set(get_goodi) then begin
        weight=sqrt(total((rebin(x_err[ind,*],n_elements(y[*,0]),n_dim)*rhat)^2,2) +0.005^2)
;;        weight=sqrt(total((rebin(x_err[ind,*],n_elements(y[*,0]),n_dim)*rhat)^2,2) + $
;;                    total((y_err*rhat)^2,2))
        weighted_distance=rnorm/weight
        if total(~finite(weighted_distance)) ne 0 then begin
           weighted_distance[where(~finite(weighted_distance))]=1e10
        endif
        nearest_locus_point=where(weighted_distance eq min(weighted_distance),count)
        if count eq 0 then message,"What the?"
;    if count gt 1 then message,"Multiple matches",/info
        nearest_locus_point=nearest_locus_point[0]
        distance_sum=distance_sum+weighted_distance[nearest_locus_point]
     endif else begin
        nearest_locus_point=where(rnorm eq min(rnorm),count)
        if count eq 0 then message,"What the?"
;    if count gt 1 then message,"Multiple matches",/info
        nearest_locus_point=nearest_locus_point[0]
        distance_sum=distance_sum+rnorm[nearest_locus_point]
     endelse
     if keyword_set(get_goodi) then begin
        if count ne 1 then message,"What the?",/info
        if weighted_distance[nearest_locus_point] le wthresh and $
           rnorm[nearest_locus_point] le thresh then begin
           goodi=push_arr(goodi,ind)
        endif
     endif

     if keyword_set(debug) then begin

        plot_3dbox,y[*,0],y[*,1],y[*,2],$
                   xtitle='g - r',ytitle='r - i',ztitle='i - z',$
                   GRIDSTYLE=1, AZ=40, $
                   /YSTYLE, charsize=3, thick=3, $
                   /xy_plane,/yz_plane,/xz_plane
        plots,[x[ind,0]],[x[ind,1]],[x[ind,2]],psym=1,symsize=5,$
              /data,/t3d
        plots,[x[ind,0]],[x[ind,1]],!Z.Crange[0],/t3d,psym=1,$
              symsize=3
        plots,!x.crange[1],[x[ind,1]],[x[ind,2]],/t3d,psym=1,$
              symsize=3
        plots,[x[ind,0]],!y.crange[1],[x[ind,2]],/t3d,psym=1,$
              symsize=3

        plots,[y[nearest_locus_point,0]],$
              [y[nearest_locus_point,1]],$
              [y[nearest_locus_point,2]],$
              psym=7,symsize=5,$
              /data,/t3d
        plots,[y[nearest_locus_point,0]],$
              [y[nearest_locus_point,1]],$
              !Z.Crange[0],/t3d,psym=7,$
              symsize=3
        plots,!x.crange[1],$
              [y[nearest_locus_point,1]],$
              [y[nearest_locus_point,2]],$
              /t3d,psym=7,$
              symsize=3
        plots,[y[nearest_locus_point,0]],$
              !y.crange[1],$
              [y[nearest_locus_point,2]],$
              /t3d,psym=7,$
              symsize=3

        plots,[x[ind,0],y[nearest_locus_point,0]],$
              [x[ind,1],y[nearest_locus_point,1]],$
              [x[ind,2],y[nearest_locus_point,2]],$
              /t3d

        wait,0.1

     endif
  endfor

  return,distance_sum/sqrt(n_dat)

end
