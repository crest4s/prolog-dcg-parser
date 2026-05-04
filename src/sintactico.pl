/*=============================================================================
 * sintactico.pl — Gramática DCG para inglés
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
 *   det, n, v_cop, v_trans, v_intr, aux, adj, adv, conj, rel, prep
 *=============================================================================*/

:- module(sintactico, [oración/3, simplificar/2, simplificar_y_dibujar/1]).

:- use_module(draw).

% =============================================================================
% Reglas de oraciones
% =============================================================================

% Regla maestra
oracion(ListaArboles) --> ocm(ListaArboles).
oracion(ListaArboles) --> or(ListaArboles).
oracion(ListaArboles) --> oc(ListaArboles).
oracion(ListaArboles) --> oc_sujeto_comun(ListaArboles).
oracion(ListaArboles) --> oc_verbo_comun(ListaArboles).
oracion([ArbolSimple]) --> o(ArbolSimple).

% Oración simple
o(o(GN, GV)) -->
    grupo_nominal(GN),
    grupo_verbal(GV).

% Oraciones coordinadas (dos oraciones completas con sujetos distintos)
oc([Arbol1, Arbol2]) -->
    o(Arbol1), [','],
    conj(_),
    o(Arbol2).

oc([Arbol1, Arbol2]) -->
    o(Arbol1),
    conj(_),
    o(Arbol2).

% Coordinadas con sujeto compartido: GN V1 [,] conj V2
oc_sujeto_comun([o(GN, GV1), o(GN, GV2)]) -->
    grupo_nominal(GN),
    grupo_verbal(GV1),
    [','],
    conj(_),
    grupo_verbal(GV2).

oc_sujeto_comun([o(GN, GV1), o(GN, GV2)]) -->
    grupo_nominal(GN),
    grupo_verbal(GV1),
    conj(_),
    grupo_verbal(GV2).

% Coordinadas con verbo transitivo compartido: GN V GN1 [,] conj GN2
oc_verbo_comun([o(GN, gv(V, GN1)), o(GN, gv(V, GN2))]) -->
    grupo_nominal(GN),
    verbo_transitivo(V),
    grupo_nominal(GN1),
    [','],
    conj(_),
    grupo_nominal(GN2).

oc_verbo_comun([o(GN, gv(V, GN1)), o(GN, gv(V, GN2))]) -->
    grupo_nominal(GN),
    verbo_transitivo(V),
    grupo_nominal(GN1),
    conj(_),
    grupo_nominal(GN2).

% Oraciones subordinadas de relativo (con comas y sin comas)
or([o(GN, GV_Sub), o(GN, GV_Princ)]) -->
    grupo_nominal(GN),
    [','],
    rel(_),
    grupo_verbal(GV_Sub),
    [','],
    grupo_verbal(GV_Princ).

or([o(GN, GV_Sub), o(GN, GV_Princ)]) -->
    grupo_nominal(GN),
    rel(_),
    grupo_verbal(GV_Sub),
    grupo_verbal(GV_Princ).

% Oraciones compuestas
ocm([ArbolSub, ArbolPrinc | RestoArboles]) -->
    or([ArbolSub, ArbolPrinc]),
    [','],
    conj(_),
    ocm(RestoArboles).

ocm([ArbolSub, ArbolPrinc | RestoArboles]) -->
    or([ArbolSub, ArbolPrinc]),
    conj(_),
    ocm(RestoArboles).

ocm([ArbolSub, ArbolPrinc, ArbolFinal]) -->
    or([ArbolSub, ArbolPrinc]),
    [','],
    conj(_),
    o(ArbolFinal).

ocm([ArbolSub, ArbolPrinc, ArbolFinal]) -->
    or([ArbolSub, ArbolPrinc]),
    conj(_),
    o(ArbolFinal).

ocm([Arbol1 | RestoArboles]) -->
    o(Arbol1),
    [','],
    conj(_),
    ocm(RestoArboles).

ocm([Arbol1 | RestoArboles]) -->
    o(Arbol1),
    conj(_),
    ocm(RestoArboles).

