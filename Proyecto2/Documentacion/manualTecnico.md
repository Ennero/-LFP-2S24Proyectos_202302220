# Manual Técnico - Proyecto 2
## Objetivos
### Objetivo General
- Proporcionar una explicación detallado sobre la manera en la que se creó el programa y su compilador
### Objetivos Específicos
- Presentar y explicar el funcionamiento del código utilizado para la solución creada
- Presentar el arbol utilizado para la creación del autómata 

## Alcances del Sistema
Este manual se creó con la finalidad de permitir entender cómo se realizaron las soluciones del programa y como estas funcionan en conjunto dentro del mismo para cumplir con el proposito del este.
Se pretende propiciar el conocimiento requerido para que se pueda replicar el compilador de ser requerido.

## Especificaciones técnicas
### Requisitos de Hardware
- Procesador con arquitectura x86
- Memoria RAM de 1GB
- Espacio libre en el disco duro de 2GB
- Pantalla
- Teclado (opcional)
### Requisitos de Software 
- Sistema Operativo compatible con Fortran y Python
- Editor de texto compatible con Fortran
- Compilador de Fortran (GNU Fortran, Intel Fortran Compiles, etc)
## Lógica y descripción de la solución
### Calculo del Autómata
Antes de realizar el cálculo del autómata, se creó una expresión regular que se replicaría en el aútomata finito determinsta.

![Expresión Regular](./img/expresion.png)

Utilizando esta expresión regular se creó el arbol para posteriormente realizar los cálculos.

![Arbol](./img/arbol.png)

Teniendo ya el árbol, se realizó el cálculo de los siguiente de cada nodo hoja.

![Siguientes](./img/siguientes.png)

Con la tabla de siguiente se concluyó con los cálculos hallando cada uno de los estados

![Calculos](./img/Calculos.png)

Por último, simplemente se armó el autómata con todo lo obtenido.

![Automata](./img/automata.png)

Apesar de ya tener el autómata realizado, se decidió optimizarlos un poco debido a que tenía ambigüedad en la definición de los comentarios, por lo que se unieron los estados S3 y S4 dándonos el siguiente autómata.

![Automata](./img/automatabueno.png)

### Creación de la gramática

Así como se creó previamente el automata para poder implementarlo en el análisis léxico, se implemento una gramática para poder utilizarla en para la creación del análisis sintáctico con BNF:


```
G = {E, N, I, P} donde:
E = { Controles, Propiedades, Colocacion, Etiqueta, Boton, Check, RadioBoton, Texto, AreaTexto, Clave, Contenedor, setColorLetra, setAncho, setAlto, setTexto, setColorFondo, setAlineacion, setMarcado, setGrupo, add, setPosicion, this, ID, ;, ., (, ), ,, Numero, true, false, Cadena, <!--, --> }
N = { Block1, ControlLista, Control, TIPO_Control, Block2, PropiedadesLista, Propiedad, Funcion, Alineado, Bool, Block3, colocacionLista, Colocacion, Colocado, Colocar }
I = S
P = {
    S ::= Block1 Block2 Block3

    Block1 ::= '<!--' 'Controles' ControlLista 'Controles' '-->'
    ControlLista ::= Control ControlLista | ε
    Control ::= TIPO_Control ID ';' | COMENTARIO
    TIPO_Control ::= 'Etiqueta' | 'Boton' | 'Check' | 'RadioBoton' | 'Texto' | 'AreaTexto' | 'Clave' | 'Contenedor'

    Block2 ::= '<!--' 'Propiedades' PropiedadesLista 'Propiedades' '-->'
    PropiedadesLista ::= Propiedad PropiedadesLista | ε
    Propiedad ::= ID '.' Funcion ';' | COMENTARIO
    Funcion ::= 'setColorLetra' '(' Numero ',' Numero ',' Numero ',' ')' | 'setAncho' '(' Numero ')' | 'setAlto' '(' Numero ')' | 'setTexto' '(' Cadena ')' | 'setColorFondo' '(' Numero ',' Numero ',' Numero ')' | 'setAlineacion' '(' Alineado ')' | 'setMarcado' '(' Booleano ')' | 'setGrupo' '(' ID ')'
    Alineado ::= 'centro' | 'izquierdo' | 'derecho'
    Booleano ::= 'true' | 'false'

    Block3 ::= '<!--' 'Colocacion' colocacionLista 'Colocacion' '-->'
    colocacionLista ::= Colocacion colocacionLista | ε
    Colocacion ::= ID '.' Colocar ';' | 'this' '.' '(' ID ')' ';' | COMENTARIO
    Colocar ::= 'setPosicion' '(' Numero ',' Numero ')' | 'add' '(' ID ')'
}
```

