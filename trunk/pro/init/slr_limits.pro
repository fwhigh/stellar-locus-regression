function slr_limits

;+
; Set the default hard limits on the data
;-

  limits={type:1,$
          tmixed:0,$
          stars_and_gals:0,$
          deredden:0,$
          cutdiskstars:0,$
          beelow:0.,$
          zeelow:100,$
          snlow:10,$
          gsnlow:10,$
          gmax:1e10,$
          rmin:-100,$
          rmax:100,$
          gimin:-100,$
          gimax:100,$
          grmin:-100,$
          grmax:100,$
          rimin:-100,$
          rimax:100,$
          izmin:-100,$
          izmax:100,$
          zJmin:-1000,$
          zJmax:+1000,$
          magerr_floor:0.00,$
          max_locus_dist:1.0,$
          max_weighted_locus_dist:10,$
          kappa_guess:[0.0,-0.5,-1.0,replicate(-27.5,4)],$
          kappa_guess_range:replicate(5.,7)$
         }

  return,limits
  
end