DECLARE FUNCTION PlotShot! (StartX!, StartY!, Angle#, Velocity!, PlayerNum!)
CONST PI180 = .017444

SCREEN 12
INPUT "Angulo?    ", ang
INPUT "Velocidad? ", vel

ang = ang * PI180

gravedad = 9.8

XVel = COS(ang) * vel
YVel = SIN(ang) * vel

x = 320
y = 470
PosX = x
PosY = y

DO WHILE x > 0 AND x < 640 AND y < 480
   x = PosX + (XVel * t)
   y = PosY + ((-1 * (YVel * t)) + (.5 * gravedad * t ^ 2))


  t = t + .1

        PSET (x, y), 11
LOOP

FUNCTION PlotShot (StartX, StartY, Angle#, Velocity, PlayerNum)
END FUNCTION

