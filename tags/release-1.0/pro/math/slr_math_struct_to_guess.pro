function slr_math_struct_to_guess, math

  for ii=0,math.kappa.n-1 do begin
     if ~math.kappa.fixed[ii] then p=push_arr(p,math.kappa.guess[ii])
  endfor
  for ii=0,math.m.n-1 do begin
     if ~math.m.fixed[ii] then p=push_arr(p,math.m.guess[ii])
  endfor
  if size(p,/tname) eq 'UNDEFINED' then $
     message,'No valid guess!'

  return,p

end
