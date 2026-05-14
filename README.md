# Quindioflix

Proyecto académico de la asignatura Bases de Datos II · Universidad del Quindío  
Modelado, implementación y administración completa de una base de datos Oracle para 
una plataforma de streaming tipo Netflix.

## Descripción

QuindíoFlix es un sistema de gestión de contenido multimedia con suscripciones, 
perfiles de usuario, historial de reproducciones y análisis de rendimiento. 
El proyecto cubre el ciclo completo de una base de datos relacional en Oracle: 
desde el diseño del modelo hasta la administración de acceso y optimización de consultas.

## Estructura del repositorio

| Archivo | Descripción |
|---|---|
| `#1_Documento_proyecto_quindioflix.docx` | Documento general del proyecto |
| `#2_Mer_completo.png` | Diagrama entidad-relación completo |
| `#2_Modelo_relacional_normalizado.png` | Modelo relacional normalizado |
| `#3_creacion_de_tablas.sql` | DDL completo — 17 tablas con restricciones e integridad referencial |
| `#4_insercion_de_datos.sql` | Datos de prueba para todas las entidades |
| `#5_nucleo1_QuindioFlix.sql` | Consultas avanzadas parametrizadas con variables de sustitución (`&`, `DEFINE`) |
| `#6_nucleo2_QuindioFlix.sql` | Cursores explícitos e implícitos, procedimientos y funciones PL/SQL |
| `#7_nucleo3_QuindioFlix.sql` | Transacciones críticas con COMMIT/ROLLBACK y manejo de concurrencia |
| `#8_nucleo4_QuindioFlix.sql` | Índices compuestos y únicos con análisis EXPLAIN PLAN |
| `#8_captura_comparacion_de_costos.png` | Captura — comparación de costos con y sin índice |
| `#8_captura_creacion_de_indices.png` | Captura — creación de índices en SQL Developer |
| `#8_captura_explain_plan_con_indice.png` | Captura — EXPLAIN PLAN con índice activo |
| `#8_captura_explain_plan_sin_indice.png` | Captura — EXPLAIN PLAN sin índice (full table scan) |
| `#8_captura_monitoreo_de_usos.png` | Captura — monitoreo de uso de índices |
| `#9_nucleo5_QuindioFlix.sql` | Roles, usuarios y gestión de privilegios de acceso |
| `#10_documento_de_sustentacion.docx` | Documento de sustentación del proyecto |

## Tecnologías

- Oracle Database 19c
- SQL*Plus / SQL Developer
- PL/SQL

## Temas implementados

- Diseño ER normalizado (17 entidades)
- Consultas parametrizadas con `&` y `DEFINE`
- Cursores explícitos e implícitos
- Transacciones con control de estados (ACTIVA → CONFIRMADA / ABORTADA)
- Índices compuestos con justificación de rendimiento y comparación de costos
- Análisis de rendimiento con `EXPLAIN PLAN`
- Roles y usuarios con privilegios diferenciados (ADMIN, ANALISTA, SOPORTE, CONTENIDO)
