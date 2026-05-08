/*=============================================================================
 * semantico.pl — Enriquecimiento semántico (inglés)
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Categorías semánticas del dominio de la física cuántica:
 *
 *   physical_constant   — valores numéricos con rol fundamental en la física
 *   physical_phenomenon — fenómenos observables en la naturaleza
 *   physical_entity     — partículas, objetos físicos
 *   person              — científicos e investigadores
 *   property            — atributos o características de entidades
 *   process             — acciones o transformaciones
 *   quantity            — magnitudes y medidas
 *   theoretical_concept — principios, teorías, leyes
 *
 * Predicados exportados:
 *   type/2              — type(+Word, -Category)
 *   semantic_category/2 — semantic_category(+Tokens, -Analysis)
 *   semantic_role/3     — semantic_role(+Tree, +Role, -Words)
 *=============================================================================*/

:- module(semantico, [type/2, semantic_category/2, semantic_role/3]).

% =============================================================================
% type/2 — asigna categoría semántica a palabras del dominio
% =============================================================================

% Constantes físicas
type(constant,         physical_constant).
type(planck,           physical_constant).
type('6.626x10-34',    physical_constant).
type(h,                physical_constant).

% Fenómenos físicos
type(uncertainty,      physical_phenomenon).
type(duality,          physical_phenomenon).
type(diffraction,      physical_phenomenon).
type(radiation,        physical_phenomenon).
type(effect,           physical_phenomenon).
type(phenomenon,       physical_phenomenon).
type(quantization,     physical_phenomenon).
type(emission,         physical_phenomenon).
type(wave,             physical_phenomenon).

% Entidades físicas (partículas, objetos)
type(particle,         physical_entity).
type(particles,        physical_entity).
type(photon,           physical_entity).
type(photons,          physical_entity).
type(electron,         physical_entity).
type(electrons,        physical_entity).
type(body,             physical_entity).
type(metal,            physical_entity).
type(light,            physical_entity).
type(barriers,         physical_entity).

% Personas
type(planck,           person).  % también physical_constant — ambigüedad léxica deliberada
type(einstein,         person).
type(heisenberg,       person).
type(bohr,             person).
type(davisson,         person).
type(germer,           person).
type(max,              person).
type(niels,            person).
type(albert,           person).
type(werner,           person).
type(clinton,          person).
type(lester,           person).
type(physicist,        person).
type(physicists,       person).
type(scientists,       person).

% Propiedades
type(essential,        property).
type(fundamental,      property).
type(innovative,       property).
type(coherent,         property).
type(efficient,        property).
type(proportional,     property).
type(indispensable,    property).
type(characteristic,   property).
type(forbidden,        property).
type(wavelike,         property).
type(subatomic,        property).
type(microscopic,      property).
type(theoretical,      property).
type(quantized,        property).
type(discretized,      property).

% Procesos / acciones
type(formulation,      process).
type(formulating,      process).
type(quantization,     process).
type(consolidation,    process).
type(diffraction,      process).

% Cantidades y medidas
type(value,            quantity).
type(quantity,         quantity).
type(quantities,       quantity).
type(energy,           quantity).
type(momentum,         quantity).
type(precision,        quantity).
type(multiples,        quantity).
type(integers,         quantity).
type(joules,           quantity).

% Conceptos teóricos
type(principle,        theoretical_concept).
type(theory,           theoretical_concept).
type(mechanics,        theoretical_concept).
type(physics,          theoretical_concept).
type(hypothesis,       theoretical_concept).
type(law,              theoretical_concept).
type(laws,             theoretical_concept).
type(postulate,        theoretical_concept).
type(approach,         theoretical_concept).
type(approaches,       theoretical_concept).

% =============================================================================
% semantic_category/2
% Analiza los tokens de una oración e identifica qué categorías semánticas aparecen.
% semantic_category(+Tokens, -Categories)
% =============================================================================

semantic_category(Tokens, Categories) :-
    findall(Cat-Word,
        (member(Word, Tokens), type(Word, Cat)),
        Pairs),
    sort(Pairs, Categories).

% =============================================================================
% semantic_role/3
% Extrae el rol semántico de un nodo del árbol sintáctico.
% semantic_role(+Tree, +Role, -Words)
%
%   Roles:  subject | predicate | object | complement
% =============================================================================

semantic_role(s(NP, _), subject, Words) :-
    words_np(NP, Words).

semantic_role(s(_, NP, _), subject, Words) :-
    words_np(NP, Words).

