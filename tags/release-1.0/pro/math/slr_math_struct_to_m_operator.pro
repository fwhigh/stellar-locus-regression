function slr_math_struct_to_m_operator, math, p,$
                                    p_counter=p_counter

m_out=replicate(0.,math.m.n)
for ii=0,math.m.n-1 do begin
    if math.m.fixed[ii] then begin
        m_out[ii]=math.m.val[ii]
    endif else begin
        m_out[ii]=p[p_counter]
        p_counter=p_counter+1
    endelse
 endfor

matrix_out=slr_colorterm_matrix(m_out,type=math.type)

return,matrix_out

end