## Lógica de la Descripción



### Interfaz gráfica
La interfaz gráfica de este proyecto 2 se creó utilizando la librería *tkinter*

**Creación de opciones de guardar, guardar como, salir, abrir y nuevo**
Para la creación de estas funciones se usaron botones que simplemente se dispondrian dentro de un *frame*
```python
#Creación del botón para nuevo
nuevo = tk.Button(contenedor, text="Nuevo", height="1", width="11", command=nuevar)
nuevo.pack(side="left")
nuevo.config(background="white", foreground="black", font=("Arial", 10, "bold"))

#Creación del botón para abrir
abrir = tk.Button(contenedor, text="Abrir", height="1", width="11", command=abro)
abrir.pack(side="right")
abrir.config(background="white", foreground="black", font=("Arial", 10, "bold"))

#Creación del botón para guardar
guardo = tk.Button(contenedor, text="Guardar", height="1", width="11", command=guardar)
guardo.pack()
guardo.config(background="white", foreground="black", font=("Arial", 10, "bold"))

#Creación del botón para guardar como
guardoComo = tk.Button(contenedor, text="Guardar como", height="1", width="11", command=guardarComo)
guardoComo.pack()
guardoComo.config(background="white", foreground="black", font=("Arial", 10, "bold"))

#Creación del botón para salir
salir= tk.Button(frame4, text="Salir", height="1", width="9", command=ventana.quit)
salir.pack(side="bottom")
salir.config(background="white", foreground="red", font=("Arial", 13, "bold"))
```
Y se crearón funciones que realizarían cada una de estas acciones (a excepción de una función para salir)
```python
    def abro(): #Función para abrir un archivo
    def guardar(): #Función para guardar el archivo
    def guardarComo(): #Función para guardar el archivo como
    def nuevar(): #Función para empezar un archivo nuevo
```

**Posición del puntero**
En este proyecto era necesario que en un label se mostrara la posición del puntero, por lo que se creo mediante la siguiente función

```python
    def posicion(event):
    x, y = event.x, event.y
    pos.config(text=f"x={x}, y={y}")
```
La cual se vinculo a toda la ventana, esto para saber siempre el la posición del mouse con respecto a cada uno de los *frames*

```python
    ventana.bind("<Motion>", posicion) 
```

**Muestra de Tokens**

Para realizar esto, durante el análisis en fortran, se crea una tabla de tokens en formato html y al pulsar esta opción, se muestra todo de manera correcta abriendolo en el navegador.
```python
    def tokens(): #Función para mostrar los tokens
    global analizado
    if analizado:

        webbrowser.open("tablaTokens.html")
        info.config(text="Mostrando tokens", foreground="green")
    else:
        messagebox.showerror("Error", "Primero se debe ejecutar el análisis exitosamente")
        info.config(text="Falta de análisis exitoso", foreground="red")
```


**Lectura para creación de la tabla y envío de la salida de Fortran**

