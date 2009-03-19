pro slr_demo, configfile=configfile

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
;  slr_demo
;
; PURPOSE:
;  Demonstrate the SLR package out of the box.
;
; EXPLANATION:
;  Uses data in example_data.  Requires a proper installation to run
;  successfully. 
;
; CALLING SEQUENCE:
;  slr_demo
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
;       Written by:     FW High Jan 2009
;-

; compile_opt idl2, hidden

 start_time=systime(1)

 slr_pipe,infile='low_reddening.ctab',$
          outfile='low_reddening.slr.ctab'

 slr_pipe,infile='high_reddening.ctab',$
          outfile='high_reddening.slr.ctab'

 message,"SLR demo successfully completed in "+$
         strtrim(string(SYSTIME(1)-start_time,format='(F10.3)'),2)+$
         ' seconds',/info

end
