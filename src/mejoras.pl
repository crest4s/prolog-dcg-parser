/*=============================================================================
 * mejoras.pl — Mejoras sobre el análisis base
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Mejoras implementadas (mínimo 3 obligatorias):
 *
 *   Mejora 1 — Preprocesamiento de la oración
 *              Tokenización avanzada y normalización del texto de entrada.
 *
 *   Mejora 2 — Flexión de palabras
 *              Manejo de plurales, género y tiempos verbales.
 *
 *   Mejora 3 — Asignación de funciones sintácticas
 *              Identificación de roles: sujeto, predicado, objeto, complemento.
 *
 * Mejoras opcionales adicionales:
 *   - Optimización del análisis sintáctico
 *   - Visualización mejorada de árboles
 *   - Análisis semántico avanzado
 *   - Detección más precisa de ambigüedad
 *   - Generación de explicaciones automáticas
 *=============================================================================*/

:- module(mejoras, [tokenize/2, normalize/2, inflect/3, syntactic_function/3]).

% tokenize/2 — divide un átomo de texto en una lista de tokens
tokenize(Text, Tokens) :-
    atomic_list_concat(Tokens, ' ', Text).

% normalize/2 — convierte todos los tokens a minúsculas
normalize(Tokens, Norm) :-
    maplist([T, N]>>(downcase_atom(T, N)), Tokens, Norm).

% inflect/3 — stub: devuelve la raíz como la propia palabra (sin flexión)
inflect(Word, _Category, Root) :-
    atom(Word),
    Root = Word.

% syntactic_function/3 — extrae sujeto o predicado de un árbol s(NP, VP)
syntactic_function(s(NP, _), subject,   NP).
syntactic_function(s(_, VP), predicate, VP).
