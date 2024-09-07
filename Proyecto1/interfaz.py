import tkinter as tk
from tkinter import messagebox
from tkinter import PhotoImage
from tkinter import filedialog
import subprocess

#Declarando mis variables globales
poblacion="NA"
pais="NA"
rutaGrafica="C:/banderas/duo.png"
rutaBandera="C:/banderas/ohio.png"



def acerca_de():
    messagebox.showinfo("Acerca de","Nombre: Enner Esaí Mendizabal Castro; Carné: 202302220; Curso: Lenguajes Formales y de Programación; Sección: B+")


def abrir():
    ruta=filedialog.askopenfilename(title="Abrir archivo", filetypes=(("Archivos .ORG", "*.org"),("Todos los archivos", "*.*")))
    if ruta != "":
        messagebox.showinfo("Abrir Archivo", "Se abrió el archivo: "+ruta+" exitosamente")


def guardar(): #Probando nada más
    cambio=PhotoImage(file=rutaGrafica)
    flag.config(image=cambio)
    pass

def guardarComo():
    pass

def analizar():
    pass
    """#agarra el dato que tiene el campo de entrada
    dato=entrada.get()

    # Aquí ejecuta el .exe creado con fortran, envia el dato, lee la salida y lo toma como texto
    resultado=subprocess.run(['analizador.exe'],input=dato, stdout=subprocess.PIPE,text=True)

    #Divido la salida de fortran por su comas
    salida=resultado.stdout.strip()
    partes=salida.split(",")"""
    
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
edittxt=tk.Label(frame1, text="EDITOR DE TEXTO: Escriba aquí las instrucciones")
edittxt.pack()
edittxt.config(highlightbackground="red", foreground="black", font=("Arial", 11, "bold"))
entrada = tk.Text(frame1, height=22, width=60)
entrada.pack()

scroll=tk.Scrollbar(ventana, orient="vertical", command=entrada.yview)
entrada.config(font=("consolas", 9), yscrollcommand=scroll.set)
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
grafica = grafica.subsample(5,7)
gra=tk.Label(frame2,image=grafica)
gra.pack()
gra.pack(anchor="e")

#Añado los labels que tendrán la información del pais
paistxt=tk.Label(frame4,text="Pais: ")
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
bandera = bandera.subsample(14,17)
flag=tk.Label(frame5,image=bandera)
flag.pack()
flag.pack(anchor="e")

#Ejecuta la ventana
ventana.mainloop()