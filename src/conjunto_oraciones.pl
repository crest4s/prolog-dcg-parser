/*=============================================================================
 * conjunto_oraciones.pl — Corpus de oraciones del dominio
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Dominio:  (completar)
 * Fuente:   (completar con referencia completa: autor, título, año, URL/editorial)
 * Tamaño:   ≥ 30 oraciones  (+5 por cada integrante adicional sobre 3)
 *
 * Formato de cada oración:
 *
 *   oracion(ID, Tipo, Clase, Tokens).
 *
 *   ID     — identificador numérico único
 *   Tipo   — o | oc | or | ocm
 *   Clase  — correcta | ambigua | problematica
 *   Tokens — lista de átomos en minúsculas sin puntuación
 *
 * Ejemplo:
 *   oracion(1, o, correcta,
 *       [el, banco, central, subio, los, tipos, de, interes]).
 *   oracion(2, oc, ambigua,
 *       [el, banco, esta, en, la, esquina, y, guarda, los, ahorros]).
 *   oracion(3, o, problematica,
 *       [la, inflacion, come, los, ahorros]).
 *=============================================================================*/

:- module(conjunto_oraciones, [oracion/4]).