Para comenzar con el análisis mediante el frontend se creó una función que abriría el ejecutable creado mediante fortran y enviaría la información del editor de texto mediante la consola, posteriormente el programa de fortan respondería y regresaria valores que procesaria phyton para generar la tabla de erroes, en caso de que hubera uno.

```python
    # Función para analizar el texto
    def analizar(): 
        atos=entrada.get("1.0","end-1c")
        resultado=subprocess.run(['./main.exe'],input=datos, stdout=subprocess.PIPE,text=True)
        salida=resultado.stdout.strip() #Aquí obtengo la salida del análisis
        if (salida=="Bien"):
            messagebox.showinfo("Análisis", "El análisis se realizó correctamente.")
            info.config(text="Análisis correcto", foreground="green") #Mensaje de éxito
            analizado=True
        else:
            messagebox.showerror("Error", "Error durante el análisis")
            info.config(text="Análisis Fallido", foreground="red")
            analizado=False
            partes=salida.split("\n")
            print(len(partes))
            print("+++++++++++++++++++++++++++++++++++++++++++++++++++++")
            temporadita=0
            otro=0
            v=0
            while temporadita<len(partes)/5:
                fila=[]
                v=0
                fila.append(temporadita+1)
                while v<5:
                    fila.append(partes[otro])
                    otro=otro+1
                    v+=1
                temporadita+=1
                arbol.insert("", "end", values=fila)
```

Y la tabla fue creada usando Treeview de tkinter
```python
#Creación de la tabla de errores ----------------------------------------------
arbol=tkk.Treeview(frame2, columns=("No. Error","Tipo","Linea","Columna","Token","Descripción"), show="headings")
arbol.pack(side="left") #Lo empaqueto en el frame2
#Encabezados
arbol.heading("No. Error", text="No. Error")
arbol.heading("Tipo", text="Tipo")
arbol.heading("Linea", text="Linea")
arbol.heading("Columna", text="Columna")
arbol.heading("Token", text="Token")
arbol.heading("Descripción", text="Descripción")

#Las scrollbar de la tabla
barraX=tk.Scrollbar(frame2, orient="vertical", command=arbol.yview)
barraX.pack(side="right", fill="y")
arbol.config(yscrollcommand=barraX.set)
```

### Análisis

El análisis se realizó mediante fortran e inicia con la creación de un módulo que contendrá cada una de las variables que se estarán usando de manera global

```fortran
module globales
!Aquí ando declarando las variables globales que usaré
    character(len=15000)::entrada,texto
    integer::cuentaT, cuentaN, cuentaE, cuentaCT, cuentaConsumo, cuentaES,sizeObjetos,temporal
    character(len=200), dimension(4,2000)::tokens,erroresLexicos,copiaTokens,erroresSintacticos
    character(len=200), dimension(1,2000)::terminales
    logical::eLexico, eSintactico, controlValido, propiedadValida, colocacionValida, ErrorValidado, exepcion1, recuperado,bien

    !Arreglo para almacenar los objetos con la siguiente estructura
    !   1     2          3       4   5   6        7       8   9  10    11         12         13        14     15      16       17     18   19  20...
    ! | ID | Tipo | ColorLetra | 0 | 0 | 0 | ColorFondo | 0 | 0 | 0 | Texto | Alineacion | Marcado | Grupo | Ancho | Alto | Posicion | x | y | Add
    
    character(len=200), dimension(50,200)::objetos,copiaObjetos
end module globales
```
Una vez se tiene todo el módulo, se ejecuta un main en el cual se coloca en orden cada una de las subrutinas de manera secuencial para ejecutar el programa correctamente

