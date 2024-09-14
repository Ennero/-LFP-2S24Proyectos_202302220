module globales
    implicit none
    character(len=100) :: rutaBandera, rutaGrafica, pais, poblacion,saturacion
    character(len=40) :: nGrafica
    integer :: cuenta1,cuenta2,cuenta3
    character(len=4000) :: contenido
    character(len=30), dimension(4,200) :: tokens, errores
    character(len=40), dimension(5,100) :: paises

end module globales

program procesando
    use globales !Se usa el modulo globales
    implicit none
    !Declaro las variables
    cuenta1  =   0
    cuenta2=0
    cuenta3=0
    saturacion='0'
    call leer() !Se llama a la subrutina que lee el archivo
    call analizar() !Se llama a la subrutina que analiza el archivo




    !call html_bueno() !Se llama a la subrutina que genera el html
    !Imprimo los resultados delimitados por una coma para que los lea phyton
    !print *, rutaGrafica,',',rutaBandera,',', pais, ',', entero_a_cadena(poblacion)
contains




subroutine analizar()
    use globales !Se usa el modulo globales
    !Declaro las variables
    integer :: posF, posC, largo, estado, indice,i
    character(len=:) :: continente, bandera, tempPais, tempBandera, pobla, tempPobla, tempSaturacion, saturacion, lexema, buffer
    character(len=1):: caracter
    logical :: vContinente,vGrafico,vPais,vbandera,vPoblacion,vSaturacion,vNombre

    !Inicializo las variables
    largo=len_trim(contenido)
    buffer=""'ddfdfsdfsdfsdfsdfs'""
    lexema='s'
    indice=1
    estado=0
    i=0
    posF=1
    posC=0
    vContinente=.false.
    vGrafico=.true.
    vPais=.false.
    vBandera=.false.
    vPoblacion=.false.
    vSaturacion=.false.
    vNombre=.false.

    !Agrego el caracter de fin de cadena (para saber cuando terminó todo)
    contenido(largo+1:largo+1)='#'
    largo=largo+1

    !Solo ando mostrando que lo hice bien o no ELIMINAR DESPUÉS
    print *, trim(contenido), largo

    !Análisis de cada caracter dentro de un ciclo for (este sería el autómata)
    do while (i<=largo) 
        i=i+1
        posC=posC+1
        if(caracter==char(10)) then !Si es un salto de línea
            posC=0 !Reinicio la posición de la columna
            posF=posF+1 !Aumento la posición de la fila
        end if
        caracter=contenido(i:i) !Obtengo el caracter actual
        select case (estado)
        !Este es el estado inicial que lee y mueve todo
        case(0) !Estado inicial
            if (caracter>= 'a' .and. caracter<= 'z') then
                estado=1
                lexema=caracter !Guardo el caracter en el lexema
            else if (caracter==' ' .or. caracter==char(9) .or. caracter==char(10)) then
                cycle !Salto al siguiente ciclo porque ignoro los espacios en blanco
            else if ( caracter=='"' .or. caracter=='(' .or. caracter=='{' ) then
                call agregarError(caracter, 'Caracter no esperado', posF, posC)
            else if (caracter==char(35) .and. i==largo) then
                !Aquí termino mi programa
            else if (caracter=='}') then
                if(vPais) then
                    call agregarPais(continente, tempPais, pobla, tempSaturacion, tempBandera)
                    if(entero_a_cadena(tempSaturacion)>entero_a_cadena(saturacion)) then
                        saturacion=tempSaturacion
                        bandera=tempBandera
                        pais=tempPais
                        poblacion=pobla
                    end if
                    saturacion=tempSaturacion
                end if
            else
                call agregarError(caracter, 'Caracter no reconocido', posF, posC)
            end if

        case(1) !Estado de palabra reservada grafica
            if (caracter>='a' .and. caracter<='z') then
                lexema=lexema//caracter !Concateno el caracter al lexema
            else if (caracter==' ' .or. caracter==char(9) .or. caracter==char(10)) then
                call agregarError(caracter, 'Espacio no esperado', posF, posC)
            else if(trim(lexema)=='grafica') then !Si el lexema es igual a grafica
                call agregarToken(trim(lexema), 'Palabra reservada', posF, posC)
                estado=2
            else if ( trim(lexema)=='continente' ) then
                call agregarToken(trim(lexema),'Palabra reservada', posF, posC)
                estado=3
                vContinente=.true.
                vPais=.false.
            else if (trim(lexema)=='nombre') then
                call agregarToken(trim(lexema),'Palabra reservada', posF, posC)
                estado=2
            else if (trim(lexema)=='pais') then
                call agregarToken(trim(lexema),'Palabra reservada', posF, posC)
                estado=2
                vPais=.true.
            else if (trim(lexema)=='poblacion') then
                call agregarToken(trim(lexema),'Palabra reservada', posF, posC)
                estado=2
            else if (trim(lexema)=='saturacion') then
                call agregarToken(trim(lexema),'Palabra reservada', posF, posC)
                estado=2
            else if (trim(lexema)=='bandera') then
                call agregarToken(trim(lexema),'Palabra reservada', posF, posC)
                estado=2
            else
                call agregarError(lexema,'Palabra reservada no reconocida', posF, posC)
                estado=0
            i=i-1 !Decremento el índice para que vuelva a analizar el caracter actual
            end if
        case(2) !Estado de dos puntos
            if (caracter==':') then !Si el caracter es igual a dos puntos
                if(trim(lexema)=='grafica') then
                    estado=3 !Cambio al estado 3
                else if(trim(lexema)=='nombre') then
                    estado=4 !Cambio al estado 4
                else if (trim(lexema)=='continente') then
                    estado=3 !Cambio al estado 3
                    vContinente=.true.
                else if (trim(lexema)=='pais') then
                    estado=3 !Cambio al estado 3
                    vPais=.true.
                else if (trim(lexema)=='poblacion') then
                    estado=7 !Cambio al estado 7
                    vPoblacion=.true.
                else if (trim(lexema)=='saturacion') then
                    estado=8 !Cambio al estado 8
                    vSaturacion=.true.
                else if (trim(lexema)=='bandera') then
                    estado=4 !Cambio al estado 4
                    vBandera=.true.
                else
                    call agregarError(lexema, 'Palabra reservada no reconocida', posF, posC)
                    estado=0
                end if
                estado=3 !Cambio al estado 3
            else
                call agregarError(caracter,'Se esperaban dos puntos', posF, posC) !Agrego un error
            end if
        case(3) !Estado de llave de apertura
            if (caracter=='{') then !Si el caracter es igual a llave de apertura
                if(trim(lexema)=='grafica') then !Si el lexema es igual a grafica
                    estado=0 !Cambio al estado 0
                else if (trim(lexema)=='continente') then !Si el lexema es igual a continente
                    estado=0 !Cambio al estado 0
                    vContinente=.true.
                else if (trim(lexema)=='pais') then !Si el lexema es igual a pais
                    estado=0 !Cambio al estado 0
                    vPais=.true.
                else if(caracter==' ' .or. caracter==char(9) .or. caracter==char(10)) then
                    cycle !Salto al siguiente ciclo porque ignoro los espacios en blanco
                else
                    call agregarError(lexema,'Palabra reservada no reconocida', posF, posC)
                    estado=3
                end if
            else
                call agregarError(caracter,'Se esperaba llave de apertura', posF, posC) !Agrego un error
            end if

        case(4) !Estado para el inicio de una cadena
            if (caracter=='"') then !Si el caracter es igual a comillas
                Lexema=caracter !Guardo el caracter en el lexema
                estado=5 !Cambio al estado 5
            else if (caracter==' ' .or. caracter==char(9) .or. caracter==char(10)) then
                cycle !Salto al siguiente ciclo porque ignoro los espacios en blanco
            else
                call agregarError(caracter,'Se esperaban comillas', posF, posC) !Agrego un error
            end if
        case(5) !Estado de lectura de cadena
            if (caracter=='"') then
                lexema=lexema//caracter !Concateno el caracter al lexema
                call agregarToken(trim(lexema),'Cadena', posF, posC)
                if (vGrafico) then
                    vGrafico=.false.
                    nGrafica=trim(lexema)
                    vContinente=.true.
                else if (vContinente) then
                    continente=lexema
                    vContinente=.false.
                    vPais=.true.
                else if (vPais) then
                    if (vNombre) then
                        tempPais=trim(lexema)
                        vNombre=.false.
                    else if (vPoblacion) then
                        pobla=trim(lexema)
                        vPoblacion=.false.
                    else if (vSaturacion) then
                        saturacion=trim(lexema)
                        vSaturacion=.false.
                    else if (vBandera) then
                        tempBandera=trim(lexema)
                        vBandera=.false.
                    end if

                end if
                estado=6 !Cambio al estado 6
            else
                lexema=lexema//caracter !Concateno el caracter al lexema
            end if
        case(6) !Estado de punto y coma
            if (caracter==';') then !Si el caracter es igual a punto y coma
                estado=0 !Cambio al estado 0
            else
                call agregarError(caracter,'Se esperaba punto y coma', posF, posC) !Agrego un error
            end if
        case(7) !Estado para la lectura de enteros
            if (caracter>='0' .and. caracter<='9') then
                lexema=trim(lexema)//caracter !Concateno el caracter al lexema
            else if (caracter==';') then
                call agregarToken(trim(lexema),'Entero', posF, posC)
                estado=0
            else if (caracter==' ' .or. caracter==char(9) .or. caracter==char(10)) then
                call agregarError(caracter,'Espacio no esperado', posF, posC)
            else
                call agregarError(caracter,'Se esperaba un entero', posF, posC) !Agrego un error
            end if
        case(8) 
            if (caracter>='0' .and. caracter<='9') then
                lexema=trim(lexema)//caracter !Concateno el caracter al lexema
            else if (caracter=='%') then
                call agregarToken(trim(lexema),'Porcentaje', posF, posC)
                estado=6
            else if (caracter==' ' .or. caracter==char(9) .or. caracter==char(10)) then
                call agregarError(caracter,'Espacio no esperado', posF, posC)
            else
                call agregarError(caracter,'Se esperaba un porcentaje', posF, posC) !Agrego un error
            end if



        end select !Fin del select case




    end do




    end subroutine analizar

