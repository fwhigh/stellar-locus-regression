FUNCTION SetUnion, a, b

;$Rev::               $:  Revision of last commit
;$Author::            $:  Author of last commit
;$Date::              $:  Date of last commit
;
;+
; NAME:
;  setunion
;
; PURPOSE:
;  Coyote's routine to return the union of two sets (arrays).
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

IF a[0] LT 0 THEN RETURN, b     ;A union NULL = a
IF b[0] LT 0 THEN RETURN, a     ;B union NULL = b
RETURN, Where(Histogram([a,b], OMin = omin)) + omin ; Return combined set
END
