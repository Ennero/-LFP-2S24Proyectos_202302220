import tkinter as tk
import subprocess

def archivo_nuevo_presionado():
    print("¡Has presionado para crear un nuevo archivo!")


def enviar():
    pass
    """#agarra el dato que tiene el campo de entrada
    dato=entrada.get()

    # Aquí ejecuta el .exe creado con fortran, envia el dato, lee la salida y lo toma como texto
    resultado=subprocess.run(['analizador.exe'],input=dato, stdout=subprocess.PIPE,text=True)

    #Divido la salida de fortran por su comas
    salida=resultado.stdout.strip()
    partes=salida.split(",")"""

#Creo la ventana principal
ventana = tk.Tk()
ventana.title("Proyecto 1 LFP")

#Creo el editor de texto
tk.Label(ventana, text="Ingrese algo xd").pack()
entrada = tk.Text(ventana, height=10, width=50)
entrada.pack()

#Creo el botón para enviar la información
tk.Button(ventana, text="Analisis", command=enviar).pack()

#----------------------------------------------------------------------------
#Creo el menu
barra=tk.Menu(ventana)
menu = tk.Menu(barra, tearoff=False)
menu.add_command(label="Abrir", command="archivo_nuevo_presionado")
menu.add_command(label="Guardar", command="archivo_nuevo_presionado")
menu.add_command(label="Guardar como", command="archivo_nuevo_presionado")


# Agregar el menú a la barra
barra.add_cascade(menu=menu, label="Archivo")

# Asignar la barra de menús a la ventana principal
ventana.config(menu=barra)
#----------------------------------------------------------------------------

#Ejecuta la ventana
ventana.mainloop()