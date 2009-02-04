function slr_get_ctab_filename, field

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
;  slr_get_ctab_filename
;
; PURPOSE:
;  Get the colortable filename given a field.
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

file=file_search(slr_datadir(),field+'_stars.csv.ct',count=count)
if count ge 1 then return, file[0]
file=file_search(slr_datadir(),field+'.ctab',count=count)
if count ge 1 then return, file[0]
file=file_search(slr_datadir(),field+'.csv.ct',count=count)
if count ge 1 then return, file[0]
file=file_search(slr_datadir(),field+'_star.ct',count=count)
if count ge 1 then return, file[0]
file=file_search(slr_datadir(),field+'.ct',count=count)
if count ge 1 then return, file[0]
file=file_search(slr_datadir(),field+'.sexcat.ctab',count=count)
if count ge 1 then return, file[0]
file=file_search(slr_datadir(),field+'.single.fct',count=count)
if count ge 1 then return, file[0]

message,"No good file found!"

end
