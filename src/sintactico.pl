/*=============================================================================
 * sintactico.pl — Gramática DCG básica
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
 *   det, n, v, adj, adv, conj, prep
 *=============================================================================*/

:- module(sintactico, [oración/3]).

% Reglas de oraciones

% Regla maestra (el usuario llama a: phrase(oracion(Lista), Tokens))
oracion(ListaArboles) --> ocm(ListaArboles).
oracion(ListaArboles) --> or(ListaArboles).
oracion(ListaArboles) --> oc(ListaArboles).
oracion([ArbolSimple]) --> o(ArbolSimple).

% Oración simple
o(o(GN, GV)) -->
    grupo_nominal(GN),
    grupo_verbal(GV).

% Oraciones coordinadas
oc([Arbol1, Arbol2]) -->
    o(Arbol1), [','],
    conj(_),
    o(Arbol2).

oc([Arbol1, Arbol2]) -->
    o(Arbol1),
    conj(_),
    o(Arbol2).

% Oraciones subordinadas de relativo
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

oración(Arbol, Tokens, Resto) :-
    phrase(oracion(Arbol), Tokens, Resto).

% Reglas de grupos sintácticos
grupo_nominal(gn(N)) -->
    nombre(N).

grupo_nominal(gn(Det, N)) -->
    determinante(Det),
    nombre(N).

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

grupo_adjetival(gadj(Adj)) -->
    adjetivo(Adj).

grupo_adverbial(gadv(Adv)) -->
    adverbio(Adv).

grupo_preposicional(gp(Prep, GN)) -->
    preposicion(Prep),
    grupo_nominal(GN).

% Diccionario (terminales)
determinante(det(Palabra)) -->
    [Palabra],
    { determinante_palabra(Palabra) }.

nombre(n(Palabra)) -->
    [Palabra],
    { nombre_palabra(Palabra) }.

adjetivo(adj(Palabra)) -->
    [Palabra],
    { adjetivo_palabra(Palabra) }.

adverbio(adv(Palabra)) -->
    [Palabra],
    { adverbio_palabra(Palabra) }.

conj(conj(Palabra)) -->
    [Palabra],
    { conjuncion_palabra(Palabra) }.

rel(rel(Palabra)) -->
    [Palabra],
    { relativo_palabra(Palabra) }.

preposicion(prep(Palabra)) -->
    [Palabra],
    { preposicion_palabra(Palabra) }.

verbo_transitivo(v(Palabra)) -->
    [Palabra],
    { verbo_transitivo_palabra(Palabra) }.

verbo_intransitivo(v(Palabra)) -->
    [Palabra],
    { verbo_intransitivo_palabra(Palabra) }.

verbo_copulativo(v(Palabra)) -->
    [Palabra],
    { verbo_copulativo_palabra(Palabra) }.

% Clasificacion lexical
determinante_palabra(P) :- memberchk(P, [
    el, la, los, las, un, una, unas, este, esta, estos, ese, esa, su
]).

conjuncion_palabra(P) :- memberchk(P, [
    y, pero, o, aunque, sino, pues, ni
]).

relativo_palabra(P) :- memberchk(P, [
    que, cual, cuales, donde
]).

preposicion_palabra(P) :- memberchk(P, [
    a, al, con, de, del, durante, en, entre, hacia, hasta, para, por, segun, sin, sobre, tras
]).

adverbio_palabra(P) :- memberchk(P, [
    no, muy, tambien, asi, asimismo, afortunadamente, finalmente, justamente,
    directamente, completamente, definitivamente, siempre, menos, tal
]).

adjetivo_palabra(P) :- memberchk(P, [
    esencial, fundamental, fundamentales, innovadora, imposible, inmediata,
    atrevida, coherentes, eficientes, caracteristica, ciertas, ciertos,
    desconcertantes, cuantica, cuanticos, subatomicas, pequenas, poetica,
    romantica, real, realidad, habituales, vigentes, ondulatorios,
    microscopico, internacional, discretizada, cuantificada, cuantizada,
    proporcional, proporcionales, enteros, exactos, similares, absoluta,
    diferentes, gran, grandes, nueva, cierto, cierta
]).

verbo_copulativo_palabra(P) :- memberchk(P, [
    es, era, fue, son, esta, estaba, estar, trata
]).

verbo_transitivo_palabra(P) :- memberchk(P, [
    absorbe, actua, arranca, considerar, considerarse, consigue, consiguio,
    consolidar, consolido, dar, deducida, demostrar, demostraron,
    desempeno, determino, entender, establecer, exhibian, explicar,
    expuso, gobierna, hicieron, introdujo, irradia, jugar, jugo, llamo,
    medir, nombro, nombrada, observa, observados, posee, postulacion,
    presento, propuso, realizo, realizaron, representada, resalto, sento,
    subio, sumerge, tener, tiene, utilizo
]).

