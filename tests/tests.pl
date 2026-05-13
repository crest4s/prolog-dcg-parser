/*=============================================================================
 * tests/tests.pl — Suite PLUnit
 * Práctica 2: Conocimiento y Razonamiento Automatizado, UAH 2025-26
 *
 * Ejecución desde la raíz del proyecto:
 *   swipl -g "run_tests, halt" -t "halt(1)" tests/tests.pl
 *=============================================================================*/

:- use_module(library(plunit)).
:- use_module(library(aggregate)).

:- consult('../sintactico').
:- consult('../deteccion').
:- consult('../mejoras').
:- consult('../conjunto_oraciones').


% =============================================================================
% Tests: corpus (frase/3)
% =============================================================================
:- begin_tests(corpus).

test(corpus_no_vacio) :-
    aggregate_all(count, frase(_, _, _), N),
    N > 0.

test(corpus_30_oraciones) :-
    aggregate_all(count, frase(_, _, _), N),
    N >= 30.

test(ids_unicos) :-
    findall(ID, frase(ID, _, _), IDs),
    sort(IDs, Sorted),
    length(IDs, N),
    length(Sorted, N).

test(tipos_validos) :-
    forall(frase(_, Tipo, _), memberchk(Tipo, [o, oc, or, ocm])).

test(hay_oracion_simple)      :- once(frase(_, o,   _)).
test(hay_oracion_coordinada)  :- once(frase(_, oc,  _)).
test(hay_oracion_relativa)    :- once(frase(_, or,  _)).
test(hay_oracion_compuesta)   :- once(frase(_, ocm, _)).

:- end_tests(corpus).


% =============================================================================
% Tests: DCG — oraciones simples del corpus
% =============================================================================
:- begin_tests(dcg_simples).

% Oración 1 — simple directa
test(oracion_1) :-
    once(oracion(Tree,
        [this, constant, played, an, essential, role,
         in, the, formulation, of, another, of,
         the, great, quantum, approaches], [])),
    functor(Tree, o, _).

% Oración 13 — adverbial inicial
test(oracion_13) :-
    once(oracion(Tree,
        [however, acceptance, of, this, idea,
         was, far, from, immediate], [])),
    functor(Tree, o, _).

% Oración 8 — preposicional inicial
test(oracion_8) :-
    once(oracion(Tree,
        [since, the, early, '20th', century,
         progress, in, physics, seemed, to, have, stalled], [])),
    functor(Tree, o, _).

% Oración 29 — adverbial + preposicional iniciales
test(oracion_29) :-
    once(oracion(Tree,
        [also, in, '1981', it, played, a, very, important, role,
         during, the, invention, of, the, tunnel, effect, microscope], [])),
    functor(Tree, o, _).

% Nodo raíz es o(...)
test(arbol_raiz_o) :-
    once(oracion(Tree, [the, constant, is, essential], [])),
    functor(Tree, o, _).

% La oración falla si la secuencia es gramaticalmente inválida
test(invalida_adj_inicial, fail) :-
    oracion(_, [essential, the, constant], []).

:- end_tests(dcg_simples).


% =============================================================================
% Tests: DCG — oraciones complejas (oc, or, ocm)
% =============================================================================
:- begin_tests(dcg_complejas).

% --- Coordinadas (oc) ---

% Sujeto compartido: GN + GV1 + conj + GV2
test(oc_sujeto_compartido) :-
    once(oracion(Tree,
        [it, played, a, role, and, laid, the, groundwork], [])),
    functor(Tree, oc, _).

% Sujetos distintos: clausula_base + conj + clausula_base
test(oc_sujetos_distintos) :-
    once(oracion(Tree,
        [planck, played, a, role, and, it, was, essential], [])),
    functor(Tree, oc, _).

% 'that'/'which' no deben generar un árbol oc (false-positive check)
test(oc_no_falso_positivo_that, fail) :-
    oracion(Tree, [planck, played, a, role, that, was, essential], []),
    functor(Tree, oc, _).

% --- Subordinadas de relativo (or) ---

% CR postverbal (modifica el sujeto): GN + GV + CR
% Hay parses oc y or — verificamos que exista al menos uno or.
test(or_cr_postverbal) :-
    findall(T, oracion(T, [the,constant,exists,which,planck,introduced], []), Trees),
    member(Tree, Trees),
    functor(Tree, or, _).

% CR modifica el objeto: GN1 + GV + GN2 + CR
% La gramática genera varios functores; verificamos la presencia de or.
test(or_cr_sobre_objeto) :-
    findall(T, oracion(T, [scientists,found,dilemmas,that,they,could,not,explain], []), Trees),
    once((member(Tree, Trees), functor(Tree, or, _))).

