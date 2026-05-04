/*=============================================================================
 * sintactico.pl — Gramática DCG para inglés
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Tipos de oración (etiqueta en corpus):
 *   o   — oración simple
 *   oc  — oración coordinada
 *   or  — oración de relativo
 *   ocm — oración compuesta
 *
 * Grupos sintácticos (nodos del árbol):
 *   np   — noun phrase / grupo nominal
 *   vp   — verb phrase / grupo verbal
 *   ap   — adjective phrase / grupo adjetival
 *   advp — adverb phrase / grupo adverbial
 *   pp   — prepositional phrase / grupo preposicional
 *
 * Etiquetas léxicas:
 *   det, n, v, adj, adv, conj, rel, prep, aux
 *=============================================================================*/

:- module(sintactico, [parse/3, simplify/2, simplify_and_draw/1]).

:- use_module(draw).

% =============================================================================
% Reglas de oraciones
% =============================================================================

% Regla maestra
sentence(Trees)  --> compound_s(Trees).
sentence(Trees)  --> relative_s(Trees).
sentence(Trees)  --> coord_s(Trees).
sentence(Trees)  --> coord_shared_subj(Trees).
sentence(Trees)  --> coord_shared_verb(Trees).
sentence([Tree]) --> simple_s(Tree).

% --- Oración simple ---

% Patrón base: SN + SV
simple_s(s(NP, VP)) -->
    noun_phrase(NP),
    verb_phrase(VP).

% Con adverbio oracional inicial (however, likewise, also…)
simple_s(s(NP, VP)) -->
    adverb(_),
    noun_phrase(NP),
    verb_phrase(VP).

% Con conjunción oracional inicial (however como conjunción, well…)
simple_s(s(NP, VP)) -->
    conjunction(_),
    noun_phrase(NP),
    verb_phrase(VP).

% Con SP inicial (since the early century, in 1981…)
simple_s(s(NP, VP)) -->
    prep_phrase(_),
    noun_phrase(NP),
    verb_phrase(VP).

% Con adverbio + SP iniciales
simple_s(s(NP, VP)) -->
    adverb(_),
    prep_phrase(_),
    noun_phrase(NP),
    verb_phrase(VP).

% --- Coordinadas (dos oraciones completas) ---

coord_s([S1, S2]) -->
    simple_s(S1), [','], conjunction(_), simple_s(S2).

coord_s([S1, S2]) -->
    simple_s(S1), conjunction(_), simple_s(S2).

% --- Coordinadas con sujeto compartido: NP V1 [,] conj V2 ---

coord_shared_subj([s(NP, VP1), s(NP, VP2)]) -->
    noun_phrase(NP),
    verb_phrase(VP1),
    [','],
    conjunction(_),
    verb_phrase(VP2).

coord_shared_subj([s(NP, VP1), s(NP, VP2)]) -->
    noun_phrase(NP),
    verb_phrase(VP1),
    conjunction(_),
    verb_phrase(VP2).

% --- Coordinadas con verbo transitivo compartido: NP V NP1 [,] conj NP2 ---

coord_shared_verb([s(NP, vp(V, NP1)), s(NP, vp(V, NP2))]) -->
    noun_phrase(NP),
    transitive_verb(V),
    noun_phrase(NP1),
    [','],
    conjunction(_),
    noun_phrase(NP2).

coord_shared_verb([s(NP, vp(V, NP1)), s(NP, vp(V, NP2))]) -->
    noun_phrase(NP),
    transitive_verb(V),
    noun_phrase(NP1),
    conjunction(_),
    noun_phrase(NP2).

% --- Subordinadas de relativo ---

relative_s([s(NP, VP_sub), s(NP, VP_main)]) -->
    noun_phrase(NP),
    [','],
    relative(_),
    verb_phrase(VP_sub),
    [','],
    verb_phrase(VP_main).

relative_s([s(NP, VP_sub), s(NP, VP_main)]) -->
    noun_phrase(NP),
    relative(_),
    verb_phrase(VP_sub),
    verb_phrase(VP_main).

% --- Oraciones compuestas ---

compound_s([S_sub, S_main | Rest]) -->
    relative_s([S_sub, S_main]),
    [','],
    conjunction(_),
    compound_s(Rest).

compound_s([S_sub, S_main | Rest]) -->
    relative_s([S_sub, S_main]),
    conjunction(_),
    compound_s(Rest).

compound_s([S_sub, S_main, S_final]) -->
    relative_s([S_sub, S_main]),
    [','],
    conjunction(_),
    simple_s(S_final).

