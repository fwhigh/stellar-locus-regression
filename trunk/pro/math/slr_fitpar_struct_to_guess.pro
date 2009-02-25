function slr_fitpar_struct_to_guess, fitpar

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
;  slr_fitpar_struct_to_guess
;
; PURPOSE:
;  Get the initial guess for parameters before numerical regression.
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
;       Written by:     FW High 2008
;
;-

  for ii=0,fitpar.kappa.n-1 do begin
     if ~fitpar.kappa.fixed[ii] then p=push_arr(p,fitpar.kappa.guess[ii])
  endfor
  for ii=0,fitpar.b.n-1 do begin
     if ~fitpar.b.fixed[ii] then p=push_arr(p,fitpar.b.guess[ii])
  endfor
  if size(p,/tname) eq 'UNDEFINED' then $
     message,'No valid guess!'

  return,p

end