% --- Compuestas (ocm) ---

% Oración 2 — sustantiva + relativa anidada
% once da oc porque oc < or < ocm en el orden de reglas; buscamos ocm entre todos.
test(oracion_2) :-
    findall(T, oracion(T,
        [it, is, often, said, that, quantum, physics,
         is, a, discipline, that, challenges,
         the, perception, of, reality], []), Trees),
    once((member(Tree, Trees), functor(Tree, ocm, _))).

% Oración 3 — adverbial concesiva (well, although…)
test(oracion_3) :-
    once(oracion(Tree,
        [well, although, it, is, a, somewhat, poetic,
         and, romantic, phrase, in, part,
         it, can, be, considered, true], [])),
    functor(Tree, ocm, _).

% Oración 9 — dos cláusulas de relativo coordinadas
test(oracion_9) :-
    findall(T, oracion(T,
        [scientists, began, to, find, perplexing, dilemmas,
         that, they, could, not, explain,
         and, for, which, there, were, no,
         coherent, and, efficient, laws], []), Trees),
    once((member(Tree, Trees), functor(Tree, ocm, _))).

% Oración 4 — aposición demostrativa + coord. con sujeto nuevo
test(oracion_4) :-
    frase(4, _, T),
    findall(Tree, oracion(Tree, T, []), Trees),
    once((member(Tree, Trees), functor(Tree, ocm, _))).

% Oración 5 — dos cláusulas relativas sobre el mismo antecedente
test(oracion_5) :-
    frase(5, _, T),
    findall(Tree, oracion(Tree, T, []), Trees),
    once((member(Tree, Trees), functor(Tree, or, _))).

% Oración 6 — adjunto participial inicial con aposición nominal
test(oracion_6) :-
    frase(6, _, T),
    once(oracion(Tree, T, [])),
    functor(Tree, o, _).

% Oración 11 — locución "in order to" + dos cláusulas yuxtapuestas
test(oracion_11) :-
    frase(11, _, T),
    findall(Tree, oracion(Tree, T, []), Trees),
    once((member(Tree, Trees), functor(Tree, ocm, _))).

% Oración 15 — "such as" ejemplificativo entre sujeto y verbo
test(oracion_15) :-
    frase(15, _, T),
    findall(Tree, oracion(Tree, T, []), Trees),
    once((member(Tree, Trees), functor(Tree, or, _))).

% Oración 24 — GP + participio inicial + cláusula + gerundio "betting that"
test(oracion_24) :-
    frase(24, _, T),
    findall(Tree, oracion(Tree, T, []), Trees),
    once((member(Tree, Trees), functor(Tree, ocm, _))).

:- end_tests(dcg_complejas).


% =============================================================================
% Tests: grupos nominales y verbales
% =============================================================================
:- begin_tests(grupos).

% GN: Det + N
test(gn_det_n) :-
    once(g_nominal(gn(det(the), n(constant)), [the, constant], [])).

% GN: Det + N + N (nombre compuesto)
test(gn_nombre_compuesto) :-
    once(g_nominal(gn(det(the), n(planck), n(constant)),
                   [the, planck, constant], [])).

% GN: pronombre solo
test(gn_pronombre) :-
    once(g_nominal(gn(pron(it)), [it], [])).

% GV: verbo solo
test(gv_intransitivo) :-
    once(g_verbal(gv(v(exists)), [exists], [])).

% GV: verbo + GN
test(gv_transitivo) :-
    once(g_verbal(gv(v(played), _), [played, an, essential, role], [])).

% GP: prep + GN
test(gp_basico) :-
    once(g_preposicional(gp(prep(in), _), [in, physics], [])).

% GInf: to + V + GP  (e.g., "to pass through barriers")
test(ginf_v_gp) :-
    once(g_infinitivo(ginf(v(pass), gp(prep(through), _)),
                      [to, pass, through, barriers], [])).

% GADJ: adjetivo solo
test(gadj_simple) :-
    once(g_adjetival(gadj(adj(essential)), [essential], [])).

% GADJ: adv + adj
test(gadj_adv_adj) :-
    once(g_adjetival(gadj(adv(very), adj(important)), [very, important], [])).

% GV: V + GADJ + GI  ("is impossible to know")
test(gv_v_gadj_gi) :-
    once(g_verbal(gv(v(is), _, ginf(_)), [is, impossible, to, know], [])).

