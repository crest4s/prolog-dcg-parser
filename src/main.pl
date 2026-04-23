/*=============================================================================
 * main.pl — Punto de entrada del sistema
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================*/

:- module(main, [analizar/1, analizar_arbol/2, detectar/1]).

:- use_module(sintactico).
:- use_module(semantico).
:- use_module(deteccion).
:- use_module(mejoras).
:- use_module(conjunto_oraciones).
:- use_module(draw).

% =============================================================================
% analizar(+ID)     — analiza la oración con ese ID del corpus
% analizar(+Tokens) — analiza directamente una lista de tokens
% =============================================================================

analizar(ID) :-
    integer(ID), !,
    (   conjunto_oraciones:oracion(ID, Tipo, Clase, Tokens)
    ->  format("~`=t~50|~n"),
        format("Oración ~w | Tipo: ~w | Clase: ~w~n", [ID, Tipo, Clase]),
        format("Tokens: ~w~n", [Tokens]),
        format("~`-t~50|~n"),
        sintactico:simplificar_y_dibujar(Tokens)
    ;   format("No existe oración con ID ~w en el corpus.~n", [ID])
    ).

analizar(Tokens) :-
    is_list(Tokens), !,
    sintactico:simplificar_y_dibujar(Tokens).

% =============================================================================
% analizar_arbol(+Tokens, -Arboles)
% Parsea los tokens y devuelve la lista de árboles sintácticos.
% =============================================================================

analizar_arbol(Tokens, Arboles) :-
    sintactico:oración(Arboles, Tokens, []).

% =============================================================================
% detectar(+ID)
% Informa sobre la clase semántica de la oración del corpus.
% =============================================================================

detectar(ID) :-
    integer(ID), !,
    (   conjunto_oraciones:oracion(ID, Tipo, Clase, Tokens)
    ->  format("~`=t~50|~n"),
        format("Detección — Oración ~w | Tipo: ~w~n", [ID, Tipo]),
        format("~`-t~50|~n"),
        detectar_clase(Clase, Tokens)
    ;   format("No existe oración con ID ~w en el corpus.~n", [ID])
    ).

detectar_clase(correcta, _) :-
    format("Clase: correcta — No se detectaron problemas.~n").
detectar_clase(ambigua, Tokens) :-
    format("Clase: ambigua — La oración presenta posible ambigüedad léxica o estructural.~n"),
    format("Tokens: ~w~n", [Tokens]).
detectar_clase(problematica, Tokens) :-
    format("Clase: problematica — La oración contiene un uso no estándar o incoherente.~n"),
    format("Tokens: ~w~n", [Tokens]).
