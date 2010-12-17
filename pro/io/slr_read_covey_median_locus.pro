function slr_read_covey_median_locus, $
                                      plot=plot, $
                                      force=force, $
                                      verbose=verbose, $
                                      interactive=interactive, $
                                      nosmooth=nosmooth,$
                                      postscript=postscript

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
;  slr_read_covey_median_locus
;
; PURPOSE:
;  Read the median locus table of Covey et al. (2008), called
;  medianlocus.tbl, available at Kevin Covey's website.
;
; EXPLANATION:
;  Returns Covey's median locus, which is smoothed by default
;  here.  This routine also makes cuts on the locus because we
;  typically don't need the very red end.  File is assumed to
;  be in $STL_DATA/covey.
;
; CALLING SEQUENCE:
;  catalog=slr_read_covey_median_locus()
;
; INPUTS:
;
; OPTIONAL INPUTS:
;  plot (bit)        Plot the data?  Default 0.
;  postscript (bit)  Save postscript versions of the plots?  Default
;                    0. 
;  force (bit)       Force to read from the original ascii table
;                    rather than the .sav file?  Default 0.
;  verbose (int)     Verbosity level.  Default 0.
;  interactive (int) Wait for user response when plotting data to
;                    screen? 
;  nosmooth (bit)    Return unsmooth the data?  Default 0.
;
; OUTPUTS:
;  catalog (structure)   The catalog of stellar locus data.
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
;  slr_datadir()
;  slr_read_covey_locus()
;  slr_figdir()
;       
; HISTORY:
;       Written by:     FW High 2008
;
;-

;  k0 = [0.,0.,0.]
;  k0 = [0.00417681,-0.00824140,0.000667928] & $
;   print,'Shifting median locus'
;  k0 = [0.01,0.005,0.005] & print,'Shifting median locus'

if not keyword_set(verbose) then verbose=0
if size(force,/tname) eq 'UNDEFINED' then force=1
force=keyword_set(force)

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
;;; Don't smooth
    endif else begin
;;; Smooth
        boxsize=10

;;; Median smooth
;;      ug=median(ug,boxsize)
;;      gr=median(gr,boxsize)
;;      ri=median(ri,boxsize)
;;      iz=median(iz,boxsize)
;;      zJ=median(zJ,boxsize)
;;      JH=median(JH,boxsize)
;;      HK=median(HK,boxsize)

;;; Boxcar smooth
        ug=smooth(ug,boxsize)
        gr=smooth(gr,boxsize)
        ri=smooth(ri,boxsize)
        iz=smooth(iz,boxsize)
        zJ=smooth(zJ,boxsize)
        JH=smooth(JH,boxsize)
        HK=smooth(HK,boxsize)

;;; Another kind of smooth
;;      ug=imsl_smoothdata1d(gi,ug,dist=0.2)
;;      gr=imsl_smoothdata1d(gi,gr,dist=0.2)
;;      ri=imsl_smoothdata1d(gi,ri,dist=0.2)
;;      iz=imsl_smoothdata1d(gi,iz,dist=0.2)
;;      zJ=imsl_smoothdata1d(gi,zJ,dist=0.2)
;;      JH=imsl_smoothdata1d(gi,JH,dist=0.2)
;;      HK=imsl_smoothdata1d(gi,HK,dist=0.2)
    endelse


    if 0 then begin
;;; Re-estimate error of locus as intrinsic width due to metallicity,
;;; ie, do not include photometric error.  Is this right?  Gives wonky
;;; errors.
        locus=slr_read_covey_locus(force=force)
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

    endif

