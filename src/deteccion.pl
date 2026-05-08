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
    translation_note/2,
    detect_problems/1
]).

:- discontiguous translation_problem/3.
:- discontiguous structure_change/2.
:- discontiguous ambiguity/2.
:- discontiguous reference_loss/2.
:- discontiguous translation_note/2.

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
% translation_note/2 — notas sobre oraciones con traducción correcta
% translation_note(+ID, -Note)
% =============================================================================

% Oración 1 — Simple (o)
% "desempeñó" → "played"; "en la formulación de" → "in the formulation of"
translation_note(1,
    '"Played an essential role" faithfully renders "desempeñó un papel esencial"; \
the nominalization "in the formulation of" correctly maps the Spanish \
"en la formulación de".').

% Oración 2 — Compuesta sustantiva + relativa (ocm)
% "Se suele decir" → "It is often said"; doble relativa preservada
translation_note(2,
    'The expletive "It is often said" correctly maps the impersonal Spanish \
"Se suele decir"; the double relative clause structure (that...that) is preserved.').

% Oración 3 — Compuesta subordinada adverbial (ocm)
% "aunque" → "although"; "puede considerarse" → "can be considered"
translation_note(3,
    'The concessive "although" correctly translates "aunque"; the modal \
"can be considered" renders the Spanish impersonal reflexive "puede considerarse".').

% Oración 5 — Compuesta de relativo (or)
% "de la cual" → "which"; "llave maestra para entender" → "master key to understanding"
translation_note(5,
    '"Which you have surely heard of" correctly maps "de la cual seguramente hayas \
oído hablar"; the double relative (which/that) preserves the original structure.').

% Oración 6 — Simple (o)
% "Llamada así en honor al" → "Named after"; "fue nombrada" → "was first named"
translation_note(6,
    'The participial opening "Named after the physicist who introduced it" \
correctly translates the Spanish passive "Llamada así en honor al físico que la \
introdujo"; "was first named" maps "fue nombrada por primera vez".').

% Oración 7 — Coordinada adversativa (oc)
% "no solo... sino que" → "not only... but also"
translation_note(7,
    'The correlative "not only... but also" correctly maps the Spanish adversative \
"no solo... sino que"; the coordination structure is fully preserved.').

% Oración 8 — Simple (o)
% "parecía haberse estancado" → "seemed to have stalled"
translation_note(8,
    '"Seemed to have stalled" correctly preserves the Spanish perfect periphrasis \
"parecía haberse estancado", maintaining both the evidential and aspect meanings.').

% Oración 9 — Compuesta relativa + coordinada (ocm)
% "a los que no conseguían dar explicación" → "that they could not explain"
translation_note(9,
    'The two relative clauses "that they could not explain" and "for which there \
were no coherent and efficient laws" faithfully translate the complex Spanish \
relative structure with prepositional complements.').

% Oración 11 — Compuesta yuxtapuesta + sustantiva (ocm)
% "cuantos" → "quanta"; appositive with colon preserved
translation_note(11,
    'The colon introducing the appositive explanation is preserved; the English \
"quanta" is the accepted scientific plural for the Spanish "cuantos" (quantum pockets).').

% Oración 12 — Compuesta sustantiva + adversativa + relativa (ocm)
% "sino que se emitía" → "but was emitted"
translation_note(12,
    '"But was emitted in small quantities" correctly maps the adversative "sino que \
se emitía en pequeñas cantidades"; the proportionality clause is faithfully preserved.').

% Oración 13 — Simple (o)
% "ni mucho menos inmediata" → "far from immediate"
translation_note(13,
    'The idiomatic "far from immediate" accurately renders the emphatic Spanish \
negation "ni mucho menos inmediata", preserving the stylistic force of the denial.').

