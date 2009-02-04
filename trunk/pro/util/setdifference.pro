FUNCTION SetDifference, a, b  

;$Rev::               $:  Revision of last commit
;$Author::            $:  Author of last commit
;$Date::              $:  Date of last commit
;
;+
; NAME:
;  setdifference
;
; PURPOSE:
;  Coyote's routine to return the difference of two sets (arrays).
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
;  Written by D. Fanning
;
;-

; = a and (not b) = elements in A but not in B

mina = Min(a, Max=maxa)
minb = Min(b, Max=maxb)
IF (minb GT maxa) OR (maxb LT mina) THEN RETURN, a ;No intersection...
r = Where((Histogram(a, Min=mina, Max=maxa) NE 0) AND $
          (Histogram(b, Min=mina, Max=maxa) EQ 0), count)
IF count eq 0 THEN RETURN, -1 ELSE RETURN, r + mina
END