```fortran 
program proceso
    use globales
    implicit none
    integer::ta,tata,tio,herberth

    !Inicializando variables
    cuentaT=0
    cuentaN=0
    cuentaE=0
    cuentaCT=0
    cuentaConsumo=0
    cuentaES=0
    ta=1
    tata=1
    bien=.true.

    /Aquí hay más codigo de cada una de las subrutinas usadas
    entrada = '' !Inicializo la variable entrada

        call html_malo()

    if (bien) then
        print *, "Bien"
    else
        !Ciclo para escribir los errores léxicos
        tio=1
        do while (tio<=cuentaE)
            print *, 'Error Lexico',char(10),trim(erroresLexicos(1,tio)),char(10),trim(erroresLexicos(2,tio)), char(10),trim(erroresLexicos(3,tio)), char(10),trim(erroresLexicos(4,tio))
            tio=tio+1
        end do
        
        !Ciclo para escribir los errores sintácticos
        herberth=1
        do while(herberth<=cuentaES)
            print *, 'Error Sintactico',char(10),trim(erroresSintacticos(1,herberth)),char(10),trim(erroresSintacticos(2,herberth)), char(10),trim(erroresSintacticos(3,herberth)), char(10),trim(erroresSintacticos(4,herberth))
            herberth=herberth+1
        end do
    end if
end program proceso
```

**Lectura de la información de Python**

Para la lectura de la información a partir de lo enviada con la interfaz gráfica con python, se creó una subrutina que leería la información enviada a partir de la consola y se almacenaria dentro de un string que seria el que, posteriormente, sería analizado.

```fortran
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
```


**Análisis Léxico**

Para la creación del análisis léxico, se implementó el autómata creado previamente con el método del árbol con estados

```fortran 
subroutine analizar()
    use globales
    implicit none

    !Agrego el caracter del final 
    entrada(largo+1:largo+1)="#"
    largo=largo+1
    do while (i<=largo)
    do while (i<=largo)
        i=i+1 !Aumento la posición del caracter
        posC=posC+1 !Aumento la posición de la columna
        c=entrada(i:i) !Tomo el caracter de la posición
        !Comienzo con el automata
        select case (estado)
            !Todos los estados del autómata
            !.
            !.
            !.
        end select
    end do
end subroutine analizar
```

Como se puede observa, para este análisis, se agregó como último caracter el *#* para que se puediera distinguir cuando era el final del código y se fue recorriendo letra por letra.

Ahora bien, se fue analizando pero también era necesario que se pudiera guardar toda la información de los tokens o de los errores, si es que lo hubiera. Por tal motivo se crearon subrutinas que se llamaran para cada uno de los casos descritos.

```fortran 
subroutine agregarToken(lexema, descrip, linea, columna) !Subrutina que agrega los tokens
    use globales !Se usa el modulo globales
    implicit none
    character(len=200) :: lexema, descrip, linea2,columna2 !Se declaran las variables
    integer :: linea, columna
    cuentaT=cuentaT+1
    tokens(1,cuentaT)=(lexema)
    tokens(2,cuentaT)=(descrip)

    !Creo la copia de los tokens
    copiaTokens(1,cuentaT)=(lexema)
    copiaTokens(2,cuentaT)=(descrip)
    write(linea2,'(I0)') linea !Lo transfora a string
    write(columna2,'(I0)') columna !Lo transforma a string
    tokens(3,cuentaT)=(linea2)
    tokens(4,cuentaT)=(columna2)

    !Creo la copia de los tokesn (parte 2)
    copiaTokens(3,cuentaT)=(linea2)
    copiaTokens(4,cuentaT)=(columna2)
end subroutine agregarToken

subroutine agregarTerminal(terminal) !Subrutina que agrega los terminales
    use globales !Se usa el modulo globales
    implicit none
    character(len=200) :: terminal !Se declara la variable
    cuentaCT=cuentaCT+1
    terminales(1,cuentaCT)=terminal
end subroutine agregarTerminal
```

Por último, una vez con todo almacenado dentro de los arreglo, en el caso de que todo esté correcto, se generará una tabla en HTML con todos los tokens obtenido, que posteriormente se abrirá cuando se llame la función en la interfaz gráfica.

```fortran 
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

```


**Análisis Sintáctico**






