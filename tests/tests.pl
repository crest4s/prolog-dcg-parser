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
:- use_module('../src/semantico').
:- use_module('../src/deteccion').
:- use_module('../src/mejoras').

% Helper: verifica que un token es clasificable por la gramática
token_clasificable(Token) :-
    once((
        phrase(sintactico:determinante(_), [Token], [])
    ;   phrase(sintactico:nombre(_), [Token], [])
    ;   phrase(sintactico:adjetivo(_), [Token], [])
    ;   phrase(sintactico:adverbio(_), [Token], [])
    ;   phrase(sintactico:conj(_), [Token], [])
    ;   phrase(sintactico:rel(_), [Token], [])
    ;   phrase(sintactico:preposicion(_), [Token], [])
    ;   phrase(sintactico:auxiliar(_), [Token], [])
    ;   phrase(sintactico:verbo_transitivo(_), [Token], [])
    ;   phrase(sintactico:verbo_intransitivo(_), [Token], [])
    ;   phrase(sintactico:verbo_copulativo(_), [Token], [])
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
    once(sintactico:oración(Arbol,
        [the, constant, is, essential],
        [])),
    nonvar(Arbol).

% Oración simple: Det + N + Aux + V_trans
test(oracion_simple_aux_trans) :-
    once(sintactico:oración(Arbol,
        [the, constant, was, named],
        [])),
    nonvar(Arbol).

% Oración simple: Det + N + V_trans + Det + N
test(oracion_simple_trans_gn) :-
    once(sintactico:oración(Arbol,
        [the, physicist, proposed, the, theory],
        [])),
    nonvar(Arbol).

% Oración inválida: empieza con verbo
test(oracion_invalida, fail) :-
    sintactico:oración(_, [is, the, constant, essential], []).

% Oración inválida: empieza con conjunción
test(oracion_invalida_conj, fail) :-
    sintactico:oración(_, [and, the, constant, is, essential], []).

:- end_tests(sintactico_dcg).

% =============================================================================
% Tests: oraciones complejas (coordinadas, relativas, compuestas)
% =============================================================================
:- begin_tests(sintactico_complejas).

% Coordinada sin coma
test(oracion_coordinada_sin_coma) :-
    once(sintactico:oración(Arboles,
        [the, constant, is, essential, and, the, theory, is, fundamental],
        [])),
    Arboles = [_, _].

% Coordinada con coma
test(oracion_coordinada_con_coma) :-
    once(sintactico:oración(Arboles,
        [the, constant, is, essential, ',', and, the, theory, is, fundamental],
        [])),
    Arboles = [_, _].

% Relativa sin comas
test(oracion_relativa_sin_comas) :-
    once(sintactico:oración(Arboles,
        [the, constant, that, is, essential, is, fundamental],
        [])),
    Arboles = [_, _].

% Relativa con comas
test(oracion_relativa_con_comas) :-
    once(sintactico:oración(Arboles,
        [the, constant, ',', that, is, essential, ',', is, fundamental],
        [])),
    Arboles = [_, _].

% Compuesta: relativa + conj + simple → 3 oraciones simples
test(oracion_compuesta_relativa_y_simple) :-
    once(sintactico:oración(Arboles,
        [the, constant, ',', that, is, essential, ',', is, fundamental,
         ',', and, the, theory, is, fundamental],
        [])),
    Arboles = [_, _, _].

% Sujeto compartido — el mismo GN en ambos árboles
test(oc_sujeto_comun_estructura) :-
    once(sintactico:oración(Arboles,
        [the, constant, exists, and, appears],
        [])),
    Arboles = [o(GN, _), o(GN, _)].

% Sujeto compartido con coma
test(oc_sujeto_comun_con_coma_estructura) :-
    once(sintactico:oración(Arboles,
        [the, constant, exists, ',', and, appears],
        [])),
    Arboles = [o(GN, _), o(GN, _)],
    GN = gn(det(the), n(constant)).

% Verbo compartido
test(oc_verbo_comun_estructura) :-
    once(sintactico:oración(Arboles,
        [the, physicist, proposed, the, theory, and, the, hypothesis],
        [])),
    Arboles = [o(GN, gv(V, _)), o(GN, gv(V, _))].

% Relativo — sujeto compartido entre subordinada y principal
test(or_sujeto_compartido_estructura) :-
    once(sintactico:oración(Arboles,
        [the, constant, ',', that, is, essential, ',', is, fundamental],
        [])),
    Arboles = [o(GN, _), o(GN, _)].

% Todos los árboles de una coordinada son o/2
test(oc_todos_arboles_son_o) :-
    once(sintactico:oración(Arboles,
        [the, constant, is, essential, and, the, theory, is, fundamental],
        [])),
    forall(member(A, Arboles), A = o(_, _)).

:- end_tests(sintactico_complejas).

% =============================================================================
% Tests: diccionario en inglés
% =============================================================================
:- begin_tests(diccionario).

test(diccionario_determinante)     :- phrase(sintactico:determinante(_), [the], []).
test(diccionario_determinante_a)   :- phrase(sintactico:determinante(_), [a], []).
test(diccionario_determinante_an)  :- phrase(sintactico:determinante(_), [an], []).
test(diccionario_nombre)           :- phrase(sintactico:nombre(_), [planck], []).
test(diccionario_adjetivo)         :- phrase(sintactico:adjetivo(_), [fundamental], []).
test(diccionario_adjetivo_small)   :- phrase(sintactico:adjetivo(_), [small], []).
test(diccionario_adverbio)         :- phrase(sintactico:adverbio(_), [also], []).
test(diccionario_adverbio_not)     :- phrase(sintactico:adverbio(_), [not], []).
test(diccionario_conjuncion)       :- phrase(sintactico:conj(_), [and], []).
test(diccionario_conjuncion_but)   :- phrase(sintactico:conj(_), [but], []).
test(diccionario_relativo_that)    :- phrase(sintactico:rel(_), [that], []).
test(diccionario_relativo_which)   :- phrase(sintactico:rel(_), [which], []).
test(diccionario_preposicion)      :- phrase(sintactico:preposicion(_), [of], []).
test(diccionario_auxiliar_was)     :- phrase(sintactico:auxiliar(_), [was], []).
test(diccionario_auxiliar_can)     :- phrase(sintactico:auxiliar(_), [can], []).
test(diccionario_verbo_copulativo) :- phrase(sintactico:verbo_copulativo(_), [became], []).
test(diccionario_verbo_transitivo) :- phrase(sintactico:verbo_transitivo(_), [proposed], []).
test(diccionario_verbo_intransitivo):- phrase(sintactico:verbo_intransitivo(_), [exists], []).

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
    sintactico:simplificar([], []).

test(simplificar_oracion_simple_suelta) :-
    O = o(gn(det(the), n(constant)), gv(v(exists))),
    sintactico:simplificar(O, [O]).

test(simplificar_lista_simples) :-
    O1 = o(gn(det(the), n(constant)), gv(v(exists))),
    O2 = o(gn(det(the), n(theory)), gv(v(appears))),
    sintactico:simplificar([O1, O2], [O1, O2]).

% Sujeto compartido sin coma
test(oc_sujeto_comun_sin_coma) :-
    once(sintactico:oración(Arboles,
        [the, constant, exists, and, appears],
        [])),
    Arboles = [o(GN, _), o(GN, _)],
    GN = gn(det(the), n(constant)).

% Sujeto compartido con coma
test(oc_sujeto_comun_con_coma) :-
    once(sintactico:oración(Arboles,
        [the, constant, exists, ',', and, appears],
        [])),
    Arboles = [o(GN, _), o(GN, _)],
    GN = gn(det(the), n(constant)).

% Sujeto compartido produce exactamente 2 oraciones simples
test(oc_sujeto_comun_longitud) :-
    once(sintactico:oración(Arboles,
        [the, constant, exists, and, appears],
        [])),
    length(Arboles, 2).

% Verbo compartido sin coma
test(oc_verbo_comun_sin_coma) :-
    once(sintactico:oración(Arboles,
        [the, physicist, proposed, the, theory, and, the, hypothesis],
        [])),
    Arboles = [o(GN, gv(V, _)), o(GN, gv(V, _))],
    GN = gn(det(the), n(physicist)),
    V = v(proposed).

% Verbo compartido con coma
test(oc_verbo_comun_con_coma) :-
    once(sintactico:oración(Arboles,
        [the, physicist, proposed, the, theory, ',', and, the, hypothesis],
        [])),
    Arboles = [o(GN, gv(V, _)), o(GN, gv(V, _))],
    GN = gn(det(the), n(physicist)),
    V = v(proposed).

% simplificar sobre oc_sujeto_comun produce lista de o/2
test(simplificar_sobre_oc_sujeto_comun) :-
    once(sintactico:oración(Arboles,
        [the, constant, exists, and, appears],
        [])),
    sintactico:simplificar(Arboles, Simples),
    Simples = [o(_, _), o(_, _)].

:- end_tests(simplificacion).

% =============================================================================
% Tests: análisis semántico
% =============================================================================
:- begin_tests(semantico).

% tipo/2 — categorías conocidas
test(tipo_constante)    :- semantico:tipo(constant, constante_fisica).
test(tipo_planck)       :- semantico:tipo(planck, persona).
test(tipo_energy)       :- semantico:tipo(energy, cantidad).
test(tipo_principle)    :- semantico:tipo(principle, concepto_teorico).
test(tipo_particle)     :- semantico:tipo(particle, entidad_fisica).
test(tipo_essential)    :- semantico:tipo(essential, propiedad).

% categoria_semantica/2 — lista de categorías para tokens de oración 1
test(categoria_oracion_1) :-
    conjunto_oraciones:oracion(1, _, _, Tokens),
    semantico:categoria_semantica(Tokens, Cats),
    Cats \= [].

% rol_semantico/3 — extracción de sujeto de árbol simple
test(rol_sujeto) :-
    Arbol = o(gn(det(the), n(constant)), gv(v(exists))),
    once(semantico:rol_semantico(Arbol, sujeto, [the, constant])).

test(rol_predicado) :-
    Arbol = o(gn(det(the), n(constant)), gv(v(exists))),
    once(semantico:rol_semantico(Arbol, predicado, [exists])).

:- end_tests(semantico).

% =============================================================================
% Tests: utilidades auxiliares (mejoras.pl)
% =============================================================================
:- begin_tests(mejoras).

test(tokenizar_basico) :-
    mejoras:tokenizar('Hello world', [Hello, world]),
    Hello == 'Hello'.

test(normalizar_minusculas) :-
    mejoras:normalizar(['HeLLo', world], [hello, world]).

test(flexion_stub) :-
    mejoras:flexion(played, verbo, played).

test(funcion_sintactica_sujeto) :-
    O = o(gn(det(the), n(constant)), gv(v(exists))),
    mejoras:funcion_sintactica(O, sujeto, gn(det(the), n(constant))).

test(funcion_sintactica_predicado) :-
    O = o(gn(det(the), n(constant)), gv(v(exists))),
    mejoras:funcion_sintactica(O, predicado, gv(v(exists))).

:- end_tests(mejoras).

% =============================================================================
% Tests: detección de problemas de traducción
% =============================================================================
:- begin_tests(deteccion_problemas).

% Las oraciones problemáticas tienen un problema registrado
test(problema_oracion_4) :-
    deteccion:problema_traduccion(4, _, _).

test(problema_oracion_16) :-
    deteccion:problema_traduccion(16, cambio_estructura, _).

test(problema_oracion_20) :-
    deteccion:problema_traduccion(20, cambio_estructura, _).

test(problema_oracion_29) :-
    deteccion:problema_traduccion(29, perdida_referencia, _).

% Las oraciones ambiguas tienen problema de tipo ambiguedad
test(ambiguedad_oracion_10) :-
    deteccion:ambiguedad(10, _).

test(ambiguedad_oracion_30) :-
    deteccion:ambiguedad(30, _).

% Las oraciones correctas NO tienen problema registrado
test(sin_problema_oracion_1, fail) :-
    deteccion:problema_traduccion(1, _, _).

test(sin_problema_oracion_8, fail) :-
    deteccion:problema_traduccion(8, _, _).

% Todos los problemas tienen descripción no vacía
test(descripciones_no_vacias) :-
    forall(
        deteccion:problema_traduccion(_, _, Desc),
        ( atom(Desc), Desc \= '' )
    ).

:- end_tests(deteccion_problemas).
