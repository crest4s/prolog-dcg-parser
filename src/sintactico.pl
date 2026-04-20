/*=============================================================================
 * sintactico.pl — Gramática DCG básica
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

:- module(sintactico, [oración/3]).

oración(Arbol, Tokens, Resto) :-
    phrase(oracion(Arbol), Tokens, Resto).

oracion(o(GN, GV)) -->
    grupo_nominal(GN),
    grupo_verbal(GV).

grupo_nominal(gn(N)) -->
    nombre(N).

grupo_nominal(gn(Det, N)) -->
    determinante(Det),
    nombre(N).

grupo_nominal(gn(Det, N, Adj)) -->
    determinante(Det),
    nombre(N),
    adjetivo(Adj).

grupo_nominal(gn(Det, N, GP)) -->
    determinante(Det),
    nombre(N),
    grupo_preposicional(GP).

grupo_nominal(gn(Det, N, Adj, GP)) -->
    determinante(Det),
    nombre(N),
    adjetivo(Adj),
    grupo_preposicional(GP).

grupo_verbal(gv(V)) -->
    verbo_intransitivo(V).

grupo_verbal(gv(V, GN)) -->
    verbo_transitivo(V),
    grupo_nominal(GN).

grupo_verbal(gv(V, GA)) -->
    verbo_copulativo(V),
    grupo_adjetival(GA).

grupo_verbal(gv(V, GN, GP)) -->
    verbo_transitivo(V),
    grupo_nominal(GN),
    grupo_preposicional(GP).

grupo_adjetival(gadj(Adj)) -->
    adjetivo(Adj).

grupo_adverbial(gadv(Adv)) -->
    adverbio(Adv).

grupo_preposicional(gp(Prep, GN)) -->
    preposicion(Prep),
    grupo_nominal(GN).