subroutine agregarPais(continente, country,population, saturacion, bandera)
    use globales !Se usa el modulo globales
    implicit none
    character(len=50), intent(in) :: continente,country, saturacion, bandera, population
    cuenta3=cuenta3+1
    paises(1,cuenta3)=trim(continente)
    paises(2,cuenta3)=trim(country)
    paises(3,cuenta3)=trim(population)
    paises(4,cuenta3)=trim(saturacion)
    paises(5,cuenta3)=trim(bandera)
end subroutine agregarPais

subroutine agregarToken(lexema, descrip, linea, columna) !Subrutina que agrega los tokens
    use globales !Se usa el modulo globales
    implicit none
    character(len=50), intent(in) :: lexema, descrip
    integer, intent(in) :: linea, columna
    cuenta1=cuenta1+1
    tokens(1,cuenta1)=trim(lexema)
    tokens(2,cuenta1)=trim(descrip)
    tokens(3,cuenta1)=entero_a_cadena(linea)
    tokens(4,cuenta1)=entero_a_cadena(columna)
end subroutine agregarToken

subroutine agregarError(lexema, descrip, linea, columna) !Subrutina que agrega los errores
    use globales !Se usa el modulo globales
    implicit none
    character(len=100), intent(in) :: lexema, descrip
    integer, intent(in) :: linea, columna
    cuenta2=cuenta2+1
    errores(1,cuenta2)=trim(lexema)
    errores(2,cuenta2)=trim(descrip)
    errores(3,cuenta2)=entero_a_cadena(linea)
    errores(4,cuenta2)=entero_a_cadena(columna)
