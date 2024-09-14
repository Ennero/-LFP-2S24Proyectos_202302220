module globales
    !Aquí declaro las variables globales que usaré
    implicit none
    character(len=100) :: rutaBandera, rutaGrafica, nPais, poblacion
    integer :: cuenta1, cuenta2,cuenta3
    character(len=30), dimension(4,300)::tokens, errores
    character(len=30), dimension(5:100)::paises
    character(len=4000):: entrada, linea
end module globales

program proceso 
use globales
implicit none
entrada=""
call leer()



!print *, trim(rutaGrafica)//","//trim(rutaBandera)//","//trim(nPais)//","//trim(poblacion)
end program proceso

subroutine leer() !Lee el archivo de entrada enviado por phyton
    use globales
    do
        read(*, '(A)', iostat = ios) linea
        if (ios /= 0) exit   ! Se alcanzo el fin del archivo
        entrada = trim(entrada) // trim(linea) // char(10) ! Concatenar la línea leida al valor de entrada y agregar un salto de línea
    end do

end subroutine leer

function itoa(i) result(str) !Convierte un entero a un string
    implicit none
    integer, intent(in) :: i
    character(len=12) :: str
    write(str, '(I0)') i
end function itoa
