function slr_colorterm_matrix, coltrm,$
                               fitpar,$
                               type=type, inverse=inverse

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

  matrix_out=identity(fitpar.n_colors)

  if fitpar.b.bands[0] ne 'none' then begin
     for ii=0,n_elements(fitpar.colornames)-1 do begin
        lhs_color=fitpar.colornames[ii]
        lhs_band1=(strsplit(lhs_color,'_',/extract))[0]
        lhs_band2=(strsplit(lhs_color,'_',/extract))[1]

        bandi1=where(fitpar.b.bands eq lhs_band1,$
                     count1)
        if count1 eq 1 then begin
           rhs_color=(fitpar.b.mult[bandi1])[0]
           colori1=where(fitpar.colornames eq rhs_color)
           if colori1[0] eq -1 then begin
              message,"Color "+rhs_color+" doesn't live in this color space"
           endif
           matrix_out[ii,colori1]+=coltrm[bandi1]
        endif
        bandi2=where(fitpar.b.bands eq lhs_band2,$
                     count2)
        if count2 eq 1 then begin
           rhs_color=(fitpar.b.mult[bandi2])[0]
           colori2=where(fitpar.colornames eq rhs_color)
           if colori2[0] eq -1 then begin
              message,"Color "+rhs_color+" doesn't live in this color space"
           endif
           matrix_out[ii,colori2]-=coltrm[bandi2]
        endif
     endfor
  endif


  return,matrix_out




  message,"I'm obsolete"


  if not keyword_set(type) then type=0

  case type of
     0:begin
        matrix_out=identity(3)+$
                   [[ coltrm[0],        0,                0],$
                    [-coltrm[1], coltrm[1],                0],$
                    [        0,-coltrm[2],coltrm[2]-coltrm[3]]]
     end
     3:begin
        matrix_out=identity(4)+$
                   [[ coltrm[0],        0,                0,        0],$
                    [-coltrm[1], coltrm[1],                0,        0],$
                    [        0,-coltrm[2],coltrm[2]-coltrm[3], coltrm[3]],$
                    [        0,        0,                0,        0]]
     end
     5:begin
        matrix_out=identity(3)+$
                   [[ coltrm[0],        0,       0],$
                    [        0, coltrm[1],       0],$
                    [        0,        0,coltrm[2]]]
     end
     6:begin
        matrix_out=identity(4)+$
                   [[ coltrm[0],        0,       0,       0],$
                    [        0, coltrm[1],       0,       0],$
                    [        0,        0,coltrm[2],       0],$
                    [        0,        0,       0,       0]]
     end
     7:begin
        matrix_out=identity(7)+$
                   [[ coltrm[0],        0,                0,       0,       0,       0,coltrm[0]],$
                    [-coltrm[1], coltrm[1],                0,       0,       0,coltrm[1],       0],$
                    [        0,-coltrm[2],coltrm[2]-coltrm[3],coltrm[3],coltrm[2],       0,       0],$
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
