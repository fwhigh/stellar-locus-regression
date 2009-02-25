function slr_get_fitpar, data,$
                         option


  case option.use_fitpar of
     0:begin
        fitpar=data.fitpar0
     end
     else:begin
        message,"Only fitpar=0 accepted right now"
     end
  endcase

  return,fitpar

end
