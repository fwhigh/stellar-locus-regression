function slr_get_2mass_filename, field, out=out

if keyword_set(out) then out='_2mass_out' else out=''

file=slr_datadir()+path_sep()+field+out+'.tbl'
return,file

end
