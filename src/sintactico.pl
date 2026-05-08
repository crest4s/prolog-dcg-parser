/*=============================================================================
 * sintactico.pl — Gramática DCG para inglés (versión robusta con fallback)
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================*/

:- module(sintactico, [parse/3, simplify/2, simplify_and_draw/1]).

:- discontiguous compound_s/3.
:- discontiguous vp_base/3.
:- discontiguous noun_phrase_simple/3.
:- discontiguous extract_from_vp/3.
:- discontiguous extract_from_np/3.

:- use_module(draw).
:- use_module(library(time)).
:- use_module(library(lists)).

% =============================================================================
% parse/3 — punto de entrada con fallback flexible
%
% No usamos call_with_time_limit anidado para no enmascarar el time_limit
% del runner externo. Para oraciones muy largas saltamos la gramática
% estructurada (que tiene retroceso exponencial) y vamos directos al
% parser flexible.
% =============================================================================

parse(Trees, Tokens, Rest) :-
    length(Tokens, N),
    N =< 25,
    phrase(sentence(Trees), Tokens, Rest),
    !.
parse(Trees, Tokens, []) :-
    flex_parse(Tokens, Trees0),
    Trees0 \= [],
    Trees = Trees0.

% =============================================================================
% Reglas de oraciones (gramática estructurada)
% =============================================================================

opt_comma --> [','], !.
opt_comma --> [].

sentence(Trees)  --> compound_s(Trees), !.
sentence(Trees)  --> relative_s(Trees), !.
sentence(Trees)  --> subordinate_adv_s(Trees), !.
sentence(Trees)  --> coord_s(Trees), !.
sentence(Trees)  --> coord_shared_subj(Trees), !.
sentence(Trees)  --> coord_shared_verb(Trees), !.
sentence(Trees)  --> participle_both_s(Trees), !.
sentence(Trees)  --> participle_fronted_s(Trees), !.
sentence(Trees)  --> participle_postsubj_s(Trees), !.
sentence(Trees)  --> participle_trailing_s(Trees), !.
sentence(Trees)  --> that_complement_s(Trees), !.
sentence([Tree]) --> simple_s(Tree).

% --- Oraciones Simples ---
simple_s(s(NP, VP)) --> noun_phrase(NP), verb_phrase(VP).
simple_s(s(NP, vp(Adv, VP))) --> adverb(Adv), opt_comma, noun_phrase(NP), verb_phrase(VP).
simple_s(s(NP, vp(Conj, VP))) --> conjunction(Conj), opt_comma, noun_phrase(NP), verb_phrase(VP).
simple_s(s(NP, vp(PP, VP))) --> prep_phrase(PP), opt_comma, noun_phrase(NP), verb_phrase(VP).
simple_s(s(NP, vp(Adv, PP, VP))) --> adverb(Adv), opt_comma, prep_phrase(PP), opt_comma, noun_phrase(NP), verb_phrase(VP).
simple_s(s(NP, vp(Conj, PP, VP))) --> conjunction(Conj), opt_comma, prep_phrase(PP), opt_comma, noun_phrase(NP), verb_phrase(VP).
simple_s(s(NP, vp(Inf, VP))) --> fronted_infinitive(Inf), opt_comma, noun_phrase(NP), verb_phrase(VP).
simple_s(s(NP, vp(as_if, VP))) --> [as, if], noun_phrase(NP), verb_phrase(VP).

% --- Oraciones Subordinadas Adverbiales ---
subordinate_adv_s([s(NP1, vp(Conj, VP1)), s(NP2, VP2)]) -->
    conjunction(Conj), simple_s(s(NP1, VP1)), opt_comma, simple_s(s(NP2, VP2)).
subordinate_adv_s([s(NP1, vp(Conj1, vp(Conj2, VP1))), s(NP2, VP2)]) -->
    conjunction(Conj1), opt_comma, conjunction(Conj2), simple_s(s(NP1, VP1)), opt_comma, simple_s(s(NP2, VP2)).

% --- Coordinadas ---
coord_s([S1, S2]) --> simple_s(S1), opt_comma, conjunction(_), simple_s(S2).

