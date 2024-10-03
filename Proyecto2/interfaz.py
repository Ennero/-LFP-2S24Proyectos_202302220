import tkinter as tk
from tkinter import messagebox
from tkinter import PhotoImage
from tkinter import filedialog



# Función para analizar el texto
def analizar():
    pass


def guardar(): #Función para guardar el archivo
    pass

def tokens(): #Función para mostrar los tokens
    pass







#Todo lo relacionado a la interfaz gráfica ----------------------------------------------
# Función para la posición del mouse
def posicion(event):
    x, y = event.x, event.y
    pos.config(text=f"x={x}, y={y}")

# Creo la ventana principal
ventana = tk.Tk()
ventana.title("Proyecto 1 LFP")

# Creación de los frames para la interfaz
frame1 = tk.Frame(ventana)
frame1.pack(side=tk.TOP)
frame2 = tk.Frame(ventana)
frame2.pack(side=tk.BOTTOM)
frame3 = tk.Frame(frame1)
frame3.pack(side=tk.LEFT)
frame4 = tk.Frame(frame1)
frame4.pack(side=tk.RIGHT)

# Creo el editor de texto ----------------------------------------------
#Creación de la información de la posición del mouse
mouse = tk.Label(frame3, text="Posición del mouse: ", font=("Arial", 12))
mouse.pack()
ventana.bind("<Motion>", posicion) # Vincular el movimiento del mouse a la función posicion
pos=tk.Label(frame3, text="x=0, y=0", font=("Arial", 12, "bold"))
pos.pack()
# Frame para tener un scrollbar
frameIzq = tk.Frame(frame3)
frameIzq.pack()

# Textbox
entrada = tk.Text(frameIzq, height=26, width=75)
entrada.pack(side="left")

# Scrollbar
scroll = tk.Scrollbar(frameIzq, orient="vertical", command=entrada.yview)
entrada.config(yscrollcommand=scroll.set)
scroll.pack(side="right", fill="y")

# Creación de los botones y las cosas que se mostrarán en el lado derecho ----------------------------------------------

#Creación del botón para el análisis




#Creación del contenedor donde meta lo demás
contenedor = tk.Frame(frame4)
contenedor.pack(ipady=5,ipadx=5, padx=5, pady=5)
contenedor.config(border=2, relief="groove")

#Creación de la etiqueta para el título
titulo = tk.Label(contenedor, text="ARCHIVO", font=("Arial", 15, "bold"))
titulo.pack(side="top")

#Creación del botón para nuevo
nuevo = tk.Button(contenedor, text="Nuevo", height="1", width="11", command=guardar)
nuevo.pack(side="left")
nuevo.config(background="white", foreground="black", font=("Arial", 10, "bold"))

#Creación del botón para abrir
abrir = tk.Button(contenedor, text="Abrir", height="1", width="11", command=guardar)
abrir.pack(side="right")
abrir.config(background="white", foreground="black", font=("Arial", 10, "bold"))

#Creación del botón para guardar
guardo = tk.Button(contenedor, text="Guardar", height="1", width="11", command=guardar)
guardo.pack()
guardo.config(background="white", foreground="black", font=("Arial", 10, "bold"))

#Creación del botón para guardar como
guardoComo = tk.Button(contenedor, text="Guardar como", height="1", width="11", command=guardar)
guardoComo.pack()
guardoComo.config(background="white", foreground="black", font=("Arial", 10, "bold"))

#Creación del contenedor para el análisis y token ----------------------------------------------
contener= tk.Frame(frame4)
contener.pack(ipadx=2, padx=5, pady=5,ipady=5)


#Creación del botón para analizar
analisis = tk.Button(contener, text="Analizar", height="2", width="9", command=analizar)
analisis.pack(side="left")
analisis.config(background="white", foreground="green", font=("Arial", 15, "bold"))

#Creación del botón para ver los tokens
token= tk.Button(contener, text="Tokens", height="2", width="9", command=tokens)
token.pack(side="right")
token.config(background="white", foreground="orange", font=("Arial", 15, "bold"))

#Creación del botón para salir
salir= tk.Button(frame4, text="Salir", height="1", width="9", command=ventana.quit)
salir.pack(side="bottom")
salir.config(background="white", foreground="red", font=("Arial", 13, "bold"))


#Creación del botón para guardar como

# Ejecuta la ventana
ventana.mainloop()