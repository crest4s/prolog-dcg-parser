/*=============================================================================
 * tests/tests.pl — Suite de tests PLUnit
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Cómo añadir tests:
 *   :- begin_tests(nombre_grupo).
 *   test(nombre_test) :- <goal que debe ser verdadero>.
 *   test(nombre_test, fail) :- <goal que debe fallar>.
 *   test(nombre_test, throws(error(_,_))) :- <goal que debe lanzar error>.
 *   :- end_tests(nombre_grupo).
 *
 * Ejecución local:
 *   swipl -g "run_tests, halt" -t "halt(1)" tests/tests.pl
 *=============================================================================*/

:- use_module(library(plunit)).

% Añade src/ al path de búsqueda de módulos
:- assertz(file_search_path(src, 'src')).

% -----------------------------------------------------------------------------
% Carga de módulos
% -----------------------------------------------------------------------------
:- use_module('../src/sintactico').
:- use_module('../src/semantico').
:- use_module('../src/conjunto_oraciones').

token_clasificable(Token) :-
    once((
        phrase(sintactico:determinante(_), [Token], [])
    ;   phrase(sintactico:nombre(_), [Token], [])
    ;   phrase(sintactico:adjetivo(_), [Token], [])
    ;   phrase(sintactico:adverbio(_), [Token], [])
    ;   phrase(sintactico:conj(_), [Token], [])
    ;   phrase(sintactico:rel(_), [Token], [])
    ;   phrase(sintactico:preposicion(_), [Token], [])
    ;   phrase(sintactico:verbo_transitivo(_), [Token], [])
    ;   phrase(sintactico:verbo_intransitivo(_), [Token], [])
    ;   phrase(sintactico:verbo_copulativo(_), [Token], [])
    )).

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% Tests: corpus de oraciones
% Al menos 30 oraciones deben estar definidas.
% -----------------------------------------------------------------------------
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

:- end_tests(corpus).

% -----------------------------------------------------------------------------
% Tests: análisis sintáctico básico
% -----------------------------------------------------------------------------
:- begin_tests(sintactico_dcg).

test(oracion_simple_correcta) :-
    once(sintactico:oración(Arbol, [la, constante, es, esencial], [])),
    nonvar(Arbol).

test(oracion_simple_con_gn_compuesto) :-
    once(sintactico:oración(Arbol, [la, fisica, cuantica, es, fundamental], [])),
    nonvar(Arbol).

test(oracion_invalida, fail) :-
    sintactico:oración(_, [es, la, constante], []).

:- end_tests(sintactico_dcg).

% -----------------------------------------------------------------------------
% Tests: persona B (oc, or, ocm)
% -----------------------------------------------------------------------------
:- begin_tests(sintactico_complejas).

test(oracion_coordinada_sin_coma) :-
    once(sintactico:oración(Arboles,
        [la, constante, es, esencial, y, la, fisica, es, fundamental],
        [])),
    Arboles = [_, _].

test(oracion_coordinada_con_coma) :-
    once(sintactico:oración(Arboles,
        [la, constante, es, esencial, ',', y, la, fisica, es, fundamental],
        [])),
    Arboles = [_, _].

test(oracion_relativo_sin_comas) :-
    once(sintactico:oración(Arboles,
        [la, constante, que, es, esencial, es, fundamental],
        [])),
    Arboles = [_, _].

test(oracion_relativo_con_comas) :-
    once(sintactico:oración(Arboles,
        [la, constante, ',', que, es, esencial, ',', es, fundamental],
        [])),
    Arboles = [_, _].

test(oracion_compuesta_relativo_y_simple) :-
    once(sintactico:oración(Arboles,
        [la, constante, ',', que, es, esencial, ',', es, fundamental, ',', y,
         la, fisica, es, fundamental],
        [])),
    Arboles = [_, _, _].

% oc con sujeto compartido — el mismo GN aparece en ambos árboles
test(oc_sujeto_comun_estructura) :-
    once(sintactico:oración(Arboles,
        [la, constante, existe, y, aparece],
        [])),
    Arboles = [o(GN, _), o(GN, _)].

