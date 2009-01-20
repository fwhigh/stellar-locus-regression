function slr_read_covey_median_locus, $
   plot=plot, $
   force=force, $
   verbose=verbose, $
   interactive=interactive, $
   nosmooth=nosmooth,$
   postscript=postscript

  k0 = [0.,0.,0.]
;  k0 = [0.00417681,-0.00824140,0.000667928]
;  k0 = [0.01,0.005,0.005]
;  print,'Correcting Covey for reddening?!?!'

  if not keyword_set(verbose) then verbose=0

  file=slr_datadir()+path_sep()+'covey'+path_sep()+'medianlocus.tbl'
  savefile=file+'.sav'
  if file_test(savefile) and not keyword_set(force) then begin
     restore,savefile
  endif else begin

     readcol,file,$
             gi,num,$
             ug,ug_err,$
             gr,gr_err,$
             ri,ri_err,$
             iz,iz_err,$
             zJ,zJ_err,$
             JH,JH_err,$
             HK,HK_err,$
             /silent

     if keyword_set(nosmooth) then begin

     endif else begin
        boxsize=10

;;      ug=median(ug,boxsize)
;;      gr=median(gr,boxsize)
;;      ri=median(ri,boxsize)
;;      iz=median(iz,boxsize)
;;      zJ=median(zJ,boxsize)
;;      JH=median(JH,boxsize)
;;      HK=median(HK,boxsize)

        ug=smooth(ug,boxsize)
        gr=smooth(gr,boxsize)
        ri=smooth(ri,boxsize)
        iz=smooth(iz,boxsize)
        zJ=smooth(zJ,boxsize)
        JH=smooth(JH,boxsize)
        HK=smooth(HK,boxsize)

;;      ug=imsl_smoothdata1d(gi,ug,dist=0.2)
;;      gr=imsl_smoothdata1d(gi,gr,dist=0.2)
;;      ri=imsl_smoothdata1d(gi,ri,dist=0.2)
;;      iz=imsl_smoothdata1d(gi,iz,dist=0.2)
;;      zJ=imsl_smoothdata1d(gi,zJ,dist=0.2)
;;      JH=imsl_smoothdata1d(gi,JH,dist=0.2)
;;      HK=imsl_smoothdata1d(gi,HK,dist=0.2)

;;; Re-estimate error of locus as intrinsic width due to metallicity,
;;; ie, do not include photometric error
     endelse
     locus=slr_read_covey_locus()
     nbins=n_elements(gi)
     large_bins=[0,1,nbins-2,nbins-1]
     for ii = 0,nbins-1 do begin
        binsize=0.02
        for jj=0,n_elements(large_bins)-1 do begin
           if ii eq large_bins[jj] then $
              binsize=0.10
        endfor
        obji=where(locus.gi ge (gi[ii] - binsize/2.0) and $
                   locus.gi le (gi[ii] + binsize/2.0), $
                   count)
        if verbose ge 2 then begin
           print
           print,"count ",count," ",fix(num[ii])," in gi bin ",gi[ii]
           if count ne num[ii] then message,"Not equal!",/info
           print,"ug ",median(locus[obji].ug)," ",ug[ii]
           print,"gr ",median(locus[obji].gr)," ",gr[ii]
           print,"ri ",median(locus[obji].ri)," ",ri[ii]
           print,"iz ",median(locus[obji].iz)," ",iz[ii]
           print,"zJ ",median(locus[obji].zJ)," ",zJ[ii]
           print,"JH ",median(locus[obji].JH)," ",JH[ii]
           print,"HK ",median(locus[obji].HK)," ",HK[ii]
        endif
        if count lt 2 then message,"Only "+strtrim(count,2)+" matches"
        ug_photerr=push_arr(ug_photerr,median(locus[obji].ugerr)>0.03)
        gr_photerr=push_arr(gr_photerr,median(locus[obji].grerr)>0.03)
        ri_photerr=push_arr(ri_photerr,median(locus[obji].rierr)>0.03)
        iz_photerr=push_arr(iz_photerr,median(locus[obji].izerr)>0.03)
        zJ_photerr=push_arr(zJ_photerr,median(locus[obji].zJerr)>0.03)
        JH_photerr=push_arr(JH_photerr,median(locus[obji].JHerr)>0.03)
        HK_photerr=push_arr(HK_photerr,median(locus[obji].HKerr)>0.03)

     endfor

     rirange=[0.1,1.9]
     select=where(ri ge rirange[0] and ri le rirange[1])
     gi=gi[select]
     ug=ug[select]
     gr=gr[select]
     ri=ri[select]
     iz=iz[select]
     zJ=zJ[select]
     JH=JH[select]
     HK=HK[select]

     ug_err=ug_err[select]
     gr_err=gr_err[select]
     ri_err=ri_err[select]
     iz_err=iz_err[select]
     zJ_err=zJ_err[select]
     JH_err=JH_err[select]
     HK_err=HK_err[select]

     ug_width=sqrt((ug_err^2 - ug_photerr^2)>0)
     gr_width=sqrt((gr_err^2 - gr_photerr^2)>0)
     ri_width=sqrt((ri_err^2 - ri_photerr^2)>0)
     iz_width=sqrt((iz_err^2 - iz_photerr^2)>0)
     zJ_width=sqrt((zJ_err^2 - zJ_photerr^2)>0)
     JH_width=sqrt((JH_err^2 - JH_photerr^2)>0)
     HK_width=sqrt((HK_err^2 - HK_photerr^2)>0)

     cat={gi:gi,$
          num:num,$
          ug:ug,$
          ug_err:ug_err,$
          ug_width:ug_width,$
          gr:gr,$
          gr_err:gr_err,$
          gr_width:gr_width,$
          ri:ri,$
          ri_err:ri_err,$
          ri_width:ri_width,$
          iz:iz,$
          iz_err:iz_err,$
          iz_width:iz_width,$
          zJ:zJ,$
          zJ_err:zJ_err,$
          zJ_width:zJ_width,$
          JH:JH,$
          JH_err:JH_err,$
          JH_width:JH_width,$
          HK:HK,$
          HK_err:HK_err,$
          HK_width:HK_width}

     save,file=savefile,cat

  endelse

  cat.gr-=k0[0]
  cat.ri-=k0[1]
  cat.iz-=k0[2]

  if keyword_set(plot) then begin

     galext=[5.115,3.793,2.751,2.086,1.479,$
             0.902,0.576,0.367,0.153]



     charsize=1.6
     psym=8
