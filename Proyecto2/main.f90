module globales
!Aquí ando declarando las variables globales que usaré
    character(len=15000)::entrada
    integer::cuentaT, cuentaN, cuentaE, cuentaCT, cuentaConsumo, cuentaES
    character(len=200), dimension(4,2000)::tokens,erroresLexicos,copiaTokens,erroresSintacticos
    character(len=200), dimension(1,2000)::terminales
    logical::eLexico, eSintactico, controlValido, propiedadValida, colocacionValida, ErrorValidado, exepcion1, recuperado
end module globales

program proceso
    use globales
    implicit none
    !-----------------------------------
    integer::ios
    character(len=200)::linea
    !-----------------------------------

    !Inicializando variables
    cuentaT=0
    cuentaN=0
    cuentaE=0
    cuentaCT=0
    cuentaConsumo=0
    cuentaES=0

    entrada = '' !Inicializo la variable entrada

    !PROBANDOOOOOOO
    open(10, file='colocacion.LFP', status='old', action='read', encoding='UTF-8') !Abro el archivo de entrada
    do
    read(10, '(A)', iostat = ios) linea
    if (ios /= 0) exit   ! Se alcanzo el fin del archivo
    entrada = trim(entrada) // trim(linea) // char(10) ! Concatenar la línea leida al valor de entrada y agregar un salto de línea
    end do
    !PROBANDOOOOOOO

    !call leer() !Llamo a la subrutina leer

    call analizar ()

    !Genero los dos HTML

    call html_bueno()

    call iniciarAnalisisSintactico() !Llamo a la subrutina iniciarAnalisisSintactico
    call html_malo()
end program proceso