end subroutine agregarError

subroutine leer() !Función para leer el documento temporal
    use globales !Se usa el modulo globales
    implicit none
    character(len=15) :: ruta
    character(len=4000):: tempLinea
    integer :: iostat, posC, posF

    !Inicializo las variables
    contenido=' '
    posC=1
    posF=1
    ruta='herbert.temp' !Asigno la ruta del archivo
    !Abro el archivo
    open(unit=54, file=ruta, status='old', action='read', iostat=iostat) !Abro el archivo para leer
    if(iostat/=0) then !Si no se pudo abrir el archivo
        print *, 'Error al abrir el archivo', ruta !Imprimo un mensaje de error
        stop
    else ! Sino leo el archivo
        do while (.not. is_iostat_end(iostat)) !Mientras que no esté en el final del archivo
            read(54, '(A)', iostat=iostat) tempLinea !Leo cada linea del archivo
            if (iostat==0) then
                contenido(posC:posC+len_trim(tempLinea))=trim(tempLinea)//char(10) !Concateno las lineas
                posC=posC+len_trim(tempLinea)+1 !Aumento la posición en donde termina la linea concatenada
            end if
        end do
    end if
    iostat=0 
    close(54) !Cierro el archivo
    print *, contenido !Imprimo el contenido del archivo
end subroutine leer

subroutine html_bueno() !Subrutina que genera el html con los 
    implicit none
    !Asignación de las variables
    integer :: unit

    unit=2023 !Se asigna un numero de unidad
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
    write(unit, '(A)') "<tr><th>Número de Token</th><th>Lexema</th><th>Descripción</th><th>Línea</th><th>Columna</th></tr>"











    end subroutine html_bueno
!Funcion que convierte un entero a una cadena de caracteres

function entero_a_cadena(entero) result(cadena) 
    implicit none
    !Declaracion de variables
    integer, intent(in) :: entero 
    character(len=10) :: cadena
    
    write(cadena, '(I0)') entero !Se convierte el entero a cadena
end function entero_a_cadena


function cadena_a_entero(cadena) result(entero)
    implicit none
    !Declaracion de variables
    character(len=10), intent(in) :: cadena
    integer :: entero

    read(cadena, '(I10)') entero !Se convierte la cadena a entero
end function cadena_a_entero
end program procesando