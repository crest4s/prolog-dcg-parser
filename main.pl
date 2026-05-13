% ===========================================================================
%  main.pl  —  Punto de entrada del sistema
%  Práctica 2: Conocimiento y Razonamiento Automatizado, UAH 2025-26
%
%  Carga todos los módulos en orden de dependencia:
%    lexico.pl        — léxico terminal (cargado por sintactico.pl)
%    draw.pl          — renderizado ASCII del árbol (cargado por sintactico.pl)
%    sintactico.pl    — gramática DCG + simplificación
%    semantico.pl     — hechos tipo/2 (cargado por deteccion.pl)
%    deteccion.pl     — ambigüedad, incoherencia, metáforas
%    mejoras.pl       — preprocesamiento, flexión, explicaciones
%    conjunto_oraciones.pl — corpus de 30 oraciones (frase/3)
%
%  Uso:
%    ?- consult('main.pl').
%    ?- inicio.               % muestra menú de ayuda rápida
%    ?- demo.                 % analiza las oraciones 1, 4 y 10
% ===========================================================================

:- consult(sintactico).
:- consult(deteccion).
:- consult(mejoras).
:- consult(conjunto_oraciones).


% ===========================================================================
%  INICIO RÁPIDO
%  Imprime un resumen de los predicados disponibles al cargar el sistema.
% ===========================================================================

inicio :-
    format("~n╔══════════════════════════════════════════════════════╗~n"),
    format("║  Sistema DCG — Física Cuántica (UAH 2025-26)         ║~n"),
    format("╠══════════════════════════════════════════════════════╣~n"),
    format("║  ANÁLISIS SINTÁCTICO                                 ║~n"),
    format("║    oracion(X, Tokens, []), draw(X).                  ║~n"),
    format("║    simplificar(Tokens, Simples).                     ║~n"),
    format("╠══════════════════════════════════════════════════════╣~n"),
    format("║  ANÁLISIS SEMÁNTICO                                  ║~n"),
    format("║    analizar(Id).          % corpus por número        ║~n"),
    format("║    analizar_oracion(Ts).  % lista de tokens manual   ║~n"),
    format("╠══════════════════════════════════════════════════════╣~n"),
    format("║  MEJORAS                                             ║~n"),
    format("║    preprocesar(String, Ts).  % tokenización          ║~n"),
    format("║    normalizar_tokens(Ts, Ns). % flexión plurales     ║~n"),
    format("║    explicar_analisis(Ts).    % reporte en español    ║~n"),
    format("║    analizar_texto(String).   % flujo completo        ║~n"),
    format("╠══════════════════════════════════════════════════════╣~n"),
    format("║  CORPUS                                              ║~n"),
    format("║    frase(Id, Tipo, Tokens). % oraciones 1-30         ║~n"),
    format("║    demo.                    % muestra 3 oraciones    ║~n"),
    format("╚══════════════════════════════════════════════════════╝~n~n").


% ===========================================================================
%  DEMO
%  Ejecuta explicar_analisis sobre tres oraciones representativas del corpus:
%    Oración  1 — oración simple correcta
%    Oración  4 — oración problemática (metáfora)
%    Oración 10 — oración coordinada (ambigüedad)
% ===========================================================================

demo :-
    format("~n*** DEMO: análisis de oraciones 1, 4 y 10 ***~n"),
    forall(member(Id, [1, 4, 10]),
           ( frase(Id, Tipo, Tokens),
             format("~n--- Oración ~w [~w] ---~n", [Id, Tipo]),
             explicar_analisis(Tokens)
           )).
