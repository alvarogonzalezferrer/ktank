DECLARE SUB ResetearJugadores ()
DECLARE FUNCTION CuantosVivos! ()
DECLARE SUB Disparar (X!, Y!, ang!, Vel!, Turno!)
DECLARE SUB VerSiPegoAlguien (Turno!)
DECLARE SUB pausa (P!)
DECLARE SUB Menu1 ()
DECLARE SUB Finalizar ()
DECLARE SUB BOX (X!, Y!, XX!, YY!, tipolinea!)
DECLARE SUB DibuTanque (X!, Y!, Angulo!, col!)
DECLARE FUNCTION Y.Ang! (Y!, Angulo!, largo!)
DECLARE FUNCTION X.Ang! (X!, Angulo!, largo!)
DECLARE SUB Iniciar ()
DECLARE SUB GeneraFondo ()
DECLARE SUB PonerTanques ()
DECLARE SUB CaerTanques ()
DECLARE SUB DibujarTanques ()
'------------------------------------------------------
'Juego de 'accion' - Remake de un juego viejo
'Hecho por Kronoman - (c) 2001, Licencia GNU - Gratuito
'En memoria de mi querido padre
'Modo de juego:
'Cada jugador hace un disparo e intenta pegarle al enemigo.
'------------------------------------------------------
'------------------------------------------------------
'Manejo de errores
'------------------------------------------------------
ON ERROR GOTO errores

'Numeros aleatorios
RANDOMIZE TIMER

'------------------------------------------------------
'Constantes
'------------------------------------------------------
CONST Version$ = "0.7á"
'---------------
'Trigonometria:
'---------------
CONST PI = 3.141 'precision corta para mas rapido
CONST PI180 = .01745 ' pi / 180, con poca precision

'------------------------------------------------------
'Tipos de datos
'------------------------------------------------------

'---------------
'Tipo del jugador
'---------------
TYPE TankeJug
    X AS INTEGER
    Y AS INTEGER
    Dcan AS INTEGER 'Direccion del ca¤on
    Pot AS INTEGER 'Potencia de tiro
    Ener AS INTEGER 'Energia 0-100%; x<=0 muerto
    Punt AS LONG 'Puntos
    Nombre AS STRING * 8 'Nombre del jugador
END TYPE

'------------------------------
'Colores de los tanques
'------------------------------
'Prohibidos: 4,6,1,0 [explosion,piso,cielo, necesario]
'Los colores deben SER UNICOS para identificar el tanque...
DIM SHARED ColTank(10)
ColTank(1) = 2
ColTank(2) = 14
ColTank(3) = 5
ColTank(4) = 7
ColTank(5) = 8
ColTank(6) = 9
ColTank(7) = 10
ColTank(8) = 11
ColTank(9) = 15
ColTank(10) = 13

'------------------------------------------------------
'Globales
'------------------------------------------------------
DIM SHARED Jugador(10) AS TankeJug 'Jugadores
DIM SHARED CantJug 'Cantidad de jugadores 2-10
DIM SHARED CantRounds 'Cantidad de rounds a jugar 1-100

'------------------------------------------------------
'Programa en si
'------------------------------------------------------


