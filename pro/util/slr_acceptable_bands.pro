function slr_acceptable_bands,$
   john_bands=john_bands,$
   sdss_bands=sdss_bands,$
   tmass_bands=tmass_bands,$
   nosuffixes=nosuffixes
  
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
;  slr_acceptable_bands
;
; PURPOSE:
;  Define the bands that SLR recognizes and can calibrate.
;
; EXPLANATION:
;
; CALLING SEQUENCE:
;  bands=slr_acceptable_bands(john_bands=john_bands,$
;                             sdss_bands=sdss_bands,$
;                             tmass_bands=tmass_bands)
;
; INPUTS:
;
; OPTIONAL INPUTS:
;  nosuffixes=  Suppress the addition of appropriate suffixes to the
;               band letters? 
;
; OUTPUTS:
;  bands (string array) The bands. Appropriate suffixes are not added
;                       if /nosuffixes is set
;
; OPIONAL OUTPUTS:
;   john_bands  (string array)  ['U','B','V','R','I']
;   sdss_bands  (string array)  ['u','g','r','i','z']
;   tmass_bands (string array)  ['J','H','K']
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

; compile_opt idl2, hidden
; on_error, 2

  john_bands=['U','B','V','R','I']
  sdss_bands=['u','g','r','i','z']
  tmass_bands=['J','H','K']
  if keyword_set(nosuffixes) then begin
     acceptable_bands=[john_bands,$
                       sdss_bands,$
                       tmass_bands]
  endif else begin
     acceptable_bands=[john_bands+'john',$
                       sdss_bands+'sdss',$
                       tmass_bands+'tmass']
  endelse

return,acceptable_bands

end
