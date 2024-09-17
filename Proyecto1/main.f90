module globales
    !Aquí declaro las variables globales que usaré
    implicit none
    character(len=100) :: rutaBandera, rutaGrafica, nPais, poblacion, tempBandera
    character(len=50) :: tempPais, tempSatu,tempPoblacion,tempContinente,auxPais,auxPoblacion,auxBandera,nGrafica
    integer :: cuentaT, cuentaE,cuentaP,tempSaturacion,satu
    character(len=30), dimension(4,500)::tokens, errores,paises
    !La estructura de pais será: continente / nombre / población / bandera
    integer, dimension(1:500)::saturaciones
    character(len=4000):: entrada,encuentraErrores
    logical :: error
end module globales

program proceso 
    use globales
    implicit none
    character(len=200) :: linea
    integer :: ios
    !Inicializo todas las variables que voy a usar
    entrada=""
    cuentaT=0
    cuentaE=0
    cuentaP=0
    error=.false.

    !PROBANDOOOOOOO
    open(10, file='entrada.org', status='old', action='read') !Abro el archivo de entrada
    do
    read(10, '(A)', iostat = ios) linea
    if (ios /= 0) exit   ! Se alcanzo el fin del archivo
    entrada = trim(entrada) // trim(linea) // char(10) ! Concatenar la línea leida al valor de entrada y agregar un salto de línea
    end do
    !PROBANDOOOOOOO

    print *, entrada

    call analizar()

    !call probando()

    if (error) then !Si hay errores
        call html_malo() !Llamo a la subrutina que genera el html con los errores
    else !Si no hay errores
        call html_bueno() !Llamo a la subrutina que genera el html con los tokens
        call recolectarPaises() !Llamo a la subrutina que genera la grafica
    end if

    !print *, trim(rutaGrafica)//","//trim(rutaBandera)//","//trim(nPais)//","//trim(poblacion)
end program proceso