'------------------------------------------------------
'Loop del programa
'------------------------------------------------------
DO

    '------------------------------------------------------
    'Menu de juego
    CALL Menu1
    '------------------------------------------------------

    '------------------------------------------------------
    'Comienzo del round
    '------------------------------------------------------


    DO
   
        '------------------------------------------------------
        'Mensaje inicio de nuevo round
        '------------------------------------------------------
        SCREEN 7, 0, 0, 0
        CLS
        CALL BOX(8, 9, 31, 11, 0)
        LOCATE 10, 9
        PRINT "COMENZANDO NUEVO ROUND"
   
        '------------------------------------------------------
        'Iniciar fondo, etc
        '------------------------------------------------------
        CALL Iniciar
   
        '------------------------------------------------------
        'Inicia los tanques
        '------------------------------------------------------
        CALL PonerTanques

        '------------------------------------------------------
        'Sortear quien juega primero
        '------------------------------------------------------
        Turno = INT(RND * CantJug) + 1

        '------------------------------------------------------
        'Loop de juego; turno x turno
        '------------------------------------------------------
        DO
            FinTurno = 0
            Redibujar = 1
            '------ Loop del turno ------
            DO ' hasta que termine el turno
               
                IF Redibujar <> 0 THEN
                    Redibujar = 0
                    'Dibujar
                    SCREEN 7, 0, 1, 0 '#1 = buffer
                    PCOPY 2, 1
                    CALL DibujarTanques

                    SCREEN 7, 0, 0, 0 '#0 = pantalla
                    PCOPY 1, 3 'Backup de pantalla en #3
                    PCOPY 1, 0 'Pantalla
                   
                    LOCATE 25, 1
                    COLOR 15, 0
                    PRINT "Ang:" + STR$(Jugador(Turno).Dcan) + "-Vel:" + STR$(Jugador(Turno).Pot) + "-Ener:" + STR$(Jugador(Turno).Ener); "% - ";
                    COLOR ColTank(Turno), 0
                    PRINT Jugador(Turno).Nombre;
                    COLOR 15, 0
                   
                    'Resalta el jugador actual
                    'CIRCLE (Jugador(Turno).X, Jugador(Turno).Y), 12, 15
                                       
                END IF
           
                'Teclado
                D$ = INKEY$

                'Interpreta teclado:

                IF D$ <> "" THEN Redibujar = 1
               
                'Flechas: ARR, ABJ, +, - = potencia
                IF D$ = CHR$(0) + "H" THEN
                    'SOUND 100, .1
                    Jugador(Turno).Pot = Jugador(Turno).Pot + 1
                    IF Jugador(Turno).Pot > 100 THEN Jugador(Turno).Pot = 100
                END IF
               
                IF D$ = CHR$(0) + "P" THEN
                    'SOUND 100, .1
                    Jugador(Turno).Pot = Jugador(Turno).Pot - 1
                    IF Jugador(Turno).Pot < 0 THEN Jugador(Turno).Pot = 0
                END IF
               
                IF D$ = "+" THEN
                    'SOUND 100, .1
                    Jugador(Turno).Pot = Jugador(Turno).Pot + 10
                    IF Jugador(Turno).Pot > 100 THEN Jugador(Turno).Pot = 100
                END IF
              
                IF D$ = "-" THEN
                    'SOUND 100, .1
                    Jugador(Turno).Pot = Jugador(Turno).Pot - 10
                    IF Jugador(Turno).Pot < 0 THEN Jugador(Turno).Pot = 0
                END IF


                'Flechas: IZQ, DER, /,* = angulo
                IF D$ = CHR$(0) + "K" THEN
                    'SOUND 500, .1
                    Jugador(Turno).Dcan = Jugador(Turno).Dcan + 1
                    IF Jugador(Turno).Dcan > 180 THEN Jugador(Turno).Dcan = 180
                END IF
               
                IF D$ = CHR$(0) + "M" THEN
                    'SOUND 500, .1
                    Jugador(Turno).Dcan = Jugador(Turno).Dcan - 1
                    IF Jugador(Turno).Dcan < 0 THEN Jugador(Turno).Dcan = 0
                END IF
               
                IF D$ = "/" THEN
                    'SOUND 500, .1
                    Jugador(Turno).Dcan = Jugador(Turno).Dcan + 10
                    IF Jugador(Turno).Dcan > 180 THEN Jugador(Turno).Dcan = 180
                END IF
              
                IF D$ = "*" THEN
                    'SOUND 500, .1
                    Jugador(Turno).Dcan = Jugador(Turno).Dcan - 10
                    IF Jugador(Turno).Dcan < 0 THEN Jugador(Turno).Dcan = 0
                END IF

                'ENTER - disparar, ajustar y pasar el turno
                IF D$ = CHR$(13) THEN
                    PCOPY 3, 0 'restaurar pantalla
                    SCREEN 7, 0, 2, 0
                    CALL Disparar(X.Ang(CSNG(Jugador(Turno).X), CSNG(Jugador(Turno).Dcan), 6), Y.Ang(CSNG(Jugador(Turno).Y) - 2, CSNG(Jugador(Turno).Dcan), 6), CSNG(Jugador(Turno).Dcan), CSNG(Jugador(Turno).Pot), Turno)
                    FinTurno = 1
                END IF

                'F10 - Salir al toque
                IF D$ = CHR$(0) + "D" THEN CALL Finalizar

            LOOP UNTIL FinTurno <> 0 'OR D$ = CHR$(27) '<ESC> salta el turno
           
            'Cambiar turno
            DO
                'Ver que al que le toca este vivo...
                Turno = Turno + 1
                IF Turno > CantJug THEN Turno = 1
               
                'Hasta que el jugador este vivo, o quede uno solo vivo
            LOOP UNTIL Jugador(Turno).Ener > 0 OR CuantosVivos <= 1
            

        LOOP UNTIL CuantosVivos <= 1 'hasta que quede 1 o ninguno vivos... < DEBUG >
        'Fin Round
       
        'Presentar puntajes
        SCREEN 7, 0, 0, 0
        CLS
        COLOR 15, 0
        IF CantRounds > 1 THEN
            PRINT "<< Fin del round >>"
        ELSE
            COLOR 14, 0
            PRINT "<< Fin del juego >>"
        END IF
        PRINT
        COLOR 11, 0
        PRINT "Puntajes:"
        COLOR 15, 0
        PRINT STRING$(40, "Ä")
        FOR I = 1 TO CantJug
            COLOR ColTank(I), 0
            PRINT Jugador(I).Nombre;
            COLOR 15, 0
            PRINT " -> "; Jugador(I).Punt; " punto(s)"
        NEXT I
        COLOR 15, 0
        LOCATE 23, 1
        PRINT STRING$(40, "Ä")
        PRINT " << Presione una tecla... >> ";
        pausa (0)
        'Pasar Round
        CantRounds = CantRounds - 1

    LOOP UNTIL CantRounds < 1 'Hasta que se acaben los rounds
    ' Fin del juego
