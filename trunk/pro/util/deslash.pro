function deslash,name,get_path=get_path,$
                 get_raw_path=get_raw_path

; Preserve the variable "name".
name2=name

if keyword_set(get_path) then begin

    val='.'
    count=0
    while ( strpos(name2,'/') ne -1 ) do begin
        if count eq 0 then val=''
        val=val+strmid(name2,0,strpos(name2,'/')+1)
        name2=strmid(name2,strpos(name2,'/')+1,strlen(name2))
        count++
    endwhile

    ; Remove the trailing slash.
    if strmid(val,strlen(val)-1,strlen(val)) eq '/' then $
      val=strmid(val,0,strlen(val)-1)

endif else if keyword_set(get_raw_path) then begin

    val=''
    while ( strpos(name2,'/') ne -1 ) do begin
        val=val+strmid(name2,0,strpos(name2,'/')+1)
        name2=strmid(name2,strpos(name2,'/')+1,strlen(name2))
    endwhile

endif else begin

    val=name2
    while ( strpos(val,'/') ne -1 ) do begin
        val=strmid(val,strpos(val,'/')+1,strlen(val))
    endwhile
 
endelse

return,val

end
