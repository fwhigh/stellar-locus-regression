function deslash,name,$
                 path=path,$
                 raw_path=raw_path

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
;  deslash
;
; PURPOSE:
;  Remove the directory-part of a filename.
;
; EXPLANATION:
;  Useful for making new filenames or logging data.
;  
; CALLING SEQUENCE:
;  filename=deslash(full_path_filename)
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
;       8/09  Added optional path outputs
;       Written by:     FW High 2009
;
;-

 compile_opt idl2, hidden
 on_error, 2

; Preserve the variable "name".
name2=name

path='.'
count=0
while ( strpos(name2,path_sep()) ne -1 ) do begin
   if count eq 0 then path=''
   path=path+strmid(name2,0,strpos(name2,path_sep())+1)
   name2=strmid(name2,strpos(name2,path_sep())+1,strlen(name2))
   count++
endwhile

                                ; Remove the trailing slash.
if strmid(path,strlen(path)-1,strlen(path)) eq path_sep() then $
   path=strmid(path,0,strlen(path)-1)

raw_path=''
while ( strpos(name2,path_sep()) ne -1 ) do begin
   raw_path=raw_path+strmid(name2,0,strpos(name2,path_sep())+1)
   name2=strmid(name2,strpos(name2,path_sep())+1,strlen(name2))
endwhile

bare_file=name2
while ( strpos(bare_file,path_sep()) ne -1 ) do begin
   bare_file=strmid(bare_file,strpos(bare_file,path_sep())+1,strlen(bare_file))
endwhile

return,bare_file

end
