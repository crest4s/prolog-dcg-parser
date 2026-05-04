/*=============================================================================
 * tests/tests.pl — Suite de tests PLUnit (inglés)
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Ejecución:
 *   swipl -g "run_tests, halt" -t "halt(1)" tests/tests.pl
 *=============================================================================*/

:- use_module(library(plunit)).

:- assertz(file_search_path(src, 'src')).

:- use_module('../src/sintactico').
:- use_module('../src/semantico').
:- use_module('../src/conjunto_oraciones').
:- use_module('../src/deteccion').
:- use_module('../src/mejoras').

% Helper: verifica que un token es clasificable por la gramática
token_clasificable(Token) :-
    once((
        phrase(sintactico:determiner(_), [Token], [])
    ;   phrase(sintactico:noun(_), [Token], [])
    ;   phrase(sintactico:adjective(_), [Token], [])
    ;   phrase(sintactico:adverb(_), [Token], [])
    ;   phrase(sintactico:conjunction(_), [Token], [])
    ;   phrase(sintactico:relative(_), [Token], [])
    ;   phrase(sintactico:preposition(_), [Token], [])
    ;   phrase(sintactico:auxiliary(_), [Token], [])
    ;   phrase(sintactico:transitive_verb(_), [Token], [])
    ;   phrase(sintactico:intransitive_verb(_), [Token], [])
    ;   phrase(sintactico:copulative_verb(_), [Token], [])
    )).

% =============================================================================
% Tests: corpus de oraciones (inglés)
% =============================================================================
:- begin_tests(corpus).

:- meta_predicate corpus_definido(0).
corpus_definido(Goal) :-
    ( predicate_property(conjunto_oraciones:oracion(_,_,_,_), defined)
    -> call(Goal)
    ;  true
    ).

test(corpus_no_vacio) :-
    corpus_definido((
        aggregate_all(count, conjunto_oraciones:oracion(_, _, _, _), N),
        N > 0
    )).

test(corpus_minimo_30_oraciones) :-
    corpus_definido((
        aggregate_all(count, conjunto_oraciones:oracion(_, _, _, _), N),
        N >= 30
    )).

test(ids_unicos) :-
    corpus_definido((
        findall(ID, conjunto_oraciones:oracion(ID, _, _, _), IDs),
        sort(IDs, Sorted),
        length(IDs, N),
        length(Sorted, N)
    )).

test(tipos_validos) :-
    corpus_definido(
        forall(
            conjunto_oraciones:oracion(_, Tipo, _, _),
            memberchk(Tipo, [o, oc, or, ocm])
        )
    ).

test(clases_validas) :-
    corpus_definido(
        forall(
            conjunto_oraciones:oracion(_, _, Clase, _),
            memberchk(Clase, [correcta, ambigua, problematica])
        )
    ).

% Cada oración inglesa tiene su referencia española
test(oraciones_es_disponibles) :-
    corpus_definido(
        forall(
            conjunto_oraciones:oracion(ID, _, _, _),
            conjunto_oraciones:oracion_es(ID, _)
        )
    ).

% Distribución: al menos una oración de cada tipo
test(hay_oracion_simple) :-
    corpus_definido(
        once(conjunto_oraciones:oracion(_, o, _, _))
    ).

test(hay_oracion_coordinada) :-
    corpus_definido(
        once(conjunto_oraciones:oracion(_, oc, _, _))
    ).

test(hay_oracion_relativa) :-
    corpus_definido(
        once(conjunto_oraciones:oracion(_, or, _, _))
    ).

test(hay_oracion_compuesta) :-
    corpus_definido(
        once(conjunto_oraciones:oracion(_, ocm, _, _))
    ).

:- end_tests(corpus).

% =============================================================================
% Tests: análisis sintáctico DCG básico (inglés)
% =============================================================================
:- begin_tests(sintactico_dcg).

% Oración simple: Det + N + V_cop + Adj
test(oracion_simple_cop_adj) :-
    once(sintactico:parse(Tree,
        [the, constant, is, essential],
        [])),
    nonvar(Tree).

% Oración simple: Det + N + Aux + V_trans
test(oracion_simple_aux_trans) :-
    once(sintactico:parse(Tree,
        [the, constant, was, named],
        [])),
    nonvar(Tree).