subroutine analizar()
    use globales
    implicit none
    !Declaro las variables que usaré
    character(len=40) :: lexema
    character(len=1) :: c
    integer:: posF, posC, largo, estado, i
    logical :: VEspacio
    !Inicializo las variables
    largo=len_trim(entrada)
    posF=1
    posC=0
    satu=100
    estado=0
    i=0
    VEspacio=.false.

    !Inicializo las variables de los errores -------------------------------------------------------------
    encuentraErrores=""
    !Inicializo las variables de los errores -------------------------------------------------------------

    !Agrego el caracter de fin de cadena (para saber cuando termina)
    entrada(largo+1:largo+1)="#"
    largo=largo+1
    do while (i<=largo)
        i=i+1
        posC=posC+1 !Aumento la posición de la columna
        c=entrada(i:i) !Obtengo el caracter actual
        !Comienzo con el selectCase
        select case (estado)

    !El estado inicial (como el enrutador)
        case(0)
            if(c>='a' .and. c<='z') then !Si es una palabra reservada
                lexema=c
                estado=1
            else if (c>='0' .and. c<='9') then !Si es un número
                lexema=c
                estado=2
            else if (c=='"') then !Si es una cadena
                lexema=c
                estado=3
            else if (c==' ' .or. c==char(9)) then !Si es un espacio
                !posC=posC+1
            
            else if (c==char(10)) then
                posC=0
                posF=posF+1
                cycle

            else if (c=='#' .and. i==largo) then !Si es el fin de la cadena
                exit !Salgo del ciclo
            else !Si es un símbolo
                lexema=c
                estado=4
            end if

    !Estado para la lectura de palabras reservadas
        case(1)
            if(c>='a' .and. c<='z') then !Si son caracteres aceptados
                lexema=trim(lexema)//c
            else !Si ya no son caracteres aceptados
                if (trim(lexema)=="grafica") then !Si es la palabra reservada GRAFICA
                    call agregarToken(adjustl("grafica" // repeat(' ', 30 - len_trim("grafica"))), &
                                    adjustl("Palabra reservada" // repeat(' ', 30 - len_trim("Palabra reservada"))), &
                                    posF, posC - len_trim("grafica"))
                    
                else if (trim(lexema)=="continente") then !Si es la palabra reservada CONTINENTE
                    call agregarToken(adjustl("continente" // repeat(' ', 30 - len_trim("continente"))), &
                                    adjustl("Palabra reservada" // repeat(' ', 30 - len_trim("Palabra reservada"))), &
                                    posF, posC - len_trim("continente"))

                else if(trim(lexema)=='pais') then !Si es la palabra reservada PAIS
                    call agregarToken(adjustl("pais" // repeat(' ', 30 - len_trim("pais"))), &
                                    adjustl("Palabra reservada" // repeat(' ', 30 - len_trim("Palabra reservada"))), &
                                    posF, posC - len_trim("pais"))

                else if(trim(lexema)=='nombre') then !Si es la palabra reservada NOMBRE
                    call agregarToken(adjustl("nombre" // repeat(' ', 30 - len_trim("nombre"))), &
                                    adjustl("Palabra reservada" // repeat(' ', 30 - len_trim("Palabra reservada"))), &
                                    posF, posC - len_trim("nombre"))

                else if(trim(lexema)=='poblacion') then !Si es la palabra reservada POBLACION
                    call agregarToken(adjustl("poblacion" // repeat(' ', 30 - len_trim("poblacion"))), &
                                    adjustl("Palabra reservada" // repeat(' ', 30 - len_trim("Palabra reservada"))), &
                                    posF, posC - len_trim("poblacion"))

                else if(trim(lexema)=='saturacion') then !Si es la palabra reservada SATURACION
                    call agregarToken(adjustl("saturacion" // repeat(' ', 30 - len_trim("saturacion"))), &
                                    adjustl("Palabra reservada" // repeat(' ', 30 - len_trim("Palabra reservada"))), &
                                    posF, posC - len_trim("saturacion"))

                else if(trim(lexema)=='bandera') then !Si es la palabra reservada BANDERA
                    call agregarToken(adjustl("bandera" // repeat(' ', 30 - len_trim("bandera"))), &
                                    adjustl("Palabra reservada" // repeat(' ', 30 - len_trim("Palabra reservada"))), &
                                    posF, posC - len_trim("bandera"))

                else !Si no es ninguna palabra reservada
                    call agregarError(lexema, adjustl("Palabra reservada no aceptada" // & 
                    repeat(' ', 30 - len_trim("Palabra reservada no aceptada"))), posF, posC - len_trim(lexema))
                end if

                estado=0
                i=i-1
                posC=posC-1
            end if

    !Estado para la lectura de numeros
        case(2)
            if(c>='0' .and. c<='9') then !Si son números
                lexema=trim(lexema)//c

            else !Si ya no son números
                call agregarToken(adjustl(trim(lexema)// repeat(' ', 28 - len_trim(lexema))), &
                                adjustl("Número" // repeat(' ', 30 - len_trim("Número"))), &
                                posF, posC - len_trim(lexema)+1)
                estado=0
                i=i-1
            end if

    !Estado para la lectura de cadenas      
        case(3)
            if(c=='"') then !Si no es el fin de la cadena
                lexema=trim(lexema)//c
                call agregarError(lexema, adjustl("Cadena vacia" // &
                repeat(' ', 30 - len_trim("Cadena vacia"))), posF, posC - len_trim(lexema))
                estado=0
                
            else !Si no el fin de la cadena
                i=i-1
                posC=posC-1
                estado=5
            end if
    !Estado para la lectura de simbolos
        case(4)
            estado=0
            i=i-1
            posC=posC-1
            if(lexema==';') then !Si es un punto y coma
                call agregarToken(adjustl(";" // repeat(' ', 30 - len_trim(lexema))), &
                                adjustl("Punto y coma" // repeat(' ', 30 - len_trim("Punto y coma"))), &
                                posF, posC-1)

            else if (lexema==':') then !Si es un dos puntos
                call agregarToken(adjustl(":" // repeat(' ', 30 - len_trim(lexema))), &
                                adjustl("Dos puntos" // repeat(' ', 30 - len_trim("Dos puntos"))), &
                                posF, posC)

            else if (lexema=='{') then !Si es una llave de apertura
                call agregarToken(adjustl("{" // repeat(' ', 30 - len_trim(lexema))), &
                                adjustl("Llave de apertura" // repeat(' ', 30 - len_trim("Llave de apertura"))), &
                                posF, posC)

            else if (lexema=='%') then !Si es un porcentaje
                call agregarToken(adjustl("%" // repeat(' ', 30 - len_trim(lexema))), &
                                adjustl("Porcentaje" // repeat(' ', 30 - len_trim("Porcentaje"))), &
                                posF, posC-1)

            else if (lexema=='}') then !Si es una llave de cierre
                call agregarToken(adjustl("}" // repeat(' ', 30 - len_trim(lexema))), &
                                adjustl("Llave de cierre" // repeat(' ', 30 - len_trim("Llave de cierre"))), &
                                posF, posC)
                
            else !Si no es ningun simbolo aceptado
                call agregarError(lexema, adjustl("Simbolo no aceptado" // & 
                repeat(' ', 30 - len_trim("Simbolo no aceptado"))), posF, posC - len_trim(lexema))
            end if


    !Estado de lectura de cadena de caracteres
        case(5)
            if (c=='"') then !Si es el fin de la cadena
                lexema=trim(lexema)//c

                call agregarToken(adjustl(trim(lexema)// repeat(' ', 28 - len_trim(lexema))), &
                                adjustl("Cadena" // repeat(' ', 30 - len_trim("Cadena"))), &
                                posF, posC - len_trim(lexema)+1)
                estado=6

            else !Si no es el fin de la cadena

                if (VEspacio) then !Si hay un espacio
                    lexema=trim(lexema)//' '//c !Concateno el espacio al lexema
                    VEspacio=.false.
                else
                    lexema=trim(lexema)//c !Concateno el caracter al lexema
                end if
                if(c==' ' .or. c==char(9) .or. c==char(10)) then
                    VEspacio=.true. !Si hay un espacio, lo agrego en el siguiente
                end if
            end if
    !Estado de finalización de lectura de caracteres
        case(6)
            estado=0
            i=i-1
        end select
    end do
end subroutine analizar

subroutine probando() !Subrutina que agrega los paises para probar la grafica
    use globales
    implicit none
    nGrafica="grafica"
    call agregarPais(adjustl("Asia"//repeat(' ', 30-len_trim("Asia"))), &
                    adjustl("Japon"//repeat(' ', 30-len_trim("Japon"))), &
                    adjustl("2352342"//repeat(' ', 30-len_trim("2352342"))), &
                    80, &
                    adjustl("C:\imagen.jpg"//repeat(' ', 30-len_trim("C:\imagen.jpg"))))

    call agregarPais(adjustl("Asia"//repeat(' ', 30-len_trim("Asia"))), &
                    adjustl("China"//repeat(' ', 30-len_trim("China"))), &
                    adjustl("1350000000"//repeat(' ', 30-len_trim("1350000000"))), &
                    95, &
                    adjustl("C:\imagen.jpg"//repeat(' ', 30-len_trim("C:\imagen.jpg"))))

    call agregarPais(adjustl("Asia"//repeat(' ', 30-len_trim("Asia"))), &
                    adjustl("Korea"//repeat(' ', 30-len_trim("Korea"))), &
                    adjustl("2352342"//repeat(' ', 30-len_trim("2352342"))), &
                    40, &
                    adjustl("C:\imagen.jpg"//repeat(' ', 30-len_trim("C:\imagen.jpg"))))

    call agregarPais(adjustl("America"//repeat(' ', 30-len_trim("America"))), &
                    adjustl("Canada"//repeat(' ', 30-len_trim("Canada"))), &
                    adjustl("23423423"//repeat(' ', 30-len_trim("23423423"))), &
                    65, &
                    adjustl("C:\imagen.jpg"//repeat(' ', 30-len_trim("C:\imagen.jpg"))))

    call agregarPais(adjustl("America"//repeat(' ', 30-len_trim("America"))), &
                    adjustl("Guatemala"//repeat(' ', 30-len_trim("Guatemala"))), &
                    adjustl("17263239"//repeat(' ', 30-len_trim("17263239"))), &
                    40, &
                    adjustl("C:\imagen.jpg"//repeat(' ', 30-len_trim("C:\imagen.jpg"))))

    call agregarPais(adjustl("America"//repeat(' ', 30-len_trim("America"))), &
                    adjustl("Chile"//repeat(' ', 30-len_trim("Chile"))), &
                    adjustl("235234234"//repeat(' ', 30-len_trim("235234234"))), &
                    60, &
                    adjustl("C:\imagen.jpg"//repeat(' ', 30-len_trim("C:\imagen.jpg"))))

    call agregarPais(adjustl("Europa"//repeat(' ', 30-len_trim("Europa"))), &
                    adjustl("espana"//repeat(' ', 30-len_trim("espana"))), &
                    adjustl("345"//repeat(' ', 30-len_trim("345"))), &
                    2, &
                    adjustl("C:\imagen.jpg"//repeat(' ', 30-len_trim("C:\imagen.jpg"))))
end subroutine probando

subroutine agregarPais(conti, pai, po, sar,ba)
    use globales
    implicit none
    character(len=30) :: conti, pai, po,ba
    integer :: sar
    cuentaP=cuentaP+1
    paises(1,cuentaP)=trim(conti)
    paises(2,cuentaP)=trim(pai)
    paises(3,cuentaP)=trim(po)
    saturaciones(cuentaP)=sar
    paises(4,cuentaP)=trim(ba)
end subroutine agregarPais

subroutine agregarError(lexema, descrip, linea, columna) !Subrutina que agrega los errores
    use globales !Se usa el modulo globales
    implicit none
    character(len=30) :: lexema, descrip, linea2,columna2
    integer :: linea, columna
    error=.true. !Se cambia el valor de error a true (porque ya hay un error xd)
    cuentaE=cuentaE+1
    errores(1,cuentaE)=trim(lexema)
    errores(2,cuentaE)=trim(descrip)
    write(linea2,'(I0)') linea !Probar nuevamente la forma en la que escribo estas cosas porque ODIO FORTRAAAAAN
    write(columna2,'(I0)') columna !Lo paso a string el int
    errores(3,cuentaE)=trim(linea2)
    errores(4,cuentaE)=trim(columna2)
end subroutine agregarError

subroutine agregarToken(lexema, descrip, linea, columna) !Subrutina que agrega los tokens
    use globales !Se usa el modulo globales
    implicit none
    character(len=30) :: lexema, descrip, linea2,columna2 !Se declaran las variables
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

subroutine html_bueno() !Subrutina que genera el html con los tokens encontrados
    use globales
    implicit none
    !Asigno las variables
    integer :: unit,i
    character(len=4) :: cuento
    unit=2024 !Se asigna un numero de unidad
    open(unit, file='tabla.html', status='unknown', action='write') !Se abre el archivo para escribir
    write(unit, '(A)') "<!DOCTYPE html>"
    write(unit, '(A)') "<html>"
    write(unit, '(A)') "<head>"
    write(unit, '(A)') "<title>Tabla de Tokens</title>"
    write(unit, '(A)') "<style>"
    write(unit, '(A)') "table {width: 50%; border-collapse: collapse;}"
    write(unit, '(A)') "th, td {border: 1px solid black; padding: 8px; text-align: left;}"
    write(unit, '(A)') "th {background-color: #f2f2f2;}"
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
        write(unit, '(A)') "<td>"//trim(tokens(1,i))//"</td>"
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
    open(unit, file='tabla.html', status='unknown', action='write') !Se abre el archivo para escribir
    write(unit, '(A)') "<!DOCTYPE html>"
    write(unit, '(A)') "<html>"
    write(unit, '(A)') "<head>"
    write(unit, '(A)') "<title>Tabla de Errores</title>"
    write(unit, '(A)') "<style>"
    write(unit, '(A)') "table {width: 50%; border-collapse: collapse;}"
    write(unit, '(A)') "th, td {border: 1px solid black; padding: 8px; text-align: left;}"
    write(unit, '(A)') "th {background-color: #f2f2f2;}"
    write(unit, '(A)') "</style>"
    write(unit, '(A)') "</head>"
    write(unit, '(A)') "<body>"
    write(unit, '(A)') "<h2>Tabla de Errores</h2>"
    write(unit, '(A)') "<table>"
    write(unit, '(A)') "<tr><th>Número de Error</th><th>Error</th><th>Descripción</th><th>Fila</th><th>Columna</th></tr>"
    do i=1,cuentaE
        write(cuento,'(I0)') i
        write(unit, '(A)') "<tr>"
        write(unit, '(A)') "<td>"//trim(cuento)//"</td>"
        write(unit, '(A)') "<td>"//trim(errores(1,i))//"</td>"
        write(unit, '(A)') "<td>"//trim(errores(2,i))//"</td>"
        write(unit, '(A)') "<td>"//trim(errores(3,i))//"</td>"
        write(unit, '(A)') "<td>"//trim(errores(4,i))//"</td>"
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

subroutine graficar() !Subrutina que genera la grafica con graphviz
    use globales
    implicit none
    character(len=5000) :: grafica
    character(len=30) :: temp,promSatu,satuPais,nG,nP,nC
    integer :: j,unit,pp,prom,herbert
    unit=2021
    j=1

    !Antes recolecto los paises de la tabla de tokens

    grafica= "digraph Grafica {" // new_line('A') // "rankdir=TB;" // new_line('A') &
                // "node [shape = record, style = filled];" // new_line('A')
    pp=1
    nG=trim(nGrafica(2:len_trim(nGrafica)-1))
    grafica=trim(grafica)//trim(nGrafica)//' [Label="{'//trim(nG)//'}" fillcolor="purple"];'//new_line('A')
    do while (j<=cuentaP)
        prom=0
        temp=trim(paises(1,j))
        herbert=0
        !Ciclo para encontrar la saturación promedio de los paises en el continente
        do while (trim(temp) == trim(paises(1,pp)))
            prom=prom+saturaciones(pp)
            pp=pp+1
            herbert=herbert+1
        end do
        prom=int(prom/herbert) !Termino de calcular el promedio

        !Convierto el promedio a string
        write(promSatu,'(I0)') prom !Lo convierto a string

        !Le quito las comillas dobles a los nombres
        nC=trim(temp(2:len_trim(temp)-1))
        grafica=trim(grafica)//trim(temp)//' [label="{'//trim(nC)//"|"//trim(promSatu)// '}"'

        !Condicional para los colorcitos
        if (prom>75) then
            grafica=trim(grafica)//' fillcolor="red";'
        else if (prom>60) then
            grafica=trim(grafica)//' fillcolor="orange";'
        else if (prom>45) then
            grafica=trim(grafica)//' fillcolor="yellow";'
        else if (prom>30) then
            grafica=trim(grafica)//' fillcolor="green";'
        else if (prom>15) then
            grafica=trim(grafica)//' fillcolor="blue";'
        else
            grafica=trim(grafica)//' fillcolor="white";'
        end if

        !Cierro y grafico :)
        grafica=trim(grafica)//'];'//new_line('A')
        grafica=trim(grafica)//trim(nGrafica)//' -> ' //trim(temp)//';'//new_line('A')

        !Ciclo para crear los nodos
        do while (trim(temp) == trim(paises(1,j)))
            write(satuPais, '(I0)') saturaciones(j) !Lo convierto a string

            !Creo los nodos de los paises y los conecto con el continente
            nP=trim(paises(2,j)(2:len_trim(paises(2,j))-1))
            grafica=trim(grafica)//trim(paises(2,j))//' [label="{'//trim(nP)//"|"//trim(satuPais)//'}"'

            !Condicional para los colorcitos
            if (saturaciones(j)>75) then
                grafica=trim(grafica)//' fillcolor="red";'
            else if (saturaciones(j)>60) then
                grafica=trim(grafica)//' fillcolor="orange";'
            else if (saturaciones(j)>45) then
                grafica=trim(grafica)//' fillcolor="yellow";'
            else if (saturaciones(j)>30) then
                grafica=trim(grafica)//' fillcolor="green";'
            else if (saturaciones(j)>15) then
                grafica=trim(grafica)//' fillcolor="blue";'
            else
                grafica=trim(grafica)//' fillcolor="white";'
            end if

            !Cierro y grafico :)
            grafica=trim(grafica)//'];'//new_line('A')
            grafica=trim(grafica)//trim(temp)//' -> '//trim(paises(2,j))//';'//new_line('A')
            j=j+1
        end do
    end do
    grafica=trim(grafica)//"}" !Cierro la grafica

    !Creo el archivo .dot
    open(unit, file='grafica.dot', status='unknown', action='write') !Se abre el archivo para escribir
    write(unit, '(A)') trim(grafica)
    close (unit) !Se cierra el archivo
    
    !Llamo a graphviz para que genere la imagen
    call system("dot -Tpng grafica.dot -o grafica.png")
    rutaGrafica="grafica.png"

end subroutine graficar

subroutine recolectarPaises() !Subrutina que recolecta los errores
    use globales
    implicit none
    integer :: i,j,cuentoGraficas, cuentoContinentes, cuentoPaises, &
    cuentoPoblacion, cuentoSaturacion,cuentoBandera,cuentoNombre,cuentoAbre,cuentoCierra, &
    cuentoDosPunto,cuentoPuntoYComa,cuentoPorcentaje,iostat
    logical :: cuadra
    i=0
    j=0
    cuentoGraficas=0
    cuentoContinentes=0
    cuentoPaises=0
    cuentoPoblacion=0
    cuentoSaturacion=0
    cuentoBandera=0
    cuentoNombre=0
    cuentoAbre=0
    cuentoCierra=0
    cuentoDosPunto=0
    cuentoPuntoYComa=0
    cuentoPorcentaje=0
    cuadra=.true.

    !Ciclo para recorrer los tokens y contarlos para que cuadren
    do while (i<=cuentaT)
        i=i+1
        if(trim(tokens(1,i))=="grafica") then
            cuentoGraficas=cuentoGraficas+1
        else if(trim(tokens(1,i))=="continente") then
            cuentoContinentes=cuentoContinentes+1
        else if(trim(tokens(1,i))=="pais") then
            cuentoPaises=cuentoPaises+1
        else if(trim(tokens(1,i))=="nombre") then
            cuentoNombre=cuentoNombre+1
        else if(trim(tokens(1,i))=="poblacion") then
            cuentoPoblacion=cuentoPoblacion+1
        else if(trim(tokens(1,i))=="saturacion") then
            cuentoSaturacion=cuentoSaturacion+1
        else if(trim(tokens(1,i))=="bandera") then
            cuentoBandera=cuentoBandera+1
        else if(trim(tokens(1,i))=="{") then
            cuentoAbre=cuentoAbre+1
        else if(trim(tokens(1,i))=="}") then
            cuentoCierra=cuentoCierra+1
        else if(trim(tokens(1,i))==":") then
            cuentoDosPunto=cuentoDosPunto+1
        else if(trim(tokens(1,i))==";") then
            cuentoPuntoYComa=cuentoPuntoYComa+1
        else if(trim(tokens(1,i))=="%") then
            cuentoPorcentaje=cuentoPorcentaje+1
        end if
    end do

    !Condicional para que cuadren los tokens
    if (cuentoGraficas/=1 ) then
        cuadra=.false.
    else if (cuentoAbre/=cuentoCierra) then
        cuadra=.false.
    else if(cuentoPaises/=cuentoPoblacion) then
        cuadra=.false.
    else if(cuentoPaises/=cuentoSaturacion) then
        cuadra=.false.
    else if(cuentoPaises/=cuentoBandera) then
        cuadra=.false.
    else if(cuentoNombre/=cuentoPaises+cuentoContinentes+cuentoGraficas) then
        cuadra=.false.
    else if(cuentoPaises/=cuentoPorcentaje) then
        cuadra=.false.
    else if(cuentoDosPunto/=cuentoNombre+cuentoPoblacion+cuentoSaturacion+cuentoBandera+cuentoGraficas+cuentoContinentes+cuentoPaises) then
        cuadra=.false.
    else if(cuentoPuntoYComa/=cuentoPoblacion+cuentoSaturacion+cuentoBandera+cuentoNombre) then
        cuadra=.false.
    else
        cuadra=.true.
    end if

    i=0
    !Si todo cuadra, entonces creo la matriz con los paises y lo grafico :)
    if (cuadra) then
        do while (i<=cuentaT)
            i=i+1

            !print *, trim(tokens(1,i))
            !Aquí obtengo el nombre de la grafica
            if (trim(tokens(1,i))=="grafica") then

                do while (j<=cuentaT)
                    j=j+1
                    if (trim(tokens(1,j))=="nombre") then
                        nGrafica=trim(tokens(1,j+2))
                        exit
                    end if
                end do
            end if

            !Aquí obtengo el primer continente
            if (trim(tokens(1,i))=="continente") then
                do while (j<=cuentaT)
                    j=j+1
                    if (trim(tokens(1,j))=="nombre") then
                        tempContinente=trim(tokens(1,j+2))
                        exit
                    end if
                end do
            end if

            !Aquí obtengo la información de los paises
            if (trim(tokens(1,i))=="pais") then
                do while (j<=cuentaT)
                    j=j+1
                    if (trim(tokens(1,j))=="nombre") then
                        tempPais=trim(tokens(1,j+2))
                    else if (trim(tokens(1,j))=="poblacion") then
                        tempPoblacion=trim(tokens(1,j+2))
                        print *, tempPoblacion
                    else if (trim(tokens(1,j))=="saturacion") then
                        tempSatu=trim(tokens(1,j+2))
                        read(tempSatu, '(I10)', iostat=iostat) tempSaturacion
                    else if (trim(tokens(1,j))=="bandera") then
                        tempBandera=trim(tokens(1,j+2))
                    else if (trim(tokens(1,j))=="}") then
                        call agregarPais(tempContinente,tempPais,tempPoblacion,tempSaturacion,tempBandera)
                        exit
                    end if
                end do
            end if
        end do
        call graficar() !Lo grafico
    end if
    print *, nGrafica
end subroutine recolectarPaises




!Lo dejo en standby xd
subroutine buscoMenorSaturacion()
    use globales
    implicit none
    integer :: i, menor, auxMenor
    menor=100
    i=0
    auxMenor=0
    do while (i<=cuentaP)
        i=i+1
        if (saturaciones(i)<menor) then
            menor=saturaciones(i)
            auxMenor=i
        end if

    end do


end subroutine buscoMenorSaturacion