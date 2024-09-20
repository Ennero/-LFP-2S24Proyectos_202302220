import tkinter as tk
from tkinter import messagebox
from tkinter import PhotoImage
from tkinter import filedialog
import subprocess

#Declarando mis variables globales
poblacion="NA"
pais="NA"
ruta=""
rutaGrafica="C:/banderas/nono.png"
rutaBandera="C:/banderas/nono.png"
guardado=False


def acerca_de(): #Función para mostrar la información del autor (la mia)
    messagebox.showinfo("Acerca de","Nombre: Enner Esaí Mendizabal Castro; Carné: 202302220; Curso: Lenguajes Formales y de Programación; Sección: B+")

def abrir():
    global ruta, guardado #Uso las variables globales
    info.config(text="Abriendo archivo...", foreground="black") #Mensaje que dice el proceso
    ruta=filedialog.askopenfilename(title="Abrir archivo", filetypes=(("Archivos .ORG", "*.org"),)) #Solo acepta archivos .org
    if ruta != "": #Si la ruta no está vacía
        guardado=True #Cambio el estado de guardado
        try:
            with open(ruta, "r", encoding="utf-8") as archivo: #Abro el archivo
                cuerpo=archivo.read() #Leo el archivo
                entrada.delete("1.0", tk.END) #Borro el contenido del editor de texto
                entrada.insert("1.0", cuerpo) #Inserto el contenido del archivo en el editor de texto
            info.config(text="Se abrió el archivo correctamente", foreground="green")
        except FileNotFoundError:
            messagebox.showerror("Error", "El archivo no se encontró o no se pudo abrir.")
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo abrir el archivo: {str(e)}")
    else:
        info.config(text="No se seleccionó ningún archivo", foreground="red") #Mensaje de error

def guardar(): #Función para guardar el archivo
    global ruta, guardado #Uso las variables globales
    info.config(text="Guardando archivo...", foreground="black") #Mensaje que dice el proceso
    if guardado:
        try:
            with open(ruta,"w", encoding="utf-8") as archivo: #Abro el archivo
                archivo.write(entrada.get("1.0", tk.END)) #Escribo el contenido del editor de texto en el archivo
            info.config(text="Se guardó el archivo correctamente", foreground="green") #Mensaje de éxito
        except Exception as e:
            messagebox.showerror("Error", f"No se pudo guardar el archivo: {str(e)}")
            info.config(text="No se pudo guardar el archivo", foreground="red") #Mensaje de error
    else:
        guardarComo() #Si no se ha guardado, llamo a la función guardarComo


def limpiar():
    global pais, poblacion, rutaGrafica, rutaBandera #Uso las variables globales
    rutaGrafica="C:/banderas/nono.png"
    rutaBandera="C:/banderas/nono.png"
    pais="NA"
    poblacion="NA"
    paistx.config(text=pais) #Actualizo el label del país
    poblaciontx.config(text=poblacion) #Actualizo el label de la población
    bandera=PhotoImage(file=rutaBandera) #Actualizo la bandera
    bandera=bandera.subsample(3,3)
    flag.config(image=bandera)
    flag.image=bandera
    grafica=PhotoImage(file=rutaGrafica) #Actualizo la gráfica
    grafica=grafica.subsample(2,2)
    gra.config(image=grafica)
    gra.image=grafica

def guardarComo(): #Función para guardar el archivo como
    global ruta, guardado #Uso las variables globales
    info.config(text="Guardando archivo como...", foreground="black") #Mensaje que dice el proceso
    ruta=filedialog.asksaveasfilename(title="Guardar archivo", filetypes=(("Archivos .ORG", "*.org"),))
    if ruta != "": #Si la ruta no está vacía
        guardado=True #Cambio el estado de guardado
        guardar() #Llamo a la función guardar
    else:
        info.config(text="No se guardó el archivo", foreground="red") #Mensaje de error
    
def actualizarInfo(): #Solo actualizo los datos de los labels y las rutas de las imagenes
    global pais, poblacion, rutaGrafica, rutaBandera #Uso las variables globales
    paistx.config(text=pais) #Actualizo el label del país
    poblaciontx.config(text=poblacion) #Actualizo el label de la población
    bandera=PhotoImage(file=rutaBandera) #Actualizo la bandera
    bandera=bandera.subsample(3,3)
    flag.config(image=bandera)
    flag.image=bandera
    grafica=PhotoImage(file=rutaGrafica) #Actualizo la gráfica
    grafica=grafica.subsample(1,1)
    gra.config(image=grafica)
    gra.image=grafica

