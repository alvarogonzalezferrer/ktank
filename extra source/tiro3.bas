CONST PI180 = .017444

SCREEN 12
col = 10
DO
LOCATE 1, 1
INPUT "Angulo?    ", ang
INPUT "Velocidad? ", vel
LOCATE 1, 1
PRINT SPACE$(40)
PRINT SPACE$(40)
IF ang = 0 OR vel = 0 THEN END
ang = ang * PI180

gravedad = 9.8

XVel = COS(ang) * vel
YVel = SIN(ang) * vel

x = 320
y = 470
PosX = x
PosY = y

t = 0

DO WHILE x > 0 AND x < 640 AND y < 480
   x = PosX + (XVel * t)
   y = PosY + ((-1 * (YVel * t)) + (.5 * gravedad * t ^ 2))
s = ((480 - y) * 10) + 37
IF s < 37 THEN s = 37
SOUND s, .1

  t = t + .1

        PSET (x, y), col
LOOP
col = col + 1
IF col > 15 THEN col = 1
LOOP