% --- Coordinadas con sujeto compartido ---
% vp_base (sin coord_tail) para que la conjunción quede disponible
coord_shared_subj([s(NP, VP1), s(NP, VP2)]) -->
    noun_phrase(NP), vp_base(VP1), opt_comma, conjunction(_), verb_phrase(VP2).
coord_shared_subj([s(NP, VP1), s(NP, VP2)]) -->
    noun_phrase(NP), auxiliary(_Aux), [not, only], vp_base(VP1), opt_comma, [but, also], verb_phrase(VP2).

% --- Coordinadas con verbo transitivo compartido ---
% noun_phrase_simple (sin coord_tail) para que la conjunción quede disponible
coord_shared_verb([s(NP, vp(V, NP1)), s(NP, vp(V, NP2))]) -->
    noun_phrase(NP), transitive_verb(V), noun_phrase_simple(NP1), opt_comma, conjunction(_), noun_phrase(NP2).

% --- Subordinadas de relativo ---
relative_s([s(NP, VP_sub), s(NP, VP_main)]) --> noun_phrase(NP), opt_comma, relative(_), verb_phrase(VP_sub), opt_comma, verb_phrase(VP_main).
relative_s_single(s(NP, vp(Rel, VP_sub, VP_main))) --> noun_phrase(NP), opt_comma, relative(Rel), verb_phrase(VP_sub), opt_comma, verb_phrase(VP_main).
relative_s_single(s(NP, VP_sub)) --> noun_phrase(NP), relative(_), verb_phrase(VP_sub).

% --- Oraciones compuestas (ocm) ---
% Relativa (2 árboles) + conj + simple → 3 árboles
compound_s([S1, S2, S3]) --> relative_s([S1, S2]), opt_comma, conjunction(_), simple_s(S3).
compound_s([S1 | Resto]) --> unit_s(S1), opt_comma, conjunction(_), (compound_s(Resto) ; unit_s_list(Resto)).
compound_s([S1, s(np(n(he)), VP)]) --> simple_s(S1), opt_comma, [he], verb_phrase(VP).

unit_s(S) --> simple_s(S).
unit_s(S) --> relative_s_single(S).
unit_s_list([S]) --> unit_s(S).

% --- Complemento con "that" ---
that_complement_s([s(NP, VP) | SubTrees]) --> noun_phrase(NP), verb_phrase(VP), [that], sentence(SubTrees).

% --- Cláusulas participiales ---
participle_fronted_s([s(NP, VP_part), s(NP, VP_main)]) --> participle_phrase(VP_part), opt_comma, noun_phrase(NP), verb_phrase(VP_main).
participle_postsubj_s([s(NP, VP_part), s(NP, VP_main)]) --> noun_phrase(NP), opt_comma, participle_phrase(VP_part), opt_comma, verb_phrase(VP_main).
participle_trailing_s([s(NP, vp(PP, VP_main)), s(NP, VP_part)]) --> prep_phrase(PP), opt_comma, noun_phrase(NP), verb_phrase(VP_main), opt_comma, participle_phrase(VP_part).
participle_trailing_s([s(NP, VP_main), s(NP, VP_part)]) --> noun_phrase(NP), verb_phrase(VP_main), opt_comma, participle_phrase(VP_part).

participle_both_s([s(NP, VP_part1), s(NP, vp(PP, VP_main)), s(NP, VP_part2)]) -->
    prep_phrase(PP), opt_comma, participle_phrase(VP_part1), opt_comma, noun_phrase(NP), verb_phrase(VP_main), opt_comma, participle_phrase(VP_part2).


% =============================================================================
% Simplificación y Extracción
% =============================================================================

simplify(Trees, Simples) :-
    catch(do_simplify(Trees, Simples0), _, Simples0 = Trees),
    sort(Simples0, Simples).

do_simplify(Trees, Simples) :-
    flatten_sentences(Trees, Flat0),
    maplist(normalize_simple, Flat0, Flat1),
    append(Flat1, Simples0),
    findall(Extra, (member(S, Simples0), extract_all_subs(S, Extra)), ExtrasNested),
    flatten(ExtrasNested, Extras),
    append(Simples0, Extras, All0),
    maplist(remove_relcl, All0, Simples).

flatten_sentences([], []) :- !.
flatten_sentences([H | T], Flat) :- !, flatten_sentences(H, FH), flatten_sentences(T, FT), append(FH, FT, Flat).
flatten_sentences(S, [S]) :- nonvar(S).

