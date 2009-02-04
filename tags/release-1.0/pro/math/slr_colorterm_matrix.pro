function slr_colorterm_matrix, m_out,type=type, inverse=inverse

;$Rev::               $:  Revision of last commit
;$Author::            $:  Author of last commit
;$Date::              $:  Date of last commit
;
; Copyright 2009 by F. William High.
;
; This file is part of Stellar Locus Regression (SLR).
;
; SLR is free software: you can redistribute it and/or modify it under
; the terms of the GNU General Public License as published by the Free
; Software Foundation, either version 3 of the License, or (at your
; option) any later version.
;
; SLR is distributed in the hope that it will be useful, but WITHOUT
; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
; License for more details.
;
; You should have received a copy of the GNU General Public License
; along with SLR.  If not, see <http://www.gnu.org/licenses/>.
;
;+
; NAME:
;  slr_colorterm_matrix
;
; PURPOSE:
;  Return the colorterm matrix, properly formatted for SLR matrix multiplication in IDL.
;
; EXPLANATION:
;
; CALLING SEQUENCE:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; OUTPUTS:
;
; OPIONAL OUTPUTS:
;       
; NOTES:
;
; EXAMPLES:
;
; PROCEDURES USED:
;       
; HISTORY:
;       Written by:     FW High 2008
;
;-

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

if keyword_set(inverse) then matrix_out=inverse(matrix_out)

return,matrix_out

end