LOOP 'Loop infinito, sale en el Menu principal...

CALL Finalizar





'------------------------------------------------------
'Errores
'------------------------------------------------------
errores:
SCREEN 0
WIDTH 80, 25
PRINT "ERROR: -> "; ERR
PRINT "Sorry macho..."
PRINT "(c) 2001, Kronoman"
SYSTEM

SUB BOX (X, Y, XX, YY, tipolinea)
    'dibuja una caja de dialogo
    'desde x,y a xx,yy con tipolinea:
    'tipolinea=0 comun
    'tipolinea=1 doble
    'tipolinea=2 gruesa
    IF XX < X THEN SWAP XX, X
    IF YY < Y THEN SWAP YY, Y

    IF tipolinea < 0 OR tipolinea > 2 OR X < 1 OR X > 80 OR XX < X OR XX > 80 THEN EXIT SUB
    IF Y < 1 OR Y > 23 OR YY < Y OR YY > 23 THEN EXIT SUB

    IF tipolinea = 0 THEN ray1$ = "³": ray2$ = "Ä": esq1$ = "Ú": esq2$ = "¿": esq3$ = "À":: esq4$ = "Ù"
    IF tipolinea = 1 THEN ray1$ = "º": ray2$ = "Í": esq1$ = "É": esq2$ = "»": esq3$ = "È":: esq4$ = "¼"
    IF tipolinea = 2 THEN ray1$ = "Û": ray2$ = "Û": esq1$ = "Û": esq2$ = "Û": esq3$ = "Û":: esq4$ = "Û"



    FOR k = Y TO YY
        LOCATE k, X: PRINT SPACE$(XX - X) 'borrar
        LOCATE k, X: PRINT ray1$
        LOCATE k, XX: PRINT ray1$
    NEXT
    FOR k = X TO XX
        LOCATE Y, k: PRINT ray2$
        LOCATE YY, k: PRINT ray2$
    NEXT
    LOCATE Y, X: PRINT esq1$
    LOCATE Y, XX: PRINT esq2$
    LOCATE YY, X: PRINT esq3$
    LOCATE YY, XX: PRINT esq4$