semantic_role(s(_, VP), predicate, Words) :-
    words_vp(VP, Words).

semantic_role(s(_, _, VP), predicate, Words) :-
    words_vp(VP, Words).

semantic_role(s(_, vp(_, NP)), object, Words) :-
    words_np(NP, Words).

semantic_role(s(_, _, vp(_, NP)), object, Words) :-
    words_np(NP, Words).

semantic_role(s(_, vp(_, _, PP)), complement, Words) :-
    words_pp(PP, Words).

semantic_role(s(_, _, vp(_, _, PP)), complement, Words) :-
    words_pp(PP, Words).

% =============================================================================
% Auxiliares para extraer palabras de los grupos sintácticos
% =============================================================================

% --- np (grupo nominal) ---

words_np(np(n(N)), [N]).
words_np(np(det(D), n(N)), [D, N]).
words_np(np(det(D), adj(A), n(N)), [D, A, N]).
words_np(np(det(D), pp(Prep, NP)), [D, P | Rest]) :-
    words_pp(pp(Prep, NP), [P | Rest]).
words_np(np(det(D), N1, N2, N3), [D, N1, N2, N3]).
words_np(np(det(D), AP, n(N)), [D | Rest]) :-
    words_ap(AP, AR),
    append(AR, [N], Rest).
words_np(np(AP, n(N)), Words) :-
    words_ap(AP, AR),
    append(AR, [N], Words).
words_np(np(AP, n(N), NP2), Words) :-
    words_ap(AP, AR),
    words_np(NP2, PR),
    append(AR, [N | PR], Words).
words_np(np(det(D), n(N), adj(A)), [D, N, A]).
words_np(np(det(D), n(N), pp(prep(P), NP2)), [D, N, P | Rest]) :-
    words_np(NP2, Rest).
words_np(np(det(D), adj(A), n(N), pp(prep(P), NP2)), [D, A, N, P | Rest]) :-
    words_np(NP2, Rest).
words_np(np(det(D), AP, n(N), pp(prep(P), NP2)), [D | R]) :-
    words_ap(AP, AR),
    words_np(NP2, PR),
    append(AR, [N, P | PR], R).
words_np(np(n(N), pp(prep(P), NP2)), [N, P | Rest]) :-
    words_np(NP2, Rest).
words_np(np(det(D), n(N1), n(N2)), [D, N1, N2]).
words_np(np(det(D), n(N1), n(N2), pp(prep(P), NP2)), [D, N1, N2, P | Rest]) :-
    words_np(NP2, Rest).

% --- ap (grupo adjetival) ---

words_ap(ap(adj(A)), [A]).
words_ap(ap(adj(A), AP), [A | Rest]) :-
    words_ap(AP, Rest).
words_ap(ap(adv(D), adj(A)), [D, A]).

% --- vp (grupo verbal) ---

words_vp(vp(v(V)), [V]).
words_vp(vp(v(V), NP), [V | Rest])      :- words_np(NP, Rest).
words_vp(vp(v(V), AP), [V | Rest])      :- words_ap(AP, Rest).
words_vp(vp(v(V), AdvP, PP), [V | Rest]) :-
    words_advp(AdvP, AR),
    words_pp(PP, PR),
    append(AR, PR, Rest).
words_vp(vp(aux(A), v(V)), [A, V]).
words_vp(vp(aux(A), v(V), NP), [A, V | Rest]) :- words_np(NP, Rest).
words_vp(vp(aux(A), v(V), AP), [A, V | Rest]) :- words_ap(AP, Rest).
words_vp(vp(v(V), infp(aux(A), v(V2))), [V, A, V2]).

% --- advp (grupo adverbial) ---

words_advp(advp(adv(D)), [D]).

% --- pp (grupo preposicional) ---

words_pp(pp(prep(P), NP), [P | Rest]) :- words_np(NP, Rest).
words_pp(pp(prep(P), AP), [P | Rest]) :- words_ap(AP, Rest).

% =============================================================================
% semantic_analysis/2
% Genera un análisis completo de la oración a partir de su árbol.
% semantic_analysis(+Tree, -Report)
% =============================================================================

semantic_analysis(s(NP, VP), report(Subject, SubjectTypes, Predicate)) :-
    words_np(NP, Subject),
    words_vp(VP, Predicate),
    findall(Cat, (member(P, Subject), type(P, Cat)), Types0),
    sort(Types0, SubjectTypes).
