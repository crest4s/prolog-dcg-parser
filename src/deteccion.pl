/*=============================================================================
 * deteccion.pl — Detección de problemas en la traducción ES→EN
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Este módulo detecta tres tipos de problemas en la traducción:
 *
 *   2.3.1 Ambigüedad léxica
 *         Palabras en inglés con múltiples interpretaciones posibles.
 *         Ej: "it" (pronombre) puede referirse a distintos antecedentes.
 *
 *   2.3.2 Cambio de estructura sintáctica
 *         La traducción usa una construcción gramaticalmente diferente
 *         al original: nominalizaciones → gerundios, deixis alterada, etc.
 *
 *   2.3.3 Pérdida de referencia o matiz semántico
 *         El significado original se modifica o se pierde parcialmente
 *         en la traducción.
 *
 * Predicados exportados:
 *   translation_problem/3 — translation_problem(+ID, -Type, -Description)
 *   ambiguity/2           — ambiguity(+ID, -Description)
 *   structure_change/2    — structure_change(+ID, -Description)
 *   reference_loss/2      — reference_loss(+ID, -Description)
 *   detect_problems/1     — detect_problems(+ID) — imprime informe
 *=============================================================================*/

:- module(deteccion, [
    translation_problem/3,
    ambiguity/2,
    structure_change/2,
    reference_loss/2,
    detect_problems/1
]).

:- discontiguous translation_problem/3.
:- discontiguous structure_change/2.
:- discontiguous ambiguity/2.
:- discontiguous reference_loss/2.

:- use_module(conjunto_oraciones).

% =============================================================================
% Base de conocimiento — problemas detectados por oración
% =============================================================================

% --- Oración 4 — Problemática ---
% "aquellas tan pequeñas" → "those so small that"
% La subordinada relativa explicativa pierde la referencia anafórica de
% "aquellas" (pronombre demostrativo que retoma "partículas subatómicas").
% En inglés "those" no señala tan claramente al antecedente nominal.
translation_problem(4, structure_change,
    'La subordinada relativa explicativa "aquellas tan pequeñas que" \
se traduce como "those so small that", perdiendo la referencia \
anafórica del demostrativo español "aquellas".').

structure_change(4, Desc) :- translation_problem(4, structure_change, Desc).

% --- Oración 10 — Ambigua ---
% "energía característica de él" → "energy characteristic of it"
% El pronombre "it" puede referirse tanto al objeto como a la energía,
% creando ambigüedad pronominal inexistente en el original.
translation_problem(10, ambiguity,
    'El pronombre "it" en "energy characteristic of it" es ambiguo: \
puede referirse al objeto ("object") o a la energía ("energy"), \
mientras que el español "él" tiene antecedente más claro en contexto.').

ambiguity(10, Desc) :- translation_problem(10, ambiguity, Desc).

% --- Oración 16 — Problemática ---
% "esa nueva concepción" → "this new conception"
% El demostrativo "esa" (distancia media, referencia conocida) se traduce
% como "this" (deixis próxima), alterando la distancia discursiva original.
translation_problem(16, structure_change,
    'El demostrativo "esa" (distancia media) se traduce como "this" \
(distancia próxima), modificando la deixis discursiva del original \
e implicando mayor cercanía de la que el autor expresa en español.').

structure_change(16, Desc) :- translation_problem(16, structure_change, Desc).

% --- Oración 17 — Problemática ---
% "jugando un papel fundamental" — gerundio causal en español →
% "playing a fundamental role" — participio libre en inglés
% Se pierde el matiz de simultaneidad/causa que introduce el gerundio español.
translation_problem(17, structure_change,
    'El gerundio "jugando" introduce una acción simultánea con matiz \
causal en español. En inglés "playing" funciona como participio libre \
adjunto, perdiendo la relación de causa-efecto con la oración principal.').

structure_change(17, Desc) :- translation_problem(17, structure_change, Desc).

% --- Oración 20 — Problemática ---
% "en la formulación de" → "in formulating"
% Nominalización española → gerundio inglés.
% El registro nominal es más formal y específico que el registro verbal
% del gerundio.
translation_problem(20, structure_change,
    'La nominalización "en la formulación de" se traduce como gerundio \
"in formulating", cambiando el registro: la construcción nominal \
española es más abstracta y formal que el gerundio inglés.').

structure_change(20, Desc) :- translation_problem(20, structure_change, Desc).

% --- Oración 24 — Problemática ---
% "apostando a que" → "betting that"
% En español "apostando a que" introduce una subordinada sustantiva
% (CD de apostando); en inglés "betting that" funciona como participio
% adjunto, perdiendo la estructura de complemento directo.
translation_problem(24, structure_change,
    '"Apostando a que" introduce una subordinada sustantiva con función \
de CD en español. "Betting that" funciona como participio adjunto \
en inglés, perdiendo la estructura de complemento directo verbal.').

structure_change(24, Desc) :- translation_problem(24, structure_change, Desc).

% --- Oración 29 — Problemática ---
% Sujeto implícito en español → "it" explícito en inglés
% El español admite sujeto gramatical nulo; el inglés obliga a un
% pronombre expletivo "it" que introduce ambigüedad referencial.
translation_problem(29, reference_loss,
    'El español tiene sujeto gramatical implícito ("jugó" sin sujeto \
léxico). En inglés es obligatorio el sujeto explícito "it", que \
introduce ambigüedad sobre a qué referente del discurso alude.').

reference_loss(29, Desc) :- translation_problem(29, reference_loss, Desc).

% --- Oración 30 — Problemática ---
% "lo cual" → "which"
% "Lo cual" en español retoma toda la proposición anterior (antecedente
% oracional). En inglés "which" puede referirse al sustantivo más próximo
% ("barriers"), creando ambigüedad de alcance del relativo.
translation_problem(30, ambiguity,
    '"Lo cual" en español tiene antecedente oracional claro (toda la \
proposición previa). En inglés "which" puede referirse al sustantivo \
más próximo ("barriers"), creando ambigüedad de alcance del relativo.').

ambiguity(30, Desc) :- translation_problem(30, ambiguity, Desc).

% =============================================================================
% detect_problems/1 — imprime el informe de problemas de una oración
% =============================================================================

detect_problems(ID) :-
    integer(ID), !,
    (   conjunto_oraciones:oracion(ID, Type, Class, TokensEN)
    ->  conjunto_oraciones:oracion_es(ID, TokensES),
        format("~`=t~60|~n"),
        format("Translation Analysis — Sentence ~w | Type: ~w | Class: ~w~n",
               [ID, Type, Class]),
        format("~`-t~60|~n"),
        format("EN: ~w~n", [TokensEN]),
        format("ES: ~w~n", [TokensES]),
        format("~`-t~60|~n"),
        report_class(ID, Class)
    ;   format("No sentence with ID ~w in the corpus.~n", [ID])
    ).

report_class(_, correcta) :-
    format("Class: correcta — No translation problems detected.~n").

report_class(ID, ambigua) :-
    format("Class: ambigua — Potential lexical or structural ambiguity.~n~n"),
    (   ambiguity(ID, Desc)
    ->  format("  Ambiguity: ~w~n", [Desc])
    ;   format("  (No specific problem registered for this ID.)~n")
    ).

report_class(ID, problematica) :-
    format("Class: problematica — Syntactic divergence from original.~n~n"),
    (   translation_problem(ID, Type, Desc)
    ->  format("  Problem type: ~w~n", [Type]),
        format("  Description: ~w~n", [Desc])
    ;   format("  (No specific problem registered for this ID.)~n")
    ).
