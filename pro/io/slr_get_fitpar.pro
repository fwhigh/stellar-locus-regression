function slr_get_fitpar, data,$
                         option, $
                         abs=abs

  if keyword_set(abs) then begin
     fitpar=data.fitpar1
  endif else begin
     case option.use_fitpar of
        0:begin
           fitpar=data.fitpar0
        end
        1:begin
           fitpar=data.fitpar1
        end
        else:begin
           message,"Only fitpar=0 accepted right now"
        end
     endcase
  endelse

  return,fitpar

end
