DECLARE SUB box (x!, y!, XX!, YY!, tipolinea!)
DECLARE SUB dialogbox (titulo$, ancho!, alto!, x!, y!)
'Hace una caja de dialogo
SCREEN 7
CALL dialogbox("< Caja de Dialogo >", 39, 19, 1, 1)

SUB box (x, y, XX, YY, tipolinea)
'dibuja una caja de dialogo
'desde x,y a xx,yy con tipolinea:
'tipolinea=0 comun
'tipolinea=1 doble
'tipolinea=2 gruesa
IF XX < x THEN SWAP XX, x
IF YY < y THEN SWAP YY, y

IF tipolinea < 0 OR tipolinea > 2 OR x < 1 OR x > 80 OR XX < x OR XX > 80 THEN EXIT SUB
IF y < 1 OR y > 23 OR YY < y OR YY > 23 THEN EXIT SUB

IF tipolinea = 0 THEN ray1$ = "³": ray2$ = "Ä": esq1$ = "Ú": esq2$ = "¿": esq3$ = "À": : esq4$ = "Ù"
IF tipolinea = 1 THEN ray1$ = "º": ray2$ = "Í": esq1$ = "É": esq2$ = "»": esq3$ = "È": : esq4$ = "¼"
IF tipolinea = 2 THEN ray1$ = "Û": ray2$ = "Û": esq1$ = "Û": esq2$ = "Û": esq3$ = "Û": : esq4$ = "Û"


FOR k = y TO YY
LOCATE k, x: PRINT ray1$
LOCATE k, XX: PRINT ray1$
NEXT
FOR k = x TO XX
LOCATE y, k: PRINT ray2$
LOCATE YY, k: PRINT ray2$
NEXT
LOCATE y, x: PRINT esq1$
LOCATE y, XX: PRINT esq2$
LOCATE YY, x: PRINT esq3$
LOCATE YY, XX: PRINT esq4$


END SUB

SUB dialogbox (titulo$, ancho, alto, x, y)
'Poner en titulo$ el titulo
'En alto, el alto (y)  del cuadro, en ancho el ancho (x) del cuadro
'en X,y la posicion del cuadro
CALL box(x, y, x + ancho, y + alto, 1)
LOCATE x + 2, y + 2
PRINT titulo$

CALL box(x + 1, y + 1, x + LEN(titulo$) + 2, y + 3, 0)'titulo

END SUB

