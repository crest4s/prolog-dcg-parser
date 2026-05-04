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
 *              Identificación de roles: CD, CI, CC, Atributo, etc.
 *
 * Mejoras opcionales adicionales:
 *   - Optimización del análisis sintáctico
 *   - Visualización mejorada de árboles
 *   - Análisis semántico avanzado
 *   - Detección más precisa de ambigüedad
 *   - Generación de explicaciones automáticas
 *=============================================================================*/

:- module(mejoras, [tokenizar/2, normalizar/2, flexion/3, funcion_sintactica/3]).

% Stub implementations — to be developed in future iterations

tokenizar(Text, Tokens) :-
    atomic_list_concat(Tokens, ' ', Text).

normalizar(Tokens, Norm) :-
    maplist([T, N]>>(downcase_atom(T, N)), Tokens, Norm).

flexion(Palabra, _Categoria, Raiz) :-
    atom(Palabra),
    Raiz = Palabra.

funcion_sintactica(o(GN, _), sujeto, GN).
funcion_sintactica(o(_, GV), predicado, GV).