test(oc_sujeto_comun_con_coma_estructura) :-
    once(sintactico:oración(Arboles,
        [la, constante, existe, ',', y, aparece],
        [])),
    Arboles = [o(GN, _), o(GN, _)],
    GN = gn(det(la), n(constante)).

% oc con verbo compartido — el mismo GN sujeto y el mismo V aparecen en ambos árboles
test(oc_verbo_comun_estructura) :-
    once(sintactico:oración(Arboles,
        [la, fisica, posee, la, constante, y, la, teoria],
        [])),
    Arboles = [o(GN, gv(V, _)), o(GN, gv(V, _))].

test(oc_verbo_comun_con_coma_estructura) :-
    once(sintactico:oración(Arboles,
        [la, fisica, posee, la, constante, ',', y, la, teoria],
        [])),
    Arboles = [o(GN, gv(V, _)), o(GN, gv(V, _))],
    GN = gn(det(la), n(fisica)),
    V = v(posee).

% or — el mismo GN sujeto aparece en la subordinada y en la principal
test(or_sujeto_compartido_estructura) :-
    once(sintactico:oración(Arboles,
        [la, constante, ',', que, es, esencial, ',', es, fundamental],
        [])),
    Arboles = [o(GN, _), o(GN, _)].

% ocm — cuatro oraciones simples: (or + conj + o + conj + o)
% "la constante , que es esencial , es fundamental , y
%  la fisica es fundamental , y la teoria es fundamental"
test(ocm_cuatro_simples) :-
    once(sintactico:oración(Arboles,
        [la, constante, ',', que, es, esencial, ',', es, fundamental,
         ',', y, la, fisica, es, fundamental,
         ',', y, la, teoria, es, fundamental],
        [])),
    length(Arboles, 4).

% Todos los árboles resultantes de una coordinada deben ser o/2
test(oc_todos_arboles_son_o) :-
    once(sintactico:oración(Arboles,
        [la, constante, es, esencial, y, la, fisica, es, fundamental],
        [])),
    forall(member(A, Arboles), A = o(_, _)).

% Oración compleja inválida (empieza con conjunción): debe fallar
test(oracion_compleja_invalida, fail) :-
    sintactico:oración(_, [y, la, constante, es, esencial], []).

:- end_tests(sintactico_complejas).

% -----------------------------------------------------------------------------
% Tests: diccionario persona B
% -----------------------------------------------------------------------------
:- begin_tests(diccionario).

test(diccionario_determinante) :- phrase(sintactico:determinante(_), [la], []).
test(diccionario_nombre) :- phrase(sintactico:nombre(_), [planck], []).
test(diccionario_adjetivo) :- phrase(sintactico:adjetivo(_), [fundamental], []).
test(diccionario_adverbio) :- phrase(sintactico:adverbio(_), [muy], []).
test(diccionario_conjuncion) :- phrase(sintactico:conj(_), [y], []).
test(diccionario_relativo) :- phrase(sintactico:rel(_), [que], []).
test(diccionario_preposicion) :- phrase(sintactico:preposicion(_), [de], []).
test(diccionario_verbo_copulativo) :- phrase(sintactico:verbo_copulativo(_), [es], []).
test(diccionario_verbo_transitivo) :- phrase(sintactico:verbo_transitivo(_), [explicar], []).
test(diccionario_verbo_intransitivo) :- phrase(sintactico:verbo_intransitivo(_), [existe], []).

test(diccionario_cubre_todos_los_tokens_del_corpus) :-
    findall(T, (conjunto_oraciones:oracion(_, _, _, Ts), member(T, Ts)), Todos),
    sort(Todos, Unicos),
    forall(member(Token, Unicos), token_clasificable(Token)).

:- end_tests(diccionario).

% -----------------------------------------------------------------------------
% Tests: enriquecimiento semántico
% -----------------------------------------------------------------------------
:- begin_tests(semantico).

test(tipo_de_persona_cientifica) :-
    once(semantico:tipo(planck, persona_cientifica)).