END SUB

SUB CaerTanques
    'Este sub hace 'caer' los tanques hasta que toman contacto con
    'el piso.
    'NOTA: la pagina de video actual debe contener la imagen del fondo...
    FOR I = 1 TO CantJug
        DO WHILE POINT(Jugador(I).X, Jugador(I).Y + 1) <> 6 AND Jugador(I).Y < 190
            Jugador(I).Y = Jugador(I).Y + 1 'para que 'caiga' a su posicion
        LOOP
    NEXT

END SUB

FUNCTION CuantosVivos
    'Esta funcion devuelve la cantidad de tanques que estan vivos
    jJj = 0
    FOR I = 1 TO CantJug
        IF Jugador(I).Ener > 0 THEN jJj = jJj + 1
    NEXT I
    CuantosVivos = jJj
END FUNCTION

SUB DialogBox (titulo$, ancho, alto, X, Y)
    'Poner en titulo$ el titulo
    'En alto, el alto (y)  del cuadro, en ancho el ancho (x) del cuadro
    'en X,y la posicion del cuadro
    CALL BOX(X, Y, X + ancho, Y + alto, 1)
    LOCATE X + 2, Y + 2
    PRINT titulo$

    CALL BOX(X + 1, Y + 1, X + LEN(titulo$) + 2, Y + 3, 0) 'titulo

END SUB

SUB DibujarTanques
    'Dibuja los tanques en pantalla
    FOR I = 1 TO CantJug
        'Uso CSNG para convertir valores de INT a SINGLE... ;^P
        IF Jugador(I).Ener > 0 THEN 'dibuja solo si esta vivo
            CALL DibuTanque(CSNG(Jugador(I).X), CSNG(Jugador(I).Y), CSNG(Jugador(I).Dcan), ColTank(I))
        END IF
    NEXT I

END SUB

SUB DibuTanque (X, Y, Angulo, col)
    '-----------------------------------------------------------
    'Dibuja un tanque con centro en X,Y y ca¤on de Angulo grados de color Col
    '-----------------------------------------------------------

    'cuerpo
    LINE (X - 3, Y - 2)-(X + 3, Y), col, BF
    LINE (X - 5, Y - 1)-(X + 5, Y), col, BF

    'ca¤on
    LINE (X, Y - 2)-(X.Ang(X, Angulo, 5), Y.Ang(Y - 2, Angulo, 5)), col

END SUB

