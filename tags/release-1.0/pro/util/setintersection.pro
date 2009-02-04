FUNCTION SetIntersection, a, b 

;$Rev::               $:  Revision of last commit
;$Author::            $:  Author of last commit
;$Date::              $:  Date of last commit
;
;+
; NAME:
;  setintersection
;
; PURPOSE:
;  Coyote's routine to return the intersection of two sets (arrays).
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

minab = Min(a, Max=maxa) > Min(b, Max=maxb) ;Only need intersection of ranges 
maxab = maxa < maxb ; If either set is empty, or their ranges don't intersect: result = NULL. 
IF maxab LT minab OR maxab LT 0 THEN RETURN, -1 
r = Where((Histogram(a, Min=minab, Max=maxab) NE 0) AND $ 
          (Histogram(b, Min=minab, Max=maxab) NE 0), count) 
IF count EQ 0 THEN RETURN, -1 ELSE RETURN, r + minab 
END