def analizar(): #Función para analizar el texto del editor
    global pais, poblacion, rutaGrafica, rutaBandera
    cuerpo=entrada.get("1.0", tk.END) #Obtengo el contenido del editor de texto
    lineas=cuerpo.splitlines() #Divido el contenido del editor de texto por líneas
    todasVacias=all(linea=="" or linea.isspace() for linea in lineas) #Verifico si todas las líneas estan vacias
    limpiar()
    if todasVacias:
        messagebox.showerror("Error", "No se ha ingresado información.") #Mensaje de error
        info.config(text="Ingrese Información en el editor de texto", foreground="red") #Mensaje de error
    else:
        info.config(text="Analizando...", foreground="black") #Mensaje que dice el proceso
        
        dato=entrada.get("1.0","end-1c")
        # Aquí ejecuta el .exe creado con fortran, envia el dato, lee la salida y lo toma como texto
        resultado=subprocess.run(['./main.exe'],input=dato, stdout=subprocess.PIPE,text=True)
        salida=resultado.stdout.strip() #Quita los espacios en blanco
        partes=salida.split(",") #Divido la salida por comas

        print(salida)

        # Viene con la siguiente estructura: [rutraGrafica, rutaBandera, pais, poblacion]
        if len(partes)==4:
            rutaGrafica=partes[0] #Actualizo la ruta de la gráfica
            rutaBandera=partes[1] #Actualizo la ruta de la bandera
            pais=partes[2] #Actualizo el país
            poblacion=partes[3] #Actualizo la población
            actualizarInfo() #Actualizo la información de la ventana
            messagebox.showinfo("Analisis", "Analisis realizado con éxito.") #Mensaje de éxito 
            info.config(text="Se analizó la información correctamente", foreground="green")
        elif len(partes)==1:
            messagebox.showerror("Error", "No se pudo completar la operación por un error")
            info.config(text="No se pudo completar la operación por un error", foreground="red") #Mensaje de error
        else:
            messagebox.showerror("Error", "No se pudo completar la operación por un error")
            info.config(text="No se pudo completar la operación por un error", foreground="red") #Mensaje de error
    
#INTEFAZ GRÁFICAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
#----------------------------------------------------------------------------

#Creo la ventana principal
ventana = tk.Tk()
ventana.title("Proyecto 1 LFP")


# Creación de los frames para la interfaz
frame1 = tk.Frame(ventana)
frame1.pack(side=tk.LEFT)
frame2 = tk.Frame(ventana)
frame2.pack(side=tk.RIGHT)
frame3= tk.Frame(frame2)
frame3.pack(side=tk.BOTTOM)
frame4= tk.Frame(frame3)
frame4.pack(side=tk.LEFT)
frame5= tk.Frame(frame3)
frame5.pack(side=tk.RIGHT)

#Creo el editor de texto
info=tk.Label(frame1,text=" ")
info.pack()
info.config(foreground="red", font=("Arial", 9, "italic"))
edittxt=tk.Label(frame1, text="EDITOR DE TEXTO: Escriba aquí las instrucciones")
edittxt.pack()
edittxt.config(foreground="black", font=("Arial", 14, "bold"))
entrada = tk.Text(frame1, height=26, width=75)
entrada.pack()

scroll=tk.Scrollbar(ventana, orient="vertical", command=entrada.yview)
entrada.config(font=("consolas", 11), yscrollcommand=scroll.set)
scroll.pack(side="right", fill="y")


#Creo el botón para enviar la información
boton=tk.Button(frame1, text="Analizar",height="1", width="8", command=analizar)
boton.pack()
boton.config(background="white", foreground="blue", font=("Arial", 14, "bold"))

#----------------------------------------------------------------------------
#Creo la barra con el la opción menu
barra=tk.Menu(ventana)
menu = tk.Menu(barra, tearoff=False)
menu.add_command(label="Abrir", command=abrir)
menu.add_command(label="Guardar", command=guardar)
menu.add_command(label="Guardar como", command=guardarComo)

# Agregar archivo, acerca de y salir
barra.add_cascade(menu=menu, label="Archivo")
barra.add_command(label="Acerca de", command=acerca_de)
barra.add_command(label="Salir", command=ventana.quit)

# Asignar la barra de menús a la ventana principal
ventana.config(menu=barra)
#----------------------------------------------------------------------------

#Le coloco un path a la grafica
grafica = PhotoImage(file=rutaGrafica)
grafica = grafica.subsample(2,2)
gra=tk.Label(frame2,image=grafica)
gra.config(width="800", height="350")
gra.pack()
gra.pack(anchor="e")

#Añado los labels que tendrán la información del pais
paistxt=tk.Label(frame4,text="Pais seleccionado:")
paistxt.pack()
paistxt.config(font=("Arial", 12, "bold"))
paistx=tk.Label(frame4,text=pais)
paistx.pack()
paistx.config(font=("Arial", 12))
poblaciontxt=tk.Label(frame4,text="Población:")
poblaciontxt.pack()
poblaciontxt.config(font=("Arial", 12,"bold"))
poblaciontx=tk.Label(frame4,text=poblacion)
poblaciontx.pack()
poblaciontx.config(font=("Arial", 12))

#Añado la bandera
bandera = PhotoImage(file=rutaBandera)
bandera = bandera.subsample(3,3)
flag=tk.Label(frame5,image=bandera)
flag.pack()
flag.pack(anchor="e")

#Ejecuta la ventana
ventana.mainloop()