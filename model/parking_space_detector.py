import cv2
import pandas as pd
from ultralytics import YOLO
import requests
from datetime import datetime

from main import SpaceData, SpacesData

# Inicialización del modelo YOLO
model = YOLO('best.pt')

# Coordenadas reales de los espacios de estacionamiento

espacios_fijos = {
    1: {'x1': 0, 'y1': 641, 'x2': 226, 'y2': 1024},
    6: {'x1': 176, 'y1': 553, 'x2': 438, 'y2': 845},
    3: {'x1': 322, 'y1': 479, 'x2': 577, 'y2': 680},
    4: {'x1': 453, 'y1': 392, 'x2': 667, 'y2': 563},
    5: {'x1': 110, 'y1': 329, 'x2': 211, 'y2': 395},
    2: {'x1': 196, 'y1': 302, 'x2': 298, 'y2': 360},
    7: {'x1': 266, 'y1': 280, 'x2': 373, 'y2': 332},
}

def send_to_api(parking_data):
    url = 'http://localhost:8000/update_spaces'
    timestamp = datetime.now().isoformat(sep=' ', timespec='seconds')
    
    # Calcula la cantidad de espacios ocupados
    espacios_ocupados = sum(1 for _, estado, _ in parking_data if estado == 'Ocupado')
    
    # Calcula la cantidad de espacios disponibles
    espacios_disponibles = 7 - espacios_ocupados
    print(f"Cantidad de espacios disponibles: {espacios_disponibles}")
    
    # Crea una lista de datos para todos los espacios
    data = {
        'spaces': [
            {
                'espacioID': espacioID,
                'estado': estado,
                'fechaHora': timestamp,
                'cantidadVehiculos': espacios_disponibles
            } for espacioID, estado, _ in parking_data
        ]
    }
    
    response = requests.post(url, json=data)
    if response.status_code == 200:
        print("Datos enviados correctamente")
    else:
        print(f"Error al enviar datos. Código de respuesta: {response.status_code}")


def centroide(x1, y1, x2, y2):
    return ((x1 + x2) // 2, (y1 + y2) // 2)

cap = cv2.VideoCapture('prueba2.mp4')
fps = int(cap.get(cv2.CAP_PROP_FPS))
frames_to_skip = 5 * fps

frame_counter = 0

cv2.namedWindow("Estacionamientos", cv2.WINDOW_NORMAL)
cv2.resizeWindow("Estacionamientos", 1020, 500)

# Inicializa el estado anterior para todos los espacios
estado_anterior = {espacioID: 'Libre' for espacioID in espacios_fijos}

while True:
    ret, frame = cap.read()
    if not ret:
        break

    frame_counter += 1
    if frame_counter % frames_to_skip != 0:
        continue

    frame = cv2.resize(frame, (1024, 1024))
    results = model.predict(frame)
    detecciones = pd.DataFrame(results[0].boxes.data.cpu()).astype("float")

    cambios = []

    # Crea una lista de datos para todos los espacios
    parking_data = []

    for espacioID, coords in espacios_fijos.items():
        estado = 'Libre'
        for index, row in detecciones.iterrows():
            x1, y1, x2, y2, conf, cls = int(row[0]), int(row[1]), int(row[2]), int(row[3]), float(row[4]), int(row[5])
            c_x, c_y = centroide(x1, y1, x2, y2)

            if coords['x1'] <= c_x <= coords['x2'] and coords['y1'] <= c_y <= coords['y2']:
                estado = 'Ocupado' if cls == 1 else 'Libre'
                break

        # Verifica si el estado ha cambiado y agregar a la lista de cambios
        if estado != estado_anterior[espacioID]:
            cambios.append((espacioID, estado, 1 if estado == 'Ocupado' else 0))
            estado_anterior[espacioID] = estado
        
        # Agrega datos del estacionamiento actual a la lista de parking_data
        parking_data.append((espacioID, estado, 1 if estado == 'Ocupado' else 0))

        color = (0, 0, 255) if estado == 'Ocupado' else (0, 255, 0)
        cv2.rectangle(frame, (coords['x1'], coords['y1']), (coords['x2'], coords['y2']), color, 2)
        cv2.putText(frame, f"{estado}", (coords['x1'], coords['y1'] - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, color, 2)

    if cambios:
        send_to_api(parking_data)

    cv2.imshow("Estacionamientos", frame)
    if cv2.waitKey(1) & 0xFF == 27:
        break

cap.release()
cv2.destroyAllWindows()