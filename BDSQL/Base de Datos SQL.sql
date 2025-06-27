USE MASTER
GO
CREATE DATABASE dbModeloMultidimensional
GO
USE dbModeloMultidimensional
GO
-- DIMENSIONES

CREATE TABLE dimUsuario (
    idUsuario INT PRIMARY KEY,
    nombre NVARCHAR(100),
    email NVARCHAR(100),
    tipoUsuario NVARCHAR(50),
    fechaRegistro DATE
);

CREATE TABLE dimCampo (
    idCampo INT PRIMARY KEY,
    nombre NVARCHAR(100),
    latitud DECIMAL(9,6),
    longitud DECIMAL(9,6),
    superficie DECIMAL(10,2),
    tipoSuelo NVARCHAR(50)
);

CREATE TABLE dimCultivo (
    idCultivo INT PRIMARY KEY,
    nombre NVARCHAR(100),
    variedad NVARCHAR(100),
    fechaSiembra DATE,
    etapaCrecimiento NVARCHAR(50),
    estado NVARCHAR(50),
    idCampo INT FOREIGN KEY REFERENCES dimCampo(idCampo),
    idUsuario INT FOREIGN KEY REFERENCES dimUsuario(idUsuario)
);

CREATE TABLE dimSensor (
    idSensor INT PRIMARY KEY,
    tipo NVARCHAR(50),
    latitud DECIMAL(9,6),
    longitud DECIMAL(9,6),
    estadoBateria NVARCHAR(50),
    ultimaLectura DATETIME,
    idCampo INT FOREIGN KEY REFERENCES dimCampo(idCampo)
);

CREATE TABLE dimPlaga (
    idPlaga INT PRIMARY KEY,
    nombreCientifico NVARCHAR(100),
    nombreComun NVARCHAR(100),
    tipo NVARCHAR(50),
    nivelSeveridad NVARCHAR(50),
    fechaDeteccion DATE,
    idCultivo INT FOREIGN KEY REFERENCES dimCultivo(idCultivo)
);

CREATE TABLE dimPrediccion (
    idPrediccion INT PRIMARY KEY,
    tipo NVARCHAR(50),
    fecha DATE,
    resultado NVARCHAR(100),
    confiabilidad DECIMAL(5,2),
    idCultivo INT FOREIGN KEY REFERENCES dimCultivo(idCultivo)
);

CREATE TABLE dimRiego (
    idRiego INT PRIMARY KEY,
    tipo NVARCHAR(50),
    programacion NVARCHAR(100),
    eficiencia DECIMAL(5,2),
    idCampo INT FOREIGN KEY REFERENCES dimCampo(idCampo)
);

CREATE TABLE dimRecomendacion (
    idRecomendacion INT PRIMARY KEY,
    tipo NVARCHAR(50),
    descripcion NVARCHAR(255),
    prioridad NVARCHAR(50),
    fechaGeneracion DATE,
    estado NVARCHAR(50),
    idCultivo INT FOREIGN KEY REFERENCES dimCultivo(idCultivo)
);

CREATE TABLE dimTiempo (
    idTiempo INT PRIMARY KEY,
    fecha DATE,
    dia INT,
    mes INT,
    anio INT,
    trimestre INT
);

-- TABLA DE HECHOS

CREATE TABLE factCultivo (
    idFact INT PRIMARY KEY IDENTITY(1,1),
    idCultivo INT FOREIGN KEY REFERENCES dimCultivo(idCultivo),
    idSensor INT FOREIGN KEY REFERENCES dimSensor(idSensor),
    idPlaga INT FOREIGN KEY REFERENCES dimPlaga(idPlaga),
    idPrediccion INT FOREIGN KEY REFERENCES dimPrediccion(idPrediccion),
    idRiego INT FOREIGN KEY REFERENCES dimRiego(idRiego),
    idRecomendacion INT FOREIGN KEY REFERENCES dimRecomendacion(idRecomendacion),
    idTiempo INT FOREIGN KEY REFERENCES dimTiempo(idTiempo),
    valorSensor DECIMAL(10,2),
    resultadoPrediccion NVARCHAR(100),
    eficienciaRiego DECIMAL(5,2),
    nivelSeveridad NVARCHAR(50)
);
-- =============================
-- CARGA DE DATOS SIMULADOS
-- =============================

