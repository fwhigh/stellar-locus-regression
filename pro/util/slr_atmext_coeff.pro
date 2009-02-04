function slr_atmext_coeff

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
;  slr_atmext_coeff
;
; PURPOSE:
;  Get the CTIO atmospheric extinction coefficients.
;
; EXPLANATION:
;  From the Smith et al. series of papers on Southern ugriz
;  standards. 
;
; CALLING SEQUENCE:
;  k=slr_atmext_coeff()
;
; INPUTS:
;      
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
;       Written by:     FW High 2008
;
;-

; Smith et al 2006
;return,[0.181,0.095,0.089,0.053]

; Smith et al 2003
return,[0.172,0.093,0.052,0.044]

end