normalize_simple(s(NP, VP), [s(NP, VP)]) :- !.
normalize_simple(s(_, NP, VP), [s(NP, VP)]) :- !.
normalize_simple(Other, [Other]).

extract_all_subs(s(NP, VP), Subs) :-
    findall(Sub, extract_from_vp(VP, NP, Sub), SubsVP),
    findall(Sub, extract_from_np(NP, NP, Sub), SubsNP),
    append(SubsVP, SubsNP, Subs).
extract_all_subs(_, []).

extract_from_vp(vp(_, Arg), Subj, Sub) :- nonvar(Arg), extract_from_np(Arg, Subj, Sub).
extract_from_vp(vp(_, Arg, _), Subj, Sub) :- nonvar(Arg), extract_from_np(Arg, Subj, Sub).
extract_from_vp(vp(_, _, Arg), Subj, Sub) :- nonvar(Arg), extract_from_np(Arg, Subj, Sub).
extract_from_vp(vp(_, _, Arg, _), Subj, Sub) :- nonvar(Arg), extract_from_np(Arg, Subj, Sub).
extract_from_vp(vp(_, that(SubTrees)), _, Sub) :- is_list(SubTrees), member(Sub, SubTrees).
extract_from_vp(vp(_, _, that(SubTrees)), _, Sub) :- is_list(SubTrees), member(Sub, SubTrees).
extract_from_vp(vp(VP1, _, VP2), Subj, Sub) :- (extract_from_vp(VP1, Subj, Sub) ; extract_from_vp(VP2, Subj, Sub)).
extract_from_vp(vp(_, VP_inner), Subj, Sub) :- extract_from_vp(VP_inner, Subj, Sub).

extract_from_np(np(Base, relcl(_, VPRel)), _, s(Base, VPRel)).
extract_from_np(np(_, relcl(_, _, S)), _, S).
extract_from_np(np(_, relcl(_, S1, _, _)), _, S1).
extract_from_np(np(_, relcl(_, _, _, pp(_, _, S2))), _, S2).
extract_from_np(np(Base, relcl(contact, S)), _, s(Base, VP)) :- S = s(_, VP).
extract_from_np(np(_, that(SubTrees)), _, Sub) :- is_list(SubTrees), member(Sub, SubTrees).
extract_from_np(np(_, S), _, S) :- S = s(_, _).
extract_from_np(np(Base, VP_part), _, s(Base, VP_part)) :- VP_part = vp(V, _), is_participle_head(V).
extract_from_np(np(Base, VP_part), _, s(Base, VP_part)) :- VP_part = vp(V, _, _), is_participle_head(V).
extract_from_np(np(_, _, NP2), Subj, Sub) :- compound(NP2), extract_from_np(NP2, Subj, Sub).

remove_relcl(s(NP, VP), s(CleanNP, CleanVP)) :- clean_np(NP, CleanNP), clean_vp(VP, CleanVP).
remove_relcl(Other, Other).

clean_np(np(Base, relcl(_,_)), Base) :- !.
clean_np(np(Base, relcl(_,_,_)), Base) :- !.
clean_np(np(Base, relcl(_,_,_,_)), Base) :- !.
clean_np(np(Base, that(_)), Base) :- !.
clean_np(np(Base, S), Base) :- S = s(_,_), !.
clean_np(np(Base, vp(V, _)), Base) :- is_participle_head(V), !.
clean_np(np(Base, vp(V, _, _)), Base) :- is_participle_head(V), !.
clean_np(np(Det, AP, N, NP2), np(Det, AP, N, Clean2)) :- clean_np(NP2, Clean2), !.
clean_np(NP, NP).

clean_vp(vp(conj(_), vp(conj(_), VP)), Clean) :- clean_vp(VP, Clean), !.
clean_vp(vp(conj(_), VP), Clean) :- clean_vp(VP, Clean), !.
clean_vp(vp(adv(_), VP), Clean) :- clean_vp(VP, Clean), !.
clean_vp(vp(PP, VP), Clean) :- PP = pp(_,_), clean_vp(VP, Clean), !.
clean_vp(vp(V, NP), vp(V, CleanNP)) :- (V = v(_) ; V = aux(_)), clean_np(NP, CleanNP), !.
clean_vp(vp(V, NP, X), vp(V, CleanNP, X)) :- (V = v(_) ; V = aux(_)), clean_np(NP, CleanNP), !.
clean_vp(vp(V, X, NP), vp(V, X, CleanNP)) :- (V = v(_) ; V = aux(_)), clean_np(NP, CleanNP), !.
clean_vp(VP, VP).

