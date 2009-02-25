function slr_fitpar_struct_to_colorterm_matrix,$
   fitpar, p,$
   p_counter=p_counter

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
;  slr_fitpar_struct_to_colorterm_matrix
;
; PURPOSE:
;  Get a colorterm matrix from a fitpar structure.
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

  m_out=replicate(0.,fitpar.b.n)
  matrix_out=identity(fitpar.n_colors)

  for ii=0,fitpar.b.n-1 do begin
     if fitpar.b.fixed[ii] then begin
        m_out[ii]=fitpar.b.val[ii]
     endif else begin
        m_out[ii]=p[p_counter]
        p_counter=p_counter+1
     endelse
  endfor

  for ii=0,n_elements(fitpar.colornames)-1 do begin
     lhs_color=fitpar.colornames[ii]
     lhs_band1=(strmid(lhs_color,0,1))[0]
     lhs_band2=(strmid(lhs_color,1,1))[0]

     bandi1=where(fitpar.b.bands eq lhs_band1,$
                  count1)
     if count1 eq 1 then begin
        rhs_color=(fitpar.b.mult[bandi1])[0]
        colori1=where(fitpar.colornames eq rhs_color)
        if colori1[0] eq -1 then begin
           message,"Color "+rhs_color+" doesn't live in this color space"
        endif
        matrix_out[ii,colori1]+=m_out[bandi1]
     endif
     bandi2=where(fitpar.b.bands eq lhs_band2,$
                  count2)
     if count2 eq 1 then begin
        rhs_color=(fitpar.b.mult[bandi2])[0]
        colori2=where(fitpar.colornames eq rhs_color)
        if colori2[0] eq -1 then begin
           message,"Color "+rhs_color+" doesn't live in this color space"
        endif
        matrix_out[ii,colori2]-=m_out[bandi2]
     endif
  endfor

;matrix_out=slr_colorterm_matrix(m_out)

  return,matrix_out

end