-- DIMENSION USUARIO
INSERT INTO dimUsuario (idUsuario, nombre, email, tipoUsuario, fechaRegistro) VALUES
(1, 'Carlos Pérez', 'cperez@agro.com', 'Agricultor', '2024-01-10'),
(2, 'Lucía Torres', 'ltorres@agro.com', 'Técnico', '2024-01-12'),
(3, 'Juan Gómez', 'jgomez@agro.com', 'Agricultor', '2024-01-15'),
(4, 'Diana Ruiz', 'druiz@agro.com', 'Supervisor', '2024-02-01'),
(5, 'Pedro Díaz', 'pdiaz@agro.com', 'Técnico', '2024-02-05'),
(6, 'Sofía Martínez', 'smartinez@agro.com', 'Agricultor', '2024-02-10'),
(7, 'Miguel Ángel', 'mangel@agro.com', 'Agricultor', '2024-02-20');

-- DIMENSION CAMPO
INSERT INTO dimCampo (idCampo, nombre, latitud, longitud, superficie, tipoSuelo) VALUES
(1, 'Campo Norte', 5.12, -74.12, 12.5, 'Franco arenoso'),
(2, 'Campo Sur', 5.13, -74.11, 10.2, 'Arcilloso'),
(3, 'Campo Este', 5.14, -74.10, 15.8, 'Limoso'),
(4, 'Campo Oeste', 5.15, -74.09, 9.4, 'Arenoso'),
(5, 'Campo Central', 5.16, -74.08, 13.7, 'Franco arcilloso'),
(6, 'Campo Bajo', 5.17, -74.07, 11.3, 'Arcillo-limoso'),
(7, 'Campo Alto', 5.18, -74.06, 14.5, 'Franco');

-- DIMENSION CULTIVO
INSERT INTO dimCultivo (idCultivo, nombre, variedad, fechaSiembra, etapaCrecimiento, estado, idCampo, idUsuario) VALUES
(1, 'Maíz', 'Híbrido 101', '2025-01-01', 'Vegetativo', 'Saludable', 1, 1),
(2, 'Papa', 'Criolla Amarilla', '2025-01-10', 'Germinación', 'En observación', 2, 2),
(3, 'Tomate', 'Chonto', '2025-02-01', 'Floración', 'Plaga leve', 3, 3),
(4, 'Arroz', 'Fedearroz 68', '2025-02-15', 'Macolla', 'Estable', 4, 4),
(5, 'Frijol', 'Rojo Bola', '2025-03-01', 'Crecimiento', 'Riesgo alto', 5, 5),
(6, 'Cebolla', 'Blanca larga', '2025-03-10', 'Desarrollo', 'Saludable', 6, 6),
(7, 'Lechuga', 'Batavia', '2025-03-15', 'Cosecha', 'Maduro', 7, 7);

-- DIMENSION SENSOR
INSERT INTO dimSensor (idSensor, tipo, latitud, longitud, estadoBateria, ultimaLectura, idCampo) VALUES
(1, 'Temperatura', 5.12, -74.12, 'Buena', '2025-01-15 10:00', 1),
(2, 'Humedad', 5.13, -74.11, 'Media', '2025-01-20 10:30', 2),
(3, 'PH', 5.14, -74.10, 'Alta', '2025-02-05 09:45', 3),
(4, 'Luminosidad', 5.15, -74.09, 'Baja', '2025-02-10 11:00', 4),
(5, 'Temperatura', 5.16, -74.08, 'Buena', '2025-03-01 12:00', 5),
(6, 'Humedad', 5.17, -74.07, 'Buena', '2025-03-05 13:00', 6),
(7, 'PH', 5.18, -74.06, 'Media', '2025-03-10 14:00', 7);

