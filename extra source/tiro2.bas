SCREEN 12

DO
x = 100
y = 400
f = -15
an = .7    ' seno
LOCATE 1, 1
INPUT "Fuerza?"; f
IF f <= 0 THEN END
INPUT "Angulo? "; an

f = -ABS(f)
'an = SIN(an * .01744)

DO
 IF an < 90 THEN
        x = x + 1
        y = y - TAN(an * .01744)
 ELSE
        x = x - 1
        y = y - TAN((180 - an) * .01744)
 END IF
 
 an = an - .5 'gravedad...
 PSET (x, y), 11
LOOP UNTIL y > 480 OR x > 640

LOOP