% Oración 14 — Coordinada + subordinada adverbial (ocm)
% "La propuesta de Planck era atrevida y, aunque parecía explicar..."
translation_note(14,
    '"And although it seemed to explain certain phenomena, it contradicted" \
correctly preserves the coordination-subordination structure; the pronoun "it" \
unambiguously refers to "Planck\'s proposal" in both clauses.').

% Oración 15 — Compuesta subordinada relativa (or)
% "que terminaron por consolidar" → "that eventually consolidated"
translation_note(15,
    '"Eventually consolidated" correctly renders the Spanish periphrastic "terminaron \
por consolidar"; the enumeration of physicists (Einstein, Bohr, Heisenberg) is maintained.').

% Oración 18 — Compuesta sustantiva + adversativa + relativa (ocm)
% "se consideraba/se determinó" → "was considered/was determined"
translation_note(18,
    'Both impersonal passive constructions "se consideraba" and "se determinó" are \
correctly rendered as English passive "was considered" and "was determined", \
preserving the impersonal register of the original.').

% Oración 19 — Simple (o)
% Valor numérico y unidades preservados
translation_note(19,
    'The technical numerical value (6.626×10⁻³⁴) and units (joules per second) \
are preserved exactly; "according to the International System of Units" faithfully \
translates "según el Sistema Internacional de Unidades".').

% Oración 21 — Compuesta de CD (ocm)
% "la cantidad de momento" → "momentum"; "imposible conocer" → "impossible to know"
translation_note(21,
    '"Momentum" is the correct scientific term for the Spanish "cantidad de momento"; \
the infinitive structure "impossible to know with absolute precision" correctly \
maps the Spanish construction.').

% Oración 22 — Subordinada adverbial (ocm)
% "tal y como si fuera" → "as if it were"
translation_note(22,
    '"As if it were a limitation" correctly translates the subjunctive "tal y como \
si fuera una limitación", preserving the counterfactual meaning of the original.').

% Oración 23 — Subordinada de relativo (or)
% "los cuales... consolidaron" → "which definitively consolidated"
translation_note(23,
    '"Which definitively consolidated its importance" correctly maps the Spanish \
"los cuales consolidaron definitivamente su importancia"; the clausal antecedent \
of "which" is clear from context.').

% Oración 25 — Compuesta sustantiva + participio (ocm)
% "llamadas fotones" → "called photons"; "cada uno con" → "each with"
translation_note(25,
    'The participial "called photons" correctly renders "llamadas fotones"; \
"each with energy proportional to Planck\'s constant" faithfully maps the \
Spanish appositive structure "cada uno con energía proporcional a la constante".').

% Oración 26 — Relativa + sustantiva (ocm)
% "Fue justamente este fenómeno el que" → "It was precisely this phenomenon that"
translation_note(26,
    'The cleft construction "It was precisely this phenomenon that managed to explain" \
correctly maps the Spanish cleft "Fue justamente este fenómeno el que consiguió \
explicar"; the gerund "laying the foundation" preserves the simultaneity of "sentando".').

% Oración 27 — Subordinada adverbial (ocm)
% "demostrando" → "showing"; "comportamientos ondulatorios" → "wavelike behaviors"
translation_note(27,
    '"Showing that they exhibited wavelike behaviors" correctly translates the \
Spanish adverbial gerund "demostrando que estos exhibían comportamientos ondulatorios"; \
"wavelike" is an accurate calque of the Spanish compound adjective.').

% Oración 28 — Relativa + coordinada copulativa (ocm)
% "pasó a conocerse como" → "came to be known as"
translation_note(28,
    '"Came to be known as electron diffraction" correctly maps the inchoative Spanish \
"pasó a conocerse como difracción de electrones"; the coordinated structure \
"confirmed... and highlighted" faithfully preserves the original copulative coordination.').

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

report_class(ID, correcta) :-
    format("Class: correcta — Translation preserves the original structure.~n"),
    (   translation_note(ID, Note)
    ->  format("  Note: ~w~n", [Note])
    ;   true
    ).

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