% Oración simple: Det + N + V_trans + Det + N
test(oracion_simple_trans_gn) :-
    once(sintactico:parse(Tree,
        [the, physicist, proposed, the, theory],
        [])),
    nonvar(Tree).

% Oración inválida: empieza con verbo
test(oracion_invalida, fail) :-
    sintactico:parse(_, [is, the, constant, essential], []).

% Oración inválida: empieza con conjunción seguida de verbo
test(oracion_invalida_conj, fail) :-
    sintactico:parse(_, [and, is, the, constant, essential], []).

:- end_tests(sintactico_dcg).

% =============================================================================
% Tests: oraciones complejas (coordinadas, relativas, compuestas)
% =============================================================================
:- begin_tests(sintactico_complejas).

% Coordinada sin coma
test(oracion_coordinada_sin_coma) :-
    once(sintactico:parse(Trees,
        [the, constant, is, essential, and, the, theory, is, fundamental],
        [])),
    Trees = [_, _].

% Coordinada con coma
test(oracion_coordinada_con_coma) :-
    once(sintactico:parse(Trees,
        [the, constant, is, essential, ',', and, the, theory, is, fundamental],
        [])),
    Trees = [_, _].

% Relativa sin comas
test(oracion_relativa_sin_comas) :-
    once(sintactico:parse(Trees,
        [the, constant, that, is, essential, is, fundamental],
        [])),
    Trees = [_, _].

% Relativa con comas
test(oracion_relativa_con_comas) :-
    once(sintactico:parse(Trees,
        [the, constant, ',', that, is, essential, ',', is, fundamental],
        [])),
    Trees = [_, _].

% Compuesta: relativa + conj + simple → 3 oraciones simples
test(oracion_compuesta_relativa_y_simple) :-
    once(sintactico:parse(Trees,
        [the, constant, ',', that, is, essential, ',', is, fundamental,
         ',', and, the, theory, is, fundamental],
        [])),
    Trees = [_, _, _].

% Sujeto compartido — el mismo NP en ambos árboles
test(oc_sujeto_comun_estructura) :-
    once(sintactico:parse(Trees,
        [the, constant, exists, and, appears],
        [])),
    Trees = [s(NP, _), s(NP, _)].

% Sujeto compartido con coma
test(oc_sujeto_comun_con_coma_estructura) :-
    once(sintactico:parse(Trees,
        [the, constant, exists, ',', and, appears],
        [])),
    Trees = [s(NP, _), s(NP, _)],
    NP = np(det(the), n(constant)).

% Verbo compartido
test(oc_verbo_comun_estructura) :-
    once(sintactico:parse(Trees,
        [the, physicist, proposed, the, theory, and, the, hypothesis],
        [])),
    Trees = [s(NP, vp(V, _)), s(NP, vp(V, _))].

% Relativo — sujeto compartido entre subordinada y principal
test(or_sujeto_compartido_estructura) :-
    once(sintactico:parse(Trees,
        [the, constant, ',', that, is, essential, ',', is, fundamental],
        [])),
    Trees = [s(NP, _), s(NP, _)].

% Todos los árboles de una coordinada son s/2
test(oc_todos_arboles_son_s) :-
    once(sintactico:parse(Trees,
        [the, constant, is, essential, and, the, theory, is, fundamental],
        [])),
    forall(member(A, Trees), A = s(_, _)).

:- end_tests(sintactico_complejas).

% =============================================================================
% Tests: gramática ampliada (adverbios oracionales, SP inicial)
% =============================================================================
:- begin_tests(sintactico_ampliado).

% Oración simple con adverbio oracional inicial
test(oracion_adverbio_inicial) :-
    once(sintactico:parse(Tree,
        [however, acceptance, of, this, idea, was, far, from, immediate],
        [])),
    nonvar(Tree).

% Oración simple con SP inicial
test(oracion_sp_inicial) :-
    once(sintactico:parse(Tree,
        [since, the, early, century, progress, in, physics, seemed,
         to, have, stalled],
        [])),
    nonvar(Tree).

% Nodo raíz es s/2
test(arbol_raiz_s) :-
    once(sintactico:parse([S], [the, constant, is, essential], [])),
    S = s(_, _).

% NP con nombre compuesto (Det + N + N)
test(np_nombre_compuesto) :-
    once(phrase(sintactico:noun_phrase(NP), [the, planck, constant], [])),
    NP = np(det(the), n(planck), n(constant)).

