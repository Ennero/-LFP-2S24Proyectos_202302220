program procesando
    implicit none
    character(len=100) :: rutaBandera, rutaGrafica, pais
    integer :: poblacion








    
    !Imprimo los resultados delimitados por una coma para que los lea phyton
    print *, rutaGrafica,',',rutaBandera,',', pais, ',', entero_a_cadena(poblacion)
contains




!Funcion que convierte un entero a una cadena de caracteres
function entero_a_cadena(entero) result(cadena) 
    implicit none
    !Declaracion de variables
    integer, intent(in) :: entero 
    character(len=10) :: cadena
    
    write(cadena, '(I0)') entero !Se convierte el entero a cadena
end function entero_a_cadena
end program procesando