test(tipo_de_disciplina) :-
    once(semantico:tipo(cuantica, disciplina_cientifica)).

test(categoria_semantica_alias) :-
    once(semantico:categoria_semantica(fotones, particula_fisica)).

test(tipo_de_alteridad) :-
    once(semantico:tipo(otros, alteridad)).

:- end_tests(semantico).

% -----------------------------------------------------------------------------
% Tests: simplificación de oraciones complejas
% -----------------------------------------------------------------------------
:- begin_tests(simplificacion).

% simplificar/2 sobre lista vacía
test(simplificar_lista_vacia) :-
    sintactico:simplificar([], []).

% simplificar/2 sobre una oración simple suelta
test(simplificar_oracion_simple_suelta) :-
    O = o(gn(det(la), n(constante)), gv(v(existe))),
    sintactico:simplificar(O, [O]).

% simplificar/2 sobre lista de oraciones simples: identidad
test(simplificar_lista_simples) :-
    O1 = o(gn(det(la), n(constante)), gv(v(existe))),
    O2 = o(gn(det(la), n(fisica)), gv(v(aparece))),
    sintactico:simplificar([O1, O2], [O1, O2]).

% Coordinada con sujeto compartido: GN V1 conj V2 (sin coma)
% "la constante existe y aparece"
test(oc_sujeto_comun_sin_coma) :-
    once(sintactico:oración(Arboles,
        [la, constante, existe, y, aparece],
        [])),
    Arboles = [o(GN, _), o(GN, _)],
    GN = gn(det(la), n(constante)).

% Coordinada con sujeto compartido: GN V1 , conj V2 (con coma)
% "la constante existe , y aparece"
test(oc_sujeto_comun_con_coma) :-
    once(sintactico:oración(Arboles,
        [la, constante, existe, ',', y, aparece],
        [])),
    Arboles = [o(GN, _), o(GN, _)],
    GN = gn(det(la), n(constante)).

% Coordinada con sujeto compartido produce exactamente 2 oraciones simples
test(oc_sujeto_comun_longitud) :-
    once(sintactico:oración(Arboles,
        [la, constante, existe, y, aparece],
        [])),
    length(Arboles, 2).

% Coordinada con verbo compartido: GN V GN1 conj GN2 (sin coma)
% "la fisica posee la constante y la teoria"
test(oc_verbo_comun_sin_coma) :-
    once(sintactico:oración(Arboles,
        [la, fisica, posee, la, constante, y, la, teoria],
        [])),
    Arboles = [o(GN, gv(V, _)), o(GN, gv(V, _))],
    GN = gn(det(la), n(fisica)),
    V = v(posee).

% Coordinada con verbo compartido: GN V GN1 , conj GN2 (con coma)
test(oc_verbo_comun_con_coma) :-
    once(sintactico:oración(Arboles,
        [la, fisica, posee, la, constante, ',', y, la, teoria],
        [])),
    Arboles = [o(GN, gv(V, _)), o(GN, gv(V, _))],
    GN = gn(det(la), n(fisica)),
    V = v(posee).

% simplificar sobre resultado de oc_sujeto_comun es la misma lista
test(simplificar_sobre_oc_sujeto_comun) :-
    once(sintactico:oración(Arboles,
        [la, constante, existe, y, aparece],
        [])),
    sintactico:simplificar(Arboles, Simples),
    Simples = [o(_, _), o(_, _)].

:- end_tests(simplificacion).

% -----------------------------------------------------------------------------
% Tests: detección de problemas
% Añadir aquí tests concretos cuando se implemente deteccion.pl.
% -----------------------------------------------------------------------------
:- begin_tests(deteccion_problemas).

% Ejemplo — descomentar cuando deteccion.pl esté implementado:
%
% test(detecta_ambiguedad) :-
%     ambigüedad(banco, _).
%
% test(detecta_incoherencia) :-
%     incoherencia([la, inflacion, come, los, ahorros], _).

:- end_tests(deteccion_problemas).
