CREATE DATABASE  IF NOT EXISTS `bdgestiontesis` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `bdgestiontesis`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: bdgestiontesis
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `documentos_requisito`
--

DROP TABLE IF EXISTS `documentos_requisito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentos_requisito` (
  `id_documento` int NOT NULL AUTO_INCREMENT,
  `id_tramite` int NOT NULL,
  `tipo_documento` enum('Solicitud','DNI','Bachiller','Certificado_Idiomas','Constancia_Practicas','Foto') NOT NULL,
  `ruta_archivo` varchar(255) NOT NULL,
  `estado_validacion` enum('Pendiente','Validado','Rechazado') DEFAULT 'Pendiente',
  `observacion_rechazo` text,
  `fecha_subida` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_documento`),
  KEY `fk_documento_tramite` (`id_tramite`),
  CONSTRAINT `fk_documento_tramite` FOREIGN KEY (`id_tramite`) REFERENCES `tramites` (`id_tramite`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documentos_requisito`
--

LOCK TABLES `documentos_requisito` WRITE;
/*!40000 ALTER TABLE `documentos_requisito` DISABLE KEYS */;
INSERT INTO `documentos_requisito` VALUES (1,2,'DNI','req_2_DNI_1763692977572.pdf','Pendiente',NULL,'2025-11-21 02:42:57'),(2,2,'Bachiller','req_2_Bachiller_1763692997109.pdf','Pendiente',NULL,'2025-11-21 02:43:17'),(3,4,'DNI','req_4_DNI_1763699098488.pdf','Pendiente',NULL,'2025-11-21 04:24:58'),(4,1,'Bachiller','req_1_Bachiller_1763700421061.pdf','Validado',NULL,'2025-11-21 04:47:01'),(5,1,'DNI','req_1_DNI_1763700654902.pdf','Validado',NULL,'2025-11-21 04:50:54'),(6,1,'Certificado_Idiomas','req_1_Certificado_Idiomas_1763732753434.pdf','Validado',NULL,'2025-11-21 13:45:53'),(7,1,'Foto','req_1_Foto_1763703596190.pdf','Validado',NULL,'2025-11-21 05:39:56');
/*!40000 ALTER TABLE `documentos_requisito` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evaluaciones`
--

DROP TABLE IF EXISTS `evaluaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evaluaciones` (
  `id_evaluacion` int NOT NULL AUTO_INCREMENT,
  `id_tesis` int NOT NULL,
  `codigo_docente` varchar(20) NOT NULL,
  `comentarios` text,
  `fecha_evaluacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `item_1` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_2` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_3` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_4` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_5` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_6` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_7` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_8` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_9` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_10` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_11` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_12` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_13` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_14` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_15` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_16` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_17` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_18` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_19` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_20` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_21` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_22` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_23` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_24` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_25` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_26` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_27` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_28` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_29` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_30` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_31` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_32` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_33` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_34` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_35` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_36` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_37` decimal(2,1) NOT NULL DEFAULT '0.0',
  `item_38` decimal(2,1) NOT NULL DEFAULT '0.0',
  `puntaje_total` decimal(4,1) NOT NULL DEFAULT '0.0',
  `condicion` enum('Aprobado','Aprobado con observaciones menores','Desaprobado con observaciones mayores') NOT NULL,
  PRIMARY KEY (`id_evaluacion`),
  KEY `codigo_docente` (`codigo_docente`),
  KEY `evaluaciones_ibfk_1` (`id_tesis`),
  CONSTRAINT `evaluaciones_ibfk_1` FOREIGN KEY (`id_tesis`) REFERENCES `tesis` (`id_tesis`) ON DELETE CASCADE,
  CONSTRAINT `evaluaciones_ibfk_2` FOREIGN KEY (`codigo_docente`) REFERENCES `usuarios` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evaluaciones`
--

LOCK TABLES `evaluaciones` WRITE;
/*!40000 ALTER TABLE `evaluaciones` DISABLE KEYS */;
INSERT INTO `evaluaciones` VALUES (7,14,'DOC002','aprobado','2025-11-17 15:27:34',1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,38.0,'Aprobado'),(9,20,'DOC001','Corregir\r\n','2025-11-21 04:58:57',1.0,0.5,1.0,0.0,1.0,0.5,0.5,1.0,0.0,0.5,0.0,1.0,0.5,1.0,0.0,0.5,1.0,0.5,1.0,0.0,1.0,1.0,1.0,0.0,0.5,1.0,0.5,0.0,0.0,1.0,0.5,1.0,0.0,0.5,0.0,1.0,1.0,1.0,22.5,'Aprobado con observaciones menores'),(10,19,'DOC001','CORREGIR POR FAVOR','2025-11-21 06:18:58',1.0,1.0,1.0,1.0,0.5,0.5,0.0,1.0,0.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,21.0,'Aprobado con observaciones menores'),(11,20,'DOC001','CORREGIR URGENTE','2025-11-21 06:19:19',0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,5.0,'Desaprobado con observaciones mayores'),(12,14,'DOC001','corregir lo que falta','2025-11-21 07:18:58',1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,18.0,'Aprobado con observaciones menores'),(13,14,'DOC001','perfecto','2025-11-21 14:31:50',1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,38.0,'Aprobado');
/*!40000 ALTER TABLE `evaluaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificaciones`
--

DROP TABLE IF EXISTS `notificaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificaciones` (
  `id_notificacion` int NOT NULL AUTO_INCREMENT,
  `codigo_usuario_destino` varchar(20) NOT NULL,
  `mensaje` text NOT NULL,
  `tipo` enum('Sistema','Email_Simulado','SMS_Simulado') NOT NULL,
  `leido` tinyint(1) DEFAULT '0',
  `fecha_envio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_notificacion`),
  KEY `fk_notificacion_usuario` (`codigo_usuario_destino`),
  CONSTRAINT `fk_notificacion_usuario` FOREIGN KEY (`codigo_usuario_destino`) REFERENCES `usuarios` (`codigo`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificaciones`
--

LOCK TABLES `notificaciones` WRITE;
/*!40000 ALTER TABLE `notificaciones` DISABLE KEYS */;
INSERT INTO `notificaciones` VALUES (1,'ALU003','Hemos recibido su documento: DNI. Está pendiente de validación.','Sistema',0,'2025-11-21 02:42:57'),(2,'ALU003','Copia de correo enviado: Hemos recibido su documento: DNI. Está pendiente de validación.','Email_Simulado',0,'2025-11-21 02:42:57'),(3,'ALU003','Hemos recibido su documento: Bachiller. Está pendiente de validación.','Sistema',0,'2025-11-21 02:43:17'),(4,'ALU003','Copia de correo enviado: Hemos recibido su documento: Bachiller. Está pendiente de validación.','Email_Simulado',0,'2025-11-21 02:43:17'),(5,'ALU003','Su trámite de titulación ha cambiado al estado: Revisión de Carpeta','Sistema',0,'2025-11-21 03:09:17'),(6,'ALU003','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Revisión de Carpeta','Email_Simulado',0,'2025-11-21 03:09:17'),(7,'ALU003','Su trámite de titulación ha cambiado al estado: Designación de Jurado','Sistema',0,'2025-11-21 03:11:12'),(8,'ALU003','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Designación de Jurado','Email_Simulado',0,'2025-11-21 03:11:12'),(9,'ALU003','Su trámite de titulación ha cambiado al estado: Iniciado','Sistema',0,'2025-11-21 03:41:00'),(10,'ALU003','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Iniciado','Email_Simulado',0,'2025-11-21 03:41:00'),(11,'ALU003','Su trámite de titulación ha cambiado al estado: Designación de Jurado','Sistema',0,'2025-11-21 03:43:03'),(12,'ALU003','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Designación de Jurado','Email_Simulado',0,'2025-11-21 03:43:03'),(13,'ALU003','Su trámite de titulación ha cambiado al estado: Sustentación Programada. Revisa tu panel.','Sistema',0,'2025-11-21 03:48:28'),(14,'ALU003','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Sustentación Programada. Revisa tu panel.','Email_Simulado',0,'2025-11-21 03:48:28'),(15,'DOC001','Su trámite de titulación ha cambiado al estado: Ha sido designado Presidente de Jurado.','Sistema',0,'2025-11-21 03:48:29'),(16,'DOC001','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Ha sido designado Presidente de Jurado.','Email_Simulado',0,'2025-11-21 03:48:29'),(17,'DOC002','Su trámite de titulación ha cambiado al estado: Ha sido designado Secretario de Jurado.','Sistema',0,'2025-11-21 03:48:29'),(18,'DOC002','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Ha sido designado Secretario de Jurado.','Email_Simulado',0,'2025-11-21 03:48:29'),(19,'DOC005','Su trámite de titulación ha cambiado al estado: Ha sido designado Vocal de Jurado.','Sistema',0,'2025-11-21 03:48:29'),(20,'DOC005','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Ha sido designado Vocal de Jurado.','Email_Simulado',0,'2025-11-21 03:48:29'),(21,'ALU003','Su trámite de titulación ha cambiado al estado: Sustentación Programada','Sistema',0,'2025-11-21 04:01:36'),(22,'ALU003','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Sustentación Programada','Email_Simulado',0,'2025-11-21 04:01:36'),(23,'t01288g','Hemos recibido su documento: DNI. Está pendiente de validación.','Sistema',0,'2025-11-21 04:24:58'),(24,'t01288g','Copia de correo enviado: Hemos recibido su documento: DNI. Está pendiente de validación.','Email_Simulado',0,'2025-11-21 04:24:58'),(25,'ALU001','Hemos recibido su documento: Bachiller. Está pendiente de validación.','Sistema',0,'2025-11-21 04:47:01'),(26,'ALU001','Copia de correo enviado: Hemos recibido su documento: Bachiller. Está pendiente de validación.','Email_Simulado',0,'2025-11-21 04:47:01'),(27,'ALU001','Su trámite de titulación ha cambiado al estado: Documento Aprobado','Sistema',0,'2025-11-21 04:47:27'),(28,'ALU001','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Documento Aprobado','Email_Simulado',0,'2025-11-21 04:47:27'),(29,'ALU001','Hemos recibido su documento: DNI. Está pendiente de validación.','Sistema',0,'2025-11-21 04:50:19'),(30,'ALU001','Copia de correo enviado: Hemos recibido su documento: DNI. Está pendiente de validación.','Email_Simulado',0,'2025-11-21 04:50:19'),(31,'ALU001','Su trámite de titulación ha cambiado al estado: Documento Rechazado: ta feo','Sistema',0,'2025-11-21 04:50:41'),(32,'ALU001','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Documento Rechazado: ta feo','Email_Simulado',0,'2025-11-21 04:50:41'),(33,'ALU001','Hemos recibido su documento: DNI. Está pendiente de validación.','Sistema',0,'2025-11-21 04:50:54'),(34,'ALU001','Copia de correo enviado: Hemos recibido su documento: DNI. Está pendiente de validación.','Email_Simulado',0,'2025-11-21 04:50:54'),(35,'ALU001','Su trámite de titulación ha cambiado al estado: Documento Aprobado','Sistema',0,'2025-11-21 04:51:04'),(36,'ALU001','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Documento Aprobado','Email_Simulado',0,'2025-11-21 04:51:04'),(37,'ALU001','Hemos recibido su documento: Certificado_Idiomas. Está pendiente de validación.','Sistema',0,'2025-11-21 05:16:44'),(38,'ALU001','Copia de correo enviado: Hemos recibido su documento: Certificado_Idiomas. Está pendiente de validación.','Email_Simulado',0,'2025-11-21 05:16:44'),(39,'ALU001','Su trámite de titulación ha cambiado al estado: Documento Rechazado: error de archivo','Sistema',0,'2025-11-21 05:17:02'),(40,'ALU001','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Documento Rechazado: error de archivo','Email_Simulado',0,'2025-11-21 05:17:02'),(41,'ALU001','Hemos recibido su documento: Foto. Está pendiente de validación.','Sistema',0,'2025-11-21 05:32:24'),(42,'ALU001','Copia de correo enviado: Hemos recibido su documento: Foto. Está pendiente de validación.','Email_Simulado',0,'2025-11-21 05:32:24'),(43,'ALU001','Su trámite de titulación ha cambiado al estado: Documento Rechazado: ver archivo correcto','Sistema',0,'2025-11-21 05:32:42'),(44,'ALU001','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Documento Rechazado: ver archivo correcto','Email_Simulado',0,'2025-11-21 05:32:42'),(45,'ALU001','Hemos recibido su documento: Foto. Está pendiente de validación.','Sistema',0,'2025-11-21 05:39:56'),(46,'ALU001','Copia de correo enviado: Hemos recibido su documento: Foto. Está pendiente de validación.','Email_Simulado',0,'2025-11-21 05:39:56'),(47,'ALU001','Su trámite de titulación ha cambiado al estado: Documento Aprobado','Sistema',0,'2025-11-21 05:40:03'),(48,'ALU001','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Documento Aprobado','Email_Simulado',0,'2025-11-21 05:40:03'),(49,'ALU001','Hemos recibido su documento: Certificado_Idiomas. Está pendiente de validación.','Sistema',0,'2025-11-21 13:45:53'),(50,'ALU001','Copia de correo enviado: Hemos recibido su documento: Certificado_Idiomas. Está pendiente de validación.','Email_Simulado',0,'2025-11-21 13:45:53'),(51,'ALU001','Su trámite de titulación ha cambiado al estado: Documento Aprobado','Sistema',0,'2025-11-21 13:46:24'),(52,'ALU001','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Documento Aprobado','Email_Simulado',0,'2025-11-21 13:46:24'),(53,'ALU001','Su trámite de titulación ha cambiado al estado: Revisión de Carpeta','Sistema',0,'2025-11-21 13:48:11'),(54,'ALU001','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Revisión de Carpeta','Email_Simulado',0,'2025-11-21 13:48:11'),(55,'ALU003','Su trámite de titulación ha cambiado al estado: Sustentación Programada','Sistema',0,'2025-11-21 13:49:20'),(56,'ALU003','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Sustentación Programada','Email_Simulado',0,'2025-11-21 13:49:20'),(57,'DOC001','Su trámite de titulación ha cambiado al estado: Designado Presidente de Jurado','Sistema',0,'2025-11-21 13:49:20'),(58,'DOC001','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Designado Presidente de Jurado','Email_Simulado',0,'2025-11-21 13:49:20'),(59,'DOC002','Su trámite de titulación ha cambiado al estado: Designado Secretario de Jurado','Sistema',0,'2025-11-21 13:49:20'),(60,'DOC002','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Designado Secretario de Jurado','Email_Simulado',0,'2025-11-21 13:49:20'),(61,'DOC005','Su trámite de titulación ha cambiado al estado: Designado Vocal de Jurado','Sistema',0,'2025-11-21 13:49:20'),(62,'DOC005','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Designado Vocal de Jurado','Email_Simulado',0,'2025-11-21 13:49:20'),(63,'ALU001','Su trámite de titulación ha cambiado al estado: Designación de Jurado','Sistema',0,'2025-11-21 13:49:38'),(64,'ALU001','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Designación de Jurado','Email_Simulado',0,'2025-11-21 13:49:38'),(65,'ALU001','Su trámite de titulación ha cambiado al estado: Sustentación Programada','Sistema',0,'2025-11-21 13:50:39'),(66,'ALU001','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Sustentación Programada','Email_Simulado',0,'2025-11-21 13:50:39'),(67,'DOC005','Su trámite de titulación ha cambiado al estado: Designado Presidente de Jurado','Sistema',0,'2025-11-21 13:50:39'),(68,'DOC005','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Designado Presidente de Jurado','Email_Simulado',0,'2025-11-21 13:50:39'),(69,'DOC001','Su trámite de titulación ha cambiado al estado: Designado Secretario de Jurado','Sistema',0,'2025-11-21 13:50:39'),(70,'DOC001','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Designado Secretario de Jurado','Email_Simulado',0,'2025-11-21 13:50:39'),(71,'DOC006','Su trámite de titulación ha cambiado al estado: Designado Vocal de Jurado','Sistema',0,'2025-11-21 13:50:39'),(72,'DOC006','Copia de correo enviado: Su trámite de titulación ha cambiado al estado: Designado Vocal de Jurado','Email_Simulado',0,'2025-11-21 13:50:39');
/*!40000 ALTER TABLE `notificaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sustentaciones`
--

DROP TABLE IF EXISTS `sustentaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sustentaciones` (
  `id_sustentacion` int NOT NULL AUTO_INCREMENT,
  `id_tramite` int NOT NULL,
  `codigo_presidente` varchar(20) NOT NULL,
  `codigo_secretario` varchar(20) NOT NULL,
  `codigo_vocal` varchar(20) NOT NULL,
  `fecha_hora` timestamp NOT NULL,
  `lugar_enlace` varchar(255) DEFAULT NULL,
  `nota_final` decimal(4,2) DEFAULT NULL,
  `resultado_defensa` enum('Pendiente','Aprobado','Desaprobado') DEFAULT 'Pendiente',
  `observaciones` text,
  PRIMARY KEY (`id_sustentacion`),
  KEY `id_tramite` (`id_tramite`),
  KEY `codigo_presidente` (`codigo_presidente`),
  KEY `codigo_secretario` (`codigo_secretario`),
  KEY `codigo_vocal` (`codigo_vocal`),
  CONSTRAINT `sustentaciones_ibfk_1` FOREIGN KEY (`id_tramite`) REFERENCES `tramites` (`id_tramite`) ON DELETE CASCADE,
  CONSTRAINT `sustentaciones_ibfk_2` FOREIGN KEY (`codigo_presidente`) REFERENCES `usuarios` (`codigo`),
  CONSTRAINT `sustentaciones_ibfk_3` FOREIGN KEY (`codigo_secretario`) REFERENCES `usuarios` (`codigo`),
  CONSTRAINT `sustentaciones_ibfk_4` FOREIGN KEY (`codigo_vocal`) REFERENCES `usuarios` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sustentaciones`
--

LOCK TABLES `sustentaciones` WRITE;
/*!40000 ALTER TABLE `sustentaciones` DISABLE KEYS */;
INSERT INTO `sustentaciones` VALUES (1,2,'DOC001','DOC002','DOC005','2025-11-22 08:48:00','Auditorio 1',NULL,'Pendiente',NULL),(2,1,'DOC005','DOC001','DOC006','2025-11-28 22:00:00','Auditorio 3',NULL,'Pendiente',NULL);
/*!40000 ALTER TABLE `sustentaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tesis`
--

DROP TABLE IF EXISTS `tesis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tesis` (
  `id_tesis` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(500) NOT NULL,
  `codigo_estudiante` varchar(20) NOT NULL,
  `codigo_docente_revisor` varchar(20) DEFAULT NULL,
  `estado` enum('Iniciado','En Proceso','Necesita Correcciones','Aprobado') DEFAULT 'Iniciado',
  `archivo_path` varchar(500) DEFAULT NULL,
  `fecha_subida` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tesis`),
  KEY `codigo_estudiante` (`codigo_estudiante`),
  KEY `codigo_docente_revisor` (`codigo_docente_revisor`),
  CONSTRAINT `tesis_ibfk_1` FOREIGN KEY (`codigo_estudiante`) REFERENCES `usuarios` (`codigo`),
  CONSTRAINT `tesis_ibfk_2` FOREIGN KEY (`codigo_docente_revisor`) REFERENCES `usuarios` (`codigo`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tesis`
--

LOCK TABLES `tesis` WRITE;
/*!40000 ALTER TABLE `tesis` DISABLE KEYS */;
INSERT INTO `tesis` VALUES (14,'Residuo De Basura en la Upla','ALU002','DOC001','Aprobado','Reglamento-General-de-Bibliotecas.pdf','2025-11-17 13:01:20'),(16,'IMPLEMENTACIÓN DEL DASHBOARD EN LA PRODUCTIVIDAD DEL ÁREA DE OPERACIONES DE UNA EMPRESA MINERA','ALU003','DOC005','En Proceso','T037_70225272_T.pdf','2025-11-21 02:28:11'),(19,'aasdasdasdas','t01288g','DOC001','Necesita Correcciones','T037_20051118_M.pdf','2025-11-21 04:23:29'),(20,'Sistema Web para Educación con Inteligencia Artificial','ALU001','DOC001','Necesita Correcciones','Reglamento-General-de-Bibliotecas.pdf','2025-11-21 05:53:16');
/*!40000 ALTER TABLE `tesis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tramites`
--

DROP TABLE IF EXISTS `tramites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tramites` (
  `id_tramite` int NOT NULL AUTO_INCREMENT,
  `codigo_estudiante` varchar(20) NOT NULL,
  `estado_actual` enum('Iniciado','Revisión de Carpeta','Designación de Jurado','Apto para Sustentar','Sustentación Programada','Titulado') DEFAULT 'Iniciado',
  `fecha_inicio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tramite`),
  KEY `fk_tramite_usuario` (`codigo_estudiante`),
  CONSTRAINT `fk_tramite_usuario` FOREIGN KEY (`codigo_estudiante`) REFERENCES `usuarios` (`codigo`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tramites`
--

LOCK TABLES `tramites` WRITE;
/*!40000 ALTER TABLE `tramites` DISABLE KEYS */;
INSERT INTO `tramites` VALUES (1,'ALU001','Sustentación Programada','2025-11-21 02:40:11','2025-11-21 13:50:39'),(2,'ALU003','Sustentación Programada','2025-11-21 02:40:31','2025-11-21 03:48:28'),(3,'ALU002','Iniciado','2025-11-21 04:14:04','2025-11-21 04:14:04'),(4,'t01288g','Iniciado','2025-11-21 04:24:35','2025-11-21 04:24:35'),(5,'T00049K','Iniciado','2025-11-21 04:33:05','2025-11-21 04:33:05');
/*!40000 ALTER TABLE `tramites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `codigo` varchar(20) NOT NULL,
  `nombres` varchar(150) NOT NULL,
  `apellidos` varchar(150) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('admin','docente','alumno') NOT NULL,
  PRIMARY KEY (`codigo`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES ('ADM001','Pedro','Perez Lopez','admin@ms.upla.edu.pe','admin123','admin'),('ALU001','Diego','Flores Yupanqui','a.dflores@ms.upla.edu.pe','diego123','alumno'),('ALU002','Jefferson Luis','Paredes Yauri','t01304d@ms.upla.edu.pe','ALU002','alumno'),('ALU003','Juan Pepe','Perez Villaba','juan@gmail.com','ALU003','alumno'),('DOC001','Raúl','Fernández Bejarano','d.rfernandez@ms.upla.edu.pe','raul123','docente'),('DOC002','Karina Luz','Cruz Oscanoa','d.kcruz@ms.upla.edu.pe','karina123','docente'),('DOC005','Walter','Estares Ventocilla','d.westaresv@ms.upla.edu.pe','DOC005','docente'),('DOC006','Juan Carlos','Cotrina Aliaga','d.jcotrinaa@ms.upla.edu.pe','DOC006','docente'),('T00049K','Frank','Matías Urcuhuaranga','T00049K@ms.upla.edu.pe','T00049K','alumno'),('t01288g','Esteban','Galarza Inga','t01288g@ms.upla.edu.pe','t01288g','alumno');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'bdgestiontesis'
--

--
-- Dumping routines for database 'bdgestiontesis'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-21 10:26:04
