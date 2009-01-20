FUNCTION SetUnion, a, b
IF a[0] LT 0 THEN RETURN, b     ;A union NULL = a
IF b[0] LT 0 THEN RETURN, a     ;B union NULL = b
RETURN, Where(Histogram([a,b], OMin = omin)) + omin ; Return combined set
END
