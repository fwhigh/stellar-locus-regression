function slr_limits

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
;  slr_limits
;
; PURPOSE:
;  Set the default hard limits on the data
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
          magerr_floor:0.005,$
          max_locus_dist:1e3,$
          max_weighted_locus_dist:1e3,$
          kappa_guess:[0.0,0.0,0.0,replicate(-27.5,4)],$
          kappa_guess_range:replicate(5.,7)$
         }

  return,limits
  
end