% =============================================================================
% Grupos sintácticos (NP, VP, AP, PP)
% =============================================================================

% --- Grupo nominal (np) ---
noun_phrase(NP) --> noun_phrase_simple(NP1), noun_phrase_coord_tail(NP1, NP).
noun_phrase_coord_tail(NP1, np(NP1, Conj, NP2)) --> opt_comma, conjunction(Conj), noun_phrase(NP2), !.
noun_phrase_coord_tail(NP, NP) --> [].

np_base(np(N)) --> noun(N).
np_base(np(Det, N)) --> determiner(Det), noun(N).
np_base(np(det(D))) --> determiner(det(D)).   % bare det: only when no noun follows
np_base(np(Det, N1, N2)) --> determiner(Det), noun(N1), noun(N2).
np_base(np(Det, N1, N2, N3)) --> determiner(Det), noun(N1), noun(N2), noun(N3).
np_base(np(N1, N2)) --> noun(N1), noun(N2).
np_base(np(N1, N2, N3)) --> noun(N1), noun(N2), noun(N3).
np_base(np(AP, N)) --> adj_phrase(AP), noun(N).
np_base(np(AP, N1, N2)) --> adj_phrase(AP), noun(N1), noun(N2).
np_base(np(Det, AP, N)) --> determiner(Det), adj_phrase(AP), noun(N).
np_base(np(Det, AP, N1, N2)) --> determiner(Det), adj_phrase(AP), noun(N1), noun(N2).
np_base(np(Det1, Det2, N)) --> determiner(Det1), determiner(Det2), noun(N).
np_base(np(det(a), adj(great), det(many), N)) --> [a, great, many], noun(N).
np_base(np(rel(what), VP)) --> [what], verb_phrase(VP).
np_base(np(n(those), AP, that(S))) --> [those], adj_phrase(AP), [that], sentence(S).

noun_phrase_simple(np(Base, PP)) --> np_base(Base), prep_phrase(PP).
noun_phrase_simple(np(Base, AP)) --> np_base(Base), adj_phrase(AP).
noun_phrase_simple(np(Base, PP1, PP2)) --> np_base(Base), prep_phrase(PP1), prep_phrase(PP2).

noun_phrase_simple(np(Base, that(S))) --> np_base(Base), [that], sentence(S).
noun_phrase_simple(np(Base, relcl(where, S))) --> np_base(Base), [where], simple_s(S).
noun_phrase_simple(np(Base, relcl(Rel, VPRel))) --> np_base(Base), opt_comma, relative(Rel), verb_phrase(VPRel).
noun_phrase_simple(np(Base, relcl(Rel, SRel))) --> np_base(Base), opt_comma, relative(Rel), simple_s(SRel).
noun_phrase_simple(np(Base, relcl(Rel1, S1, conj(C), pp(Prep, Rel2, S2)))) -->
    np_base(Base), opt_comma, relative(Rel1), simple_s(S1), opt_comma, conjunction(C), preposition(Prep), relative(Rel2), simple_s(S2).

noun_phrase_simple(np(Base, relcl(contact, s(np(n(Pron)), VP)))) -->
    np_base(Base), [Pron], { memberchk(Pron, [they, he, she, it, we, you, i]) }, verb_phrase(VP).

noun_phrase_simple(np(Base, Appos)) --> np_base(Base), [','], np_base(Appos), [','].
noun_phrase_simple(np(Base, conj(that_is), NP)) --> np_base(Base), [',', that, is, ','], noun_phrase(NP).
noun_phrase_simple(np(Base, ParticipleP)) --> np_base(Base), opt_comma, participle_phrase(ParticipleP).
noun_phrase_simple(Base) --> np_base(Base).