;;; Convert to Johnson bands.
;;; Jordi et al. 2006
;;; http://www.sdss.org/dr7/algorithms/sdssUBVRITransform.html
;;      U-B   =     (0.79 ± 0.02)*(u-g)    - (0.93 ± 0.02)
;;      U-B   =     (0.52 ± 0.06)*(u-g)    + (0.53 ± 0.09)*(g-r) - (0.82 ± 0.04)
;;      B-g   =     (0.175 ± 0.002)*(u-g)  + (0.150 ± 0.003)
;;      B-g   =     (0.313 ± 0.003)*(g-r)  + (0.219 ± 0.002)
;;      V-g   =     (-0.565 ± 0.001)*(g-r) - (0.016 ± 0.001)
;;      V-I   =     (0.675 ± 0.002)*(g-i)  + (0.364 ± 0.002) if  g-i <= 2.1
;;      V-I   =     (1.11 ± 0.02)*(g-i)    - (0.52 ± 0.05)   if  g-i >  2.1
;;      R-r   =     (-0.153 ± 0.003)*(r-i) - (0.117 ± 0.003)
;;      R-I   =     (0.930 ± 0.005)*(r-i)  + (0.259 ± 0.002)
;;      I-i   =     (-0.386 ± 0.004)*(i-z) - (0.397 ± 0.001)

    Ujohn_Bjohn   =     (0.79)*(ug)    - (0.93)
;     Ujohn_Bjohn   =     (0.52)*(ug)    + (0.53)*(gr) - (0.82)
;     Bjohn_gsdss   =     (0.175)*(ug)  + (0.150)
    Bjohn_gsdss   =     (0.313)*(gr)  + (0.219)
    Vjohn_gsdss   =     (-0.565)*(gr) - (0.016)
    ind1=where(gi le 2.1)
    ind2=where(gi gt 2.1)
    Vjohn_Ijohn=replicate(-99.0,n_elements(gi))
    Vjohn_Ijohn[ind1]   =     (0.675)*(gi[ind1])  + (0.364) ; if  g-i <= 2.1
    Vjohn_Ijohn[ind2]   =     (1.11)*(gi[ind2])    - (0.52) ; if  g-i >  2.1
    Rjohn_rsdss   =     (-0.153)*(ri) - (0.117)
    Rjohn_Ijohn   =     (0.930)*(ri)  + (0.259)
    Ijohn_isdss   =     (-0.386)*(iz) - (0.397)

    Bjohn_Vjohn=Bjohn_gsdss-Vjohn_gsdss
    Bjohn_Rjohn=Bjohn_gsdss+gr-Rjohn_rsdss
;     Vjohn_Rjohn=Vjohn_Ijohn-Rjohn_Ijohn
    Vjohn_Rjohn=Vjohn_gsdss+gr-Rjohn_rsdss
    Ijohn_zsdss=Ijohn_isdss+iz
    Ijohn_Jtmass=Ijohn_zsdss+zJ
    Rjohn_Jtmass=Rjohn_Ijohn+Ijohn_Jtmass
    Vjohn_Jtmass=Vjohn_Rjohn+Rjohn_Jtmass
    Bjohn_Jtmass=Bjohn_Rjohn+Rjohn_Jtmass


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
    Bjohn_Vjohn=Bjohn_Vjohn[select]
    Bjohn_Rjohn=Bjohn_Rjohn[select]
    Vjohn_Rjohn=Vjohn_Rjohn[select]
    rjohn_ijohn=rjohn_ijohn[select]
    ijohn_zsdss=ijohn_zsdss[select]
    Bjohn_Jtmass=Bjohn_Jtmass[select]
    Vjohn_Jtmass=Vjohn_Jtmass[select]
    Rjohn_Jtmass=Rjohn_Jtmass[select]
    Ijohn_Jtmass=Ijohn_Jtmass[select]

    ug_err=ug_err[select]
    gr_err=gr_err[select]
    ri_err=ri_err[select]
    iz_err=iz_err[select]
    zJ_err=zJ_err[select]
    JH_err=JH_err[select]
    HK_err=HK_err[select]