% GV: V + GP + GN  ("presented in 1900 an innovative idea")
test(gv_v_gp_gn) :-
    once(g_verbal(gv(v(presented), gp(_, _), _),
                  [presented, in, '1900', an, innovative, idea], [])).

% GV: V + GADV + GN  ("was not a constant value")
test(gv_v_gadv_gn) :-
    once(g_verbal(gv(v(was), gadv(adv(not)), _),
                  [was, not, a, constant, value], [])).

% GV: V + GN + GADJ  ("considered this idea essential")
test(gv_v_gn_gadj) :-
    once(g_verbal(gv(v(considered), _, gadj(adj(essential))),
                  [considered, this, idea, essential], [])).

% GV: V + Prep  (preposición varada "heard of")
test(gv_v_prep_varada) :-
    once(g_verbal(gv(v(heard), prep(of)), [heard, of], [])).

% GV: V + that + clausula_base  ("determined that it was essential")
test(gv_v_that_cb) :-
    once(g_verbal(gv(v(determined), conj(that), _),
                  [determined, that, it, was, essential], [])).

% GV: GI + conj + V + GN + GP  (GV coordinado complejo)
test(gv_gi_coord_v_gn_gp) :-
    once(g_verbal(gv(ginf(_, _), conj(and), v(laid), _, gp(prep(for), _)),
                  [to, give, role, and, laid, the, groundwork, for, physics], [])).

% GN: Det + GADJ + GP  ("a great many of the anxieties")
test(gn_det_gadj_gp) :-
    once(g_nominal(gn(det(a), _, gp(prep(of), _)),
                   [a, great, many, of, the, anxieties], [])).

% GN: GADJ + N + GP sin det  ("multiple integers of the constant")
test(gn_gadj_n_gp) :-
    once(g_nominal(gn(_, n(integers), gp(prep(of), _)),
                   [multiple, integers, of, the, constant], [])).

% GV: GADV + GADJ  ("finally able to explain…" tras correlativa)
test(gv_gadv_gadj) :-
    once(g_verbal(gv(gadv(adv(finally)), _),
                  [finally, able, to, explain, a, role], [])).

% GV: V + GN + V2  causativa ("made this idea grow")
test(gv_v_gn_v2) :-
    once(g_verbal(gv(v(made), _, v(grow)),
                  [made, this, idea, grow], [])).

% GV: Aux + V + that + clausula_base  ("was determined that it was essential")
test(gv_aux_v_that_cb) :-
    once(g_verbal(gv(v(was), v(determined), conj(that), _),
                  [was, determined, that, it, was, essential], [])).

% GInf: to + V + GN + GADV  ("to measure certain quantities accurately")
test(ginf_v_gn_gadv) :-
    once(g_infinitivo(ginf(v(measure), _, gadv(adv(accurately))),
                      [to, measure, certain, quantities, accurately], [])).

% GInf: to + V + GP + GNC  ("to know with precision the position and momentum")
test(ginf_v_gp_gnc) :-
    once(g_infinitivo(ginf(v(know), gp(prep(with), _), _),
                      [to, know, with, absolute, precision,
                       the, position, and, momentum], [])).

% GN: Det + N + GI  ("the ability to measure certain quantities")
test(gn_det_n_gi) :-
    once(g_nominal(gn(det(the), n(ability), ginf(v(measure), _)),
                   [the, ability, to, measure, certain, quantities], [])).

% GN: Pron + GADJ + CR  ("those so small that they are not perceptible")
test(gn_pron_gadj_cr) :-
    once(g_nominal(gn(pron(those), gadj(adv(so), adj(small)), _),
                   [those, so, small, that, they, are, not,
                    perceptible, to, our, eyes], [])).

% GV: V + GADV + V2 + Prep  ("have surely heard of")
test(gv_v_gadv_v2_prep) :-
    once(g_verbal(gv(v(have), gadv(adv(surely)), v(heard), prep(of)),
                  [have, surely, heard, of], [])).

% GV: V + GP + GI  ("acts as a master key to understanding…")
test(gv_v_gp_gi) :-
    once(g_verbal(gv(v(acts), gp(prep(as), _), ginf(v(understanding), _)),
                  [acts, as, a, master, key,
                   to, understanding, this, miniature, world], [])).

% GN: N + gpart(V, GN2)  ("light hitting a metal")
test(gn_n_gpart_gn) :-
    once(g_nominal(gn(n(light), gpart(v(hitting), gn(det(a), n(metal)))),
                   [light, hitting, a, metal], [])).

