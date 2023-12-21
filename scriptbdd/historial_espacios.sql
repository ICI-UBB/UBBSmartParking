-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 21-12-2023 a las 05:38:31
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `estacionamiento_ubb`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_espacios`
--

CREATE TABLE `historial_espacios` (
  `id` int(11) NOT NULL,
  `espacioID` int(11) NOT NULL,
  `estado` varchar(10) NOT NULL,
  `fechaHora` datetime DEFAULT current_timestamp(),
  `cantidadVehiculos` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `historial_espacios`
--

INSERT INTO `historial_espacios` (`id`, `espacioID`, `estado`, `fechaHora`, `cantidadVehiculos`) VALUES
(446, 1, 'Libre', '2023-12-14 02:05:51', 6),
(447, 2, 'Libre', '2023-12-14 02:05:51', 6),
(448, 3, 'Libre', '2023-12-14 02:05:51', 6),
(449, 4, 'Libre', '2023-12-14 02:05:51', 6),
(450, 5, 'Libre', '2023-12-14 02:05:51', 6),
(451, 6, 'Ocupado', '2023-12-14 02:05:51', 6),
(452, 7, 'Libre', '2023-12-14 02:05:51', 6),
(453, 1, 'Libre', '2023-12-14 02:06:28', 6),
(454, 2, 'Libre', '2023-12-14 02:06:28', 6),
(455, 3, 'Libre', '2023-12-14 02:06:28', 6),
(456, 4, 'Libre', '2023-12-14 02:06:28', 6),
(457, 5, 'Libre', '2023-12-14 02:06:28', 6),
(458, 6, 'Ocupado', '2023-12-14 02:06:28', 6),
(459, 7, 'Libre', '2023-12-14 02:06:28', 6);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `historial_espacios`
--
ALTER TABLE `historial_espacios`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `historial_espacios`
--
ALTER TABLE `historial_espacios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=551;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
