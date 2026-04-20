/*=============================================================================
 * deteccion.pl — Detección de problemas de interpretación
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Módulos de detección:
 *
 *   2.3.1 Ambigüedad léxica
 *         Palabras con múltiples significados dentro del dominio.
 *         Ej: banco → institucion_financiera | objeto_fisico
 *
 *   2.3.2 Incoherencia semántica
 *         Combinaciones incompatibles entre sujeto y predicado.
 *         Ej: "La inflación come los ahorros"
 *
 *   2.3.3 Uso no literal (metáforas simples)
 *         Verbos empleados fuera de su contexto habitual.
 *         Ej: "El mercado se desplomó"
 *=============================================================================*/

:- module(deteccion, [detectar/1, ambigüedad/2, incoherencia/2, metafora/2]).
