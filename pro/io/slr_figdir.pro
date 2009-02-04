function slr_figdir

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
;  slr_figdir
;
; PURPOSE:
;  Return the generic, root figure directory for Stellar Locus Regression.
;
; EXPLANATION:
;  This routine lets you put SLR figures always in the same place.
;  This routine does not create the directory.
;
; CALLING SEQUENCE:
;  dir=slr_figdir()
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;  dir (string)   The dirctory.
;
; OPIONAL OUTPUTS:
;       
; NOTES:
;
; EXAMPLES:
;  filename=slr_figdir()+path_sep()+'someplot.ps'
;
; PROCEDURES USED:
;       
; HISTORY:
;       Written by:     FW High 2008
;
;-

return,slr_datadir()+path_sep()+'fig'

end
