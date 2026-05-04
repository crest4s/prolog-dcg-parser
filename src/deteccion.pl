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
 *   problema_traduccion/3  — problema_traduccion(+ID, -Tipo, -Descripcion)
 *   ambiguedad/2           — ambiguedad(+ID, -Descripcion)
 *   cambio_estructura/2    — cambio_estructura(+ID, -Descripcion)
 *   perdida_referencia/2   — perdida_referencia(+ID, -Descripcion)
 *   detectar_problemas/1   — detectar_problemas(+ID) — imprime informe
 *=============================================================================*/

:- module(deteccion, [
    problema_traduccion/3,
    ambiguedad/2,
    cambio_estructura/2,
    perdida_referencia/2,
    detectar_problemas/1
]).

:- discontiguous problema_traduccion/3.
:- discontiguous cambio_estructura/2.
:- discontiguous ambiguedad/2.
:- discontiguous perdida_referencia/2.

:- use_module(conjunto_oraciones).

% =============================================================================
% Base de conocimiento — problemas detectados por oración
% =============================================================================

% --- Oración 4 — Problemática ---
% "aquellas tan pequeñas" → "those so small that"
% La subordinada relativa explicativa pierde la referencia anafórica de
% "aquellas" (pronombre demostrativo que retoma "partículas subatómicas").
% En inglés "those" no señala tan claramente al antecedente nominal.
problema_traduccion(4, cambio_estructura,
    'La subordinada relativa explicativa "aquellas tan pequeñas que" \
se traduce como "those so small that", perdiendo la referencia \
anafórica del demostrativo español "aquellas".').

cambio_estructura(4, Desc) :- problema_traduccion(4, cambio_estructura, Desc).

% --- Oración 10 — Ambigua ---
% "energía característica de él" → "energy characteristic of it"
% El pronombre "it" puede referirse tanto al objeto como a la energía,
% creando ambigüedad pronominal inexistente en el original.
problema_traduccion(10, ambiguedad,
    'El pronombre "it" en "energy characteristic of it" es ambiguo: \
puede referirse al objeto ("object") o a la energía ("energy"), \
mientras que el español "él" tiene antecedente más claro en contexto.').

ambiguedad(10, Desc) :- problema_traduccion(10, ambiguedad, Desc).

% --- Oración 16 — Problemática ---
% "esa nueva concepción" → "this new conception"
% El demostrativo "esa" (distancia media, referencia conocida) se traduce
% como "this" (deixis próxima), alterando la distancia discursiva original.
problema_traduccion(16, cambio_estructura,
    'El demostrativo "esa" (distancia media) se traduce como "this" \
(distancia próxima), modificando la deixis discursiva del original \
e implicando mayor cercanía de la que el autor expresa en español.').

cambio_estructura(16, Desc) :- problema_traduccion(16, cambio_estructura, Desc).

% --- Oración 17 — Problemática ---
% "jugando un papel fundamental" — gerundio causal en español →
% "playing a fundamental role" — participio libre en inglés
% Se pierde el matiz de simultaneidad/causa que introduce el gerundio español.
problema_traduccion(17, cambio_estructura,
    'El gerundio "jugando" introduce una acción simultánea con matiz \
causal en español. En inglés "playing" funciona como participio libre \
adjunto, perdiendo la relación de causa-efecto con la oración principal.').

cambio_estructura(17, Desc) :- problema_traduccion(17, cambio_estructura, Desc).

% --- Oración 20 — Problemática ---
% "en la formulación de" → "in formulating"
% Nominalización española → gerundio inglés.
% El registro nominal es más formal y específico que el registro verbal
% del gerundio.
problema_traduccion(20, cambio_estructura,
    'La nominalización "en la formulación de" se traduce como gerundio \
"in formulating", cambiando el registro: la construcción nominal \
española es más abstracta y formal que el gerundio inglés.').

cambio_estructura(20, Desc) :- problema_traduccion(20, cambio_estructura, Desc).

% --- Oración 24 — Problemática ---
% "apostando a que" → "betting that"
% En español "apostando a que" introduce una subordinada sustantiva
% (CD de apostando); en inglés "betting that" funciona como participio
% adjunto, perdiendo la estructura de complemento directo.
problema_traduccion(24, cambio_estructura,
    '"Apostando a que" introduce una subordinada sustantiva con función \
de CD en español. "Betting that" funciona como participio adjunto \
en inglés, perdiendo la estructura de complemento directo verbal.').

cambio_estructura(24, Desc) :- problema_traduccion(24, cambio_estructura, Desc).

% --- Oración 29 — Problemática ---
% Sujeto implícito en español → "it" explícito en inglés
% El español admite sujeto gramatical nulo; el inglés obliga a un
% pronombre expletivo "it" que introduce ambigüedad referencial.
problema_traduccion(29, perdida_referencia,
    'El español tiene sujeto gramatical implícito ("jugó" sin sujeto \
léxico). En inglés es obligatorio el sujeto explícito "it", que \
introduce ambigüedad sobre a qué referente del discurso alude.').

perdida_referencia(29, Desc) :- problema_traduccion(29, perdida_referencia, Desc).

% --- Oración 30 — Problemática ---
% "lo cual" → "which"
% "Lo cual" en español retoma toda la proposición anterior (antecedente
% oracional). En inglés "which" puede referirse al sustantivo más próximo
% ("barriers"), creando ambigüedad de alcance del relativo.
problema_traduccion(30, ambiguedad,
    '"Lo cual" en español tiene antecedente oracional claro (toda la \
proposición previa). En inglés "which" puede referirse al sustantivo \
más próximo ("barriers"), creando ambigüedad de alcance del relativo.').

ambiguedad(30, Desc) :- problema_traduccion(30, ambiguedad, Desc).

% =============================================================================
% detectar_problemas/1 — imprime el informe de problemas de una oración
% =============================================================================

detectar_problemas(ID) :-
    integer(ID), !,
    (   conjunto_oraciones:oracion(ID, Tipo, Clase, TokensEN)
    ->  conjunto_oraciones:oracion_es(ID, TokensES),
        format("~`=t~60|~n"),
        format("Translation Analysis — Sentence ~w | Type: ~w | Class: ~w~n",
               [ID, Tipo, Clase]),
        format("~`-t~60|~n"),
        format("EN: ~w~n", [TokensEN]),
        format("ES: ~w~n", [TokensES]),
        format("~`-t~60|~n"),
        detectar_clase_informe(ID, Clase)
    ;   format("No sentence with ID ~w in the corpus.~n", [ID])
    ).

detectar_clase_informe(_, correcta) :-
    format("Class: correcta — No translation problems detected.~n").

detectar_clase_informe(ID, ambigua) :-
    format("Class: ambigua — Potential lexical or structural ambiguity.~n~n"),
    (   ambiguedad(ID, Desc)
    ->  format("  Ambiguity: ~w~n", [Desc])
    ;   format("  (No specific problem registered for this ID.)~n")
    ).

detectar_clase_informe(ID, problematica) :-
    format("Class: problematica — Syntactic divergence from original.~n~n"),
    (   problema_traduccion(ID, Tipo, Desc)
    ->  format("  Problem type: ~w~n", [Tipo]),
        format("  Description: ~w~n", [Desc])
    ;   format("  (No specific problem registered for this ID.)~n")
    ).
