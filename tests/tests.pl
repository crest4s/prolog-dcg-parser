/*=============================================================================
 * tests/tests.pl — Suite de tests PLUnit
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Cómo añadir tests:
 *   :- begin_tests(nombre_grupo).
 *   test(nombre_test) :- <goal que debe ser verdadero>.
 *   test(nombre_test, fail) :- <goal que debe fallar>.
 *   test(nombre_test, throws(error(_,_))) :- <goal que debe lanzar error>.
 *   :- end_tests(nombre_grupo).
 *
 * Ejecución local:
 *   swipl -g "run_tests, halt" -t "halt(1)" tests/tests.pl
 *=============================================================================*/

:- use_module(library(plunit)).

% Añade src/ al path de búsqueda de módulos
:- assertz(file_search_path(src, 'src')).

% -----------------------------------------------------------------------------
% Carga de módulos
% -----------------------------------------------------------------------------
:- use_module('../src/sintactico').
:- use_module('../src/semantico').
:- use_module('../src/deteccion').
:- use_module('../src/mejoras').
:- use_module('../src/conjunto_oraciones').

% -----------------------------------------------------------------------------
% Tests: carga de módulos
% Los módulos deben cargarse sin errores de compilación.
% -----------------------------------------------------------------------------
:- begin_tests(carga_modulos).

test(sintactico_cargado) :-
    current_module(sintactico).

test(semantico_cargado) :-
    current_module(semantico).

test(deteccion_cargado) :-
    current_module(deteccion).

test(mejoras_cargado) :-
    current_module(mejoras).

test(conjunto_oraciones_cargado) :-
    current_module(conjunto_oraciones).

:- end_tests(carga_modulos).

% -----------------------------------------------------------------------------
% Tests: corpus de oraciones
% Al menos 30 oraciones deben estar definidas.
% -----------------------------------------------------------------------------
:- begin_tests(corpus).

test(corpus_no_vacio) :-
    aggregate_all(count, conjunto_oraciones:oracion(_, _, _, _), N),
    N > 0.

test(corpus_minimo_30_oraciones) :-
    aggregate_all(count, conjunto_oraciones:oracion(_, _, _, _), N),
    N >= 30.

test(ids_unicos) :-
    findall(ID, conjunto_oraciones:oracion(ID, _, _, _), IDs),
    sort(IDs, Sorted),
    length(IDs, N),
    length(Sorted, N).

test(tipos_validos) :-
    forall(
        conjunto_oraciones:oracion(_, Tipo, _, _),
        memberchk(Tipo, [o, oc, or, ocm])
    ).

test(clases_validas) :-
    forall(
        conjunto_oraciones:oracion(_, _, Clase, _),
        memberchk(Clase, [correcta, ambigua, problematica])
    ).

:- end_tests(corpus).

% -----------------------------------------------------------------------------
% Tests: análisis sintáctico
% Añadir aquí tests concretos cuando se implemente la DCG.
% -----------------------------------------------------------------------------
:- begin_tests(sintactico_dcg).

% Ejemplo — descomentar cuando sintactico.pl esté implementado:
%
% test(oracion_simple_correcta) :-
%     oración([el, banco, central, subio, los, tipos, de, interes], _, []).
%
% test(oracion_invalida, fail) :-
%     oración([subio, el, de, interes], _, []).

:- end_tests(sintactico_dcg).

% -----------------------------------------------------------------------------
% Tests: detección de problemas
% Añadir aquí tests concretos cuando se implemente deteccion.pl.
% -----------------------------------------------------------------------------
:- begin_tests(deteccion_problemas).

% Ejemplo — descomentar cuando deteccion.pl esté implementado:
%
% test(detecta_ambiguedad) :-
%     ambigüedad(banco, _).
%
% test(detecta_incoherencia) :-
%     incoherencia([la, inflacion, come, los, ahorros], _).

:- end_tests(deteccion_problemas).
