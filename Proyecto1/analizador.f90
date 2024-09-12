module globales
    implicit none
    character(len=100) :: rutaBandera, rutaGrafica, pais
    integer :: poblacion,cuenta1,cuenta2
    character(len=4000) :: contenido
    character(len=30), dimension(4,200) :: tokens, errores
    
end module globales

program procesando
    use globales !Se usa el modulo globales
    implicit none
    cuenta1=0
    cuenta2=0
    call leer() !Se llama a la subrutina que lee el archivo
    call analizar() !Se llama a la subrutina que analiza el archivo




    !call html_bueno() !Se llama a la subrutina que genera el html
    !Imprimo los resultados delimitados por una coma para que los lea phyton
    !print *, rutaGrafica,',',rutaBandera,',', pais, ',', entero_a_cadena(poblacion)
contains




subroutine analizar()
    use globales !Se usa el modulo globales
    !Declaro las variables
    character(len=4000) :: buffer
    integer :: posF, posC, largo, estado, indice,i
    character(len=50) :: lexema
    character(len=1):: caracter

    !Inicializo las variables
    largo=len_trim(contenido)
    buffer=''
    lexema= ''
    indice=1
    estado=0
    i=0
    posF=1
    posC=0

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
        print *, caracter !Solo quiero saber si sí va de caracter en caracter
        select case (estado)
        case(0) !Estado inicial
            if (caracter>= 'a' .and. caracter<= 'z') then
                estado=1
                lexema=caracter !Guardo el caracter en el lexema
            else if (caracter=='"') then
                estado=2
                lexema=caracter !Guardo el caracter en el lexema
            else if (caracter==' ' .or. caracter==char(9) .or. caracter==char(10)) then
                cycle !Salto al siguiente ciclo porque ignoro los espacios en blanco
            else if (caracter==':') then
                estado=3

            else if (caracter==char(35) .and. i==largo) then
                !Aquí termino mi programa
            else
                !Aquí hago el manejo de mis erroreeeeeees
            end if

        case(1) !Estado de palabras reservadas
            if (caracter>='a' .and. caracter<='z') then
                lexema=trim(lexema)//caracter !Concateno el caracter al lexema
            else
                if(trim(lexema)=='grafica') then !Si el lexema es igual a grafica
                    call agregarToken(lexema, 'Palabra reservada'//repeat(' ', 33), posF, posC)
                    estado=2
                else
                    call agregarError(lexema, 'Palabra reservada no reconocida', posF, posC)
                    estado=0
                end if
                i=i-1 !Decremento el índice para que vuelva a analizar el caracter actual
            end if
        case(2) !Estado cuando ya se tiene la palabra reservada grafica
            if (caracter==':') then !Si el caracter es igual a dos puntos
                estado=3 !Cambio al estado 3
            else
                call agregarError(caracter, 'Se esperaban dos puntos', posF, posC) !Agrego un error
            end if

        case(3) !Estado de cadena
            if (caracter=='"') then !Si el caracter es igual a comillas
                estado=0 !Cambio al estado 0
                call agregarToken(lexema, 'Cadena', posF, posC) !Agrego el token de la cadena
            else
                lexema=lexema//caracter !Concateno el caracter al lexema
            end if
        case(4) !Estado de dos puntos



        end select !Fin del select case




    end do




    end subroutine analizar

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

subroutine leer()
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
end program procesando
