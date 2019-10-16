SCREEN 12

DO
x = 0
y = 470
f = -15
an = .7    ' seno
LOCATE 1, 1
INPUT "Fuerza?"; f
IF f <= 0 THEN END
INPUT "Angulo? "; an

f = -ABS(f)
an = SIN(an * .01744)
DO
 x = x + 1
 y = y + (an * f)
 f = f + .5 'gravedad...
 PSET (x, y), 11
LOOP UNTIL y > 480 OR x > 640

LOOP

