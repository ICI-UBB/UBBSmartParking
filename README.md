# UBBSmartParking
 Proyecto de tesis enfocado en la gestión de estacionamientos mediante cámaras utilizando inteligencia artificial para la Universidad del Bío-Bío

    Requerimientos:

    -Python sdk
    -flutter sdk

    Luego de clonar el repositorio es necesario la creación de un enviroment con los siguientes comandos:
    -python -m venv env
    -env\Scripts\activate 
    En caso de errores con la autorizacion de los script ejecutar el siguiente comando en la powershell: 
    -Set-ExecutionPolicy RemoteSigned

    A continuación instalar los requirements.txt junto a las bibliotecas necesarias: 
    -pip install -r requirements.txt
    -pip install torch
    -pip install uvicorn
    -pip install fastapi
    -pip install mysql-connector-python
    -pip install opencv-python
    -pip install pandas
    -pip install ultralytics 

    configurar base de datos:
    En la carpeta scriptbdd se encuentra la tabla necesaria para el proyecto, el nombre de la base de datos es "estacionamiento_ubb" y el de la tabla "historial_espacios"

    entrar a la carpeta app y ejecutar comando flutter pub get
    luego ejecutar el comando flutter create .

    click derecho en best.pt seleccionar la opción "copy path"
    en el archivo parking_space_detector.py en la linea 10 copiar el path de best.pt deberia quedar de la siguiente forma: model = YOLO('C:\\Users\\josse\\Documents\\GitHub\\UBBSmartParking\\best.pt'), lo mismo para el archivo modelo.py en la línea 4 

    cada una de los siguientes comandos se deben ejecutar en terminales distintas:
    ejecutar api(carpeta raíz): -uvicorn main:app --reload
    ejecutar app(carpeta app): -flutter run
    finalmente ejecutar parking_space_detector

    Dentro del proyecto se encuentra 2 videos de prueba en la linea 57 de parking_space_detector se puede cambiar la ruta al video que desee probar
    Para probar solo el rendimiento del modelo ejecutar el archivo modelo.py el cual tambien puede cambiar el video a observar en la linea 6
