/*=============================================================================
 * sintactico.pl — Gramática DCG y árbol de constituyentes
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Tipos de oración:
 *   o   — oración simple
 *   oc  — oración coordinada
 *   or  — oración subordinada de relativo
 *   ocm — oración compuesta
 *
 * Grupos sintácticos:
 *   gn   — grupo nominal
 *   gv   — grupo verbal
 *   gadj — grupo adjetival
 *   gadv — grupo adverbial
 *   gp   — grupo preposicional
 *
 * Léxico:
 *   det, n, v, adj, adv, conj, prep
 *=============================================================================*/

:- module(sintactico, [oración/3, simplificar/2]).