% GI: in order to + V + GN  ("in order to solve this phenomenon")
test(ginf_inorder) :-
    once(g_infinitivo(ginf(inorder, v(solve), gn(det(this), n(phenomenon))),
                      [in, order, to, solve, this, phenomenon], [])).

% GP: prep + GNC  ("into small intervals or pockets")
test(gp_prep_gnc) :-
    once(g_preposicional(gp(prep(into), gn_coord(_, _, _)),
                         [into, small, intervals, or, pockets], [])).

% GP: such as + GNC  ("such as albert einstein niels bohr or werner heisenberg")
test(gp_such_as) :-
    once(g_preposicional(gp(such_as, _),
                         [such, as, albert, einstein,
                          niels, bohr, or, werner, heisenberg], [])).

% GV: V + conj(that) + clausula_base  ("proposed that energy was discretized")
test(gv_v_that_cb_single) :-
    once(g_verbal(gv(v(proposed), conj(that), _),
                  [proposed, that, energy, was, discretized,
                   into, small, intervals, or, pockets], [])).

% GV: Aux + Adv + Aux + V  ("should always be quantized")
test(gv_aux_adv_aux_v) :-
    once(g_verbal(gv(v(should), gadv(adv(always)), v(be), v(quantized)),
                  [should, always, be, quantized], [])).

% GV: Aux + Adv + Aux + V + GP  ("should always be quantized into quantities")
test(gv_aux_adv_aux_v_gp) :-
    once(g_verbal(gv(v(should), gadv(adv(always)), v(be), v(quantized),
                     gp(prep(into), _)),
                  [should, always, be, quantized, into, quantities], [])).

:- end_tests(grupos).


% =============================================================================
% Tests: léxico (reglas puente)
% =============================================================================
:- begin_tests(lexico).

test(det_the)    :- once(determinante(det(the),   [the],   [])).
test(det_a)      :- once(determinante(det(a),     [a],     [])).
test(det_an)     :- once(determinante(det(an),    [an],    [])).
test(nombre)     :- once(nombre(n(planck),        [planck],[  ])).
test(pronombre)  :- once(pronombre(pron(it),      [it],    [])).
test(verbo)      :- once(verbo(v(played),         [played],[  ])).
test(adjetivo)   :- once(adjetivo(adj(essential), [essential], [])).
test(adverbio)   :- once(adverbio(adv(however),   [however],   [])).
test(preposicion):- once(preposicion(prep(in),    [in],    [])).
test(conjuncion) :- once(conjuncion(conj(and),    [and],   [])).
test(pron_this)  :- once(pronombre(pron(this),   [this],  [])).
test(adj_many)   :- once(adjetivo(adj(many),     [many],  [])).
test(v_make)     :- once(verbo(v(make),           [make],  [])).
test(v_made)     :- once(verbo(v(made),           [made],  [])).

% conj_coord solo acepta coordinantes puros (and, but, or)
test(conj_coord_and) :- once(conj_coord(conj(and), [and], [])).
test(conj_coord_but) :- once(conj_coord(conj(but), [but], [])).
test(conj_coord_or)  :- once(conj_coord(conj(or),  [or],  [])).
test(conj_coord_no_that,  fail) :- conj_coord(_, [that],  []).
test(conj_coord_no_which, fail) :- conj_coord(_, [which], []).

:- end_tests(lexico).


% =============================================================================
% Tests: semántica (tipo/2)
% =============================================================================
:- begin_tests(semantico).

test(tipo_energy)   :- tipo(energy,   physical_quantity).
test(tipo_particle) :- tipo(particle, physical_object).
test(tipo_planck)   :- tipo(planck,   person).
test(tipo_constant_physq) :- tipo(constant, physical_quantity).
test(tipo_constant_abst)  :- tipo(constant, abstract_concept).

% constant es ambigua (aparece en más de una categoría)
test(tipo_ambiguo_constant) :-
    findall(C, tipo(constant, C), Cats),
    length(Cats, N), N > 1.

:- end_tests(semantico).


% =============================================================================
% Tests: detección
% =============================================================================
:- begin_tests(deteccion).

% Oración 1: ninguna ambigüedad sobre "role" y "constant" a la vez → resultado no vacío posible
test(ambiguedad_constant_es_ambigua) :-
    ambiguedad_lexica([the, constant, played, an, essential, role], Info),
    member(constant-_, Info).

% Palabras sin tipo: no aparecen en Info
test(ambiguedad_sin_tipo) :-
    ambiguedad_lexica([an], Info),
    \+ member(an-_, Info).