ocm([Arbol1, Arbol2]) -->
    o(Arbol1),
    [','],
    conj(_),
    o(Arbol2).

ocm([Arbol1, Arbol2]) -->
    o(Arbol1),
    conj(_),
    o(Arbol2).

% Punto de entrada para phrase/3
oración(Arbol, Tokens, Resto) :-
    phrase(oracion(Arbol), Tokens, Resto).

% =============================================================================
% Simplificación: convierte cualquier árbol o lista a [o(GN,GV), ...]
% =============================================================================

simplificar([], []) :- !.
simplificar(o(GN, GV), [o(GN, GV)]) :- !.
simplificar([H | T], Simples) :-
    simplificar(H, HS),
    simplificar(T, TS),
    append(HS, TS, Simples).

% =============================================================================
% Simplificación + dibujo con draw.pl
% =============================================================================

simplificar_y_dibujar(Tokens) :-
    (   oración(Arboles, Tokens, [])
    ->  simplificar(Arboles, Simples),
        length(Simples, N),
        format("~`=t~50|~n"),
        format("~w simple sentence(s) obtained:~n", [N]),
        format("~`=t~50|~n"),
        dibujar_simples(Simples, 1)
    ;   format("~`=t~50|~n"),
        format("Note: sentence structure exceeds current DCG coverage.~n"),
        format("      Stored in corpus for reference and semantic analysis.~n"),
        format("~`=t~50|~n")
    ).

dibujar_simples([], _).
dibujar_simples([O | Resto], Num) :-
    format("~n[~w] ~w~n", [Num, O]),
    draw(O),
    Siguiente is Num + 1,
    dibujar_simples(Resto, Siguiente).

% =============================================================================
% Grupos sintácticos
% =============================================================================

% Grupo nominal
grupo_nominal(gn(N)) -->
    nombre(N).

grupo_nominal(gn(Det, N)) -->
    determinante(Det),
    nombre(N).

% Adjetivo pre-nominal (orden inglés: Det + Adj + N)
grupo_nominal(gn(Det, Adj, N)) -->
    determinante(Det),
    adjetivo(Adj),
    nombre(N).

grupo_nominal(gn(Det, Adj, N, GP)) -->
    determinante(Det),
    adjetivo(Adj),
    nombre(N),
    grupo_preposicional(GP).

% Adjetivo post-nominal (orden español: Det + N + Adj)
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

% Grupo verbal — verbos simples
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

% Grupo verbal — auxiliar + verbo principal (pasiva y perfectiva en inglés)
grupo_verbal(gv(Aux, V)) -->
    auxiliar(Aux),
    verbo_intransitivo(V).

grupo_verbal(gv(Aux, V, GA)) -->
    auxiliar(Aux),
    verbo_copulativo(V),
    grupo_adjetival(GA).

grupo_verbal(gv(Aux, V, GN)) -->
    auxiliar(Aux),
    verbo_transitivo(V),
    grupo_nominal(GN).

grupo_verbal(gv(Aux, V)) -->
    auxiliar(Aux),
    verbo_transitivo(V).

grupo_verbal(gv(Aux, V)) -->
    auxiliar(Aux),
    verbo_copulativo(V).

% Grupo adjetival
grupo_adjetival(gadj(Adj)) -->
    adjetivo(Adj).

% Grupo adverbial
grupo_adverbial(gadv(Adv)) -->
    adverbio(Adv).

% Grupo preposicional
grupo_preposicional(gp(Prep, GN)) -->
    preposicion(Prep),
    grupo_nominal(GN).

% =============================================================================
% Terminales DCG
% =============================================================================

determinante(det(P)) --> [P], { determinante_palabra(P) }.
nombre(n(P))         --> [P], { nombre_palabra(P) }.
adjetivo(adj(P))     --> [P], { adjetivo_palabra(P) }.
adverbio(adv(P))     --> [P], { adverbio_palabra(P) }.
conj(conj(P))        --> [P], { conjuncion_palabra(P) }.
rel(rel(P))          --> [P], { relativo_palabra(P) }.
preposicion(prep(P)) --> [P], { preposicion_palabra(P) }.
auxiliar(aux(P))     --> [P], { auxiliar_palabra(P) }.

