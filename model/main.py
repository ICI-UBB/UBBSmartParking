from fastapi import FastAPI
from pydantic import BaseModel
import mysql.connector
from mysql.connector import Error
from fastapi.middleware.cors import CORSMiddleware
from typing import List

app = FastAPI()

#Configuración error de CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

#Estructura de los datos a trabajar
class SpaceData(BaseModel):
    espacioID: int
    estado: str
    cantidadVehiculos: int

class SpacesData(BaseModel):
    spaces: List[SpaceData]

def create_connection():
    try:
        return mysql.connector.connect(
            host="127.0.0.1",
            user="root",
            password="",
            database="estacionamiento_ubb"
        )
    except Error as e:
        print(f"Error al conectar a MySQL: {e}")
        return None

# Endpoint para insertar los espacios de estacionamientos
@app.post("/update_spaces")
def update_spaces(data: SpacesData):
    connection = create_connection()
    if connection:
        try:
            cursor = connection.cursor()
            query = """
            INSERT INTO historial_espacios (espacioID, estado, cantidadVehiculos, fechaHora)
            VALUES (%s, %s, %s, NOW());
            """
            records = [(d.espacioID, d.estado, d.cantidadVehiculos) for d in data.spaces]
            cursor.executemany(query, records)
            connection.commit()
            return {"message": f"{cursor.rowcount} registros insertados correctamente"}
        except Error as e:
            return {"error": f"Error al insertar datos en la base de datos: {e}"}, 500
        finally:
            if connection.is_connected():
                cursor.close()
                connection.close()
    else:
        return {"error": "Error al conectar con la base de datos"}, 500


# Endpoint para obtener los espacios de estacionamientos
@app.get("/get_spaces")
def get_spaces():
    connection = create_connection()
    if connection:
        cursor = connection.cursor()
        
        
        cursor.execute("SELECT espacioID, estado, cantidadVehiculos FROM historial_espacios ORDER BY fechaHora DESC LIMIT 7")
        
        spaces = cursor.fetchall()
        cursor.close()
        connection.close()
        
        return {
            "espacios": [{"espacioID": space[0], "estado": space[1], "cantidadVehiculos": space[2]} for space in spaces]
        }
    else:
        return {"error": "Error al conectar con la base de datos"}, 500


