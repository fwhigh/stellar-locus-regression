function slr_galactic_zee1, $
   r, i, b

;+ 
; NAME:
;  slr_galactic_zee1
;
; PURPOSE:
;  Get MS photometric parallax distance above the Galactic plane Z.
;
; EXPLANATION:
;     Get the distance above the Galactic plane, Z, from the r-i color
;     and r mag of a main sequence star, a la Juric et al. 2008.
;
; NOTES:
;
;
; CALLING SEQUENCE:
;     zee = slr_galactic_zee1(r,i,b)
;
; INPUTS:
;     r - N element array of r magnitudes (mag)
;     i - N element array of i magnitudes (mag)
;     b - N element array of Galactic latitude b (deg)
;
; OUTPUTS:
;     zee - N elements array of heights above the Galactic plane (pc)
;
;-

  Mr = 4.0 + 11.86*(r-i) - 10.74*(r-i)^2 + 5.99*(r-i)^3 - 1.20*(r-i)^4
  Distance = 10 * 10^(-0.2*(Mr - r))         ; units of 1 pc
  Zee = abs( 25 + Distance * sin(b/!radeg) ) ; units of 1 pc

  return,zee

end
