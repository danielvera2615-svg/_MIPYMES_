import sys
from pathlib import Path

# Agregar la ruta de la carpeta padre o donde esté conexion.py
# (Ajusta 'RUTA_DE_CARPETA' según tu estructura real)
sys.path.append(str(Path(__file__).resolve().parent.parent))

"""Ejemplo mínimo de conexión con el conector oficial mariadb.

Lista el contenido de la tabla CLIENTE. A diferencia del resto de scripts de py/
(que usan PyMySQL a través de conexion.py), este usa el paquete mariadb, que es
opcional: está comentado en requirements.txt porque necesita MariaDB Connector/C >= 3.3.1.

Configuración: no tiene valores escritos en el código. Usuario, contraseña, host, puerto y
base de datos salen de las variables de entorno GLOB_GUSTERS_HOST, GLOB_GUSTERS_PORT,
GLOB_GUSTERS_USER, GLOB_GUSTERS_PASSWORD y GLOB_GUSTERS_DB, que conexion.py lee del
archivo .env de la raíz (una variable ya definida en el sistema tiene prioridad).

Requisitos: Python 3.9+, el paquete mariadb (está en requirements.txt) y, en el sistema,
MariaDB Connector/C >= 3.3.1 (macOS: brew install mariadb-connector-c; Debian/Ubuntu:
sudo apt install libmariadb-dev build-essential python3-dev; Windows: instalador de
mariadb.com/downloads/connectors si pip intenta compilar). Detalle por sistema operativo:
README.md, sección «Dependencias requeridas».
"""

# Conector oficial de MariaDB (dependencia opcional, ver requirements.txt).
import mariadb

# Reutiliza los mismos parámetros de conexion.py (variables de entorno y archivo .env).
from conexion import CONFIG, explicar_tabla_danada

try:
    # Establecer la conexión con la base de datos (la contraseña vacía es válida)
    conexion = mariadb.connect(
        # Usuario tomado de la configuración compartida.
        user=CONFIG["user"],
        # Contraseña; or "" convierte None en cadena vacía (sin contraseña).
        password=CONFIG["password"] or "",
        # Servidor de MariaDB. Con "localhost" el conector oficial usa el socket Unix local
        # (que puede pertenecer a otro servidor MySQL/MariaDB e ignora el puerto); por eso se
        # fuerza TCP con 127.0.0.1, igual que hace PyMySQL.
        host="127.0.0.1" if CONFIG["host"] == "localhost" else CONFIG["host"],
        # Puerto TCP.
        port=CONFIG["port"],
        # Base de datos a usar.
        database=CONFIG["database"]
    )
except mariadb.Error as e:
    # Si la conexión falla, se muestra el motivo y se sale con código 1 (error).
    print(f"Error al conectar a MariaDB: {e}")
    sys.exit(1)

try:
    # Crear un cursor para ejecutar sentencias SQL
    cursor = conexion.cursor()

    # Ejecutar la consulta apuntando a tu tabla CLIENTE de Mipymes
    cursor.execute("SELECT cliente_id, nombre, documento, email FROM CLIENTE")

    # Recorrer los resultados y mostrarlos
    for (cliente_id, nombre, documento, email) in cursor:
        print(f"ID: {cliente_id} | Nombre: {nombre} | Documento: {documento} | Email: {email}")

except mariadb.Error as e:
    # Una tabla dañada en el servidor se explica con los pasos de reparación, sin traza.
    explicar_tabla_danada(getattr(e, "errno", None), e)
    # Cualquier otro error se propaga sin modificar.
    raise

# Cerrar cursor y conexión
cursor.close()
conexion.close()