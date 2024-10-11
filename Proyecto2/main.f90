module globales
!Aquí ando declarando las variables globales que usaré
    character(len=15000)::entrada
    integer::cuentaT, cuentaN, cuentaE
    character(len=200), dimension(4,2000)::tokens,erroresLexicos
    logical::eLexico


end module globales

program proceso
    use globales
    implicit none


    !-----------------------------------
    integer::ios
    character(len=200)::linea
    !-----------------------------------

    !Inicializando variables
    entrada = '' !Inicializo la variable entrada


    !PROBANDOOOOOOO
    open(10, file='Prueba.LFP', status='old', action='read') !Abro el archivo de entrada
    do
    read(10, '(A)', iostat = ios) linea
    if (ios /= 0) exit   ! Se alcanzo el fin del archivo
    entrada = trim(entrada) // trim(linea) // char(10) ! Concatenar la línea leida al valor de entrada y agregar un salto de línea
    end do
    !PROBANDOOOOOOO



    !call leer() !Llamo a la subrutina leer
    !print *, entrada !Imprimo la variable entrada
    call analizar ()

    !Genero los dos HTML
    call html_malo()
    call html_bueno()



end program proceso


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
                print*, c
                cycle
            end if

    !Estado de lectura de palabras reservadas e identificadores (parte 1) 1
        case(1)
            if (c>='a' .and. c<='z' .or. c>='A' .and. c<='Z' .or. c>='0' .and. c<='9' .or. c=='_') then !Si es una letra o número
                lexema=trim(lexema)//c
            else 
            !Estas serán las palabras reservadas
                
                if (trim(lexema)=="Controles") then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=="Propiedades") then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=="Colocacion") then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))

                !Lo que contiene contenedor
                else if (trim(lexema)=="Etiqueta") then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=='Boton') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=='Check') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=='RadioBoton') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=='Texto') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=='AreaTexto') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=='Clave') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=='Contenedor') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))

                !Lo que contiene propiedades
                else if (trim(lexema)=='setColorLetra') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=='setAncho') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=='setAlto') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=='setTexto') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=='setColorFondo') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=='setAlineacion') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if ( trim(lexema)=='setMarcado' ) then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=='setGrupo') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))

                !Lo que contiene colocacion
                else if (trim(lexema)=='add') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=='setPosicion') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))
                else if (trim(lexema)=='this') then
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Palabra reservada" // repeat(' ', 200-len_trim("Palabra reservada")), posF, posC-len_trim(lexema))

            !Si es simplemente un identificador
                else
                    call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Identificador" // repeat(' ', 200-len_trim("Identificador")), posF, posC-len_trim(lexema))
                end if
                estado=0
                i=i-1
                posC=posC-1
            end if

    !Estado de lectura de símbolos (parte 1) 2
        case (2)
            if (c == ';' .or. c=='.' .or. c=='(' .or. c==')' .or. c==',') then
                call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Simbolo" // repeat(' ', 200-len_trim("Simbolo")), posF, posC)
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
                estado=0
                i=i-1
                posC=posC-1
            end if

    !Estado de lectura de cadenas de texto
        case (5)
            if (c=='"') then
                lexema=trim(lexema)//c
                call agregarToken(trim(lexema)// repeat(' ', 200 - len_trim(lexema)), "Cadena" // repeat(' ', 200-len_trim("Cadena")), posF, posC-len_trim(lexema))
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
                !print *, lexema
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
                estado=0
                i=i-1
                posC=posC-1
                VEspacio=0
            else

                !Si hay un espacio para que no lo elimine con el trim
                if(c==' ' .or. c==char(9)) then
                    VEspacio=VEspacio+1 !Si hay un espacio, lo agrego en el siguiente
                    !print *, VEspacio
                else
                    !print *, VEspacio
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
                    !print *, Saltos
                else
                    !Si hay un espacio para que no lo elimine con el trim
                    if(c==' ' .or. c==char(9)) then
                        VEspacio=VEspacio+1 !Si hay un espacio, lo agrego en el siguiente
                        !print *, VEspacio
                    else
                        !print *, VEspacio
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
                estado=0
                !print *, lexema
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
                estado=0
                !print *, lexema
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
    integer :: unit,i
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
    write(unit, '(A)') "<tr><th>Número de Error</th><th>Error</th><th>Descripción</th><th>Fila</th><th>Columna</th></tr>"
    do i=1,cuentaE
        write(cuento,'(I3)') i
        write(unit, '(A)') "<tr>"
        write(unit, '(A)') "<td>"//trim(cuento)//"</td>"
        write(unit, '(A)') "<td>"//trim(erroresLexicos(1,i))//"</td>"
        write(unit, '(A)') "<td>"//trim(erroresLexicos(2,i))//"</td>"
        write(unit, '(A)') "<td>"//trim(erroresLexicos(3,i))//"</td>"
        write(unit, '(A)') "<td>"//trim(erroresLexicos(4,i))//"</td>"
        write(unit, '(A)') "</tr>"
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

    print *, lexema

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
    write(linea2,'(I0)') linea !Lo transfora a string
    write(columna2,'(I0)') columna !Lo transforma a string
    tokens(3,cuentaT)=(linea2)
    tokens(4,cuentaT)=(columna2)
    !print *, lexema, descrip, linea, columna
end subroutine agregarToken