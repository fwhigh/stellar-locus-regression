function strip_ext,name,get_ext=get_ext

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
;  strip_ext
;
; PURPOSE:
;  Return a filename string with the extinsion stripped off.
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


; Preserve the variable "name".
name2=name

if keyword_set(get_ext) then begin

; Get the last extension.
    name2=deslash(name2)
    val=''
    while ( strpos(name2,'.') ne -1 ) do begin
        val=strmid(name2,strpos(name2,'.')+1,strlen(name2))
        name2=strmid(name2,strpos(name2,'.')+1,strlen(name2))
    endwhile

endif else begin

; Strip the last extension.
    path=deslash(name2,/get_raw_path)
    val=deslash(name2)
    name2=val
    count=0
    while ( strpos(name2,'.') ne -1 ) do begin

        if count eq 0 then begin
            val=''
            name2=deslash(name2)
        endif

        if strpos(name2,'.')+1 eq strlen(name2) then begin
            message,'Cannot have a dot as the last character',/info
            return,bunk
        endif

        val=val+strmid(name2,0,strpos(name2,'.')+1)
        name2=strmid(name2,strpos(name2,'.')+1,strlen(name2))
        count++
    endwhile
    
    ; Remove the trailing dot.
    if strmid(val,strlen(val)-1,strlen(val)) eq '.' then $
      val=strmid(val,0,strlen(val)-1)

    val=path+val
    
endelse

return,val

end
