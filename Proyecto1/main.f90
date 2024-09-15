module globales
    !Aquí declaro las variables globales que usaré
    implicit none
    character(len=100) :: rutaBandera, rutaGrafica, nPais, poblacion
    character(len=50) :: tempPais, tempSaturacion,tempPoblacion,tempContinente,auxPais,auxPoblacion,nGrafica, tempBandera
    integer :: cuentaT, cuentaE,cuentaP,auxSatu,satu,caent
    character(len=30), dimension(4,500)::tokens, errores,paises
    !La estructura de pais será: continente / nombre / población / bandera
    integer, dimension(1:500)::saturaciones
    character(len=4000):: entrada
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

call agregarToken(adjustl("grafica")//repeat(' ', 30-len_trim("grafica")), adjustl("Palabra reservada")//repeat(' ', 30-len_trim("Palabra reservada")), 1, 1)
!call analizar()

if (error) then !Si hay errores
    call html_malo() !Llamo a la subrutina que genera el html con los errores
else !Si no hay errores
    call html_bueno() !Llamo a la subrutina que genera el html con los tokens
end if

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
    write(columna2,'(I0)') columna
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
    print *, lexema, descrip, linea, columna
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