**Creación de los archivos CSS y HTML**

Durante todo el procedimiento del analizador sintáctico, simplemente se verifico que todo siguiera el orden establecido, ahora que esto ya está establecido, se realizaron la subrutinas para crear los archivos CSS y HTML de la página.

Primero se organizaron todos los elemento a partir de los tokens obtenidos durante el análisis léxico dentro de un matriz que se puede observar dentro del módulo de globales, asignando una fila para cada componente y en cada columna de cada fila, los distintos atributos de cada componente

```fortran 
subroutine crearObjetos()
    use globales
    implicit none
    integer :: i,j, colocacionLength, propiedadesLength, controlesLength, bi,k,p

    !Todo el código para almacenar la información
    !.
    !.
    !.
end subroutine crearObjeto()
```

Teniendo todos lo elemento clasificados y ordenados para una recolección de los datos más simple, se comienza con la creación de los archivos.

Para crear el archivo CSS, se creó la subrutina que tomaria todo lo que se puede modificar con un archivos CSS dentro de un HTML, se copio la lista para luego trabajar con ella con los HTML, y se colocó su respectivo ID

```fortran 
subroutine crearCSS()
    use globales
    implicit none
    integer :: unit ,i,j
        !character(len=4) :: cuento
        unit=305320 !Se asigna un numero de unidad
    i=1
    open(unit, file='page/estilos.css', status='unknown', action='write') !Se abre el archivo para escribir
    !Código para la creación del CSS
    !.
    !.
    !.
    close (unit)
    print *,"sdfjaskdfjskldfjaklsdjfjsadjfajsdklfjasdf"
    print *, copiaObjetos(11,5)
end subroutine crearCSS
```

Por último se creó el archivo HTML con tres subrutinas, una para inicializar la contrucción del HTML y otra para crear el body, la cual llamaria a la última subrutina que seria recursiva ya que, si fuera necesario, se llamaría a sí misma para poder crear un elemento dentro de un contenedor

```fortran 
    subroutine crearHTML()
        use globales
        implicit none
        !Asigno las variables
        integer :: unit !,i
        texto=""
        !character(len=4) :: cuento
        unit=30530 !Se asigna un numero de unidad
        open(unit, file='page/pagina.html', status='unknown', action='write') !Se abre el archivo para escribir
        write(unit, '(A)') "<!DOCTYPE html>"
        write(unit, '(A)') "<html>"
        write(unit, '(A)') "<head>"
        write(unit, '(A)') '<meta charset="UTF-8">'
        write(unit, '(A)') "<title>Página Web</title>"
        write(unit, '(A)') "<link rel='stylesheet' type='text/css' href='estilos.css'>"
        write(unit, '(A)') "</head>"
        call contenido()
        write(unit, '(A)') texto    
        write(unit, '(A)') "</html>"
        close(unit)
    end subroutine crearHTML

    subroutine contenido()
        use globales
        implicit none
        integer :: i,j,k
        character(len=200) :: previous
        
        i=1
        j=1
        do while (i<=sizeObjetos)
            if (trim(copiaObjetos(1,i))=="this") then
                k=0
                copiaObjetos(1,i)=" "
                texto=trim(texto)//'<body>'
                do while (trim(copiaObjetos(20+k,i)) /= " ")
                    print *, "aqui va un ADD"
                    previous=trim(copiaObjetos(20+k,i))
                    call div(previous)
                    k=k+1
                end do
                texto=trim(texto)//'</body>'
            end if
            i=i+1
        end do
    end subroutine contenido

    recursive subroutine div(previous)
        use globales
        implicit none
        integer :: i,j,k
        character(len=200) :: previous
        print *, previous
        i=1
        j=1
        do while (i<=sizeObjetos)
            !Código similar al de la subrutina contenido() pero con más condicionales para cada uno de los elementos
            i=i+1
        end do
    end subroutine div
```
