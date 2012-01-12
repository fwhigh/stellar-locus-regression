function slr_get_covey_data,$
                            colornames,$
                            use_synthetic,$
                            err=err
                        
if n_elements(use_synthetic) eq 0 then use_synthetic=0

if (use_synthetic) then restore,slr_datadir()+path_sep()+'phoenixlocus.sav' $
else cat=slr_read_covey_median_locus()
  for jj=0,n_elements(colornames)-1 do begin
;     this_color=strjoin(strsplit(colornames[jj],'-',/extract))
     this_color=colornames[jj]
     tags=tag_names(cat)
     coli=where(strlowcase(tags) eq $
                strlowcase(this_color),count)
;     colerri=where(strlowcase(tags) eq $
;                   strlowcase(this_color)+'_err',count_err)
     if count eq 0 then begin
        message,"Covey data doesn't include color "+this_color
     endif else if count eq 1 then begin
        if size(dat,/tname) eq 'UNDEFINED' then begin
           dat=cat.(coli)
;           err=cat.(colerri)
        endif else begin
           dat=[[dat],$
                [cat.(coli)]]
;           err=[[err],$
;                [cat.(colerri)]]
        endelse
     endif
  endfor

  return,dat

end