compound_s([S_sub, S_main, S_final]) -->
    relative_s([S_sub, S_main]),
    conjunction(_),
    simple_s(S_final).

compound_s([S1 | Rest]) -->
    simple_s(S1),
    [','],
    conjunction(_),
    compound_s(Rest).

compound_s([S1 | Rest]) -->
    simple_s(S1),
    conjunction(_),
    compound_s(Rest).

compound_s([S1, S2]) -->
    simple_s(S1),
    [','],
    conjunction(_),
    simple_s(S2).

compound_s([S1, S2]) -->
    simple_s(S1),
    conjunction(_),
    simple_s(S2).

% Punto de entrada para phrase/3
parse(Tree, Tokens, Rest) :-
    phrase(sentence(Tree), Tokens, Rest).

% =============================================================================
% Simplificación: convierte cualquier árbol o lista a [s(NP,VP), ...]
% =============================================================================

simplify([], []) :- !.
simplify(s(NP, VP), [s(NP, VP)]) :- !.
simplify([H | T], Simples) :-
    simplify(H, HS),
    simplify(T, TS),
    append(HS, TS, Simples).

% =============================================================================
% Simplificación + dibujo con draw.pl
% =============================================================================

simplify_and_draw(Tokens) :-
    (   parse(Trees, Tokens, [])
    ->  simplify(Trees, Simples),
        length(Simples, N),
        format("~`=t~50|~n"),
        format("~w simple sentence(s) obtained:~n", [N]),
        format("~`=t~50|~n"),
        draw_sentences(Simples, 1)
    ;   format("~`=t~50|~n"),
        format("Note: sentence structure exceeds current DCG coverage.~n"),
        format("      Stored in corpus for reference and semantic analysis.~n"),
        format("~`=t~50|~n")
    ).

draw_sentences([], _).
draw_sentences([S | Rest], Num) :-
    format("~n[~w] ~w~n", [Num, S]),
    draw(S),
    Next is Num + 1,
    draw_sentences(Rest, Next).

% =============================================================================
% Grupos sintácticos
% =============================================================================

% --- Grupo nominal (np) ---

% Solo nombre
noun_phrase(np(N)) -->
    noun(N).

% Nombre + SP
noun_phrase(np(N, PP)) -->
    noun(N),
    prep_phrase(PP).

% Det + N
noun_phrase(np(Det, N)) -->
    determiner(Det),
    noun(N).

% Det + Adj + N  (orden inglés: det adj n)
noun_phrase(np(Det, adj(A), N)) -->
    determiner(Det),
    adjective(adj(A)),
    noun(N).

% Det + AP + N  (ap puede llevar adverbio: very important)
noun_phrase(np(Det, AP, N)) -->
    determiner(Det),
    adj_phrase(AP),
    noun(N).

% Det + Adj + N + SP
noun_phrase(np(Det, adj(A), N, PP)) -->
    determiner(Det),
    adjective(adj(A)),
    noun(N),
    prep_phrase(PP).

% Det + AP + N + SP
noun_phrase(np(Det, AP, N, PP)) -->
    determiner(Det),
    adj_phrase(AP),
    noun(N),
    prep_phrase(PP).

% Det + N + Adj  (orden pospuesto)
noun_phrase(np(Det, N, adj(A))) -->
    determiner(Det),
    noun(N),
    adjective(adj(A)).

% Det + N + SP
noun_phrase(np(Det, N, PP)) -->
    determiner(Det),
    noun(N),
    prep_phrase(PP).

% Det + N + Adj + SP
noun_phrase(np(Det, N, adj(A), PP)) -->
    determiner(Det),
    noun(N),
    adjective(adj(A)),
    prep_phrase(PP).

% Det + N + N  (nombre compuesto: planck constant)
noun_phrase(np(Det, N1, N2)) -->
    determiner(Det),
    noun(N1),
    noun(N2).

% Det + N + N + SP
noun_phrase(np(Det, N1, N2, PP)) -->
    determiner(Det),
    noun(N1),
    noun(N2),
    prep_phrase(PP).

% --- Grupo verbal (vp) ---

% V intransitivo
verb_phrase(vp(V)) -->
    intransitive_verb(V).

% V transitivo + SN
verb_phrase(vp(V, NP)) -->
    transitive_verb(V),
    noun_phrase(NP).

% V copulativo + SA
verb_phrase(vp(V, AP)) -->
    copulative_verb(V),
    adj_phrase(AP).

% V copulativo + SN  (predicado nominal: the constant is h)
verb_phrase(vp(V, NP)) -->
    copulative_verb(V),
    noun_phrase(NP).