% --- Grupo verbal (vp) ---
verb_phrase(VP) --> vp_base(VP1), vp_coord_tail(VP1, VP).
vp_coord_tail(VP1, vp(VP1, Conj, VP2)) --> opt_comma, conjunction(Conj), verb_phrase(VP2), !.
vp_coord_tail(VP, VP) --> [].

vp_base(vp(V)) --> intransitive_verb(V).
vp_base(vp(V, PP)) --> intransitive_verb(V), prep_phrase(PP).
vp_base(vp(Adv, V)) --> adverb(Adv), intransitive_verb(V).
vp_base(vp(Adv, AP)) --> adverb(Adv), adj_phrase(AP).

vp_base(vp(V, NP)) --> transitive_verb(V), noun_phrase(NP).
vp_base(vp(V, NP, PP)) --> transitive_verb(V), noun_phrase(NP), prep_phrase(PP).
vp_base(vp(V, PP, NP)) --> transitive_verb(V), prep_phrase(PP), noun_phrase(NP).
vp_base(vp(V, PP1, NP, PP2)) --> transitive_verb(V), prep_phrase(PP1), noun_phrase(NP), prep_phrase(PP2).
vp_base(vp(V, NP, NP2)) --> transitive_verb(V), noun_phrase(NP), noun_phrase(NP2).
vp_base(vp(Adv, V, NP)) --> adverb(Adv), transitive_verb(V), noun_phrase(NP).
vp_base(vp(Adv, V, NP, PP)) --> adverb(Adv), transitive_verb(V), noun_phrase(NP), prep_phrase(PP).

vp_base(vp(V, AP)) --> copulative_verb(V), adj_phrase(AP).
vp_base(vp(V, NP)) --> copulative_verb(V), noun_phrase(NP).
vp_base(vp(V, NP, PP)) --> copulative_verb(V), noun_phrase(NP), prep_phrase(PP).
vp_base(vp(V, AP, PP)) --> copulative_verb(V), adj_phrase(AP), prep_phrase(PP).
vp_base(vp(V, Adv, AP)) --> copulative_verb(V), adverb(Adv), adj_phrase(AP).
vp_base(vp(V, Adv, PP)) --> copulative_verb(V), adverb(Adv), prep_phrase(PP).

vp_base(vp(Aux, V)) --> auxiliary(Aux), intransitive_verb(V).
vp_base(vp(Aux, V, NP)) --> auxiliary(Aux), transitive_verb(V), noun_phrase(NP).
vp_base(vp(Aux, V))    --> auxiliary(Aux), transitive_verb(V).   % pasiva sin complemento
vp_base(vp(Aux, V))    --> auxiliary(Aux), copulative_verb(V).   % was named, was called…
vp_base(vp(Aux, V, AP)) --> auxiliary(Aux), copulative_verb(V), adj_phrase(AP).
vp_base(vp(Aux, V, PP)) --> auxiliary(Aux), copulative_verb(V), prep_phrase(PP).
vp_base(vp(Aux, Adv, V)) --> auxiliary(Aux), adverb(Adv), (intransitive_verb(V); transitive_verb(V)).
vp_base(vp(Aux, Adv, V, NP)) --> auxiliary(Aux), adverb(Adv), transitive_verb(V), noun_phrase(NP).
vp_base(vp(Aux, Adv, V, PP)) --> auxiliary(Aux), adverb(Adv), (transitive_verb(V);copulative_verb(V)), prep_phrase(PP).
vp_base(vp(Aux, Adv, AP)) --> auxiliary(Aux), adverb(Adv), adj_phrase(AP).
vp_base(vp(Aux1, Aux2, V, PP)) --> auxiliary(Aux1), auxiliary(Aux2), copulative_verb(V), prep_phrase(PP).
vp_base(vp(Aux1, Aux2, AP)) --> auxiliary(Aux1), auxiliary(Aux2), adj_phrase(AP).

vp_base(vp(V, to, V2)) --> copulative_verb(V), [to], intransitive_verb(V2).
vp_base(vp(V, to, V2, NP)) --> (intransitive_verb(V); transitive_verb(V)), [to], transitive_verb(V2), noun_phrase(NP).
vp_base(vp(V, to, Aux, V2, PP)) --> copulative_verb(V), [to], auxiliary(Aux), (copulative_verb(V2); transitive_verb(V2)), prep_phrase(PP).
vp_base(vp(V, to, Aux, V2)) --> copulative_verb(V), [to], auxiliary(Aux), intransitive_verb(V2).