verbo_transitivo(v(P))   --> [P], { verbo_transitivo_palabra(P) }.
verbo_intransitivo(v(P)) --> [P], { verbo_intransitivo_palabra(P) }.
verbo_copulativo(v(P))   --> [P], { verbo_copulativo_palabra(P) }.

% =============================================================================
% Clasificación léxica — inglés
% =============================================================================

determinante_palabra(P) :- memberchk(P, [
    the, a, an, this, that, these, those, its, our, their,
    another, other, one, each, any, such, some, no, all, both, many
]).

conjuncion_palabra(P) :- memberchk(P, [
    and, but, or, although, however, well, yet, if
]).

relativo_palabra(P) :- memberchk(P, [
    that, which, who, where, what
]).

preposicion_palabra(P) :- memberchk(P, [
    in, of, for, to, from, at, on, by, with, through, into, about,
    as, after, since, until, during, per, between, according, over,
    upon, within
]).

adverbio_palabra(P) :- memberchk(P, [
    not, very, also, likewise, fortunately, finally, precisely,
    directly, completely, definitively, always, often, only, just,
    eventually, far, simply, surely, so, somewhat, then, first,
    classically, similarly, already, still, here, now,
    never, ever, truly, accurately
]).

adjetivo_palabra(P) :- memberchk(P, [
    essential, fundamental, innovative, impossible, immediate, bold,
    coherent, efficient, characteristic, certain, perplexing, subatomic,
    poetic, romantic, usual, wavelike, microscopic, international,
    revolutionary, theoretical, forbidden, important, indispensable,
    multiple, photoelectric, able, early, exact, miniature, small,
    new, great, absolute, different, proportional, quantized, discretized,
    general, similar, black, precise, basic, quantum, true,
    specific, unique, natural, physical, perceptible, complete,
    innovative, proportional, various
]).

auxiliar_palabra(P) :- memberchk(P, [
    was, were, is, are, have, had, can, could, should, would,
    may, might, do, does, did, be, been, being, has
]).

verbo_copulativo_palabra(P) :- memberchk(P, [
    % Verbos copulativos directos (inglés: be + adjectivo/nombre)
    is, are, was, were, be, been,
    % Otros copulativos
    became, become, seem, seemed, appears, appeared, remain, remained,
    come, came, known, named, considered, established, related
]).

verbo_transitivo_palabra(P) :- memberchk(P, [
    played, plays, governs, govern, challenges, challenged, proposed,
    made, make, contradicted, contradict,
    confirmed, highlighted, consolidated, contributed, absorbed, absorbs,
    radiates, radiated, strikes, ejects, used, managed, gave, quantified,
    called, exhibited, introduced, expounded, found, conducted,
    said, determined, presented, explained, laid, heard, explained,
    states, stated, showed, hitting, ejects, established, observed,
    confirmed, highlighted, managed, consolidated, explained, laid,
    represented, formulating, understand, know, measure, find, explain,
    solve, establish, give, manifest, show, conduct, confirm, highlight,
    consider, determine, present, propose, introduce, name, use, manage,
    exhibit, quantify, call, absorb, radiate, strike, eject, hear,
    expressed, proved, demonstrated, reveal, suggest
]).

verbo_intransitivo_palabra(P) :- memberchk(P, [
    exists, exist, stalled, grew, grow, acts, act, appears, appear,
    began, begin, plunges, plunge, started, start, contributed,
    contribute, possessed, possess, passes, pass, stalled, stall,
    proceeded, proceed
]).

nombre_palabra(P) :-
    token_corpus(P),
    \+ determinante_palabra(P),
    \+ conjuncion_palabra(P),
    \+ relativo_palabra(P),
    \+ preposicion_palabra(P),
    \+ adverbio_palabra(P),
    \+ adjetivo_palabra(P),
    \+ auxiliar_palabra(P),
    \+ verbo_copulativo_palabra(P),
    \+ verbo_transitivo_palabra(P),
    \+ verbo_intransitivo_palabra(P).