;     ug_width=sqrt((ug_err^2 - ug_photerr^2)>0)
;     gr_width=sqrt((gr_err^2 - gr_photerr^2)>0)
;     ri_width=sqrt((ri_err^2 - ri_photerr^2)>0)
;     iz_width=sqrt((iz_err^2 - iz_photerr^2)>0)
;     zJ_width=sqrt((zJ_err^2 - zJ_photerr^2)>0)
;     JH_width=sqrt((JH_err^2 - JH_photerr^2)>0)
;     HK_width=sqrt((HK_err^2 - HK_photerr^2)>0)

    cat={gsdss_isdss:gi,$
         num:n_elements(gi),$
         usdss_gsdss:ug,$
         usdss_gsdss_err:ug_err,$
;          ug_width:ug_width,$
    gsdss_rsdss:gr,$
      gsdss_rsdss_err:gr_err,$
;          gr_width:gr_width,$
    rsdss_isdss:ri,$
      rsdss_isdss_err:ri_err,$
;          ri_width:ri_width,$
    isdss_zsdss:iz,$
      isdss_zsdss_err:iz_err,$
;          iz_width:iz_width,$
    zsdss_Jtmass:zJ,$
      zsdss_Jtmass_err:zJ_err,$
;          zJ_width:zJ_width,$
    Jtmass_Htmass:JH,$
      Jtmass_Htmass_err:JH_err,$
;          JH_width:JH_width,$
    Htmass_Ktmass:HK,$
      Htmass_Ktmass_err:HK_err,$
;          HK_width:HK_width,$
    gsdss_zsdss:gi+iz,$
      gsdss_Jtmass:gi+iz+zJ,$
      gsdss_Htmass:gi+iz+zJ+JH,$
      gsdss_Ktmass:gi+iz+zJ+JH+HK,$
      rsdss_zsdss:ri+iz,$
      rsdss_Jtmass:ri+iz+zJ,$
      rsdss_Htmass:ri+iz+zJ+JH,$
      rsdss_Ktmass:ri+iz+zJ+JH+HK,$
      isdss_Jtmass:iz+zJ,$
      isdss_Htmass:iz+zJ+JH,$
      isdss_Ktmass:iz+zJ+JH+HK,$
      zsdss_Htmass:zJ+JH,$
      zsdss_Ktmass:zJ+JH+HK,$
      Jtmass_Ktmass:JH+HK,$
      bjohn_vjohn:bjohn_vjohn,$
      bjohn_rjohn:bjohn_rjohn,$
      vjohn_rjohn:vjohn_rjohn,$
      rjohn_ijohn:rjohn_ijohn,$
      ijohn_zsdss:ijohn_zsdss,$
      Bjohn_Jtmass:Bjohn_Jtmass,$
      Vjohn_Jtmass:Vjohn_Jtmass,$
      Rjohn_Jtmass:Rjohn_Jtmass,$
      Ijohn_Jtmass:Ijohn_Jtmass}

    save,file=savefile,cat

endelse

;  cat.gr-=k0[0]
;  cat.ri-=k0[1]
;  cat.iz-=k0[2]

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
    plot_3dbox,cat.gr,cat.ri,cat.iz,$
      xtitle='!6g - r',ytitle='!6r - i',ztitle='!6i - z',$
      thick=linethick, $
      GRIDSTYLE=1, AZ=az, ax=ax, $
      /YSTYLE, charsize=charsize,$
      /xy_plane,/yz_plane,/xz_plane, /nodata_3d
;;      plot_3dbox_fwhigh,cat.gr,cat.ri,cat.iz,$
;;                        xtitle='!6g - r',ytitle='!6r - i',ztitle='!6i - z',$
;;                        thick=linethick, $
;;                        GRIDSTYLE=1, AZ=az, ax=ax, $
;;                        /YSTYLE, charsize=charsize,$
;;                        /xy_plane,/yz_plane,/xz_plane, /nodata_3d
    loadct,12,/silent
    plot_3dbox,cat.gr,cat.ri,cat.iz,$
      /overplot, thick=linethick, $
      color_3d=200, $
      /xy_plane,/yz_plane,/xz_plane, /onlydata_3d
;;      plot_3dbox_fwhigh,cat.gr,cat.ri,cat.iz,$
;;                        /overplot, thick=linethick, $
;;                        color_3d=200, $
;;                        /xy_plane,/yz_plane,/xz_plane, /onlydata_3d
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

endif

return,cat

end