SUB Disparar (X, Y, ang, Vel, Turno)
    '--------------------------------------------
    'Hace un disparo desde el punto X,Y
    'con angulo Ang y velocidad Vel
    'realiza los graficos, y mata a los que toque
    'ademas, tira la tierra...
    'En Turno pasar el N§ del tanque que esta jugando
    '--------------------------------------------


    PSET (X, Y), 1 'Evita un bug


    ang = ang * PI180

    gravedad = 9.8 'gravedad del sistema

    'velocidades
    XVel = COS(ang) * Vel
    YVel = SIN(ang) * Vel

    'posiciones
    PosX = X
    PosY = Y

    'contador
    t = 0

    'termino??
    listo = 0


    'Pagina de video de backup en #3



    'repetir hasta que pase algo
    DO WHILE listo = 0
  
        'calculo
        X = PosX + (XVel * t)
        Y = PosY + ((-1 * (YVel * t)) + (.5 * gravedad * t ^ 2))

        'sonido
        s = ((480 - Y) * 10) + 37
        IF s < 37 THEN s = 37
        SOUND s, .1

        'contador
        t = t + .1

        'condiciones de salida
        IF Y > 190 THEN listo = 1
        IF X < 0 THEN listo = 1
        IF X > 320 THEN listo = 1
       
        'Ver si pego con algo o el piso -> explotar...
        'Si la velocidad es < 2 tambien explota
        SCREEN 7, 0, 3, 0 'mira la pantalla
        IF (POINT(X, Y) > 0 AND POINT(X, Y) <> 4 AND POINT(X, Y) <> 1) OR Y > 189 OR Vel < 2 THEN
            'pego con algo... :^)
           
            'Modificar entorno con la explosion
            SCREEN 7, 0, 2, 0
            'Borrar con cielo
            CIRCLE (X, Y), 7, 0
            PAINT (X, Y), 0, 0
            CIRCLE (X, Y), 7, 1
            PAINT (X, Y), 1, 1
           
            'Explosion en pantalla
            SCREEN 7, 0, 0, 0
            PCOPY 3, 0
            'Dibujar explosion
            CIRCLE (X, Y), 7, 0
            PAINT (X, Y), 0, 0
           
            CIRCLE (X, Y), 7, 4
            PAINT (X, Y), 4, 4
               
            'sonido
            PLAY "mfl32o1 cbc o0 b p32"

            'Analizar a quien le pego...
            CALL VerSiPegoAlguien(Turno)

            listo = 1

        END IF
       
        SCREEN 7, 0, 0, 0
        'dibuja balita
        PSET (X, Y), 4
        CIRCLE (X, Y), 1, 4

    LOOP

    'Hacer caer la tierra suelta [dificil]
    SCREEN 7, 0, 2, 0

    'Limita donde se puede dibujar
    VIEW SCREEN(0, 0)-(319, 190)

    FOR XX = X - 10 TO X + 10
        EnElAire = 0 'Esta en el aire?
        YFall = Y + 10
   
        FOR YY = Y + 10 TO 99 STEP -1
            'Va tomando el punto, y si no es tierra, setea que debe caer
            IF POINT(XX, YY) = 6 AND EnElAire = 0 THEN
                YFall = YY - 1
            END IF
            IF POINT(XX, YY) = 6 AND EnElAire <> 0 THEN
                'Si esta en el aire, caer
                PSET (XX, YY), 1
                PSET (XX, YFall), 6
                YFall = YFall - 1
                EnElAire = 0
            END IF
            IF POINT(XX, YY) = 1 THEN
                EnElAire = -1
            END IF

        NEXT YY
    NEXT XX

    VIEW 'restaura visualizacion


    'hacer caer los tanques
    SCREEN 7, 0, 1, 0 '#1 = buffer
    PCOPY 2, 1 'en #2 guardo el entorno
    CALL CaerTanques

END SUB

SUB Finalizar
    'Salir del programa
    SCREEN 0
    WIDTH 80, 25
    CLS
    COLOR 15, 0
    PRINT "KTank(r) " + Version$
    PRINT
    COLOR 14, 0
    PRINT "Creado por Kronoman - (c) 2001 - Software Libre - Licencia GNU"
    COLOR 8, 0
    PRINT "Para mas informacion sobre la licencia GNU, vea http://www.gnu.org/"
    PRINT
    COLOR 15, 3
    PRINT "ÜÜÜ";
    COLOR 14, 3
    PRINT "Ü";
    COLOR 15, 3
    PRINT "ÜÜÜ"
    COLOR 3, 0
    PRINT "ßßßßßßß"
    COLOR 15, 0
    PRINT "Programa hecho en ";
    COLOR 3
    PRINT "Arg";
    COLOR 15
    PRINT "ent";
    COLOR 3
    PRINT "ina"
    COLOR 7, 0
    PRINT
    PRINT
    CLOSE
    SYSTEM
END SUB

SUB GeneraFondo
    '-----------------------------
    'Genera un fondo fractal
    '-----------------------------
    'cielo
    LINE (0, 0)-(320, 190), 1, BF

    'tierra
    X = 0
    Y = 100
    PSET (X, Y), 6
    DO WHILE X < 320
        xd = INT(RND * 15) + 1
        yd = INT(RND * 10) + 1
        IF RND <= .5 THEN yd = -yd
        IF Y < 100 THEN yd = ABS(yd)
        IF Y > 185 THEN yd = -ABS(yd)

        X = X + xd
   
        Y = Y + yd

        IF Y > 185 THEN Y = 185
        IF Y < 100 THEN Y = 100


        LINE -(X, Y), 6

    LOOP
    LINE (0, 190)-(320, 190), 6
    PAINT (0, 189), 6, 6

