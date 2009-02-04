function slr_sfd_coeff

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
;  slr_sfd_coeff
;
; PURPOSE:
;  Return the Schlegel, Finkbeiner & Davis 1998 Galactic extinction
;  coefficients 
;
; EXPLANATION:
;  Use this routine to get the SFD extinction coefficients.  See Table
;  6 of Schlegel, Finkbeiner & Davis (1998).
;
; CALLING SEQUENCE:
;  coeff=slr_sfd_coeff()
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;  coeff (float array)  Array of SFD coefficients
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
;-

; ugrizJHK
galext=[5.115,3.793,2.751,2.086,1.479,$
        0.902,0.576,0.367]

return,galext


end
