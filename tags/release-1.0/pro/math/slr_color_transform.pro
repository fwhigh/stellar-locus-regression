function slr_color_transform_OLD, x2, p, trans_type, basis, const=const, $
                                  inverse=inverse, debug=debug

  debug=keyword_set(debug)

  small_color_coeff=0

  if keyword_set(inverse) then begin
     if trans_type eq 0 then begin
        return,[[-p[0]+x2[*,0]],$
                [-p[1]+x2[*,1]],$
                [-p[2]+x2[*,2]],$
                [-p[3]+x2[*,3]]]
     endif else if trans_type eq 1 then begin
        if basis eq 1 then begin
           if small_color_coeff then begin
              return,$
                 [[(x2[*,0]-p[0])*(1-p[3]) + (x2[*,1]-p[1])*p[4]                      ],$
                  [                          (x2[*,1]-p[1])*(1-p[4]) + (x2[*,2]-p[2])*p[5]   ]  ,$
                  [                                                    (x2[*,2]-p[2])*(1-p[5]+p[6]) ] ]
           endif else begin
              if debug then print,'small=',0
              return,$
                 [[(x2[*,0]-p[0])          /(1+p[3]) +$
                   (x2[*,1]-p[1])*p[4]     /(1+p[3])/(1+p[4])+$
                   (x2[*,2]-p[2])*p[4]*p[5]/(1+p[3])/(1+p[4])/(1+p[5]-p[6]) $
                  ],$
                  [(x2[*,1]-p[1])      /(1+p[4]) +$
                   (x2[*,2]-p[2])*p[5]/(1+p[4])/(1+p[5]-p[6]) $
                  ]  ,$
                  [(x2[*,2]-p[2])/(1+p[5]-p[6]) ] ]
           endelse
        endif else if basis eq 2 then begin
           message,"No"
           return,[[p[0]+x2[*,0]*(1+p[3])+$
                    x2[*,1]*(p[5]-p[3])   -x2[*,2]*p[5]]     ,$
                   [p[1]                 +$
                    x2[*,1]*(1+p[4]+p[5]) -x2[*,2]*p[5]]     ,$
                   [p[2]                 +$
                    x2[*,1]*(p[4]+p[6])   +x2[*,2]*(1-p[6])] ]
        endif else begin
           message,"Don't know basis"
        endelse
     endif else if trans_type eq 2 then begin
        if basis eq 1 then begin
           if small_color_coeff then begin
              if debug then print,'small=',1
              return,$
                 [[(x2[*,0]-const[0])*(1-p[0]) +   (x2[*,1]-const[1])*p[1]  ],$
                  [(x2[*,1]-const[1])*(1-p[1]) +   (x2[*,2]-const[2])*p[2]  ]  ,$
                  [(x2[*,2]-const[2])*(1-p[2]+p[3]) ] ]
           endif else begin
              return,$
                 [[(x2[*,0]-const[0])          *(1+p[0])^(-1) +$
                   (x2[*,1]-const[1])*p[1]     *(1+p[0])^(-1) *(1+p[1])^(-1) +$
                   (x2[*,2]-const[2])*p[1]*p[2]*(1+p[0])^(-1) *(1+p[1])^(-1) *(1+p[2]-p[3])^(-1) $
                  ],$
                  [(x2[*,1]-const[1])                         *(1+p[1])^(-1) +$
                   (x2[*,2]-const[2])*p[2]                    *(1+p[1])^(-1) *(1+p[2]-p[3])^(-1) $
                  ]  ,$
                  [(x2[*,2]-const[2])*(1+p[2]-p[3])^(-1) ] ]
           endelse
        endif else if basis eq 2 then begin
           message,"No"
           return,[[p[0]+x2[*,0]*(1+p[3]) +x2[*,1]*(p[5]-p[3])   -x2[*,2]*p[5]]     ,$
                   [p[1]                  +x2[*,1]*(1+p[4]+p[5]) -x2[*,2]*p[5]]     ,$
                   [p[2]                  +x2[*,1]*(p[4]+p[6])   +x2[*,2]*(1-p[6])] ]
        endif else begin
           message,"Don't know basis"
        endelse
     endif else begin
        message,"Order must be 0 or 1"
     endelse  


  endif else begin

     if trans_type eq 0 then begin
        return,[[p[0]+x2[*,0]],$
                [p[1]+x2[*,1]],$
                [p[2]+x2[*,2]],$
                [p[3]+x2[*,3]]]
     endif else if trans_type eq 1 then begin
        if basis eq 1 then begin
           return,$
              [[p[0]+$
                x2[*,0]*(1+p[3]) -x2[*,1]*p[4] ] ,$
               [p[1]+$
                x2[*,1]*(1+p[4]) -x2[*,2]*p[5]]  ,$
               [p[2]+$
                x2[*,2]*(1+p[5]-p[6])]]
        endif else if basis eq 2 then begin
           message,"No"
           return,[[p[0]+x2[*,0]*(1+p[3])+$
                    x2[*,1]*(p[5]-p[3])   -x2[*,2]*p[5]]     ,$
                   [p[1]                 +$
                    x2[*,1]*(1+p[4]+p[5]) -x2[*,2]*p[5]]     ,$
                   [p[2]                 +$
                    x2[*,1]*(p[4]+p[6])   +x2[*,2]*(1-p[6])] ]
        endif else begin
           message,"Don't know basis"
        endelse
     endif else if trans_type eq 2 then begin
        if basis eq 1 then begin
           return,$
              [[const[0]  +   x2[*,0]*(1+p[0]) -      x2[*,1]*p[1]  ] ,$
               [const[1]  +   x2[*,1]*(1+p[1]) -      x2[*,2]*p[2]  ] ,$
               [const[2]  +   x2[*,2]*(1+p[2]-p[3]) ] ]
        endif else if basis eq 2 then begin
           message,"No"
           return,[[p[0]+x2[*,0]*(1+p[3]) +x2[*,1]*(p[5]-p[3])   -x2[*,2]*p[5]]     ,$
                   [p[1]                  +x2[*,1]*(1+p[4]+p[5]) -x2[*,2]*p[5]]     ,$
                   [p[2]                  +x2[*,1]*(p[4]+p[6])   +x2[*,2]*(1-p[6])] ]
        endif else begin
           message,"Don't know basis"
        endelse
     endif else begin
        message,"Order must be 0 or 1"
     endelse  

  endelse

  message,"No transformation performed"

  return,0
end


function slr_color_transform, x2,$
                              kappa=kappa,$
                              M_operator=M,$
                              trans_type=trans_type,$
                              basis=basis,$
                              inverse=inverse,$
                              debug=debug

n_dim=n_elements(x2[0,*])
n_dat=n_elements(x2[*,0])

if n_elements(kappa) ne n_dim then $
   message,'Constant array must have same dimensions as color vector'
if not keyword_set(M) then M=identity(n_dim)

if keyword_set(inverse) then begin

   M_use = imsl_inv(M)

   x2_tr=x2/x2-1
   for ii=0,n_dat-1 do begin
      x2_tr[ii,*] = matrix_multiply(M_use,x2[ii,*]-kappa,/btranspose)
   endfor



endif else begin

   M_use = M

   x2_tr=x2/x2-1
   for ii=0,n_dat-1 do begin
      x2_tr[ii,*] = kappa+matrix_multiply(M_use,x2[ii,*],/btranspose)
   endfor

endelse

return,x2_tr

end