;psym=1
     symsize=1
     az=45
     ax=45


     if keyword_set(postscript) then begin
        psfile=slr_figdir()+path_sep()+'covey_median_sloan.eps'
        ops,file=psfile,/encap,/color,form=2
        linethick=12
     endif else linethick=3
     erase
     loadct,0,/silent
     plot_3dbox_fwhigh,cat.gr,cat.ri,cat.iz,$
                       xtitle='!6g - r',ytitle='!6r - i',ztitle='!6i - z',$
                       thick=linethick, $
                       GRIDSTYLE=1, AZ=az, ax=ax, $
                       /YSTYLE, charsize=charsize,$
                       /xy_plane,/yz_plane,/xz_plane, /nodata_3d
     loadct,12,/silent
     plot_3dbox_fwhigh,cat.gr,cat.ri,cat.iz,$
                       /overplot, thick=linethick, $
                       color_3d=200, $
                       /xy_plane,/yz_plane,/xz_plane, /onlydata_3d
     if keyword_set(postscript) then begin
        cps
     endif else begin
        if keyword_set(interactive) then begin
           junk='' & read,'Hit enter',junk
        endif
     endelse



     if keyword_set(postscript) then begin
        psfile=slr_figdir()+path_sep()+'covey_median_2mass.eps'
        ops,file=psfile,/encap,/color,form=2
        linethick=12
     endif else linethick=3
     erase
     loadct,0,/silent
     plot_3dbox_fwhigh,cat.zJ,cat.JH,cat.HK,$
                       xtitle='!6z - J',ytitle='!6J - H',ztitle='!6H - K',$
                       thick=linethick, $
                       GRIDSTYLE=1, AZ=az, ax=ax, $
                       /YSTYLE, charsize=charsize,$
                       /xy_plane,/yz_plane,/xz_plane, /nodata_3d
     loadct,12,/silent
     plot_3dbox_fwhigh,cat.zJ,cat.JH,cat.HK,$
                       /overplot, thick=linethick, $
                       color_3d=200, $
                       /xy_plane,/yz_plane,/xz_plane, /onlydata_3d
     if keyword_set(postscript) then begin
        cps
     endif else begin
        if keyword_set(interactive) then begin
           junk='' & read,'Hit enter',junk
        endif
     endelse



;;         window,0,xsize=800,ysize=800
;;         multiplot,[0,3,2,0,0],/dox,/doy,gap=0.035
;;         ploterror,cat.ug,cat.gr,cat.ug_width,cat.gr_width,/nohat,$
;;                   xtitle='u - g',$
;;                   ytitle='g - r'
;;         arrow,!x.crange[0],!y.crange[0],$
;;               !x.crange[0]+galext[0]-galext[1],$
;;               !y.crange[0]+galext[1]-galext[2],$
;;               /data,color=40,thick=4,/solid
;;         multiplot,/dox,/doy
;;         ploterror,cat.gr,cat.ri,cat.gr_width,cat.ri_width,/nohat,$
;;                   xtitle='g - r',$
;;                   ytitle='r - i'
;;         arrow,!x.crange[0],!y.crange[0],$
;;               !x.crange[0]+galext[1]-galext[2],$
;;               !y.crange[0]+galext[2]-galext[3],$
;;               /data,color=40,thick=4,/solid
;;         multiplot,/dox,/doy
;;         ploterror,cat.ri,cat.iz,cat.ri_width,cat.iz_width,/nohat,$
;;                   xtitle='r - i',$
;;                   ytitle='i - z'
;;         arrow,!x.crange[0],!y.crange[0],$
;;               !x.crange[0]+galext[2]-galext[3],$
;;               !y.crange[0]+galext[3]-galext[4],$
;;               /data,color=40,thick=4,/solid
;;         multiplot,/dox,/doy
;;         ploterror,cat.iz,cat.zJ,cat.iz_width,cat.zJ_width,/nohat,$
;;                   xtitle='z - J',$
;;                   ytitle='J - H'
;;         arrow,!x.crange[0],!y.crange[0],$
;;               !x.crange[0]+galext[3]-galext[4],$
;;               !y.crange[0]+galext[4]-galext[5],$
;;               /data,color=40,thick=4,/solid
;;         multiplot,/dox,/doy
;;         ploterror,cat.JH,cat.HK,cat.JH_width,cat.HK_width,/nohat,$
;;                   xtitle='J - H',$
;;                   ytitle='H - K'
;;         arrow,!x.crange[0],!y.crange[0],$
;;               !x.crange[0]+galext[4]-galext[5],$
;;               !y.crange[0]+galext[5]-galext[6],$
;;               /data,color=40,thick=4,/solid
;;         multiplot,/default


  endif

  return,cat

end
