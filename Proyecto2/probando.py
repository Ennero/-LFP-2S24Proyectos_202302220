
import tkinter as tk
from tkhtmlview import HTMLLabel

# HTML de ejemplo con una tabla
html_content = '''
<table border="1">
    <tr>
        <th>País</th>
        <th>Población</th>
    </tr>
    <tr>
        <td>Guatemala</td>
        <td>17,000,000</td>
    </tr>
    <tr>
        <td>México</td>
        <td>126,000,000</td>
    </tr>
</table>
'''

# Crear la ventana principal de tkinter
root = tk.Tk()
root.title("Tabla HTML en Tkinter")

# Crear un widget HTMLLabel y cargar el contenido HTML
html_label = HTMLLabel(root, html=html_content)
html_label.pack(fill="both", expand=True)

# Iniciar el bucle principal de tkinter
