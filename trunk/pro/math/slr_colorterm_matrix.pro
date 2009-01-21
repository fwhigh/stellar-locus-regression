function slr_colorterm_matrix, m_out,type=type

if not keyword_set(type) then type=0

case type of
    0:begin
        matrix_out=identity(3)+$
          [[ m_out[0],        0,                0],$
           [-m_out[1], m_out[1],                0],$
           [        0,-m_out[2],m_out[2]-m_out[3]]]
    end
    3:begin
        matrix_out=identity(4)+$
          [[ m_out[0],        0,                0,        0],$
           [-m_out[1], m_out[1],                0,        0],$
           [        0,-m_out[2],m_out[2]-m_out[3], m_out[3]],$
           [        0,        0,                0,        0]]
    end
    5:begin
        matrix_out=identity(3)+$
          [[ m_out[0],        0,       0],$
           [        0, m_out[1],       0],$
           [        0,        0,m_out[2]]]
    end
    6:begin
        matrix_out=identity(4)+$
          [[ m_out[0],        0,       0,       0],$
           [        0, m_out[1],       0,       0],$
           [        0,        0,m_out[2],       0],$
           [        0,        0,       0,       0]]
    end
    7:begin
        matrix_out=identity(7)+$
          [[ m_out[0],        0,                0,       0,       0,       0,m_out[0]],$
           [-m_out[1], m_out[1],                0,       0,       0,m_out[1],       0],$
           [        0,-m_out[2],m_out[2]-m_out[3],m_out[3],m_out[2],       0,       0],$
           [        0,        0,                0,       0,0,0,0],$
           [        0,        0,                0,       0,0,0,0],$
           [        0,        0,                0,       0,0,0,0],$
           [        0,        0,                0,       0,0,0,0]]
    end
    else:message,"Don't know math operator type "+strtrim(type,2)
endcase

return,matrix_out

end