% V copulativo + SAdvP + SP  (was far from immediate)
verb_phrase(vp(V, AdvP, PP)) -->
    copulative_verb(V),
    adv_phrase(AdvP),
    prep_phrase(PP).

% V transitivo + SN + SP
verb_phrase(vp(V, NP, PP)) -->
    transitive_verb(V),
    noun_phrase(NP),
    prep_phrase(PP).

% Aux + V intransitivo
verb_phrase(vp(Aux, V)) -->
    auxiliary(Aux),
    intransitive_verb(V).

% Aux + V copulativo + SA
verb_phrase(vp(Aux, V, AP)) -->
    auxiliary(Aux),
    copulative_verb(V),
    adj_phrase(AP).

% Aux + V transitivo + SN
verb_phrase(vp(Aux, V, NP)) -->
    auxiliary(Aux),
    transitive_verb(V),
    noun_phrase(NP).

% Aux + V transitivo  (pasiva sin complemento)
verb_phrase(vp(Aux, V)) -->
    auxiliary(Aux),
    transitive_verb(V).

% Aux + V copulativo  (be been…)
verb_phrase(vp(Aux, V)) -->
    auxiliary(Aux),
    copulative_verb(V).

% Aux + V copulativo + SN  (predicado nominal con aux: was named h)
verb_phrase(vp(Aux, V, NP)) -->
    auxiliary(Aux),
    copulative_verb(V),
    noun_phrase(NP).

% V copulativo + [to] + Aux + V intransitivo  (seemed to have stalled)
verb_phrase(vp(V, infp(aux(A), v(V2)))) -->
    copulative_verb(V),
    [to],
    auxiliary(aux(A)),
    intransitive_verb(v(V2)).

% --- Grupo adjetival (ap) ---

% Adjetivo solo
adj_phrase(ap(adj(A))) -->
    adjective(adj(A)).

% Adv + Adj  (very important, far from…)
adj_phrase(ap(adv(D), adj(A))) -->
    adverb(adv(D)),
    adjective(adj(A)).

% --- Grupo adverbial (advp) ---

adv_phrase(advp(adv(D))) -->
    adverb(adv(D)).

% --- Grupo preposicional (pp) ---

% Prep + SN  (caso normal)
prep_phrase(pp(Prep, NP)) -->
    preposition(Prep),
    noun_phrase(NP).

% Prep + SA  (from immediate, as essential)
prep_phrase(pp(Prep, AP)) -->
    preposition(Prep),
    adj_phrase(AP).

% =============================================================================
% Terminales DCG
% =============================================================================

determiner(det(P))      --> [P], { is_determiner(P) }.
noun(n(P))              --> [P], { is_noun(P) }.
adjective(adj(P))       --> [P], { is_adjective(P) }.
adverb(adv(P))          --> [P], { is_adverb(P) }.
conjunction(conj(P))    --> [P], { is_conjunction(P) }.
relative(rel(P))        --> [P], { is_relative(P) }.
preposition(prep(P))    --> [P], { is_preposition(P) }.
auxiliary(aux(P))       --> [P], { is_auxiliary(P) }.

transitive_verb(v(P))   --> [P], { is_transitive_verb(P) }.
intransitive_verb(v(P)) --> [P], { is_intransitive_verb(P) }.
copulative_verb(v(P))   --> [P], { is_copulative_verb(P) }.

% =============================================================================
% Clasificación léxica — inglés
% =============================================================================

is_determiner(P) :- memberchk(P, [
    the, a, an, this, that, these, those, its, our, their,
    another, other, one, each, any, such, some, no, all, both, many
]).

is_conjunction(P) :- memberchk(P, [
    and, but, or, although, however, well, yet, if
]).

is_relative(P) :- memberchk(P, [
    that, which, who, where, what
]).

is_preposition(P) :- memberchk(P, [
    in, of, for, to, from, at, on, by, with, through, into, about,
    as, after, since, until, during, per, between, according, over,
    upon, within
]).

is_adverb(P) :- memberchk(P, [
    not, very, also, likewise, fortunately, finally, precisely,
    directly, completely, definitively, always, often, only, just,
    eventually, far, simply, surely, so, somewhat, then, first,
    classically, similarly, already, still, here, now,
    never, ever, truly, accurately
]).