-- DIMENSION PLAGA
INSERT INTO dimPlaga (idPlaga, nombreCientifico, nombreComun, tipo, nivelSeveridad, fechaDeteccion, idCultivo) VALUES
(1, 'Spodoptera frugiperda', 'Gusano cogollero', 'Insecto', 'Moderado', '2025-01-18', 1),
(2, 'Phytophthora infestans', 'Tizón tardío', 'Hongo', 'Alto', '2025-01-25', 2),
(3, 'Bemisia tabaci', 'Mosca blanca', 'Insecto', 'Bajo', '2025-02-15', 3),
(4, 'Alternaria solani', 'Mancha foliar', 'Hongo', 'Moderado', '2025-02-25', 4),
(5, 'Puccinia graminis', 'Roya', 'Hongo', 'Alto', '2025-03-05', 5),
(6, 'Trips tabaci', 'Trips', 'Insecto', 'Leve', '2025-03-12', 6),
(7, 'Fusarium oxysporum', 'Marchitez', 'Hongo', 'Crítico', '2025-03-20', 7);

-- DIMENSION PREDICCION
INSERT INTO dimPrediccion (idPrediccion, tipo, fecha, resultado, confiabilidad, idCultivo) VALUES
(1, 'Clima', '2025-01-12', 'Alta humedad', 85.0, 1),
(2, 'Producción', '2025-01-22', 'Rendimiento bajo', 75.5, 2),
(3, 'Enfermedad', '2025-02-14', 'Posible brote', 70.0, 3),
(4, 'Clima', '2025-02-20', 'Sequía parcial', 65.0, 4),
(5, 'Producción', '2025-03-10', 'Rendimiento medio', 80.5, 5),
(6, 'Clima', '2025-03-15', 'Lluvias intensas', 90.0, 6),
(7, 'Enfermedad', '2025-03-25', 'Alerta fitosanitaria', 60.0, 7);

-- DIMENSION RIEGO
INSERT INTO dimRiego (idRiego, tipo, programacion, eficiencia, idCampo) VALUES
(1, 'Goteo', 'Diario 06:00', 92.0, 1),
(2, 'Aspersión', 'Interdiario 07:30', 78.5, 2),
(3, 'Goteo', 'Cada 2 días 08:00', 85.3, 3),
(4, 'Manual', 'Semanal 09:00', 65.2, 4),
(5, 'Aspersión', 'Diario 07:00', 80.0, 5),
(6, 'Goteo', 'Cada 3 días 06:30', 88.9, 6),
(7, 'Manual', 'Según demanda', 70.0, 7);

-- DIMENSION RECOMENDACION
INSERT INTO dimRecomendacion (idRecomendacion, tipo, descripcion, prioridad, fechaGeneracion, estado, idCultivo) VALUES
(1, 'Fertilización', 'Aplicar NPK', 'Alta', '2025-01-13', 'Pendiente', 1),
(2, 'Control Plagas', 'Insecticida biológico', 'Media', '2025-01-28', 'Aplicado', 2),
(3, 'Riego', 'Aumentar frecuencia', 'Alta', '2025-02-16', 'Pendiente', 3),
(4, 'Monitoreo', 'Evaluar hojas dañadas', 'Baja', '2025-02-27', 'Pendiente', 4),
(5, 'Fungicida', 'Aplicar tratamiento', 'Alta', '2025-03-06', 'En progreso', 5),
(6, 'Poda', 'Eliminar hojas enfermas', 'Media', '2025-03-13', 'Pendiente', 6),
(7, 'Cambio cultivo', 'Rotación de terreno', 'Alta', '2025-03-22', 'Sugerido', 7);

-- DIMENSION TIEMPO
INSERT INTO dimTiempo (idTiempo, fecha, dia, mes, anio, trimestre) VALUES
(1, '2025-01-15', 15, 1, 2025, 1),
(2, '2025-01-25', 25, 1, 2025, 1),
(3, '2025-02-15', 15, 2, 2025, 1),
(4, '2025-02-28', 28, 2, 2025, 1),
(5, '2025-03-10', 10, 3, 2025, 1),
(6, '2025-03-20', 20, 3, 2025, 1),
(7, '2025-03-30', 30, 3, 2025, 1); 