vp_base(vp(Aux1, Aux2, V, AP)) --> auxiliary(Aux1), auxiliary(Aux2), copulative_verb(V), adj_phrase(AP).

vp_base(vp(V, that(S))) --> (transitive_verb(V); participle_head(V)), [that], sentence(S).
vp_base(vp(Aux, Adv, V, that(S))) --> auxiliary(Aux), adverb(Adv), transitive_verb(V), [that], sentence(S).
vp_base(vp(V, NP, that(S))) --> transitive_verb(V), noun_phrase(NP), [that], sentence(S).

% --- Grupo adjetival (ap) ---
adj_phrase(AP) --> adj_phrase_simple(AP1), adj_phrase_coord_tail(AP1, AP).
adj_phrase_coord_tail(AP1, ap(AP1, Conj, AP2)) --> opt_comma, conjunction(Conj), adj_phrase(AP2), !.
adj_phrase_coord_tail(AP, AP) --> [].

adj_phrase_simple(ap(adj(A))) --> adjective(adj(A)).
adj_phrase_simple(ap(adv(Adv), adj(Adj))) --> adverb(adv(Adv)), adjective(adj(Adj)).
adj_phrase_simple(ap(adj(A), AP)) --> adjective(adj(A)), adj_phrase_simple(AP).
adj_phrase_simple(ap(adj(A), fronted(to, VP))) --> adjective(adj(A)), [to], verb_phrase(VP).

% --- Grupo preposicional (pp) ---
prep_phrase(pp(Prep, NP)) --> preposition(Prep), noun_phrase(NP).
prep_phrase(pp(Prep, Rel, SRel)) --> preposition(Prep), relative(Rel), simple_s(SRel).
prep_phrase(pp(Prep, VP)) --> preposition(Prep), verb_phrase(VP).
prep_phrase(pp(Prep, AP)) --> preposition(Prep), adj_phrase(AP).
prep_phrase(pp(prep(according), PP)) --> [according], prep_phrase(PP).
prep_phrase(pp(prep(in), np(n(order)), fronted(to, VP))) --> [in, order, to], verb_phrase(VP).

fronted_infinitive(fronted(to, VP)) --> [to], verb_phrase(VP).

% --- Cláusulas participiales ---
participle_head(v(P)) --> [P], { is_participle_head(P) }.
participle_phrase(vp(V, NP)) --> participle_head(V), noun_phrase(NP).
participle_phrase(vp(V, PP)) --> participle_head(V), prep_phrase(PP).
participle_phrase(vp(V, NP, PP)) --> participle_head(V), noun_phrase(NP), prep_phrase(PP).
participle_phrase(vp(V, PP, Appos)) --> participle_head(V), prep_phrase(PP), proper_name_np(Appos).
participle_phrase(vp(V, that(SubTrees))) --> participle_head(V), [that], sentence(SubTrees).

is_participle_head(P) :-
    memberchk(P, [named, based, deduced, represented, playing, laying, showing,
                  betting, quantified, observed, composed, called, taking,
                  hitting, emitted, conducted, considered, established]).

proper_name_np(np(N1, N2)) --> noun(N1), noun(N2).

% =============================================================================
% Léxico
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

is_determiner(P) :- memberchk(P, [the, a, an, this, that, these, those, its, our,
    their, another, other, one, each, any, such, some, no, all, both, many]).
is_conjunction(P) :- memberchk(P, [and, but, or, although, however, well, yet, if]).
is_relative(P) :- memberchk(P, [that, which, who, where, what]).
is_preposition(P) :- memberchk(P, [in, of, for, to, from, at, on, by, with, through,
    into, about, as, after, since, until, during, per, between, according, over,
    upon, within, without]).
is_adverb(P) :- memberchk(P, [not, very, also, likewise, fortunately, finally,
    precisely, directly, completely, definitively, always, often, only, just,
    eventually, far, simply, surely, so, somewhat, then, first, classically,
    similarly, already, still, here, now, never, ever, truly, accurately]).
