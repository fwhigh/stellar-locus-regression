function push_arr, array, scalar

if size(array,/tname) eq "UNDEFINED" then begin
    outarr=[scalar]
endif else begin
    outarr=[array,scalar]
endelse

return,outarr

end
