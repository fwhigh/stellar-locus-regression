function slr_read_covey_locus

file=slr_datadir()+path_sep()+'covey'+path_sep()+'superclean.fits'
savefile=file+'.sav'
if file_test(savefile) then begin
   restore,savefile
endif else begin
   cat=mrdfits(file,1)
   save,file=savefile
endelse

return,cat

end