END SUB

SUB Iniciar
    'Inicializa el mapa

    'Modo de video 320x200x7 colores
    SCREEN 7, 0, 1, 0

    CLS
    'Fondo
    CALL GeneraFondo
    'Copiar en RAM de video
    PCOPY 1, 1
    PCOPY 1, 2
    PCOPY 1, 3
    PCOPY 1, 4
    PCOPY 1, 5
    PCOPY 1, 6


END SUB

SUB Menu1
    '---------------------------------------------------
    'Menu donde permite al usuario comenzar a jugar, y
    'setear los jugadores...
    '---------------------------------------------------
    SCREEN 7, 0, 0, 0
    COLOR 15, 0
    CLS
    LOCATE 22, 1
    COLOR 10, 0
    PRINT "Creado por Kronoman "
    PRINT "** En memoria de mi querido padre **"
    PRINT "<< Software Libre - Licencia GNU >>";
    COLOR 15, 0
    LOCATE 1, 1
    PRINT "Bienvenido a KTank(r)" + Version$
    PRINT
    PLAY "MB MNT150L16O2GBGG>D<BB>DEL32FL8EEL4<G"

    PRINT "Cuantos jugadores? (2-10) "
    PRINT "Ponga 0 para finalizar programa."
    LINE INPUT j$
    IF j$ = "" THEN j$ = "2"
    CantJug = VAL(j$)
    IF CantJug < 2 OR CantJug > 10 THEN CALL Finalizar
    FOR I = 1 TO CantJug
        LOCATE 7, 1
        PRINT "Nombre Jugador "; STR$(I)
        PRINT "8 letras maximo..."
        LINE INPUT ">"; j$
        j$ = UCASE$(LTRIM$(RTRIM$(j$)))
        IF j$ = "" THEN j$ = "Jug:" + STR$(I)
        Jugador(I).Nombre = j$ 'LEFT$(8, j$)
        COLOR ColTank(I), 0
        PRINT Jugador(I).Nombre
        COLOR 15, 0
        pausa (.1)
        LOCATE 7, 1
        PRINT SPACE$(160)
    NEXT

    LOCATE 7, 1
    PRINT "Cuantos rounds? (1-100)"
    LINE INPUT j$

    CantRounds = VAL(j$)
    IF CantRounds < 1 THEN CantRounds = 1
    IF CantRounds > 100 THEN CantRounds = 100
    PRINT "Rounds: "; CantRounds

    'Resetear los jugadores [JUEGO NUEVO]
    CALL ResetearJugadores

END SUB

SUB pausa (P)
    'Realiza una pausa sin valor de devolucion
    IF P = 0 THEN
        DO: LOOP WHILE INKEY$ = ""
    ELSE
        t = TIMER
        DO: LOOP UNTIL ABS(TIMER - t) >= P 'el abs evita el bug de 'medianoche'
    END IF

END SUB

SUB PonerTanques
    'Este sub se encarga de colocar los tanques en el paisaje actual
    xxzz = INT(RND * 300) + 1
    FOR I = 1 TO CantJug
        Jugador(I).X = xxzz
        Jugador(I).Y = 0 'para que 'caiga' a su posicion
        Jugador(I).Dcan = INT(RND * 100) + 45
        Jugador(I).Pot = INT(RND * 100) + 1
        Jugador(I).Ener = 100

        xxzz = xxzz + INT(RND * 320 / CantJug) + 10
        IF xxzz > 300 THEN xxzz = INT(RND * 30) + 30

    NEXT I
    'Posicion definitiva
    CALL CaerTanques

END SUB

SUB ResetearJugadores
    'Setea los jugadores con todo a 0
    'Llamar en cada nuevo juego
    FOR I = 1 TO CantJug
        Jugador(I).X = 0
        Jugador(I).Y = 0
        Jugador(I).Dcan = 0
        Jugador(I).Pot = 0
        Jugador(I).Ener = 0
        Jugador(I).Punt = 0
    NEXT I

END SUB

