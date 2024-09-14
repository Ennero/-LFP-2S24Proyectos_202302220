module globales
    !Aquí declaro las variables globales que usaré
    implicit none
    character(len=100) :: rutaBandera, rutaGrafica, nPais, poblacion
    character(len=50) :: tempPais, tempSaturacion,tempPoblacion,tempContinente,auxPais,auxPoblacion,nGrafica, tempBandera
    integer :: cuenta1, cuenta2,cuenta3,auxSatu,satu,caent
    character(len=30), dimension(4,300)::tokens, errores,paises
    integer, dimension(1:100)::saturaciones
    character(len=4000):: entrada
end module globales

program proceso 
use globales
implicit none
!Inicializo todas las variables que voy a usar
entrada=""
cuenta1=1
cuenta2=1
cuenta3=1

!call leer()
call analizar()


!print *, trim(rutaGrafica)//","//trim(rutaBandera)//","//trim(nPais)//","//trim(poblacion)
end program proceso




subroutine analizar()
use globales
implicit none
character(len=40) :: lexema
character(len=1) :: c
integer:: posF, posC, largo, estado, i
logical :: VContinente, VGrafica, VPaisNombre, VPaisPoblacion, VPaisSaturacion, VPaisBandera ,VPais
!Inicializo las variables
largo=len_trim(entrada)
posF=1
posC=1
satu=100
estado=0
i=0
VContinente=.false.
VGrafica=.false.
VPaisNombre=.false.
VPaisBandera=.false.
VPaisPoblacion=.false.
VPaisSaturacion=.false.
VPais=.false.


!Agrego el caracter de fin de cadena (para saber cuando termina)
entrada(largo+1:largo+1)="#"
largo=largo+1