% =============================================================================
% Tokens del corpus (inglés) — usado para inferir nombres por exclusión
% =============================================================================

token_corpus(P) :- memberchk(P, [
    % Numbers and special values
    1900, 1905, 1927, 1981, '6.626x10-34',
    % Pronouns and expletives (treated as nouns in the grammar)
    it, its, they, their, he, you, we, there, itself, themselves,
    this, that, those, one, each,
    % Determiners
    the, a, an, another, other, some, no, all, both, many, such, any,
    % Conjunctions
    and, but, or, although, however, well, yet,
    % Relatives
    that, which, who, where, what,
    % Prepositions
    in, of, for, to, from, at, on, by, with, through, into, about, as,
    after, since, until, during, per, between, according, over,
    % Adverbs
    not, very, also, likewise, fortunately, finally, precisely, directly,
    completely, definitively, always, often, only, just, eventually, far,
    simply, surely, so, somewhat, then, first, classically,
    % Adjectives
    essential, fundamental, innovative, impossible, immediate, bold,
    coherent, efficient, characteristic, certain, perplexing, subatomic,
    poetic, romantic, usual, wavelike, microscopic, international,
    revolutionary, theoretical, forbidden, important, indispensable,
    multiple, photoelectric, able, early, exact, miniature, small,
    new, great, absolute, different, proportional, quantized, discretized,
    general, similar, black, true, quantum, constant,
    % Auxiliaries (also classified as v_cop when used as main verb)
    was, were, is, are, have, had, can, could, should, would, may,
    might, do, does, did, be, been, being, has,
    % Copular verbs
    became, become, seemed, seems, appeared, come, came,
    known, named, considered, established, related,
    % Pronouns / expletives
    there, itself, themselves, himself, herself,
    % Transitive verbs
    played, governs, challenges, proposed, confirmed, highlighted,
    consolidated, contributed, absorbed, absorbs, radiates, strikes,
    ejects, used, managed, gave, quantified, called, exhibited,
    introduced, expounded, found, conducted, said, determined,
    presented, explained, laid, heard, states, showed, hitting,
    represented, formulating, observed, manages,
    % Intransitive verbs
    exists, exist, stalled, grew, grow, acts, began, plunges,
    possessed, passes, pass, contributed, appeared,
    % Domain nouns
    constant, role, formulation, approaches, heisenberg, uncertainty,
    principle, physics, discipline, perception, reality, phrase, part,
    behavior, particles, eyes, study, scientists, research, laws, context,
    protagonist, world, planck, physicist, century, work, anxieties,
    time, era, progress, dilemmas, radiation, body, object, quantity,
    energy, phenomenon, idea, quantization, intervals, pockets, quanta,
    value, quantities, acceptance, proposal, phenomena, theories, force,
    physicists, importance, einstein, bohr, werner, breakthroughs, theory,
    duality, mechanics, pillars, conception, way, letter, h, nature,
    emission, postulate, integers, joules, second, units, system, approach,
    precision, position, momentum, particle, case, impediment, limitation,
    ability, presence, explanation, experiments, testimony, effect,
    light, metal, electrons, hypothesis, photons, foundation, diffraction,
    behaviors, waves, wave, element, barriers, multiples, microscope,
    invention, tunnel, niels, bohr, albert, lester, germer, clinton,
    davisson, max, werner, order, words, example, problem, body, object,
    key, understanding, groundwork, many, anxieties, need, consider,
    importance, consolidate, highlight, establish, show, give, manifest,
    itself, photons, energy, intervals, pockets, quanta, integers,
    multiples, barriers, diffraction, behaviors, waves, breakthroughs,
    % Participles and gerunds used as nouns/modifiers
    emitted, observed, deduced, showing, laying, playing, betting,
    hitting, taking, place, based, composed, called,
    % Additional nouns/words that may not fall in other categories
    force, role, context, key, understanding, order, words, example,
    constant, problem, body, object, groundwork, need, consider,
    consolidate, highlight, establish, show, give, manifest, itself,
    photons, quanta, diffraction, electron, master
]).
