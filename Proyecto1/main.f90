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
character(len=200) :: linea
integer :: ios
!Inicializo todas las variables que voy a usar
entrada=""
cuenta1=1
cuenta2=1
cuenta3=1

!PROBANDOOOOOOO
open(10, file='entrada.org', status='old', action='read') !Abro el archivo de entrada
do
read(10, '(A)', iostat = ios) linea
if (ios /= 0) exit   ! Se alcanzo el fin del archivo
entrada = trim(entrada) // trim(linea) // char(10) ! Concatenar la línea leida al valor de entrada y agregar un salto de línea
end do
!PROBANDOOOOOOO

call analizar()
call html_bueno()

!print *, trim(rutaGrafica)//","//trim(rutaBandera)//","//trim(nPais)//","//trim(poblacion)
end program proceso




subroutine analizar()
use globales
implicit none
character(len=40) :: lexema
character(len=1) :: c
integer:: posF, posC, largo, estado, i
logical :: VContinente, VGrafica, VPaisNombre, VPaisPoblacion, VPaisSaturacion, VPaisBandera ,VPais,VEspacio
!Inicializo las variables
largo=len_trim(entrada)
posF=1
posC=1
satu=100
estado=0
i=0
VEspacio=.false.
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
    write(linea2,'(I0)') linea !Probar nuevamente la forma en la que escribo estas cosas porque ODIO FORTRAAAAAN
    write(columna2,'(I0)') columna
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
    write(linea2,'(I0)') linea !Lo transfora a string
    write(columna2,'(I0)') columna !Lo transforma a string
    tokens(3,cuenta1)=trim(linea2)
    tokens(4,cuenta1)=trim(columna2)
end subroutine agregarToken

subroutine html_bueno() !Subrutina que genera el html con los tokens encontrados
    use globales
    implicit none
    !Asigno las variables
    integer :: unit,i
    character(len=100) :: cuento
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
    do i=1,cuenta1
        write(cuento,'(I0)') i
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
    character(len=100) :: cuento
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
    do i=1,cuenta1
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