-- TABLA DE HECHOS
INSERT INTO factCultivo (
    idCultivo, idSensor, idPlaga, idPrediccion, idRiego, idRecomendacion, idTiempo,
    valorSensor, resultadoPrediccion, eficienciaRiego, nivelSeveridad
) VALUES
(2, 7, 3, 2, 1, 4, 1, 18.7, 'Sequía parcial', 63.6, 'Alto'),
(5, 3, 2, 2, 2, 4, 3, 18.2, 'Lluvias intensas', 72.1, 'Crítico'),
(2, 3, 3, 2, 1, 4, 4, 27.6, 'Lluvias intensas', 67.3, 'Crítico'),
(1, 5, 1, 6, 5, 4, 2, 29.6, 'Alerta fitosanitaria', 65.5, 'Leve'),
(1, 1, 2, 3, 4, 4, 1, 22.1, 'Sequía parcial', 71.4, 'Leve'),
(6, 6, 2, 1, 6, 1, 7, 26.6, 'Alta humedad', 82.6, 'Moderado'),
(5, 7, 2, 6, 4, 7, 4, 29.3, 'Rendimiento bajo', 73.7, 'Crítico'),
(4, 3, 1, 6, 5, 6, 5, 21.1, 'Sequía parcial', 74.8, 'Moderado'),
(5, 2, 3, 3, 2, 4, 2, 23.6, 'Alta humedad', 64.2, 'Moderado'),
(2, 3, 6, 4, 5, 1, 4, 24.4, 'Rendimiento bajo', 65.2, 'Leve'),
(2, 6, 6, 5, 4, 7, 4, 19.5, 'Alta humedad', 63.0, 'Alto'),
(2, 3, 7, 1, 5, 7, 4, 28.6, 'Lluvias intensas', 91.8, 'Crítico'),
(1, 4, 1, 7, 7, 7, 1, 23.1, 'Posible brote', 88.3, 'Crítico'),
(3, 1, 1, 6, 4, 3, 3, 20.3, 'Alta humedad', 66.9, 'Leve'),
(4, 4, 5, 4, 1, 3, 6, 22.5, 'Rendimiento bajo', 68.1, 'Moderado'),
(7, 6, 4, 5, 3, 6, 5, 21.9, 'Lluvias intensas', 89.0, 'Moderado'),
(1, 2, 2, 1, 2, 1, 6, 24.3, 'Sequía parcial', 86.2, 'Crítico'),
(4, 1, 6, 7, 6, 3, 2, 19.3, 'Rendimiento medio', 63.2, 'Leve'),
(6, 5, 1, 3, 6, 3, 3, 27.4, 'Alta humedad', 87.1, 'Alto'),
(7, 6, 7, 4, 1, 2, 5, 29.4, 'Rendimiento medio', 91.6, 'Moderado'),
(2, 6, 1, 5, 4, 2, 5, 22.0, 'Rendimiento bajo', 71.7, 'Crítico'),
(7, 5, 6, 5, 5, 1, 6, 21.6, 'Posible brote', 92.4, 'Crítico'),
(4, 7, 3, 2, 1, 3, 6, 25.5, 'Alta humedad', 87.6, 'Alto'),
(5, 6, 2, 6, 6, 2, 7, 22.6, 'Sequía parcial', 64.1, 'Moderado'),
(1, 6, 3, 5, 7, 6, 5, 18.0, 'Rendimiento medio', 85.2, 'Crítico'),
(7, 3, 4, 5, 2, 3, 1, 21.3, 'Rendimiento medio', 62.2, 'Leve'),
(5, 2, 1, 1, 4, 4, 3, 25.0, 'Alerta fitosanitaria', 83.4, 'Moderado'),
(6, 3, 4, 2, 7, 5, 2, 22.8, 'Posible brote', 81.5, 'Crítico'),
(4, 1, 5, 4, 3, 3, 7, 29.9, 'Alta humedad', 90.2, 'Crítico'),
(6, 4, 2, 3, 6, 2, 6, 26.3, 'Rendimiento medio', 75.5, 'Alto'),
(2, 2, 4, 4, 3, 6, 7, 24.9, 'Sequía parcial', 66.3, 'Moderado'),
(6, 7, 4, 1, 2, 6, 1, 18.6, 'Alta humedad', 76.7, 'Alto'),
(1, 4, 5, 3, 7, 5, 6, 29.2, 'Rendimiento bajo', 79.8, 'Moderado'),
(5, 4, 5, 5, 6, 5, 1, 25.1, 'Alerta fitosanitaria', 92.0, 'Crítico');