% Uso no literal de "played"
test(uso_no_literal_played) :-
    uso_no_literal([this, constant, played, an, essential, role], Info),
    Info \= [].

% Uso no literal de "stalled"
test(uso_no_literal_stalled) :-
    uso_no_literal([progress, seemed, to, have, stalled], Info),
    Info \= [].

% Oración sin verbos metafóricos
test(uso_no_literal_vacio) :-
    uso_no_literal([the, constant, is, essential], Info),
    Info = [].

:- end_tests(deteccion).


% =============================================================================
% Tests: mejoras
% =============================================================================
:- begin_tests(mejoras).

% Mejora 1: preprocesar
test(preprocesar_minusculas) :-
    preprocesar('The Constant.', Tokens),
    Tokens = [the, constant].

test(preprocesar_frase) :-
    preprocesar('This constant played an essential role.', Tokens),
    Tokens = [this, constant, played, an, essential, role].

% Mejora 2: singular
test(singular_particles)  :- once(singular(particles,  particle)).
test(singular_theories)   :- once(singular(theories,   theory)).
test(singular_phenomena)  :- once(singular(phenomena,  phenomenon)).
test(singular_quanta)     :- once(singular(quanta,     quantum)).

% Mejora 2: normalizar_tokens
test(normalizar_vacio) :-
    normalizar_tokens([], []).

test(normalizar_conserva) :-
    normalizar_tokens([the, constant], [the, constant]).

test(normalizar_plural) :-
    normalizar_tokens([the, particles], [the, particle]).

% tokenize/2
test(tokenize_basico) :-
    tokenize('Particles absorbed energies.', Ts),
    Ts = [particles, absorbed, energies].

test(tokenize_mayusculas) :-
    tokenize('The Constant', Ts),
    Ts = [the, constant].

% normalize/2
test(normalize_plurales) :-
    normalize('Particles absorbed energies.', Ns),
    Ns = [particle, absorbed, energy].

% inflect/3
test(inflect_singular) :-
    inflect(energy, singular, energy).

test(inflect_plural_irregular) :-
    inflect(phenomenon, plural, phenomena).

test(inflect_plural_regular) :-
    inflect(particle, plural, particles).

test(inflect_base) :-
    inflect(constant, base, constant).

% syntactic_function/3
test(synfun_verbo) :-
    syntactic_function(played, v, []).

test(synfun_nombre) :-
    syntactic_function(constant, n, []).

test(synfun_desconocido) :-
    syntactic_function(xyzzy, unknown, []).

% translation_note/2
test(translation_note_quantum) :-
    translation_note(quantum, 'cuántico/cuántica').

test(translation_note_energy) :-
    translation_note(energy, 'energía').

:- end_tests(mejoras).


% =============================================================================
% Tests: simplificar (split_coord_shared)
% =============================================================================
:- begin_tests(simplificar).

test(simplificar_sujeto_compartido_and) :-
    simplificar([planck, played, a, role, and, laid, the, groundwork], Ss),
    Ss = [[planck, played, a, role], [planck, laid, the, groundwork]].

test(simplificar_sujeto_independiente_and) :-
    simplificar([planck, played, a, role, and, it, was, revolutionary], Ss),
    Ss = [[planck, played, a, role], [it, was, revolutionary]].

test(simplificar_but) :-
    simplificar([it, absorbs, radiation, but, radiates, energy], Ss),
    Ss = [[it, absorbs, radiation], [radiates, energy]].

test(simplificar_atomico) :-
    simplificar([this, constant, played, a, role], Ss),
    Ss = [[this, constant, played, a, role]].

% although al inicio — subordinada concesiva separada de cláusula principal
test(simplificar_although) :-
    simplificar(
        [although, it, was, bold, it, was, essential], Ss),
    Ss = [[it, was, bold], [it, was, essential]].

% which — cláusula de relativo separada del antecedente
test(simplificar_which) :-
    simplificar(
        [the, constant, exists, which, planck, introduced], Ss),
    Ss = [[the, constant, exists], [planck, introduced]].

% that — complemento sustantivo
test(simplificar_that) :-
    simplificar(
        [planck, proposed, that, energy, exists], Ss),
    Ss = [[planck, proposed], [energy, exists]].

% división recursiva: although + that anidados producen tres fragmentos
test(simplificar_recursivo) :-
    simplificar(
        [although, it, was, bold,
         it, contradicted, theories, that, were, essential], Ss),
    Ss = [[it, was, bold],
          [it, contradicted, theories],
          [were, essential]].

:- end_tests(simplificar).
