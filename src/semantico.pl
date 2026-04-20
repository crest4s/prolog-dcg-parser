/*=============================================================================
 * semantico.pl — Enriquecimiento semántico
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Hechos de la forma:  tipo(+Palabra, +Categoría)
 *
 * Ejemplos:
 *   tipo(inflacion, fenomeno_economico).
 *   tipo(banco, institucion_financiera).
 *   tipo(banco, objeto_fisico).
 *   tipo(crecer, proceso).
 *   tipo(comer, accion_fisica).
 *=============================================================================*/

:- module(semantico, [tipo/2, categoria_semantica/2]).
