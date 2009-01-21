function slr_math_struct_to_guess_range, math


  for ii=0,math.kappa.n-1 do begin
     if ~math.kappa.fixed[ii] then $
        range=push_arr(range,math.kappa.range[ii])
  endfor
  for ii=0,math.m.n-1 do begin
     if ~math.m.fixed[ii] then $
        range=push_arr(range,math.m.range[ii])
  endfor

  return,range

end