SUB VerSiPegoAlguien (Turno)
    'Ve si le pego a algun tanque
    'Para esto, verifica si la posicion del tanque
    'esta sobre el color rojo (4) que representa explosion
    'y le resta la energia que sea adecuada.
    'Hay que pasar en Turno el turno del tanque que juega,
    'al cual sera el que se le sumen los puntos (resten si se pego a el mismo)
    'Si le pega a alguien y muere, hace una explosion al azar grande...
    'NOTA: la pagina de video actual debe contener la imagen del fondo + la explosion(es)

    FOR I = 1 TO CantJug
        IF Jugador(I).Ener > 0 THEN
            EstabaVivo = -1
        ELSE
            EstabaVivo = 0
        END IF

        IF POINT(Jugador(I).X, Jugador(I).Y) = 4 THEN
            'Si le pego de lleno, matarlo casi...
            Jugador(I).Ener = Jugador(I).Ener - (INT(RND * 20) + 80)
        END IF
        IF POINT(Jugador(I).X - 5, Jugador(I).Y - 1) = 4 THEN
            'Si es alguna esquina, sacarle al azar
            Jugador(I).Ener = Jugador(I).Ener - (INT(RND * 25) + 10)
        END IF
        IF POINT(Jugador(I).X + 5, Jugador(I).Y - 1) = 4 THEN
            'Si es alguna esquina, sacarle al azar
            Jugador(I).Ener = Jugador(I).Ener - (INT(RND * 25) + 10)
        END IF
        IF POINT(Jugador(I).X - 5, Jugador(I).Y) = 4 THEN
            'Si es alguna esquina, sacarle al azar
            Jugador(I).Ener = Jugador(I).Ener - (INT(RND * 25) + 10)
        END IF
        IF POINT(Jugador(I).X + 5, Jugador(I).Y) = 4 THEN
            'Si es alguna esquina, sacarle al azar
            Jugador(I).Ener = Jugador(I).Ener - (INT(RND * 25) + 10)
        END IF
    
        IF POINT(X.Ang(CSNG(Jugador(I).X), CSNG(Jugador(I).Dcan), 6), Y.Ang(CSNG(Jugador(I).Y) - 2, CSNG(Jugador(I).Dcan), 6)) = 4 THEN
            'Si se pega en el ca¤or, sacarle %
            Jugador(I).Ener = Jugador(I).Ener - (INT(RND * 80) + 15)
        END IF
  
   
        IF Jugador(I).Ener < 0 THEN
            Jugador(I).Ener = 0
        END IF

        IF Jugador(I).Ener <= 0 AND EstabaVivo = -1 THEN
            'Si estaba vivo y murio, explotar y sumar puntos
       
            IF Turno <> I THEN
                Jugador(Turno).Punt = Jugador(Turno).Punt + 1
            ELSE
                'se pego el solo... :^D
                Jugador(Turno).Punt = Jugador(Turno).Punt - 1
            END IF

            Jugador(I).Ener = 0
            'Dibujar explosion
            r1 = INT(RND * 5) + 10
            CIRCLE (Jugador(I).X, Jugador(I).Y), r1, 0
            PAINT (Jugador(I).X, Jugador(I).Y), 0, 0
          
            CIRCLE (Jugador(I).X, Jugador(I).Y), r1, 4
            PAINT (Jugador(I).X, Jugador(I).Y), 4, 4
               
            PLAY "mf l32 o0 >bb < a c l8 c"
        END IF

    NEXT


END SUB

FUNCTION X.Ang (X, Angulo, largo)
    '-------------------------------------------------------------
    'Devuelve la coordenada X para un angulo en x,y de angulo 0-360
    '-------------------------------------------------------------

    'pasar a radianes y calcular
    X.Ang = INT(X + COS((360 - Angulo) * PI180) * largo)


END FUNCTION

FUNCTION Y.Ang (Y, Angulo, largo)
    '-------------------------------------------------------------
    'Devuelve la coordenada Y para un angulo en Y de angulo 0-360
    '-------------------------------------------------------------
    'pasar a radianes y calcular
    Y.Ang = INT(Y + SIN((360 - Angulo) * PI180) * largo)


END FUNCTION