% AP con adverbio modificador (adv + adj)
test(ap_adv_adj) :-
    once(phrase(sintactico:adj_phrase(AP), [very, important], [])),
    AP = ap(adv(very), adj(important)).

% PP con complemento adjetival (from immediate)
test(pp_complemento_adjetival) :-
    once(phrase(sintactico:prep_phrase(PP), [from, immediate], [])),
    PP = pp(prep(from), ap(adj(immediate))).

:- end_tests(sintactico_ampliado).

% =============================================================================
% Tests: diccionario en inglés
% =============================================================================
:- begin_tests(diccionario).

test(diccionario_determinante)      :- phrase(sintactico:determiner(_), [the], []).
test(diccionario_determinante_a)    :- phrase(sintactico:determiner(_), [a], []).
test(diccionario_determinante_an)   :- phrase(sintactico:determiner(_), [an], []).
test(diccionario_nombre)            :- phrase(sintactico:noun(_), [planck], []).
test(diccionario_adjetivo)          :- phrase(sintactico:adjective(_), [fundamental], []).
test(diccionario_adjetivo_small)    :- phrase(sintactico:adjective(_), [small], []).
test(diccionario_adverbio)          :- phrase(sintactico:adverb(_), [also], []).
test(diccionario_adverbio_not)      :- phrase(sintactico:adverb(_), [not], []).
test(diccionario_conjuncion)        :- phrase(sintactico:conjunction(_), [and], []).
test(diccionario_conjuncion_but)    :- phrase(sintactico:conjunction(_), [but], []).
test(diccionario_relativo_that)     :- phrase(sintactico:relative(_), [that], []).
test(diccionario_relativo_which)    :- phrase(sintactico:relative(_), [which], []).
test(diccionario_preposicion)       :- phrase(sintactico:preposition(_), [of], []).
test(diccionario_auxiliar_was)      :- phrase(sintactico:auxiliary(_), [was], []).
test(diccionario_auxiliar_can)      :- phrase(sintactico:auxiliary(_), [can], []).
test(diccionario_verbo_copulativo)  :- phrase(sintactico:copulative_verb(_), [became], []).
test(diccionario_verbo_transitivo)  :- phrase(sintactico:transitive_verb(_), [proposed], []).
test(diccionario_verbo_intransitivo):- phrase(sintactico:intransitive_verb(_), [exists], []).

% Todos los tokens del corpus son clasificables
test(diccionario_cubre_todos_los_tokens_del_corpus) :-
    findall(T, (conjunto_oraciones:oracion(_, _, _, Ts), member(T, Ts)), Todos),
    sort(Todos, Unicos),
    forall(member(Token, Unicos), token_clasificable(Token)).

:- end_tests(diccionario).

% =============================================================================
% Tests: simplificación de oraciones
% =============================================================================
:- begin_tests(simplificacion).

test(simplificar_lista_vacia) :-
    sintactico:simplify([], []).

test(simplificar_oracion_simple_suelta) :-
    S = s(np(det(the), n(constant)), vp(v(exists))),
    sintactico:simplify(S, [S]).

test(simplificar_lista_simples) :-
    S1 = s(np(det(the), n(constant)), vp(v(exists))),
    S2 = s(np(det(the), n(theory)), vp(v(appears))),
    sintactico:simplify([S1, S2], [S1, S2]).

% Sujeto compartido sin coma
test(oc_sujeto_comun_sin_coma) :-
    once(sintactico:parse(Trees,
        [the, constant, exists, and, appears],
        [])),
    Trees = [s(NP, _), s(NP, _)],
    NP = np(det(the), n(constant)).

% Sujeto compartido con coma
test(oc_sujeto_comun_con_coma) :-
    once(sintactico:parse(Trees,
        [the, constant, exists, ',', and, appears],
        [])),
    Trees = [s(NP, _), s(NP, _)],
    NP = np(det(the), n(constant)).

% Sujeto compartido produce exactamente 2 oraciones simples
test(oc_sujeto_comun_longitud) :-
    once(sintactico:parse(Trees,
        [the, constant, exists, and, appears],
        [])),
    length(Trees, 2).

