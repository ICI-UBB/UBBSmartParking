import cv2
from ultralytics import YOLO

model = YOLO('C:\\Users\\josse\\OneDrive\\Escritorio\\proyecto-tesis\\runs\\detect\\Yolov5mu-libreocupado 100\\weights\\best.pt')  # Actualiza con la ruta de tu modelo

cap = cv2.VideoCapture('prueba2.mp4')


cv2.namedWindow("Video con Detecciones", cv2.WINDOW_NORMAL)
cv2.resizeWindow("Video con Detecciones", 1020, 500)

while True:
    ret, frame = cap.read()
    if not ret:
        break

    
    frame = cv2.resize(frame, (1024, 1024))
    results = model.predict(frame)
    detections = results[0].boxes.data.cpu()

    for box in detections:
        x1, y1, x2, y2, conf, cls = box.tolist()
        x1, y1, x2, y2 = map(int, [x1, y1, x2, y2])

        
        color = (0, 0, 255) if cls == 1 else (0, 255, 0)

       
        cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
        cv2.putText(frame, f'Clase {int(cls)}', (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, color, 2)

    
    cv2.imshow("Video con Detecciones", frame)

    
    key = cv2.waitKey(1)
    if key == 27:  
        break

cap.release()
cv2.destroyAllWindows()