verbo_intransitivo_palabra(P) :- memberchk(P, [
    aparece, conocer, conocerse, conseguir, contribuir, contribuyeron,
    crecer, desafia, emitir, emitia, entraba, existe, existen, existian,
    hablar, hayas, haberse, incide, manifestarse, parecer, parecia,
    paso, puede, pudieron, relaciona, suele, terminaron
]).

nombre_palabra(P) :-
    token_corpus(P),
    \+ determinante_palabra(P),
    \+ conjuncion_palabra(P),
    \+ relativo_palabra(P),
    \+ preposicion_palabra(P),
    \+ adverbio_palabra(P),
    \+ adjetivo_palabra(P),
    \+ verbo_copulativo_palabra(P),
    \+ verbo_transitivo_palabra(P),
    \+ verbo_intransitivo_palabra(P).

token_corpus(P) :- memberchk(P, [
    1900, 1905, 1927, 1981, '6.626x10-34', a, abrir, absoluta, absorbe,
    aceptacion, actua, afortunadamente, al, albert, algo, ano, aparece,
    apostando, aquel, aquellas, arranca, asento, asi, asimismo, atravesar,
    atrevida, aunque, avance, avances, barreras, basandose, bases, bien,
    bohr, bolsas, cada, cantidad, cantidades, capaces, capacidad,
    caracteristica, caso, cientificos, cierta, ciertas, ciertos,
    clasicamente, clinton, coherentes, comenzaron, comienzos, como,
    completamente, comportamiento, comportamientos, compuesta, con,
    concepcion, confirmo, conocer, conocerse, conseguian, consideraba,
    considerar, considerarse, consigue, consiguio, consolidar,
    consolidaron, constante, contexto, contradiccion, contribuyeron,
    crecer, cual, cuales, cualquier, cuantica, cuanticos, cuantificada,
    cuantizacion, cuantizada, cuantos, cuerpo, dar, davisson, de, debia,
    decir, deducida, definitivamente, del, demostrando, desafia,
    desconcertantes, desde, desempeno, determino, diferentes, difraccion,
    dilemas, directamente, disciplina, discretizada, donde, dualidad,
    durante, efecto, eficientes, einstein, ejemplo, el, electrones,
    elemento, embargo, emision, emitia, emitida, en, encontrar,
    energeticas, energia, entender, enteros, entraba, epoca, era, es, esa,
    ese, esencial, esos, esta, estaba, establece, establecer, estancado,
    estar, este, estos, estudio, exactos, exhibian, existe, existen,
    existian, experimentos, explicacion, explicar, expuso, fenomeno,
    fenomenos, finalmente, fisica, fisico, fisicos, forma, formulacion,
    fotoelectrico, fotones, frase, fue, fuera, fueran, fueron, fundamental,
    fundamentales, general, germer, gobierna, gran, grandes, h, haberse,
    habituales, hablar, hasta, hayas, heisenberg, hicieron, hipotesis,
    honor, idea, impedimento, importancia, importante, imposible, incertidumbre,
    incide, indispensable, inmediata, innovadora, inquietudes,
    internacional, intervalos, introdujo, invencion, investigaciones,
    irradia, jugando, jugo, julios, justamente, la, las, lester, letra,
    leyes, limitacion, llamada, llamadas, llamo, llave, lo, los, lugar,
    luz, maestra, manifestarse, max, mecanica, medir, menos, menudo,
    metal, microscopico, microscopio, miniatura, momento, muchas, mucho,
    multiplos, mundo, muy, naturaleza, necesidad, negro, ni, niels, no,
    nombrada, nuestros, nueva, o, objetivo, objeto, observados, oido,
    ojos, onda, ondas, ondulatorios, otras, otro, otros, palabras, papel,
    para, parecia, parte, particula, particulas, paso, pequenas, pequenos,
    percepcion, perceptibles, pero, pilares, planck, planteamiento,
    planteamientos, podia, poetica, por, posee, posicion, postulacion,
    precision, presencia, presentaba, presento, primera, principio,
    principios, problemas, prohibidas, proporcional, proporcionales,
    propuesta, propuso, protagonista, pudo, puede, pues, que, radiacion,
    realidad, realizaron, relaciona, representada, resalto,
    revolucionario, romantica, se, segun, segundo, seguramente, sentando,
    sento, ser, si, siempre, siglo, similares, sin, sino, sistema, sobre,
    solo, solucion, son, su, subatomicas, suele, sumerge, tal, tambien,
    tan, tener, tenia, teoria, teorias, teorica, terminaron, testimonio,
    tienen, toda, trabajo, trata, traves, tunel, un, una, unas, unidades,
    uno, utilizo, valor, vez, vigentes, werner, xx, y
]).