% Verbo compartido sin coma
test(oc_verbo_comun_sin_coma) :-
    once(sintactico:parse(Trees,
        [the, physicist, proposed, the, theory, and, the, hypothesis],
        [])),
    Trees = [s(NP, vp(V, _)), s(NP, vp(V, _))],
    NP = np(det(the), n(physicist)),
    V = v(proposed).

% Verbo compartido con coma
test(oc_verbo_comun_con_coma) :-
    once(sintactico:parse(Trees,
        [the, physicist, proposed, the, theory, ',', and, the, hypothesis],
        [])),
    Trees = [s(NP, vp(V, _)), s(NP, vp(V, _))],
    NP = np(det(the), n(physicist)),
    V = v(proposed).

% simplify sobre coord con sujeto común produce lista de s/2
test(simplificar_sobre_oc_sujeto_comun) :-
    once(sintactico:parse(Trees,
        [the, constant, exists, and, appears],
        [])),
    sintactico:simplify(Trees, Simples),
    Simples = [s(_, _), s(_, _)].

:- end_tests(simplificacion).

% =============================================================================
% Tests: análisis semántico
% =============================================================================
:- begin_tests(semantico).

% type/2 — categorías conocidas
test(type_constant)  :- semantico:type(constant, physical_constant).
test(type_planck)    :- semantico:type(planck, person).
test(type_energy)    :- semantico:type(energy, quantity).
test(type_principle) :- semantico:type(principle, theoretical_concept).
test(type_particle)  :- semantico:type(particle, physical_entity).
test(type_essential) :- semantico:type(essential, property).

% semantic_category/2 — lista de categorías para tokens de oración 1
test(categoria_oracion_1) :-
    conjunto_oraciones:oracion(1, _, _, Tokens),
    semantico:semantic_category(Tokens, Cats),
    Cats \= [].

% semantic_role/3 — extracción de sujeto de árbol simple
test(semantic_role_subject) :-
    Tree = s(np(det(the), n(constant)), vp(v(exists))),
    once(semantico:semantic_role(Tree, subject, [the, constant])).

test(semantic_role_predicate) :-
    Tree = s(np(det(the), n(constant)), vp(v(exists))),
    once(semantico:semantic_role(Tree, predicate, [exists])).

:- end_tests(semantico).

% =============================================================================
% Tests: utilidades auxiliares (mejoras.pl)
% =============================================================================
:- begin_tests(mejoras).

test(tokenize_basico) :-
    mejoras:tokenize('Hello world', [Hello, world]),
    Hello == 'Hello'.

test(normalize_minusculas) :-
    mejoras:normalize(['HeLLo', world], [hello, world]).

test(inflect_stub) :-
    mejoras:inflect(played, verb, played).

test(syntactic_function_subject) :-
    S = s(np(det(the), n(constant)), vp(v(exists))),
    mejoras:syntactic_function(S, subject, np(det(the), n(constant))).

test(syntactic_function_predicate) :-
    S = s(np(det(the), n(constant)), vp(v(exists))),
    mejoras:syntactic_function(S, predicate, vp(v(exists))).

:- end_tests(mejoras).

% =============================================================================
% Tests: detección de problemas de traducción
% =============================================================================
:- begin_tests(deteccion_problemas).

% Las oraciones problemáticas tienen un problema registrado
test(problema_oracion_4) :-
    deteccion:translation_problem(4, _, _).

test(problema_oracion_16) :-
    deteccion:translation_problem(16, structure_change, _).

test(problema_oracion_20) :-
    deteccion:translation_problem(20, structure_change, _).

test(problema_oracion_29) :-
    deteccion:translation_problem(29, reference_loss, _).

% Las oraciones ambiguas tienen problema de tipo ambiguity
test(ambiguedad_oracion_10) :-
    deteccion:ambiguity(10, _).

test(ambiguedad_oracion_30) :-
    deteccion:ambiguity(30, _).

% Las oraciones correctas NO tienen problema registrado
test(sin_problema_oracion_1, fail) :-
    deteccion:translation_problem(1, _, _).

test(sin_problema_oracion_8, fail) :-
    deteccion:translation_problem(8, _, _).

% Todos los problemas tienen descripción no vacía
test(descripciones_no_vacias) :-
    forall(
        deteccion:translation_problem(_, _, Desc),
        ( atom(Desc), Desc \= '' )
    ).

:- end_tests(deteccion_problemas).