is_adjective(P) :- memberchk(P, [
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

is_auxiliary(P) :- memberchk(P, [
    was, were, is, are, have, had, can, could, should, would,
    may, might, do, does, did, be, been, being, has
]).

is_copulative_verb(P) :- memberchk(P, [
    % Cópulas directas en inglés
    is, are, was, were, be, been,
    % Verbos atributivos
    became, become, seem, seemed, appears, appeared, remain, remained,
    come, came, known, named, considered, established, related
]).

is_transitive_verb(P) :- memberchk(P, [
    played, plays, governs, govern, challenges, challenged, proposed,
    made, make, contradicted, contradict,
    confirmed, highlighted, consolidated, contributed, absorbed, absorbs,
    radiates, radiated, strikes, ejects, used, managed, gave, quantified,
    called, exhibited, introduced, expounded, found, conducted,
    said, determined, presented, explained, laid, heard,
    states, stated, showed, hitting, established, observed,
    represented, formulating, understand, know, measure, find, explain,
    solve, establish, give, manifest, show, conduct, confirm, highlight,
    consider, determine, present, propose, introduce, name, use, manage,
    exhibit, quantify, call, absorb, radiate, strike, eject, hear,
    expressed, proved, demonstrated, reveal, suggest
]).

is_intransitive_verb(P) :- memberchk(P, [
    exists, exist, stalled, grew, grow, acts, act, appears, appear,
    began, begin, plunges, plunge, started, start, contributed,
    contribute, possessed, possess, passes, pass, stall,
    proceeded, proceed
]).

is_noun(P) :-
    corpus_token(P),
    \+ is_determiner(P),
    \+ is_conjunction(P),
    \+ is_relative(P),
    \+ is_preposition(P),
    \+ is_adverb(P),
    \+ is_adjective(P),
    \+ is_auxiliary(P),
    \+ is_copulative_verb(P),
    \+ is_transitive_verb(P),
    \+ is_intransitive_verb(P).

% =============================================================================
% Tokens del corpus (inglés) — usado para inferir nombres por exclusión
% =============================================================================

corpus_token(P) :- memberchk(P, [
    % Números y valores especiales
    1900, 1905, 1927, 1981, '6.626x10-34',
    % Pronombres y expletivos (tratados como nombres en la gramática)
    it, its, they, their, he, you, we, there, itself, themselves,
    this, that, those, one, each,
    % Determinantes
    the, a, an, another, other, some, no, all, both, many, such, any,
    % Conjunciones
    and, but, or, although, however, well, yet,
    % Relativos
    that, which, who, where, what,
    % Preposiciones
    in, of, for, to, from, at, on, by, with, through, into, about, as,
    after, since, until, during, per, between, according, over,
    % Adverbios
    not, very, also, likewise, fortunately, finally, precisely, directly,
    completely, definitively, always, often, only, just, eventually, far,
    simply, surely, so, somewhat, then, first, classically,
    % Adjetivos
    essential, fundamental, innovative, impossible, immediate, bold,
    coherent, efficient, characteristic, certain, perplexing, subatomic,
    poetic, romantic, usual, wavelike, microscopic, international,
    revolutionary, theoretical, forbidden, important, indispensable,
    multiple, photoelectric, able, early, exact, miniature, small,
    new, great, absolute, different, proportional, quantized, discretized,
    general, similar, black, true, quantum, constant,
    % Auxiliares (también cópulas cuando son verbo principal)
    was, were, is, are, have, had, can, could, should, would, may,
    might, do, does, did, be, been, being, has,
    % Verbos copulativos
    became, become, seemed, seems, appeared, come, came,
    known, named, considered, established, related,
    % Pronombres / expletivos
    there, itself, themselves, himself, herself,
    % Verbos transitivos
    played, governs, challenges, proposed, confirmed, highlighted,
    consolidated, contributed, absorbed, absorbs, radiates, strikes,
    ejects, used, managed, gave, quantified, called, exhibited,
    introduced, expounded, found, conducted, said, determined,
    presented, explained, laid, heard, states, showed, hitting,
    represented, formulating, observed, manages,
    % Verbos intransitivos
    exists, exist, stalled, grew, grow, acts, began, plunges,
    possessed, passes, pass, contributed, appeared,
    % Nombres del dominio (física cuántica)
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
    % Participios y gerundios usados como nombres/modificadores
    emitted, observed, deduced, showing, laying, playing, betting,
    hitting, taking, place, based, composed, called,
    % Palabras adicionales que no caen en otras categorías
    force, role, context, key, understanding, order, words, example,
    constant, problem, body, object, groundwork, need, consider,
    consolidate, highlight, establish, show, give, manifest, itself,
    photons, quanta, diffraction, electron, master
]).
