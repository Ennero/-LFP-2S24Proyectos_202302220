program procesando
    implicit none
    character(len=100) :: rutaBandera, rutaGrafica, pais
    integer :: poblacion








    call html_bueno() !Se llama a la subrutina que genera el html
    !Imprimo los resultados delimitados por una coma para que los lea phyton
    print *, rutaGrafica,',',rutaBandera,',', pais, ',', entero_a_cadena(poblacion)
contains



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