do while (i<=largo)
    i=i+1
    if(c==char(10)) then !Si es un salto de línea
            posC=0 !Reinicio la posición de la columna
            posF=posF+1 !Aumento la posición de la fila
    end if
    posC=posC+1 !Aumento la posición de la columna
    c=entrada(i:i) !Obtengo el caracter actual
    
    !Comienzo con el selectCase
    select case (estado)
    case(0) !Estado inicial
        if(c>='a' .and. c>='z') then
            lexema=c
            estado=1
        else if(c==' ' .or. c==char(10) .or. c==char(9)) then
            cycle
        else if(c==char(35) .and. i==largo) then
            exit
        else if(c=='}') then
            estado=10
        else

        end if
    case(1) !Estado para la lectura de palabras reservadas
        if(c>='a' .and. c<='z') then
            lexema=lexema//c !Concateno el caracter al lexema
        else
            if(lexema=="grafica") then
            estado=2
            call agregarToken(adjustl(lexema), adjustl("Palabra reservada")//repeat(' ', 83), posF, posC)
            VGrafica=.true.
            else if(lexema=="nombre") then
            estado=2
            call agregarToken(adjustl(lexema), adjustl("Palabra reservada")//repeat(' ', 83), posF, posC)
            else if(lexema=="continente") then
            estado=3
            VContinente=.true.
            call agregarToken(adjustl(lexema), adjustl("Palabra reservada")//repeat(' ', 83), posF, posC)
            else if (lexema=="pais") then
            estado=2
            !Aquí solo me aseguro de que sean negativas
            VContinente=.false.
            VGrafica=.false.
            VPais=.true.
            call agregarToken(adjustl(lexema), adjustl("Palabra reservada")//repeat(' ', 83), posF, posC)
            else if (lexema=="poblacion") then
            estado=2
            call agregarToken(adjustl(lexema), adjustl("Palabra reservada")//repeat(' ', 83), posF, posC)
            else if (lexema=="saturacion") then
            estado=2
            call agregarToken(adjustl(lexema), adjustl("Palabra reservada")//repeat(' ', 83), posF, posC)
            else if (lexema=="bandera") then
            estado=2
            call agregarToken(adjustl(lexema), adjustl("Palabra reservada")//repeat(' ', 83), posF, posC)




            !DSIFHASDNFKASDGCFGNSKFNGKDSGFGNdfsdfsdfsdfsdfCASNDFSA poR AQUÍ VOY
            else
                call agregarError(adjustl(lexema), "Palabra reservada no válida"//repeat(' ', 81), posF, posC)
                estado=0
            end if
            i=i-1
        end if
    case(2) !Para cuando aparecen los dos puntos
        if(c==':') then
            if(lexema=="grafica") then
                estado=3
            else if (lexema=="nombre") then
                estado=4
                if (VPais) then
                    VPaisNombre=.true.
                end if
            else if (lexema=="continente") then
                estado=3
            else if (lexema=="pais") then
                estado=3
            else if (lexema=="poblacion") then
                estado=7
                if (VPais) then
                    VPaisPoblacion=.true.
                end if
            else if (lexema=="saturacion") then
                estado=7
                if (VPais) then
                    VPaisSaturacion=.true.
                end if
            else if (lexema=="bandera") then
                estado=4
                if (VPais) then
                    VPaisBandera=.true.
                end if
            else
                call agregarError(adjustl(lexema), "Palabra reservada no válida"//repeat(' ', 81), posF, posC)
            end if



        else if (c==' ' .or. c==char(9) .or. c==char(10)) then
            cycle
        else
            call agregarError(adjustl(c), "Caracter no válido"//repeat(' ', 81), posF, posC)
        end if
    case(3) !Para cuando aparezca una llave de aparertura
        if (c=='{') then
            estado=0 !Lo paso al estado inicial porque va a leer una reservada
        else if (c==' ' .or. c==char(9) .or. c==char(10)) then
            cycle
        else
            call agregarError(adjustl(c), "Caracter no válido"//repeat(' ', 81), posF, posC)
        end if
    case(4) !Para cuando se comienza a leer un string
        if (c=='"') then
            estado=5
            lexema=""
        else if (c==' ' .or. c==char(9) .or. c==char(10)) then
            cycle
        else
            call agregarError(adjustl(c), "Caracter no válido"//repeat(' ', 81), posF, posC)
        end if
    case(5) !Para cuando se lee un string
        if(c=='"') then
            if (VGrafica) then
                nGrafica=lexema
                call agregarToken('"'//adjustl(lexema)//'"', adjustl("Cadena")//repeat(' ', 81), posF, posC)
                estado=6
                VGrafica=.false.
            end if
            if (VPais) then
                tempPais=lexema
                if (VPaisNombre) then
                    tempPais=lexema
                    VPaisNombre=.false.
                end if
                call agregarToken('"'//adjustl(lexema)//'"', adjustl("Cadena")//repeat(' ', 81), posF, posC)
                estado=6

                
            end if
            if (VContinente) then
                tempContinente=lexema
                call agregarToken('"'//adjustl(lexema)//'"', adjustl("Cadena")//repeat(' ', 81), posF, posC)
                estado=6
                VContinente=.false.
            end if
            if (VPaisBandera) then
                tempBandera=lexema
                call agregarToken('"'//adjustl(lexema)//'"', adjustl("Cadena")//repeat(' ', 81), posF, posC)
                VPaisBandera=.false.
                estado=6
            end if






        else
            lexema=lexema//c
        end if
    case(6) !Para cuando se lee un punto y coma
        if(c==';') then
            estado=0
        else if (c==' ' .or. c==char(9) .or. c==char(10)) then
            cycle
        else
            call agregarError(adjustl(c), "Caracter no válido"//repeat(' ', 81), posF, posC)
        end if
    case(7) !Para cuando se inicia a leer un número
        if(c>='0' .and. c<='9') then
            lexema=c
            estado=8
        else if (c==' ' .or. c==char(9) .or. c==char(10)) then
            cycle
        else
            call agregarError(adjustl(c), "Caracter no válido"//repeat(' ', 81), posF, posC)
        end if
    case(8) !Para cuando se lee un número
        if(c>='0' .and. c<='9') then
            lexema=lexema//c
        else 
            i=i-1

            call agregarToken(adjustl(lexema), adjustl("Número")//repeat(' ', 83), posF, posC)
            if (VPaisPoblacion) then
                tempPoblacion=lexema
                VPaisPoblacion=.false.
                estado=6
            end if
            if (VPaisSaturacion) then
                tempSaturacion=lexema
                VPaisSaturacion=.false.
                estado=9
            end if
        end if
    case(9) !Para cuando se lee un %
        if(c=='%') then
            estado=6
        else if (c==' ' .or. c==char(9) .or. c==char(10)) then
            cycle
        else
            call agregarError(adjustl(c), "Caracter no válido"//repeat(' ', 81), posF, posC)
        end if
    case(10) !Para cuando se lee un }
        if(c==char(35)) then
            exit
        else if (c==' ' .or. c==char(9) .or. c==char(10)) then
            cycle
        else if (c>='a' .and. c<='z') then
            if(VPais) then
            read(tempSaturacion,*) auxSatu
            call agregarPais(tempContinente,tempPais,tempPoblacion,auxSatu,tempBandera)
            if(auxSatu>satu) then
                satu=auxSatu
                nPais=tempPais
                poblacion=tempPoblacion
                rutaBandera=tempBandera
            end if
            estado=0
            end if
            i=i-1
        else if (c=='}') then
            estado=0
            VPais=.false.
            VContinente=.true.
        else
            call agregarError(adjustl(c), "Caracter no válido"//repeat(' ', 81), posF, posC)
        end if







    end select



end do




end subroutine analizar


subroutine agregarPais(conti, pai, po, sar,ba)
    use globales
    implicit none
    character(len=100) :: conti, pai, po,ba
    integer :: sar
    cuenta3=cuenta3+1
    paises(1,cuenta3)=trim(conti)
    paises(2,cuenta3)=trim(pai)
    paises(3,cuenta3)=trim(po)
    saturaciones(cuenta3)=sar
    paises(4,cuenta3)=trim(ba)
end subroutine agregarPais

subroutine agregarError(lexema, descrip, linea, columna) !Subrutina que agrega los errores
    use globales !Se usa el modulo globales
    implicit none
    character(len=100) :: lexema, descrip, linea2,columna2
    integer :: linea, columna
    cuenta2=cuenta2+1
    errores(1,cuenta2)=trim(lexema)
    errores(2,cuenta2)=trim(descrip)
    write(linea2,*) linea !Probar nuevamente la forma en la que escribo estas cosas porque ODIO FORTRAAAAAN
    write(columna2,*) columna
    errores(3,cuenta2)=trim(linea2)
    errores(4,cuenta2)=trim(columna2)
end subroutine agregarError

subroutine agregarToken(lexema, descrip, linea, columna) !Subrutina que agrega los tokens
    use globales !Se usa el modulo globales
    implicit none
    character(len=100) :: lexema, descrip, linea2,columna2 !Se declaran las variables
    integer :: linea, columna
    cuenta1=cuenta1+1
    tokens(1,cuenta1)=trim(lexema)
    tokens(2,cuenta1)=trim(descrip)
    write(linea2,*) linea !Lo transfora a string
    write(columna2,*) columna !Lo transforma a string
    tokens(3,cuenta1)=trim(linea2)
    tokens(4,cuenta1)=trim(columna2)
end subroutine agregarToken

subroutine html_bueno() !Subrutina que genera el html con los tokens encontrados
    use globales
    implicit none
    !Asignación de las variables
    integer :: unit,i

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
    do i=1,cuenta1
        write(unit, '(A)') "<tr>"
        write(unit, '(A)') "<td>"//trim(tokens(1,i))//"</td>"
        write(unit, '(A)') "<td>"//trim(tokens(2,i))//"</td>"
        write(unit, '(A)') "<td>"//trim(tokens(3,i))//"</td>"
        write(unit, '(A)') "<td>"//trim(tokens(4,i))//"</td>"
        write(unit, '(A)') "</tr>"
    end do










end subroutine html_bueno

subroutine leer() !Lee el archivo de entrada enviado por phyton
    use globales
    do
        read(*, '(A)', iostat = ios) linea
        if (ios /= 0) exit   ! Se alcanzo el fin del archivo
        entrada = trim(entrada) // trim(linea) // char(10) ! Concatenar la línea leida al valor de entrada y agregar un salto de línea
    end do

end subroutine leer

integer function caent(cadena) result(entero) !Convierte una cadena a entero
    character(len=*) :: cadena
    read(cadena,*) entero
end function caent