is_adjective(P) :- memberchk(P, [essential, fundamental, innovative, impossible,
    immediate, bold, coherent, efficient, characteristic, certain, perplexing,
    subatomic, poetic, romantic, usual, wavelike, microscopic, international,
    revolutionary, theoretical, forbidden, important, indispensable, multiple,
    photoelectric, able, early, exact, miniature, small, new, great, absolute,
    different, proportional, quantized, discretized, general, similar, black,
    precise, basic, quantum, true, specific, unique, natural, physical,
    perceptible, complete, various, considered, master, established]).
is_auxiliary(P) :- memberchk(P, [was, were, is, are, have, had, can, could,
    should, would, may, might, do, does, did, be, been, being, has]).
is_copulative_verb(P) :- memberchk(P, [is, are, was, were, be, been, became,
    become, seem, seemed, appears, appeared, remain, remained, come, came,
    known, named, considered, related]).
is_transitive_verb(P) :- memberchk(P, [played, plays, governs, govern,
    challenges, challenged, proposed, made, make, contradicted, contradict,
    confirmed, highlighted, consolidated, contributed, absorbed, absorbs,
    radiates, radiated, strikes, ejects, used, managed, gave, quantified,
    called, exhibited, introduced, expounded, found, conducted, said,
    determined, presented, explained, laid, heard, states, stated, showed,
    hitting, observed, represented, formulating, understand, know, measure,
    find, explain, solve, establish, give, manifest, show, conduct, confirm,
    highlight, consider, determine, present, propose, introduce, name, use,
    manage, exhibit, quantify, call, absorb, radiate, strike, eject, hear,
    expressed, proved, demonstrated, reveal, suggest, plunges]).
is_intransitive_verb(P) :- memberchk(P, [exists, exist, stalled, grew, grow,
    acts, act, appears, appear, began, begin, plunge, started, start,
    contributed, contribute, possessed, possess, passes, pass, stall,
    proceeded, proceed]).

% Cualquier átomo numérico es nombre.
is_noun(P) :- atom(P), atom_number(P, _), !.
% Cualquier átomo no clasificado en otra categoría se considera nombre.
is_noun(P) :-
    atom(P),
    P \== ',', P \== to,
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
% Parser flexible de respaldo (chunk parser)
% =============================================================================
%
% Si la gramática estructurada no logra parsear toda la oración, se segmenta
% el flujo de tokens en cláusulas simples consumiendo el prefijo más largo
% que coincida con simple_s y descartando separadores entre cláusulas
% (comas, conjunciones, relativos, "that", "to", "where").
% =============================================================================

flex_parse([], []).
flex_parse(Tokens, Out) :-
    skip_seps_list(Tokens, T1),
    T1 \== [],
    longest_simple(T1, Tree, T2),
    !,
    flex_parse(T2, Rest),
    Out = [Tree | Rest].
flex_parse([_ | Rest], Out) :-
    flex_parse(Rest, Out).

skip_seps_list([], []).
skip_seps_list([H | T], Out) :-
    is_clause_sep(H), !,
    skip_seps_list(T, Out).
skip_seps_list(L, L).

is_clause_sep(',').
is_clause_sep(P) :- is_conjunction(P).
is_clause_sep(P) :- is_relative(P).
is_clause_sep(that).
is_clause_sep(where).
is_clause_sep(to).
is_clause_sep(as).
is_clause_sep(if).

% Encuentra el prefijo más largo que se parsea como simple_s o como
% un participle_phrase.
longest_simple(Tokens, Tree, Rest) :-
    length(Tokens, N),
    Cap is min(N, 22),
    longest_loop(Cap, Tokens, Tree, Rest).

longest_loop(K, Tokens, Tree, Rest) :-
    K >= 2,
    length(Prefix, K),
    append(Prefix, Rest, Tokens),
    try_unit(Tree, Prefix),
    !.
longest_loop(K, Tokens, Tree, Rest) :-
    K > 2,
    K1 is K - 1,
    longest_loop(K1, Tokens, Tree, Rest).

try_unit(Tree, Prefix) :- phrase(simple_s(Tree), Prefix).
try_unit(s(np(n(it)), Tree), Prefix) :- phrase(participle_phrase(Tree), Prefix).

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
    (   catch(draw(S), _, fail)
    ->  true
    ;   format("(tree too wide to draw)~n")
    ),
    Next is Num + 1,
    draw_sentences(Rest, Next).