!Analisis léxico --------------------------------------------------------------------------------------------------------------------------------
subroutine analizar()
    use globales
    implicit none
    
    !Declaración de variables
    character(len=200)::lexema
    character(len=1) :: c
    integer::posF, posC,estado,i,largo,VEspacio,Saltos,tempPos

    !Inicialización de las variables
    largo=len_trim(entrada)
    posF=1
    posC=0
    estado=0
    i=0
    VEspacio=0
    Saltos=0
    tempPos=0

    !Agrego el caracter del final 
    entrada(largo+1:largo+1)="#"
    largo=largo+1

    !Comienzo con el ciclo
    do while (i<=largo)

        i=i+1 !Aumento la posición del caracter
        posC=posC+1 !Aumento la posición de la columna
        c=entrada(i:i) !Tomo el caracter de la posición

        !Comienzo con el automata
        select case (estado)
    !Estado Inicial que lleva a todos lados (0) 
        case(0)
            if (c>='a' .and. c<='z' .or. c>='A' .and. c<='Z') then !Si es una letra
                estado=1
                lexema=c
            
            else if (c == ';' .or. c=='.' .or. c==',' .or. c=='(' .or. c==')') then !Si es un simbolo
                estado=2
                lexema=c
                i=i-1
                posC=posC-1

            else if (c== '/') then !Si es un comentario
                estado=3
                lexema=c
                tempPos=posC

            else if (c>= '0' .and. c<='9') then !Si es un número
                estado=4
                lexema=c

            else if (c=='"') then !Si es una cadena
                estado=5
                lexema=c

            else if (c=='<') then !Si es apertura de control
                estado=6
                lexema=c

            else if (c=='-') then !Si es una cerradura de control
                estado=7
                lexema=c

            else if (c==' ' .or. c==char(9)) then !Si es un espacio
                cycle
            else if (c==char(10)) then !Si es un salto de línea
                posC=0
                posF=posF+1
                cycle
            else if (c=='#' .and. i==largo) then !Si es el final
                exit
            else
                call agregarErrorLexico(trim(c)// repeat(' ', 200 - len_trim(c)), "Caracter no reconocido" // repeat(' ', 200-len_trim("Caracter no reconocido")), posF, posC)

                cycle
            end if

    !Estado de lectura de palabras reservadas e identificadores (parte 1) 1
        case(1)
            if (c>='a' .and. c<='z' .or. c>='A' .and. c<='Z' .or. c>='0' .and. c<='9' .or. c=='_' .or. c=='$' .or. c=='%' .or. c=='&') then !Si es una letra o número
                lexema=trim(lexema)//c
            else 
            !Estas serán las palabras reservadas
                
                if (trim(lexema)=="Controles") then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=="Propiedades") then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=="Colocacion") then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))

                !Lo que contiene controles
                else if (trim(lexema)=="Etiqueta") then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='Boton') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='Check') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='RadioBoton') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='Texto') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='AreaTexto') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='Clave') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='Contenedor') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))

                !Lo que contiene propiedades
                else if (trim(lexema)=='setColorLetra') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='setAncho') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='setAlto') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='setTexto') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='setColorFondo') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='setAlineacion') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if ( trim(lexema)=='setMarcado' ) then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='setGrupo') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))

                !Lo que contiene colocacion
                else if (trim(lexema)=='add') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='setPosicion') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='this') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                
                !Los booleanos
                else if (trim(lexema)=='true') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Booleano" // repeat(' ', 200-len_trim("Booleano")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='false') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Booleano" // repeat(' ', 200-len_trim("Booleano")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))

                !Las alineaciones
                else if (trim(lexema)=='centro') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Alineacion" // repeat(' ', 200-len_trim("Alineacion")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='derecho') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Alineacion" // repeat(' ', 200-len_trim("Alineacion")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                else if (trim(lexema)=='izquierdo') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Alineacion" // repeat(' ', 200-len_trim("Alineacion")), posF, posC-len_trim(lexema))
                    call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                    
            !Si es simplemente un identificador
                else
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Identificador" // repeat(' ', 200-len_trim("Identificador")), posF, posC-len_trim(lexema))
                    call agregarTerminal('ID'// repeat(' ', 200 - len_trim('ID')))
                end if
                estado=0
                i=i-1
                posC=posC-1
            end if

    !Estado de lectura de símbolos (parte 1) 2
        case (2)
            if (c == ';' .or. c=='.' .or. c=='(' .or. c==')' .or. c==',') then
                call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Simbolo" // repeat(' ', 200-len_trim("Simbolo")), posF, posC)
                call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                estado=0
            else
                call agregarErrorLexico(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Simbolo no reconocido" // repeat(' ', 200-len_trim("Simbolo no reconocido")), posF, posC-len_trim(lexema))
                estado=0
                i=i-1
                posC=posC-1
            end if

    !Estado de lectura de comentarios (parte 1) 3
        case (3)
            if (c=='/') then
                lexema=trim(lexema)//c
                estado=8
            else if (c=='*') then
                lexema=trim(lexema)//c
                estado=9
            else
                call agregarErrorLexico(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Comentario no reconocido" // repeat(' ', 200-len_trim("Comentario no reconocido")), posF, posC-len_trim(lexema))
                estado=0
                i=i-1
                posC=posC-1
            end if
        
    !Estado de lectura de numeros (4)
        case (4)
            if (c>='0' .and. c<='9') then
                lexema=trim(lexema)//c
            else
                call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Numero" // repeat(' ', 200-len_trim("Numero")), posF, posC-len_trim(lexema))
                call agregarTerminal(trim("Numero")// repeat(' ', 200 - len_trim("Numero")))
                estado=0
                i=i-1
                posC=posC-1
            end if

    !Estado de lectura de cadenas de texto
        case (5)
            if (c=='"') then
                lexema=trim(lexema)//c
                call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Cadena" // repeat(' ', 200-len_trim("Cadena")), posF, posC-len_trim(lexema)+1)
                call agregarTerminal('Cadena'// repeat(' ', 200 - len_trim("Cadena")))
                estado=0
            else if (c==char(10)) then
                call agregarErrorLexico(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Cadena no cerrada" // repeat(' ', 200-len_trim("Cadena no cerrada")), posF, posC-len_trim(lexema))
                estado=0
                i=i-1
                posC=posC-1
            else

                lexema=trim(lexema)//c !Concateno cualquier cosa que no sea comillas
            end if

    !Estado de lectura de apertura de control (parte 1) 6->10
        case (6)
            if (c=='!') then
                lexema=trim(lexema)//c
                estado=10
            else
                call agregarErrorLexico(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Apertura de control no reconocida" // repeat(' ', 200-len_trim("Apertura de control no reconocida")), posF, posC-len_trim(lexema))
                estado=0
                i=i-1
                posC=posC-1
            end if
    !Estado de lectura de cerradura de control (parte 1) 6->7
        case (7)
            if (c=='-') then
                lexema=trim(lexema)//c
                estado=11
            else
                call agregarErrorLexico(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Cerradura de control no reconocida" // repeat(' ', 200-len_trim("Cerradura de control no reconocida")), posF, posC-len_trim(lexema))
                estado=0
                i=i-1
                posC=posC-1
            end if
    !Estado de lectura de comentarios de una línea (parte 1) 3->8
        case (8)
            if (c==char(10)) then
                call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Comentario de una línea" // repeat(' ', 200-len_trim("Comentario de una línea")), posF, posC-len_trim(lexema))
                call agregarTerminal('Comentario'// repeat(' ', 200 - len_trim("Comentario")))
                estado=0
                i=i-1
                posC=posC-1
                VEspacio=0
            else

                !Si hay un espacio para que no lo elimine con el trim
                if(c==' ' .or. c==char(9)) then
                    VEspacio=VEspacio+1 !Si hay un espacio, lo agrego en el siguiente

                else

                    lexema=trim(lexema)//repeat(char(32),VEspacio)//c !Concateno el espacio al lexema
                    VEspacio=0
                end if

            end if
    !Estado de lectura de comentario de varias lineas (parte 1) 3->9
        case (9)
            if (c=='*') then
                lexema=trim(lexema)//c
                estado=12
                VEspacio=0
            else
                if (c==char(10)) then
                    posF=posF+1
                    Saltos=Saltos+1
                else
                    !Si hay un espacio para que no lo elimine con el trim
                    if(c==' ' .or. c==char(9)) then
                        VEspacio=VEspacio+1 !Si hay un espacio, lo agrego en el siguiente
                    else
                        lexema=trim(lexema)//repeat(char(32),VEspacio)//c !Concateno el espacio al lexema
                        VEspacio=0
                    end if

                end if
            end if
    !Estado de lectura de apertura de control (parte 2) 7->10
        case (10)
            if (c=='-') then
                lexema=trim(lexema)//c
                estado=13
            else
                call agregarErrorLexico(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Apertura de control no reconocida" // repeat(' ', 200-len_trim("Apertura de control no reconocida")), posF, posC-len_trim(lexema))
                estado=0
                i=i-1
                posC=posC-1
            end if
    !Estado de lecutra de cerradura de control (parte 2) 7->11
        case (11)
            if (c=='>') then
                lexema=trim(lexema)//c
                call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Cerradura de control" // repeat(' ', 200-len_trim("Cerradura de control")), posF, posC-len_trim(lexema)+1)
                call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                estado=0
            else
                call agregarErrorLexico(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Cerradura de control no reconocida" // repeat(' ', 200-len_trim("Cerradura de control no reconocida")), posF, posC-len_trim(lexema))
                estado=0
                i=i-1
                posC=posC-1
            end if
    !Estado de lectura de comentario de varias lineas (parte 2) 6->9->12
        case (12)
            if (c=='/') then
                lexema=trim(lexema)//c
                call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Comentario de varias líneas" // repeat(' ', 200-len_trim("Comentario de varias líneas")), posF-Saltos, tempPos)
                call agregarTerminal('Comentario'// repeat(' ', 200 - len_trim("Comentario")))
                estado=0
            else
                call agregarErrorLexico(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Comentario de varias líneas no cerrado" // repeat(' ', 200-len_trim("Comentario de varias líneas no cerrado")), posF-Saltos, tempPos)
                estado=0
                i=i-1
                posC=posC-1
            end if
            Saltos=0 !Para poder llevar la cuenta de los saltos de línea

    !Estado de lectura de apertura de control (parte 3) 10->13
        case (13)
            if (c=='-') then
                lexema=trim(lexema)//c
                call agregarToken(adjustl(trim(lexema)// repeat(' ', 200 - len_trim(lexema))), "Apertura de control" // repeat(' ', 200-len_trim("Apertura de control")), posF, posC-len_trim(lexema)+1)
                call agregarTerminal(trim(lexema)// repeat(' ', 200 - len_trim(lexema)))
                estado=0
            else
                call agregarErrorLexico(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Apertura de control no reconocida" // repeat(' ', 200-len_trim("Apertura de control no reconocida")), posF, posC-len_trim(lexema))
                estado=0
                i=i-1
                posC=posC-1
            end if
        end select
    end do


end subroutine analizar

subroutine html_bueno() !Subrutina que genera el html con los tokens encontrados
    use globales
    implicit none
    !Asigno las variables
    integer :: unit,i
    character(len=4) :: cuento
    unit=2024 !Se asigna un numero de unidad
    open(unit, file='tablaTokens.html', status='unknown', action='write') !Se abre el archivo para escribir
    write(unit, '(A)') "<!DOCTYPE html>"
    write(unit, '(A)') "<html>"
    write(unit, '(A)') "<head>"
    write(unit, '(A)') "<title>Tabla de Tokens</title>"
    write(unit, '(A)') "<style>"
    write(unit, '(A)') "table {width: 50%; border-collapse: collapse;}"
    write(unit, '(A)') "th, td {border: 1px solid black; padding: 8px; text-align: left;}"
    write(unit, '(A)') "th {background-color: #1fc738;}"
    write(unit, '(A)') "</style>"
    write(unit, '(A)') "</head>"
    write(unit, '(A)') "<body>"
    write(unit, '(A)') "<h2>Tabla de Tokens</h2>"
    write(unit, '(A)') "<table>"
    write(unit, '(A)') "<tr><th>Número de Token</th><th>Lexema</th><th>Tipo</th><th>Fila</th><th>Columna</th></tr>"
    do i=1,cuentaT
        write(cuento,'(I3)') i 
        write(unit, '(A)') "<tr>"
        write(unit, '(A)') "<td>"//trim(cuento)//"</td>"
        if (trim(tokens(1,i))=="-->") then
            write(unit, '(A)') "<td>--&gt;</td>"
        else if (trim(tokens(1,i))=="<!--") then
            write(unit, '(A)') "<td>&lt;!--</td>"
        else
            write(unit, '(A)') "<td>"//trim(tokens(1,i))//"</td>"
        end if
        write(unit, '(A)') "<td>"//trim(tokens(2,i))//"</td>"
        write(unit, '(A)') "<td>"//trim(tokens(3,i))//"</td>"
        write(unit, '(A)') "<td>"//trim(tokens(4,i))//"</td>"
        write(unit, '(A)') "</tr>"
    end do
    close(unit) !Se cierra el archivo
end subroutine html_bueno

subroutine html_malo () !Subrutina que genera el html con los errores encontrados
    use globales
    implicit none
    !Asigno las variables
    integer :: unit,i,j
    character(len=4) :: cuento
    unit=254 !Se asigna un numero de unidad
    open(unit, file='tablaErrores.html', status='unknown', action='write') !Se abre el archivo para escribir
    write(unit, '(A)') "<!DOCTYPE html>"
    write(unit, '(A)') "<html>"
    write(unit, '(A)') "<head>"
    write(unit, '(A)') "<title>Tabla de Errores</title>"
    write(unit, '(A)') "<style>"
    write(unit, '(A)') "table {width: 50%; border-collapse: collapse;}"
    write(unit, '(A)') "th, td {border: 1px solid black; padding: 8px; text-align: left;}"
    write(unit, '(A)') "th {background-color: #f84545;}"
    write(unit, '(A)') "</style>"
    write(unit, '(A)') "</head>"
    write(unit, '(A)') "<body>"
    write(unit, '(A)') "<h2>Tabla de Errores</h2>"
    write(unit, '(A)') "<table>"
    write(unit, '(A)') "<tr><th>Numero de Error</th><th>Tipo de Error</th><th>Token/Componente Esperado</th><th>Descripcion</th><th>Fila</th><th>Columna</th></tr>"
    do i=1,cuentaE
        write(cuento,'(I3)') i
        write(unit, '(A)') "<tr>"
        write(unit, '(A)') "<td>"//trim(cuento)//"</td>"
        write(unit, '(A)') "<td>Error Lexico</td>"
        if (trim(erroresLexicos(1,i))=="-->") then
            write(unit, '(A)') "<td>--&gt;</td>"
        else if (trim(erroresLexicos(1,i))=="<!--") then
            write(unit, '(A)') "<td>&lt;!--</td>"
        else
            write(unit, '(A)') "<td>"//trim(erroresLexicos(1,i))//"</td>"
        end if
        write(unit, '(A)') "<td>"//trim(erroresLexicos(2,i))//"</td>"
        write(unit, '(A)') "<td>"//trim(erroresLexicos(3,i))//"</td>"
        write(unit, '(A)') "<td>"//trim(erroresLexicos(4,i))//"</td>"
        write(unit, '(A)') "</tr>"
    end do
    do j=1, cuentaES
        write(cuento,'(I3)') i
        write(unit, '(A)') "<tr>"
        write(unit, '(A)') "<td>"//trim(cuento)//"</td>"
        write(unit, '(A)') "<td>Error Sintactico</td>"
        if (trim(erroresSintacticos(1,j))=="-->") then
            write(unit, '(A)') "<td>--&gt;</td>"
        else if (trim(erroresSintacticos(1,j))=="<!--") then
            write(unit, '(A)') "<td>&lt;!--</td>"
        else
            write(unit, '(A)') "<td>"//trim(erroresSintacticos(1,i))//"</td>"
        end if
        write(unit, '(A)') "<td>"//trim(erroresSintacticos(2,j))//"</td>"
        write(unit, '(A)') "<td>"//trim(erroresSintacticos(3,j))//"</td>"
        write(unit, '(A)') "<td>"//trim(erroresSintacticos(4,j))//"</td>"
        write(unit, '(A)') "</tr>"
        i=i+1
    end do
    close(unit) !Se cierra el archivo
end subroutine html_malo

subroutine leer() !Lee el archivo de entrada enviado por phyton
    use globales
    implicit none
    character(len=200) :: linea
    integer :: ios
    do
        read(*, '(A)', iostat = ios) linea
        if (ios /= 0) exit   ! Se alcanzo el fin del archivo
        entrada = trim(entrada) // trim(linea) // char(10) ! Concatenar la línea leida al valor de entrada y agregar un salto de línea
    end do
end subroutine leer

subroutine agregarErrorLexico(lexema, descrip, linea, columna) !Subrutina que agrega los errores
    use globales !Se usa el modulo globales
    implicit none
    character(len=200) :: lexema, descrip, linea2,columna2
    integer :: linea, columna
    eLexico=.true. !Se cambia el valor de error a true (porque ya hay un error xd)
    cuentaE=cuentaE+1
    erroresLexicos(1,cuentaE)=(lexema)
    erroresLexicos(2,cuentaE)=(descrip)

    write(linea2,'(I0)') linea !Probar nuevamente la forma en la que escribo estas cosas porque ODIO FORTRAAAAAN
    write(columna2,'(I0)') columna !Lo paso a string el int
    erroresLexicos(3,cuentaE)=trim(linea2)
    erroresLexicos(4,cuentaE)=trim(columna2)
end subroutine agregarErrorLexico

subroutine agregarToken(lexema, descrip, linea, columna) !Subrutina que agrega los tokens
    use globales !Se usa el modulo globales
    implicit none
    character(len=200) :: lexema, descrip, linea2,columna2 !Se declaran las variables
    integer :: linea, columna
    cuentaT=cuentaT+1
    tokens(1,cuentaT)=(lexema)
    tokens(2,cuentaT)=(descrip)

    !Creo la copia de los tokens
    copiaTokens(1,cuentaT)=(lexema)
    copiaTokens(2,cuentaT)=(descrip)
    write(linea2,'(I0)') linea !Lo transfora a string
    write(columna2,'(I0)') columna !Lo transforma a string
    tokens(3,cuentaT)=(linea2)
    tokens(4,cuentaT)=(columna2)

    !Creo la copia de los tokesn (parte 2)
    copiaTokens(3,cuentaT)=(linea2)
    copiaTokens(4,cuentaT)=(columna2)
end subroutine agregarToken

subroutine agregarTerminal(terminal) !Subrutina que agrega los terminales
    use globales !Se usa el modulo globales
    implicit none
    character(len=200) :: terminal !Se declara la variable
    cuentaCT=cuentaCT+1
    terminales(1,cuentaCT)=terminal
end subroutine agregarTerminal
!Analisis léxico --------------------------------------------------------------------------------------------------------------------------------   

!subrutina para agregar errores sintácticos
subroutine agregarSintactico(esperado, descrip, linea, columna)
    use globales !Se usa el modulo globales
    implicit none
    character(len=200) :: esperado, descrip,linea, columna
    eLexico=.true. !Se cambia el valor de error a true (porque ya hay un error xd)
    cuentaES=cuentaES+1
    erroresSintacticos(1,cuentaES)=(esperado)
    erroresSintacticos(2,cuentaES)=(descrip)

    !write(linea2,'(I0)') linea !Probar nuevamente la forma en la que escribo estas cosas porque ODIO FORTRAAAAAN
    !write(columna2,'(I0)') columna !Lo paso a string el int
    erroresSintacticos(3,cuentaES)=trim(linea)
    erroresSintacticos(4,cuentaES)=trim(columna)

end subroutine agregarSintactico

!Analisis sintáctico ----------------------------------------------------------------------------------------------------------------------------

!Inicia el análisis sintáctico (parte 1)
subroutine iniciarAnalisisSintactico()
    use globales
    implicit none
    
    !Inicializo la variable que indica la posición del token dentro de la lista de tokens
    cuentaConsumo=1

    eSintactico=.false.
    ErrorValidado=.false.
    exepcion1=.false.
    recuperado=.true.

    call inicio() !Llamo a la subrutina inicio


end subroutine iniciarAnalisisSintactico

!Estado inicial del analisis sintáctico (parte 2)
subroutine inicio()
    use globales
    implicit none

    !Llamo a las subrutinas que contienen Controles
    call Block1()

    !Llamo a las subrutinas que contienen Propiedades
    !call block2()

    !Llamo a las subrutinas que contienen Colocacion
    !call block3()

    if (eSintactico) then
        print *, "Error sintáctico"
    else
        print *, "Análisis sintáctico correcto"
    end if

end subroutine inicio

!Lectura de Controles ----------------------------------------------------------------------------------------------------------------------------
    subroutine Block1()
        use globales
        implicit none


        !Consumo el token <!--
        call consumirToken(trim("<!--")//repeat(" ",200-len_trim("<!--")))
        if (eSintactico) call panico(trim("<!--")//repeat(" ",200-len_trim("<!--")))

        !Consumo el token Controles
        call consumirToken(trim("Controles")//repeat(" ",200-len_trim("Controles")))
        if (eSintactico) call panico(trim("Controles")//repeat(" ",200-len_trim("Controles")))

        call ControlLista() !Llamo a la subrutina que contiene la lista de controles

        !Consumo el token Controles
        call consumirToken(trim("Controles")//repeat(" ",200-len_trim("Controles")))
        if (eSintactico) call panico(trim("Controles")//repeat(" ",200-len_trim("Controles")))

        !Consumo el token -->
        call consumirToken(trim("-->")//repeat(" ",200-len_trim("-->")))
        if (eSintactico) call panico(trim("-->")//repeat(" ",200-len_trim("-->")))

    end subroutine Block1

    recursive subroutine ControlLista()
        use globales
        implicit none

        !Valido si es un control valido xd
        call validoControl()
        if (controlValido) then
            controlValido=.false.

            print *, terminales(1,cuentaConsumo)
            call Control()

            call ControlLista()
        else

            !No hago nada xd
        end if
    end subroutine ControlLista

    subroutine Control()
        use globales
        implicit none

        if(trim(terminales(1,cuentaConsumo))=="Comentario") then
            call consumirToken(trim("Comentario")//repeat(" ",200-len_trim("Comentario")))
            return
        else

            !Llamo la subroutina para verificar la validez del token
            call TIPO_Control()

            
            !Consumo el token ID
            call consumirToken(trim("ID")//repeat(" ",200-len_trim("ID")))
            if (eSintactico) call panico(trim("ID")//repeat(" ",200-len_trim("ID")))

            !Consumo el token ;
            call consumirToken(trim(";")//repeat(" ",200-len_trim(";")))
            if (eSintactico) call panico(trim(";")//repeat(" ",200-len_trim(";")))
            
        end if

    end subroutine Control

    subroutine TIPO_Control()
        use globales
        implicit none

        if(trim(terminales(1,cuentaConsumo))=="Etiqueta") then
            call consumirToken(trim("Etiqueta")//repeat(" ",200-len_trim("Etiqueta")))
            eSintactico=.false.
            return
        else if(trim(terminales(1,cuentaConsumo))=="Boton") then
            call consumirToken(trim("Boton")//repeat(" ",200-len_trim("Boton")))
            eSintactico=.false.
            return
        else if(trim(terminales(1,cuentaConsumo))=="Check") then
            call consumirToken(trim("Check")//repeat(" ",200-len_trim("Check")))
            eSintactico=.false.
            return
        else if(trim(terminales(1,cuentaConsumo))=="RadioBoton") then
            call consumirToken(trim("RadioBoton")//repeat(" ",200-len_trim("RadioBoton")))
            eSintactico=.false.
            return
        else if(trim(terminales(1,cuentaConsumo))=="Texto") then
            call consumirToken(trim("Texto")//repeat(" ",200-len_trim("Texto")))
            eSintactico=.false.
            return
        else if(trim(terminales(1,cuentaConsumo))=="AreaTexto") then
            call consumirToken(trim("AreaTexto")//repeat(" ",200-len_trim("AreaTexto")))
            eSintactico=.false.
            return
        else if(trim(terminales(1,cuentaConsumo))=="Clave") then
            call consumirToken(trim("Clave")//repeat(" ",200-len_trim("Clave")))
            eSintactico=.false.
            return
        else if(trim(terminales(1,cuentaConsumo))=="Contenedor") then
            call consumirToken(trim("Contenedor")//repeat(" ",200-len_trim("Contenedor")))
            eSintactico=.false.
            return
        else !Si no es ninguno de los anteriores, entonces hay un error sintáctico
            eSintactico=.true.
            call panico(trim("un tipo de control")//repeat(" ",200-len_trim("un tipo de control")))
        end if

    end subroutine TIPO_Control

    !Función que valida si son los controles válidos
    subroutine validoControl()
        use globales
        implicit none

        !Si el token es igual a un control
        if (trim(terminales(1,cuentaConsumo))=="Etiqueta") then
            controlValido=.true.
        else if (trim(terminales(1,cuentaConsumo))=="Boton") then
            controlValido=.true.
        else if (trim(terminales(1,cuentaConsumo))=="Check") then
            controlValido=.true.
        else if (trim(terminales(1,cuentaConsumo))=="RadioBoton") then
            controlValido=.true.
        else if (trim(terminales(1,cuentaConsumo))=="Texto") then
            controlValido=.true.
        else if (trim(terminales(1,cuentaConsumo))=="AreaTexto") then
            controlValido=.true.
        else if (trim(terminales(1,cuentaConsumo))=="Clave") then
            controlValido=.true.
        else if (trim(terminales(1,cuentaConsumo))=="Contenedor") then
            controlValido=.true.
        else if (trim(terminales(1,cuentaConsumo))=="Comentario") then
            controlValido=.true.
        else !Si no es ninguno de los anteriores, entonces no es un control válido
            controlValido=.false.
        end if
    end subroutine validoControl
!Fin Lectura de Controles ------------------------------------------------------------------------------------------------------------

!Lectura de Propieades ------------------------------------------------------------------------------------------------------------
    subroutine block2()
        use globales
        implicit none

        !Consumo el token <!--
        call consumirToken(trim("<!--")//repeat(" ",200-len_trim("<!--")))
        if (eSintactico) call panico(trim("<!--")//repeat(" ",200-len_trim("<!--")))

        !Consumo el token Propiedades
        call consumirToken(trim("Propiedades")//repeat(" ",200-len_trim("Propiedades")))
        if (eSintactico) call panico(trim("Propiedades")//repeat(" ",200-len_trim("Propiedades")))

        call PropiedadesLista() !Llamo a la subrutina que contiene la lista de propiedades

        !Consumo el token Propiedades
        call consumirToken(trim("Propiedades")//repeat(" ",200-len_trim("Propiedades")))
        if (eSintactico) call panico(trim("Propiedades")//repeat(" ",200-len_trim("Propiedades")))

        !Consumo el token -->
        call consumirToken(trim("-->")//repeat(" ",200-len_trim("-->")))
        if (eSintactico) call panico(trim("-->")//repeat(" ",200-len_trim("-->")))

    end subroutine block2

    recursive subroutine PropiedadesLista()
        use globales
        implicit none

        !Valido si es una propiedad válida xd
        call validoPropiedad()

        if (propiedadValida) then
            propiedadValida=.false.
            
            call Propiedad()

            call PropiedadesLista()
        else
            !No hago nada xd
        end if
    end subroutine PropiedadesLista

    subroutine Propiedad()
        use globales
        implicit none

        if (trim(terminales(1, cuentaConsumo))=="Comentario") then
            call consumirToken(trim("Comentario")//repeat(" ",200-len_trim("Comentario")))
            return
        else

            !Consumo el token ID
            call consumirToken(trim("ID")//repeat(" ",200-len_trim("ID")))
            if (eSintactico) call panico(trim("ID")//repeat(" ",200-len_trim("ID")))

            !Consumo el token .
            call consumirToken(trim(".")//repeat(" ",200-len_trim(".")))
            if (eSintactico) call panico(trim(".")//repeat(" ",200-len_trim(".")))

            !Llamo la subrutina de la función
            call Funcion()

            !Consumo el token ;
            call consumirToken(trim(";")//repeat(" ",200-len_trim(";")))
            if (eSintactico) call panico(trim(";")//repeat(" ",200-len_trim(";")))
        end if
    end subroutine Propiedad

    subroutine Funcion()
        use globales
        implicit none


        if (trim(terminales(1,cuentaConsumo))=="setColorLetra") then

            !Consumo el token setColorLetra
            call consumirToken(trim("setColorLetra")//repeat(" ",200-len_trim("setColorLetra")))
            if (eSintactico) call panico(trim("setColorLetra")//repeat(" ",200-len_trim("setColorLetra")))

            !Consumo el token (
            call consumirToken(trim("(")//repeat(" ",200-len_trim("(")))
            if (eSintactico) call panico(trim("(")//repeat(" ",200-len_trim("(")))

            !Consumo el token Numero
            call consumirToken(trim("Numero")//repeat(" ",200-len_trim("Numero")))
            if (eSintactico) call panico(trim("Numero")//repeat(" ",200-len_trim("Numero")))

            !Consumo el token ,
            call consumirToken(trim(",")//repeat(" ",200-len_trim(",")))
            if (eSintactico) call panico(trim(",")//repeat(" ",200-len_trim(",")))

            !Consumo el token Numero
            call consumirToken(trim("Numero")//repeat(" ",200-len_trim("Numero")))
            if (eSintactico) call panico(trim("Numero")//repeat(" ",200-len_trim("Numero")))

            !Consumo el token ,
            call consumirToken(trim(",")//repeat(" ",200-len_trim(",")))
            if (eSintactico) call panico(trim(",")//repeat(" ",200-len_trim(",")))

            !Consumo el token Numero
            call consumirToken(trim("Numero")//repeat(" ",200-len_trim("Numero")))
            if (eSintactico) call panico(trim("Numero")//repeat(" ",200-len_trim("Numero")))

            !Consumo el token )
            call consumirToken(trim(")")//repeat(" ",200-len_trim(")")))
            if (eSintactico) call panico(trim(")")//repeat(" ",200-len_trim(")")))

        else if (trim(terminales(1,cuentaConsumo))=="setAncho") then

            !Consumo el token setAncho
            call consumirToken(trim("setAncho")//repeat(" ",200-len_trim("setAncho")))
            if (eSintactico) call panico(trim("setAncho")//repeat(" ",200-len_trim("setAncho")))

            !Consumo el token (
            call consumirToken(trim("(")//repeat(" ",200-len_trim("(")))
            if (eSintactico) call panico(trim("(")//repeat(" ",200-len_trim("(")))

            !Consumo el token Numero
            call consumirToken(trim("Numero")//repeat(" ",200-len_trim("Numero")))
            if (eSintactico) call panico(trim("Numero")//repeat(" ",200-len_trim("Numero")))

            !Consumo el token )
            call consumirToken(trim(")")//repeat(" ",200-len_trim(")")))
            if (eSintactico) call panico(trim(")")//repeat(" ",200-len_trim(")")))

        else if (trim(terminales(1,cuentaConsumo))=="setAlto") then

            !Consumo el token setAlto
            call consumirToken(trim("setAlto")//repeat(" ",200-len_trim("setAlto")))
            if (eSintactico) call panico(trim("setAlto")//repeat(" ",200-len_trim("setAlto")))

            !Consumo el token (
            call consumirToken(trim("(")//repeat(" ",200-len_trim("(")))
            if (eSintactico) call panico(trim("(")//repeat(" ",200-len_trim("(")))

            !Consumo el token Numero
            call consumirToken(trim("Numero")//repeat(" ",200-len_trim("Numero")))
            if (eSintactico) call panico(trim("Numero")//repeat(" ",200-len_trim("Numero")))

            !Consumo el token )
            call consumirToken(trim(")")//repeat(" ",200-len_trim(")")))
            if (eSintactico) call panico(trim(")")//repeat(" ",200-len_trim(")")))

        else if (trim(terminales(1,cuentaConsumo))=="setTexto") then

            !Consumo el token setTexto
            call consumirToken(trim("setTexto")//repeat(" ",200-len_trim("setTexto")))
            if (eSintactico) call panico(trim("setTexto")//repeat(" ",200-len_trim("setTexto")))

            !Consumo el token (
            call consumirToken(trim("(")//repeat(" ",200-len_trim("(")))
            if (eSintactico) call panico(trim("(")//repeat(" ",200-len_trim("(")))

            !Consumo el token Cadena
            call consumirToken(trim("Cadena")//repeat(" ",200-len_trim("Cadena")))
            if (eSintactico) call panico(trim("Cadena")//repeat(" ",200-len_trim("Cadena")))

            !Consumo el token )
            call consumirToken(trim(")")//repeat(" ",200-len_trim(")")))
            if (eSintactico) call panico(trim(")")//repeat(" ",200-len_trim(")")))

        else if (trim(terminales(1,cuentaConsumo))=="setColorFondo") then

            !Consumo el token setColorFondo
            call consumirToken(trim("setColorFondo")//repeat(" ",200-len_trim("setColorFondo")))
            if (eSintactico) call panico(trim("setColorFondo")//repeat(" ",200-len_trim("setColorFondo")))

            !Consumo el token (
            call consumirToken(trim("(")//repeat(" ",200-len_trim("(")))
            if (eSintactico) call panico(trim("(")//repeat(" ",200-len_trim("(")))

            !Consumo el token Numero
            call consumirToken(trim("Numero")//repeat(" ",200-len_trim("Numero")))
            if (eSintactico) call panico(trim("Numero")//repeat(" ",200-len_trim("Numero")))

            !Consumo el token ,
            call consumirToken(trim(",")//repeat(" ",200-len_trim(",")))
            if (eSintactico) call panico(trim(",")//repeat(" ",200-len_trim(",")))

            !Consumo el token Numero
            call consumirToken(trim("Numero")//repeat(" ",200-len_trim("Numero")))
            if (eSintactico) call panico(trim("Numero")//repeat(" ",200-len_trim("Numero")))

            !Consumo el token ,
            call consumirToken(trim(",")//repeat(" ",200-len_trim(",")))
            if (eSintactico) call panico(trim(",")//repeat(" ",200-len_trim(",")))

            !Consumo el token Numero
            call consumirToken(trim("Numero")//repeat(" ",200-len_trim("Numero")))
            if (eSintactico) call panico(trim("Numero")//repeat(" ",200-len_trim("Numero")))

            !Consumo el token )
            call consumirToken(trim(")")//repeat(" ",200-len_trim(")")))
            if (eSintactico) call panico(trim(")")//repeat(" ",200-len_trim(")")))

        else if (trim(terminales(1,cuentaConsumo))=="setAlineacion") then

            !Consumo el token setAlineacion
            call consumirToken(trim("setAlineacion")//repeat(" ",200-len_trim("setAlineacion")))
            if (eSintactico) call panico(trim("setAlineacion")//repeat(" ",200-len_trim("setAlineacion")))

            !Consumo el token (
            call consumirToken(trim("(")//repeat(" ",200-len_trim("(")))
            if (eSintactico) call panico(trim("(")//repeat(" ",200-len_trim("(")))

            call Alineado() !Llamo a la subrutina que contiene el alineado

            !Consumo el token )
            call consumirToken(trim(")")//repeat(" ",200-len_trim(")")))
            if (eSintactico) call panico(trim(")")//repeat(" ",200-len_trim(")")))

        else if (trim(terminales(1,cuentaConsumo))=="setMarcado") then

            !Consumo el token setMarcado
            call consumirToken(trim("setMarcado")//repeat(" ",200-len_trim("setMarcado")))
            if (eSintactico) call panico(trim("setMarcado")//repeat(" ",200-len_trim("setMarcado")))

            !Consumo el token (
            call consumirToken(trim("(")//repeat(" ",200-len_trim("(")))
            if (eSintactico) call panico(trim("(")//repeat(" ",200-len_trim("(")))

            call Booleano() !Llamo a la subrutina que contiene el booleano

            !Consumo el token )
            call consumirToken(trim(")")//repeat(" ",200-len_trim(")")))
            if (eSintactico) call panico(trim(")")//repeat(" ",200-len_trim(")")))

        else if (trim(terminales(1,cuentaConsumo))=="setGrupo") then

            !Consumo el token setGrupo
            call consumirToken(trim("setGrupo")//repeat(" ",200-len_trim("setGrupo")))
            if (eSintactico) call panico(trim("setGrupo")//repeat(" ",200-len_trim("setGrupo")))

            !Consumo el token (
            call consumirToken(trim("(")//repeat(" ",200-len_trim("(")))
            if (eSintactico) call panico(trim("(")//repeat(" ",200-len_trim("(")))

            !Consumo el token ID
            call consumirToken(trim("ID")//repeat(" ",200-len_trim("ID")))
            if (eSintactico) call panico(trim("ID")//repeat(" ",200-len_trim("ID")))

        else !Si no es ninguna de las anteriores, entonces hay un error sintáctico
            eSintactico=.true.
            call panico(trim("una propiedad")//repeat(" ",200-len_trim("una propiedad")))
        end if
    end subroutine Funcion

    subroutine Alineado()
        use globales
        implicit none

        if (trim(terminales(1,cuentaConsumo))=="izquierdo") then
            call consumirToken(trim("izquierdo")//repeat(" ",200-len_trim("Izquierda")))
            if (eSintactico) call panico(trim("izquierdo")//repeat(" ",200-len_trim("Izquierda")))
        else if (trim(terminales(1,cuentaConsumo))=="centro") then
            call consumirToken(trim("centro")//repeat(" ",200-len_trim("Centro")))
            if (eSintactico) call panico(trim("centro")//repeat(" ",200-len_trim("Centro")))
        else if (trim(terminales(1,cuentaConsumo))=="derecho") then
            call consumirToken(trim("derecho")//repeat(" ",200-len_trim("Derecha")))
            if (eSintactico) call panico(trim("derecho")//repeat(" ",200-len_trim("Derecha")))
        else !Si no es ninguna de las anteriores, entonces hay un error sintáctico
            eSintactico=.true.
            call panico(trim("un alineado")//repeat(" ",200-len_trim("un alineado")))
        end if
    end subroutine Alineado

    subroutine Booleano()
        use globales
        implicit none

        if (trim(terminales(1,cuentaConsumo))=="true") then
            call consumirToken(trim("true")//repeat(" ",200-len_trim("true")))
            if (eSintactico) call panico(trim("true")//repeat(" ",200-len_trim("true")))
        else if (trim(terminales(1,cuentaConsumo))=="false") then
            call consumirToken(trim("false")//repeat(" ",200-len_trim("false")))
            if (eSintactico) call panico(trim("false")//repeat(" ",200-len_trim("false")))
        else !Si no es ninguna de las anteriores, entonces hay un error sintáctico
            eSintactico=.true.
            call panico(trim("un booleano")//repeat(" ",200-len_trim("un booleano")))
        end if
    end subroutine Booleano

    subroutine validoPropiedad()
        use globales
        implicit none

        !Si el token es igual a una propiedad
        if (trim(terminales(1,cuentaConsumo))=='Comentario') then
            propiedadValida=.true.
        else if (trim(terminales(1, cuentaConsumo))== 'ID') then
            propiedadValida=.true.
        else !Si no es ninguna de las anteriores, entonces no es una propiedad válida
            propiedadValida=.false.
        end if

    end subroutine validoPropiedad

!Fin Lectura de Propiedades ------------------------------------------------------------------------------------------------------------

!Lectura de Colocacion ------------------------------------------------------------------------------------------------------------
    subroutine block3()
        use globales
        implicit none

        !Consumo el token <!--

        call consumirToken(trim("<!--")//repeat(" ",200-len_trim("<!--")))
        if (eSintactico) call panico(trim("<!--")//repeat(" ",200-len_trim("<!--")))

        !Consumo el token Colocacion
        call consumirToken(trim("Colocacion")//repeat(" ",200-len_trim("Colocacion"))) 
        if (eSintactico) call panico(trim("Colocacion")//repeat(" ",200-len_trim("Colocacion")))

        call ColocacionLista() !Llamo a la subrutina que contiene la lista de colocación

        !Consumo el token Colocacion
        call consumirToken(trim("Colocacion")//repeat(" ",200-len_trim("Colocacion")))
        if (eSintactico) call panico(trim("Colocacion")//repeat(" ",200-len_trim("Colocacion")))

        !Consumo el token -->
        call consumirToken(trim("-->")//repeat(" ",200-len_trim("-->")))
        if (eSintactico) call panico(trim("-->")//repeat(" ",200-len_trim("-->")))
    end subroutine block3

    recursive subroutine ColocacionLista()
        use globales
        implicit none

        !Valido si es una colocación válida xd
        call validoColocacion()

        if (colocacionValida) then
            colocacionValida=.false.
            call Colocacion()

            call ColocacionLista()
        else
            !No hago nada xd
        end if
    end subroutine ColocacionLista

    subroutine Colocacion()
        use globales
        implicit none

        if (trim(terminales(1,cuentaConsumo))=="Comentario") then
            call consumirToken(trim("Comentario")//repeat(" ",200-len_trim("Comentario")))
            return
        else if (trim(terminales(1,cuentaConsumo))=='ID') then
                
            !Consumo el token ID
            call consumirToken(trim("ID")//repeat(" ",200-len_trim("ID")))
            if (eSintactico) call panico(trim("ID")//repeat(" ",200-len_trim("ID")))

            !Consumo el token .
            call consumirToken(trim(".")//repeat(" ",200-len_trim(".")))
            if (eSintactico) call panico(trim(".")//repeat(" ",200-len_trim(".")))

            call Colocar()!Llamo la subrutina de la función

            !Consumo el token ;
            call consumirToken(trim(";")//repeat(" ",200-len_trim(";")))
            if (eSintactico) call panico(trim(";")//repeat(" ",200-len_trim(";")))

        else if (trim(terminales(1,cuentaConsumo))=="this") then

            !Consumo el token this
            call consumirToken(trim("this")//repeat(" ",200-len_trim("this")))
            if (eSintactico) call panico(trim("this")//repeat(" ",200-len_trim("this")))

            !Consumo el token .
            call consumirToken(trim(".")//repeat(" ",200-len_trim(".")))
            if (eSintactico) call panico(trim(".")//repeat(" ",200-len_trim(".")))

            !Consumo el token add
            call consumirToken(trim("add")//repeat(" ",200-len_trim("add")))
            if (eSintactico) call panico(trim("add")//repeat(" ",200-len_trim("add")))

            !Consumo el token (
            call consumirToken(trim("(")//repeat(" ",200-len_trim("(")))
            if (eSintactico) call panico(trim("(")//repeat(" ",200-len_trim("(")))

            !Consumo el token ID
            call consumirToken(trim("ID")//repeat(" ",200-len_trim("ID")))
            if (eSintactico) call panico(trim("ID")//repeat(" ",200-len_trim("ID")))

            !consumo el token )
            call consumirToken(trim(")")//repeat(" ",200-len_trim(")")))
            if (eSintactico) call panico(trim(")")//repeat(" ",200-len_trim(")")))

            !Consumo el token ;
            call consumirToken(trim(";")//repeat(" ",200-len_trim(";")))
            if (eSintactico) call panico(trim(";")//repeat(" ",200-len_trim(";")))

        else !Si no es ninguna de las anteriores, entonces hay un error sintáctico
            eSintactico=.true.
            call panico(trim('un ID o la palabra reservada "this"')//repeat(" ",200-len_trim('un ID o la palabra reservada "this"')))
        end if
    end subroutine Colocacion

    subroutine Colocar()
        use globales
        implicit none

        if (trim(terminales(1,cuentaConsumo))=="setPosicion") then

            !Consumo el token setPosicion
            call consumirToken(trim("setPosicion")//repeat(" ",200-len_trim("setPosicion")))
            if (eSintactico) call panico(trim("setPosicion")//repeat(" ",200-len_trim("setPosicion")))

            !Consumo el token (
            call consumirToken(trim("(")//repeat(" ",200-len_trim("(")))
            if (eSintactico) call panico(trim("(")//repeat(" ",200-len_trim("(")))

            !Consumo el token Numero
            call consumirToken(trim("Numero")//repeat(" ",200-len_trim("Numero")))
            if (eSintactico) call panico(trim("Numero")//repeat(" ",200-len_trim("Numero")))

            !Consumo el token ,
            call consumirToken(trim(",")//repeat(" ",200-len_trim(",")))
            if (eSintactico) call panico(trim(",")//repeat(" ",200-len_trim(",")))

            !Consumo el token Numero
            call consumirToken(trim("Numero")//repeat(" ",200-len_trim("Numero")))
            if (eSintactico) call panico(trim("Numero")//repeat(" ",200-len_trim("Numero")))

            !Consumo el token )
            call consumirToken(trim(")")//repeat(" ",200-len_trim(")")))
            if (eSintactico) call panico(trim(")")//repeat(" ",200-len_trim(")")))

        else if (trim(terminales(1,cuentaConsumo))=="add") then

            !Consumo el token add
            call consumirToken(trim("add")//repeat(" ",200-len_trim("add")))
            if (eSintactico) call panico(trim("add")//repeat(" ",200-len_trim("add")))

            !Consumo el token (
            call consumirToken(trim("(")//repeat(" ",200-len_trim("(")))
            if (eSintactico) call panico(trim("(")//repeat(" ",200-len_trim("(")))

            !Consumo el token ID
            call consumirToken(trim("ID")//repeat(" ",200-len_trim("ID")))
            if (eSintactico) call panico(trim("ID")//repeat(" ",200-len_trim("ID")))

            !Consumo el token )
            call consumirToken(trim(")")//repeat(" ",200-len_trim(")")))
            if (eSintactico) call panico(trim(")")//repeat(" ",200-len_trim(")")))

        else
            eSintactico=.true.
            call panico(trim("una colocación")//repeat(" ",200-len_trim("una colocación")))
        end if

    end subroutine Colocar

    subroutine validoColocacion()
        use globales
        implicit none

        !Si el token es igual a una colocación
        if (trim(terminales(1,cuentaConsumo))=="Comentario") then
            colocacionValida=.true.
        else if (trim(terminales(1,cuentaConsumo))=="ID") then
            colocacionValida=.true.
        else if (trim(terminales(1,cuentaConsumo))=="this") then
            colocacionValida=.true.
        else !Si no es ninguna de las anteriores, entonces no es una colocación válida
            colocacionValida=.false.
        end if
    end subroutine validoColocacion

!Fin Lectura de Colocacion ------------------------------------------------------------------------------------------------------------


!Subrutina que se llama cuando hay un error sintáctico
subroutine panico(esperado)
    use globales
    implicit none
    character(len=200), intent(in) :: esperado


    print *, cuentaConsumo
    print *, terminales(1,cuentaConsumo-1)

    if ((terminales(1,cuentaConsumo-1)/=";" .or. terminales(1,cuentaConsumo-1)/="-->" ) .and. cuentaConsumo<=cuentaT) then

        !exepcion1=.false.
        !Genero el error :)
        call agregarSintactico(trim(esperado)//repeat(' ', 200 - len_trim(esperado)), "Se encontro un " // terminales(1,cuentaConsumo) // repeat(' ', 200-len_trim(esperado)-len_trim(terminales(1,cuentaConsumo))-len_trim("se encontro un ")), &
        tokens(3,cuentaConsumo)//repeat(' ', 200 -len_trim(tokens(3,cuentaConsumo))) , tokens(4,cuentaConsumo)//repeat(' ', 200 -len_trim(tokens(4,cuentaConsumo))))
        print *, "entroooooooooooooooooooooooooooooooooooooooooooooo"

        recuperado=.false.

        !Avanzo hasta encontrar un token que sea ;
        do while (cuentaConsumo<=cuentaCT)
            if (trim(terminales(1,cuentaConsumo)) == ";" .or. trim(terminales(1,cuentaConsumo))=="-->" ) then
                print *, terminales(1,cuentaConsumo)
                !Salgo del bucle porque encontre el símbolo de sincronización
                exit 

                print *, "Buscando ; o -->"
            end if
            cuentaConsumo=cuentaConsumo+1
        end do

        !Ya me encuentro en las posición del token ;
        !Ahora voy una posición adelante de este
        if (cuentaConsumo<=cuentaCT) then
            print *, "Token de sincronización encontrado en la posición ", cuentaConsumo
            cuentaConsumo=cuentaConsumo+1
        else
            print *, "Se nos acabaron los tokens xd"
            
        end if

    else
        print *, "Ya se encuentra en la posición correcta"
    end if

end subroutine panico

!Subrutina que contiene las propiedades y recorre los tokens conforme se van consumiendo
subroutine consumirToken(tipo)
    use globales
    implicit none
    character(len=200), intent(in) :: tipo

    if (cuentaConsumo<=cuentaCT) then
        !Si el token es igual al tipo que se espera
        if (trim(terminales(1,cuentaConsumo))==trim(tipo)) then
            cuentaConsumo=cuentaConsumo+1 !Aumento la posición del token
            recuperado=.true.
        else
            !Si no es igual, entonces hay un error sintáctico
                eSintactico=.true.
        end if
    else
        !Si ya no hay más tokens, entonces ya no hago nada :)
    end if

end subroutine consumirToken
!Analisis sintáctico --------------------------------------------------------------------------------------------------------------------------------

!Creación de HTML -----------------------------------------------------------------------------------------------------------------------------------
subroutine crearHTML()
    use globales
    implicit none
    !Asigno las variables
    integer :: unit,i
    character(len=4) :: cuento
    unit=30530 !Se asigna un numero de unidad
    open(unit, file='tablaTokens.html', status='unknown', action='write') !Se abre el archivo para escribir
    write(unit, '(A)') "<!DOCTYPE html>"
    write(unit, '(A)') "<html>"
    write(unit, '(A)') "<head>"
    write(unit, '(A)') "<title>Página Web</title>"
    write(unit, '(A)') "<link rel='stylesheet' type='text/css' href='estilos.css'>"
    write(unit, '(A)') "</head>"
    write(unit, '(A)') "<body>"





    write(unit, '(A)') "</body>"    
    



end subroutine crearHTML







!Creación de HTML -----------------------------------------------------------------------------------------------------------------------------------


