function slr_get_ctab_filename, field

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
