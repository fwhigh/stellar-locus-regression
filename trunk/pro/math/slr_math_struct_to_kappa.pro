function slr_math_struct_to_kappa, math, p,$
                               p_counter=p_counter

kappa_out=replicate(0.,math.kappa.n)
for ii=0,math.kappa.n-1 do begin
    if math.kappa.fixed[ii] then begin
        kappa_out[ii]=math.kappa.val[ii]
    endif else begin
        kappa_out[ii]=p[p_counter]
        p_counter=p_counter+1
    endelse
endfor

return,kappa_out

end
