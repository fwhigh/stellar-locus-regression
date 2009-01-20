pro slr_locus_cubes, field=field,$
                     gr=gr,ri=ri,iz=iz,$
                     zJ=zJ,$
                     covey_gr=covey_gr,covey_ri=covey_ri,covey_iz=covey_iz,$
                     covey_zJ=covey_zJ,$
                     postscript=postscript, $
                     interactive=interactive,$
                     ironly=ironly,$
                     snlow=snlow
  
  if not keyword_set(field) then $
     message,"Set a field"
  if not keyword_set(snlow) then snlow=0.0

;;; Covey
  if not keyword_set(covey_gr) then begin
     cat=slr_read_covey_median_locus()
;     cat=slr_covey_analytic_locus()
     y=[[cat.gr],[cat.ri],[cat.iz],[cat.zJ],[cat.JH],[cat.HK]]
     y_err=[[cat.gr_err],[cat.ri_err],[cat.iz_err],[sqrt(cat.iz_err^2+cat.zJ_err^2+cat.JH_err^2)]]
  endif else begin
     if keyword_set(covey_zJ) then begin
        y=[[covey_gr],[covey_ri],[covey_iz],[covey_zJ]]
     endif else begin
        y=[[covey_gr],[covey_ri],[covey_iz]]
     endelse
  endelse


  charsize=1.6
  psym=8
;psym=1
  symsize=1
  az=45
  ax=45

if keyword_set(gr) and not keyword_set(ironly) then begin
  if keyword_set(postscript) then begin
     psfile=slr_figdir()+path_sep()+field+'_ccd.eps'
     ops,file=psfile,/encap,/color,form=2
     linethick=9
  endif else linethick=1
;  xrange=[0,2]
;  yrange=[0,1.4]
;  zrange=[-0.2,1]

  erase
  loadct,12,/silent
  plot_3dbox_fwhigh,gr,ri,iz,$
                    xtitle='!6g - r',ytitle='!6r - i',ztitle='!6i - z',$
                    psym=psym, symsize=symsize, $
                    xrange=xrange, yrange=yrange, zrange=zrange, $
                    GRIDSTYLE=1, AZ=az, ax=ax, $
                    /YSTYLE, charsize=charsize,$
                    /xy_plane,/yz_plane,/xz_plane, /nodata_3d
  loadct,0,/silent
  plot_3dbox_fwhigh,y[*,0],y[*,1],y[*,2],$
                    /overplot, thick=linethick, $
                    color_walls=200, $
                    /xy_plane,/yz_plane,/xz_plane, /nodata_3d
  loadct,12,/silent
  if 0 then begin
  plot_3dbox_fwhigh,y[*,0],y[*,1],y[*,2],$
                    /overplot, thick=linethick, $
                    color_3d=200, color_walls=200, $
                    /xy_plane,/yz_plane,/xz_plane, /onlydata_3d
  plot_3dbox_fwhigh,gr,ri,iz,$
                    /overplot, color_3d=200, $
                    psym=psym, symsize=symsize, $
                    /xy_plane,/yz_plane,/xz_plane, /onlydata_3d
endif
  if keyword_set(postscript) then begin
     cps
  endif else begin
     if keyword_set(interactive) then begin
        junk='' & read,'Hit enter',junk
     endif
  endelse
endif


;;; Plot 2mass too!

  if keyword_Set(zJ) then begin

     if keyword_set(postscript) then begin
        psfile=slr_figdir()+path_sep()+field+'_ccd_2mass_j.eps'
        ops,file=psfile,/encap,/color,form=2
        linethick=9
     endif else linethick=1
     erase
     loadct,12,/silent
     plot,iz,zJ,$
          ytitle='!6z - J',xtitle='!6i - z',$
          psym=psym, symsize=symsize, $
          charsize=charsize
     loadct,0,/silent
     oplot,y[*,2],y[*,3],$
           color=200, thick=linethick
     loadct,12,/silent
     if keyword_set(postscript) then begin
        cps
     endif else begin
        if keyword_set(interactive) then begin
           junk='' & read,'Hit enter',junk
        endif
     endelse

  endif




;;   if keyword_Set(J) then begin

;;      if keyword_set(postscript) then begin
;;         psfile=slr_figdir()+path_sep()+field+'_ccd_2mass.eps'
;;         ops,file=psfile,/encap,/color,form=2
;;         linethick=12
;;      endif else linethick=1
;;      erase
;;      loadct,12,/silent
;;      plot_3dbox_fwhigh,z-J,J-H,H-K,$
;;                        xtitle='!6z - J',ytitle='!6J - H',ztitle='!6H - K',$
;;                        psym=psym, symsize=symsize, $
;;                        GRIDSTYLE=1, AZ=az, ax=ax, $
;;                        /YSTYLE, charsize=charsize,$
;;                        /xy_plane,/yz_plane,/xz_plane, /nodata_3d
;;   loadct,0,/silent
;;   plot_3dbox_fwhigh,cat.zJ,cat.JH,cat.HK,$
;;                     /overplot, thick=linethick, $
;;                     color_walls=200, $
;;                     /xy_plane,/yz_plane,/xz_plane, /nodata_3d
;;   loadct,12,/silent
;;   plot_3dbox_fwhigh,cat.zJ,cat.JH,cat.HK,$
;;                     /overplot, thick=linethick, $
;;                     color_3d=200, color_walls=200, $
;;                     /xy_plane,/yz_plane,/xz_plane, /onlydata_3d
;;      plot_3dbox_fwhigh,z-J,J-H,H-K,$
;;                        /overplot, color_3d=200, $
;;                        psym=psym, symsize=symsize, $
;;                        /xy_plane,/yz_plane,/xz_plane, /onlydata_3d
;;      if keyword_set(postscript) then begin
;;         cps
;;      endif else begin
;;         if keyword_set(interactive) then begin
;;            junk='' & read,'Hit enter',junk
;;         endif
;;      endelse

;;   endif

end
