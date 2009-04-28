pro slr_log, file, $
             lines, $
             initialize=initialize

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
;  slr_log
;
; PURPOSE:
;  Append information to a log file.
;
; EXPLANATION:
;  Default behavior is to append to an existing log file.  You must
;  specify /initialize at least once so that the file is sure to
;  exist.
;
; CALLING SEQUENCE:
;  slr_log,logfile,lines
;
; INPUTS:
;  logfile (string)      The log filename.
;  lines (string array)  Lines to write to logfile.  Should be
;                        preformatted, as no formatting is done here.
;
; OPTIONAL INPUTS:
;  initialize (bit)  Initialize logfile?  If true: logfile is
;                    created if it doesn't exist, and is
;                    clobbered otherwise.  Default false.
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

; compile_opt idl2, hidden
; on_error,2


;if not file_test(file) then begin
;   if not keyword_set(initialize) then begin
;      message,"You must initialize the log file with /initialize"
;   endif
;endif

if n_elements(lines) eq 0 then begin
   message,"You must supply text to write"
endif

if keyword_set(initialize) then append=0 else append=1

lun=8
openw,lun,file,append=append
for ii=0,n_elements(lines)-1 do begin
   print,lines[ii]
   printf,lun,lines[ii]
endfor
close,lun

end
