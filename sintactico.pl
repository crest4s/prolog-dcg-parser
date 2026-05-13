% ===========================================================
%  sintactico.pl
%  Gramática DCG — Oraciones Simples (tipo: o)
%  Práctica 2: Conocimiento y Razonamiento Automatizado
%  Universidad de Alcalá, 2025-26
%
%  Corpus: 30 oraciones inglés, física cuántica.
%  Este archivo cubre ÚNICAMENTE las oraciones (o).
%
%  Carga y uso básico:
%    ?- consult('sintactico.pl').
%    ?- oracion(X, [this,constant,played,an,essential,role], []), draw(X).
%
%  Oraciones simples del corpus cubiertas aquí:
%    1  — This constant played an essential role...
%    6  — The constant was first named in the early 20th century.
%    8  — Since the early 20th century, progress in physics seemed to have stalled.
%   13  — However, acceptance of this idea was far from immediate.
%   19  — To be exact, its value is 6.626x10-34 joules per second...
%   20  — Likewise, the Planck constant also played an essential role...
%   29  — Also in 1981 it played a very important role...
%
%  Nota oración 6: el participio inicial "Named after the physicist
%  who introduced it, Max Planck," contiene una subordinada de relativo
%  (se trata en sintactico_compuesto.pl). Para el análisis simple, pasar
%  solo los tokens de la cláusula principal:
%    [the,constant,was,first,named,in,the,early,'20th',century]
% ===========================================================

:- consult(lexico).
:- consult(draw).

:- discontiguous oracion/3.


% ===========================================================
%  ORACIÓN SIMPLE  (o)
%  Estructura canónica: [Adjunto*]  GN  GV
%  Los adjuntos iniciales pueden ser adverbiales,
%  preposicionales o infinitivos.
% ===========================================================

%  Núcleo básico
oracion(o(GN, GV)) -->
    g_nominal(GN),
    g_verbal(GV).

%  Adjunto adverbial + GN + GV
%  — "However, acceptance of this idea was far from immediate."
oracion(o(GADV, GN, GV)) -->
    g_adverbial(GADV),
    g_nominal(GN),
    g_verbal(GV).

%  Adjunto preposicional + GN + GV
%  — "Since the early 20th century, progress in physics seemed to have stalled."
oracion(o(GP, GN, GV)) -->
    g_preposicional(GP),
    g_nominal(GN),
    g_verbal(GV).

%  Adjunto adverbial + adjunto preposicional + GN + GV
%  — "Also in 1981 it played a very important role..."
oracion(o(GADV, GP, GN, GV)) -->
    g_adverbial(GADV),
    g_preposicional(GP),
    g_nominal(GN),
    g_verbal(GV).

%  Adjunto infinitivo + GN + GV
%  — "To be exact, its value is 6.626x10-34 joules per second..."
oracion(o(GI, GN, GV)) -->
    g_infinitivo(GI),
    g_nominal(GN),
    g_verbal(GV).

%  GN + gpart(V, GP) + GV  — participio parentético intercalado entre sujeto y predicado
%  — "This phenomenon, confirmed by experiments, changed everything."
%  El V es el participio (también verbo en léxico), GP su adjunto preposicional.
oracion(o(GN, gpart(V, GP), GV)) -->
    g_nominal(GN),
    verbo(V), g_preposicional(GP),
    g_verbal(GV).

%  GADV + GN + gpart(V, GP) + GV
oracion(o(GADV, GN, gpart(V, GP), GV)) -->
    g_adverbial(GADV),
    g_nominal(GN),
    verbo(V), g_preposicional(GP),
    g_verbal(GV).

%  GP + GN + gpart(V, GP2) + GV
oracion(o(GP1, GN, gpart(V, GP2), GV)) -->
    g_preposicional(GP1),
    g_nominal(GN),
    verbo(V), g_preposicional(GP2),
    g_verbal(GV).


% ===========================================================
%  GRUPO NOMINAL  (gn)
%  Cubre pronombres, nombres solos, y combinaciones con
%  determinante, adjetivo y/o complemento preposicional.
% ===========================================================

%  Pronombre solo  (e.g., "it", "they")
g_nominal(gn(P)) --> pronombre(P).

%  Nombre solo  (e.g., "physics")
g_nominal(gn(N)) --> nombre(N).

%  Det + N  (e.g., "the constant", "this idea")
g_nominal(gn(D, N)) --> determinante(D), nombre(N).

%  Det + GP  (e.g., "another of the great quantum approaches")
g_nominal(gn(D, GP)) --> determinante(D), g_preposicional(GP).

%  Det + N + N  (nombre compuesto: "the Planck constant")
g_nominal(gn(D, N1, N2)) --> determinante(D), nombre(N1), nombre(N2).

%  Det + N + N + N  (compuesto de 3: "the tunnel effect microscope")
g_nominal(gn(D, N1, N2, N3)) -->
    determinante(D), nombre(N1), nombre(N2), nombre(N3).

%  Det + N + N + N + N  (compuesto de 4)
g_nominal(gn(D, N1, N2, N3, N4)) -->
    determinante(D), nombre(N1), nombre(N2), nombre(N3), nombre(N4).

%  Det + GADJ + N  (e.g., "an essential role", "a very important role")
g_nominal(gn(D, GADJ, N)) --> determinante(D), g_adjetival(GADJ), nombre(N).

%  Det + GADJ + N + N  (e.g., "the early 20th century")
g_nominal(gn(D, GADJ, N1, N2)) -->
    determinante(D), g_adjetival(GADJ), nombre(N1), nombre(N2).

%  Det + N + GADJ  (adjetivo postnominal)
g_nominal(gn(D, N, GADJ)) --> determinante(D), nombre(N), g_adjetival(GADJ).

%  Det + N + GP  (e.g., "the formulation of another...")
g_nominal(gn(D, N, GP)) --> determinante(D), nombre(N), g_preposicional(GP).

%  Det + N + N + GP  (e.g., "the Planck constant" + complemento prep)
g_nominal(gn(D, N1, N2, GP)) -->
    determinante(D), nombre(N1), nombre(N2), g_preposicional(GP).

%  Det + GADJ + N + GP  (e.g., "the International System of Units")
g_nominal(gn(D, GADJ, N, GP)) -->
    determinante(D), g_adjetival(GADJ), nombre(N), g_preposicional(GP).

%  N + GP  (sin det: "acceptance of this idea", "progress in physics")
g_nominal(gn(N, GP)) --> nombre(N), g_preposicional(GP).

%  N + GADJ + N  (posesivo sajón: "quantum's great approaches")
g_nominal(gn(N1, GADJ, N2)) --> nombre(N1), g_adjetival(GADJ), nombre(N2).

%  N + N + GP  (sin det: "6.626x10-34 joules per second")
g_nominal(gn(N1, N2, GP)) --> nombre(N1), nombre(N2), g_preposicional(GP).

%  N + N  (sin det: "planck's proposal", "wave-particle duality", "electron diffraction")
g_nominal(gn(N1, N2)) --> nombre(N1), nombre(N2).

%  GADJ + N  (sin det: "perplexing dilemmas", "quantum physics", "classically forbidden barriers")
g_nominal(gn(GADJ, N)) --> g_adjetival(GADJ), nombre(N).

%  --- Grupos nominales con cláusula de relativo integrada ---
%  Permiten que el GN contenga directamente una CR sin necesitar
%  una regla de oracion(or) separada para el antecedente.

%  Det + N + CR  (e.g., "the constant that Planck introduced")
g_nominal(gn(D, N, CR)) --> determinante(D), nombre(N), clausula_relativa(CR).

%  Det + N + N + CR  (e.g., "the Planck constant that was named")
g_nominal(gn(D, N1, N2, CR)) -->
    determinante(D), nombre(N1), nombre(N2), clausula_relativa(CR).

%  Det + GADJ + N + CR  (e.g., "an essential role that Planck played")
g_nominal(gn(D, GADJ, N, CR)) -->
    determinante(D), g_adjetival(GADJ), nombre(N), clausula_relativa(CR).

%  Det + N + GP + CR  (e.g., "the idea of physics that challenged reality")
g_nominal(gn(D, N, GP, CR)) -->
    determinante(D), nombre(N), g_preposicional(GP), clausula_relativa(CR).

%  N + CR  (sin det: "physics that challenges reality")
g_nominal(gn(N, CR)) --> nombre(N), clausula_relativa(CR).

%  --- Participio postnominal (cláusula relativa reducida) ---
%  Modela construcciones como "the energy emitted by the electron"
%  (equivalente a "the energy that was emitted by the electron").
%  Se exige un GP a continuación para reducir ambigüedad con el GV.

%  Det + N + gpart(V, GP)  (e.g., "the energy emitted by the electron")
g_nominal(gn(D, N, gpart(V, GP))) -->
    determinante(D), nombre(N), verbo(V), g_preposicional(GP).

%  Det + N + N + gpart(V, GP)  (e.g., "the Planck constant named after Max Planck")
g_nominal(gn(D, N1, N2, gpart(V, GP))) -->
    determinante(D), nombre(N1), nombre(N2), verbo(V), g_preposicional(GP).


% ===========================================================
%  GRUPO VERBAL  (gv)
%  Cubre: verbos intransitivos, transitivos, copulativos,
%  cadenas auxiliar-verbo y adverbios dentro del GV.
% ===========================================================

%  Verbo solo  (intransitivo)
g_verbal(gv(V)) --> verbo(V).

%  V + GN  (complemento directo)
g_verbal(gv(V, GN)) --> verbo(V), g_nominal(GN).

%  V + GADJ  (cópula + atributo: "was far from immediate")
g_verbal(gv(V, GADJ)) --> verbo(V), g_adjetival(GADJ).

%  V + GP
g_verbal(gv(V, GP)) --> verbo(V), g_preposicional(GP).

%  V + GN + GP  (e.g., "played an essential role in the formulation...")
g_verbal(gv(V, GN, GP)) --> verbo(V), g_nominal(GN), g_preposicional(GP).

%  V + GN + GP + GP
g_verbal(gv(V, GN, GP1, GP2)) -->
    verbo(V), g_nominal(GN), g_preposicional(GP1), g_preposicional(GP2).

%  --- Cadenas auxiliar + verbo principal ---

%  Aux + V  (e.g., "was named", "have stalled")
g_verbal(gv(V1, V2)) --> verbo(V1), verbo(V2).

%  Aux + V + GN
g_verbal(gv(V1, V2, GN)) --> verbo(V1), verbo(V2), g_nominal(GN).

%  Aux + V + GADJ
g_verbal(gv(V1, V2, GADJ)) --> verbo(V1), verbo(V2), g_adjetival(GADJ).

%  Aux + V + GP
g_verbal(gv(V1, V2, GP)) --> verbo(V1), verbo(V2), g_preposicional(GP).

%  Aux + V + GN + GP
g_verbal(gv(V1, V2, GN, GP)) -->
    verbo(V1), verbo(V2), g_nominal(GN), g_preposicional(GP).

%  Aux + Aux + V  (3 verbos seguidos)
g_verbal(gv(V1, V2, V3)) --> verbo(V1), verbo(V2), verbo(V3).

%  Aux + Aux + V + GN
g_verbal(gv(V1, V2, V3, GN)) -->
    verbo(V1), verbo(V2), verbo(V3), g_nominal(GN).

%  Aux + Aux + V + GP
g_verbal(gv(V1, V2, V3, GP)) -->
    verbo(V1), verbo(V2), verbo(V3), g_preposicional(GP).

%  Aux + Aux + V + GADJ  (e.g., "can be considered true", "was first named early")
g_verbal(gv(V1, V2, V3, GADJ)) -->
    verbo(V1), verbo(V2), verbo(V3), g_adjetival(GADJ).

%  --- Adverbio modificando dentro del GV ---

%  GADV + V  (e.g., "also played", "first named")
g_verbal(gv(GADV, V)) --> g_adverbial(GADV), verbo(V).

%  GADV + V + GN
g_verbal(gv(GADV, V, GN)) --> g_adverbial(GADV), verbo(V), g_nominal(GN).

%  GADV + V + GP
g_verbal(gv(GADV, V, GP)) --> g_adverbial(GADV), verbo(V), g_preposicional(GP).

%  GADV + V + GN + GP
g_verbal(gv(GADV, V, GN, GP)) -->
    g_adverbial(GADV), verbo(V), g_nominal(GN), g_preposicional(GP).

%  V + GADV + V2  (aux + adv + participio: "was first named")
g_verbal(gv(V1, GADV, V2)) -->
    verbo(V1), g_adverbial(GADV), verbo(V2).

%  V + GADV + V2 + GP
g_verbal(gv(V1, GADV, V2, GP)) -->
    verbo(V1), g_adverbial(GADV), verbo(V2), g_preposicional(GP).

%  V + GADV + V2 + GN + GP
g_verbal(gv(V1, GADV, V2, GN, GP)) -->
    verbo(V1), g_adverbial(GADV), verbo(V2), g_nominal(GN), g_preposicional(GP).

%  V + GADV + GADJ  (e.g., "was finally able to explain…")
g_verbal(gv(V, GADV, GADJ)) --> verbo(V), g_adverbial(GADV), g_adjetival(GADJ).

%  --- Complemento infinitivo ---
%  (e.g., "seemed to have stalled", "is 6.626... joules")
g_verbal(gv(V, GI)) --> verbo(V), g_infinitivo(GI).
g_verbal(gv(V, GI, GP)) --> verbo(V), g_infinitivo(GI), g_preposicional(GP).

%  --- Reglas adicionales de GV ---

%  V + GADJ + GI  (e.g., "is impossible to know", "are able to pass through")
%  Distinto de gv(V,GADJ) con GADJ=gadj(A,GI): aquí GADJ y GI son constituyentes separados.
g_verbal(gv(V, GADJ, GI)) --> verbo(V), g_adjetival(GADJ), g_infinitivo(GI).

%  V + GP + GN  (GP precede al CD: "presented in 1900 an innovative idea")
g_verbal(gv(V, GP, GN)) --> verbo(V), g_preposicional(GP), g_nominal(GN).

%  V + GADV + GN  (e.g., "was not a constant value", "was precisely this phenomenon")
g_verbal(gv(V, GADV, GN)) --> verbo(V), g_adverbial(GADV), g_nominal(GN).

%  V + GN + GADJ  (atributo predicativo postnominal: "exhibited behaviors very similar to light")
g_verbal(gv(V, GN, GADJ)) --> verbo(V), g_nominal(GN), g_adjetival(GADJ).

%  V + Prep  (preposición varada: "heard of", "spoken about")
g_verbal(gv(V, P)) --> verbo(V), preposicion(P).

%  V + [that] + clausula_base  (cláusula sustantiva embebida en GV)
%  (e.g., "was determined that it should always be quantized")
g_verbal(gv(V, conj(that), O)) --> verbo(V), [that], clausula_base(O).

%  GI + conj + V + GN + GP  (GV coordinado complejo)
%  (e.g., "to give explanation and manifest itself through quantum phenomena")
g_verbal(gv(GI, C, V, GN, GP)) -->
    g_infinitivo(GI), conjuncion(C), verbo(V), g_nominal(GN), g_preposicional(GP).

%  V + [what] + GV  (relativa libre copulativa: "is what governs the energy of photons")
g_verbal(gv(V, rel_what(GV2))) --> verbo(V), [what], g_verbal(GV2).

%  Aux + V + GP + GADV + GADJ  (e.g., "is often described as fundamentally important")
g_verbal(gv(V1, V2, GP, GADV, GADJ)) -->
    verbo(V1), verbo(V2), g_preposicional(GP), g_adverbial(GADV), g_adjetival(GADJ).

%  V + GN + ',' + each + GP  (distributivo dentro del GV: "emitted n quanta, each with energy hf")
g_verbal(gv(V, GN, dist(each, GP))) -->
    verbo(V), g_nominal(GN), [','], [each], g_preposicional(GP).

%  V + GN + each + GP  (distributivo sin coma explícita)
g_verbal(gv(V, GN, dist(each, GP))) -->
    verbo(V), g_nominal(GN), [each], g_preposicional(GP).


% ===========================================================
%  GRUPO INFINITIVO  (ginf)
%  Complemento o adjunto encabezado por el marcador "to".
%  Se procesa el átomo [to] directamente para distinguirlo
%  de prep(to) dentro de grupos preposicionales.
% ===========================================================

%  to + V  (e.g., "to stall")
g_infinitivo(ginf(V)) --> [to], verbo(V).

%  to + V + V  (e.g., "to have stalled")
g_infinitivo(ginf(V1, V2)) --> [to], verbo(V1), verbo(V2).

%  to + V + GADJ  (e.g., "to be exact")
g_infinitivo(ginf(V, GADJ)) --> [to], verbo(V), g_adjetival(GADJ).

%  to + V + GN  (e.g., "to understanding this miniature world")
g_infinitivo(ginf(V, GN)) --> [to], verbo(V), g_nominal(GN).

%  to + V + GP  (e.g., "to contribute to the field", "to pass through barriers")
g_infinitivo(ginf(V, GP)) --> [to], verbo(V), g_preposicional(GP).

%  to + V + V + GN
g_infinitivo(ginf(V1, V2, GN)) --> [to], verbo(V1), verbo(V2), g_nominal(GN).


% ===========================================================
%  GRUPO ADJETIVAL  (gadj)
% ===========================================================

%  Adjetivo solo
g_adjetival(gadj(A)) --> adjetivo(A).

%  Adv + Adj  (e.g., "very important", "essentially complete")
g_adjetival(gadj(ADV, A)) --> adverbio(ADV), adjetivo(A).

%  Adj + Adj  (e.g., "great quantum", "coherent efficient")
g_adjetival(gadj(A1, A2)) --> adjetivo(A1), adjetivo(A2).

%  Adv + Adj + Adj
g_adjetival(gadj(ADV, A1, A2)) --> adverbio(ADV), adjetivo(A1), adjetivo(A2).

%  Adj + GP  (e.g., "proportional to Planck's constant")
g_adjetival(gadj(A, GP)) --> adjetivo(A), g_preposicional(GP).

%  Adv + GP  (e.g., "far from immediate")
g_adjetival(gadj(ADV, GP)) --> adverbio(ADV), g_preposicional(GP).

%  Adv + Adj + GP
g_adjetival(gadj(ADV, A, GP)) --> adverbio(ADV), adjetivo(A), g_preposicional(GP).

%  Adj + conj + Adj  (e.g., "poetic and romantic", "coherent and efficient")
g_adjetival(gadj(A1, C, A2)) --> adjetivo(A1), conjuncion(C), adjetivo(A2).

%  Adv + Adj + conj + Adj  (e.g., "somewhat poetic and romantic")
g_adjetival(gadj(ADV, A1, C, A2)) --> adverbio(ADV), adjetivo(A1), conjuncion(C), adjetivo(A2).

%  Adj + GInf  (e.g., "able to explain", "able to pass", "key to understanding")
g_adjetival(gadj(A, GI)) --> adjetivo(A), g_infinitivo(GI).

%  Adv + Adj + GInf  (e.g., "finally able to explain" como GADJ embebida en GV)
g_adjetival(gadj(ADV, A, GI)) --> adverbio(ADV), adjetivo(A), g_infinitivo(GI).


% ===========================================================
%  GRUPO ADVERBIAL  (gadv)
% ===========================================================

g_adverbial(gadv(A)) --> adverbio(A).
g_adverbial(gadv(A1, A2)) --> adverbio(A1), adverbio(A2).


% ===========================================================
%  GRUPO PREPOSICIONAL  (gp)
% ===========================================================

%  Prep + GN  (caso base)
g_preposicional(gp(P, GN)) --> preposicion(P), g_nominal(GN).

%  Prep + Prep + GN  (e.g., "according to the International System...")
g_preposicional(gp(P1, P2, GN)) -->
    preposicion(P1), preposicion(P2), g_nominal(GN).

%  Prep + V + GN  (gerundivo: "in formulating another of...")
g_preposicional(gp(P, V, GN)) --> preposicion(P), verbo(V), g_nominal(GN).

%  Prep + GADJ  (complemento adjetival: "from immediate")
g_preposicional(gp(P, GADJ)) --> preposicion(P), g_adjetival(GADJ).


% ===========================================================
%  TERMINALES — conexión con el léxico en lexico.pl
% ===========================================================

determinante(det(X)) --> [X], { det(X) }.
nombre(n(X))         --> [X], { n(X) }.
pronombre(pron(X))   --> [X], { pron(X) }.
verbo(v(X))          --> [X], { v(X) }.
adjetivo(adj(X))     --> [X], { adj(X) }.
adverbio(adv(X))     --> [X], { adv(X) }.
preposicion(prep(X)) --> [X], { prep(X) }.
conjuncion(conj(X))  --> [X], { conj(X) }.


% ===========================================================
%  CONSULTAS DE PRUEBA (ejecutar tras consult)
%
%  Oración 1:
%    ?- oracion(X,[this,constant,played,an,essential,role,
%         in,the,formulation,of,another,of,the,great,quantum,approaches],[]),
%       draw(X).
%
%  Oración 6 (cláusula principal):
%    ?- oracion(X,[the,constant,was,first,named,in,the,early,'20th',century],[]),
%       draw(X).
%
%  Oración 8:
%    ?- oracion(X,[since,the,early,'20th',century,progress,in,physics,
%         seemed,to,have,stalled],[]), draw(X).
%
%  Oración 13:
%    ?- oracion(X,[however,acceptance,of,this,idea,was,far,from,immediate],[]),
%       draw(X).
%
%  Oración 19:
%    ?- oracion(X,[to,be,exact,its,value,is,'6.626x10-34',joules,per,second,
%         according,to,the,international,system,of,units],[]), draw(X).
%
%  Oración 20:
%    ?- oracion(X,[likewise,the,planck,constant,also,played,an,essential,role,
%         in,formulating,another,of,'quantum''s',great,approaches],[]),
%       draw(X).
%
%  Oración 29:
%    ?- oracion(X,[also,in,1981,it,played,a,very,important,role,
%         during,the,invention,of,the,tunnel,effect,microscope],[]),
%       draw(X).
% ===========================================================


% ===========================================================
%  CLÁUSULA BASE  (uso interno en oc / or / ocm)
%  Reutiliza los patrones de oracion(o(...)) como constituyente
%  embebido. Incluye variante con CR para cláusulas relativas
%  anidadas dentro de un bloque sustantivo.
% ===========================================================

clausula_base(o(GN, GV)) -->
    g_nominal(GN), g_verbal(GV).

clausula_base(o(GADV, GN, GV)) -->
    g_adverbial(GADV), g_nominal(GN), g_verbal(GV).

clausula_base(o(GP, GN, GV)) -->
    g_preposicional(GP), g_nominal(GN), g_verbal(GV).

clausula_base(o(GN, GV, CR)) -->
    g_nominal(GN), g_verbal(GV), clausula_relativa(CR).

clausula_base(o(GN, GV1, C, GV2)) -->
    g_nominal(GN), g_verbal(GV1), conjuncion(C), g_verbal(GV2).

%  Participio parentético en cláusula embebida (p.ej., dentro de oc/ocm)
clausula_base(o(GN, gpart(V, GP), GV)) -->
    g_nominal(GN), verbo(V), g_preposicional(GP), g_verbal(GV).


% ===========================================================
%  CLÁUSULA DE RELATIVO  (cr)
%  Introducida por pronombre relativo (that, which, who)
%  o por grupo preposicional relativo (in which, for which).
% ===========================================================

pronrel(pron(X)) --> [X], { member(X, [that, which, who]) }.

%  Relativo + GV  (antecedente es sujeto: "that consolidated Planck's theory")
clausula_relativa(cr(C, GV)) -->
    pronrel(C), g_verbal(GV).

%  Relativo + GN + GV  (antecedente es objeto: "that they could not explain")
clausula_relativa(cr(C, GN, GV)) -->
    pronrel(C), g_nominal(GN), g_verbal(GV).

%  "where" + GV  (locativo: "where the usual laws do not exist")
clausula_relativa(cr(adv(where), GV)) --> [where], g_verbal(GV).
clausula_relativa(cr(adv(where), GN, GV)) --> [where], g_nominal(GN), g_verbal(GV).

%  GP relativo + GV  ("for which there were no laws", "in which particles are able to pass")
clausula_relativa(cr(GP, GV)) --> g_preposicional(GP), g_verbal(GV).
clausula_relativa(cr(GP, GN, GV)) --> g_preposicional(GP), g_nominal(GN), g_verbal(GV).


% ===========================================================
%  GRUPO NOMINAL COORDINADO  (gn_coord)
%  Separado de g_nominal para evitar recursión izquierda.
%  Usado en cabeceras de reglas de oracion(or/ocm).
% ===========================================================

%  GN1 + and/or + GN2  (par)
g_nominal_coord(gn_coord(GN1, C, GN2)) -->
    g_nominal(GN1), conjuncion(C), g_nominal(GN2).

%  GN1, GN2 + and/or + GN3  (lista de 3: "duality, mechanics and physics")
g_nominal_coord(gn_coord(GN1, GN2, C, GN3)) -->
    g_nominal(GN1), [','], g_nominal(GN2), conjuncion(C), g_nominal(GN3).

%  GN1, GN2, GN3 + and/or + GN4  (lista de 4 con Oxford comma)
g_nominal_coord(gn_coord(GN1, GN2, GN3, C, GN4)) -->
    g_nominal(GN1), [','], g_nominal(GN2), [','], g_nominal(GN3), conjuncion(C), g_nominal(GN4).


% ===========================================================
%  ORACIÓN COORDINADA  (oc)
%  Dos cláusulas o GV unidos por conjunción coordinante.
% ===========================================================

%  GN + GV1 + conj + GV2  — sujeto compartido
%  — Oración 10: "an object that absorbs… but radiates…"
oracion(oc(GN, GV1, C, GV2)) -->
    g_nominal(GN),
    g_verbal(GV1),
    conjuncion(C),
    g_verbal(GV2).

%  GP + GN + GV1 + conj + GV2
oracion(oc(GP, GN, GV1, C, GV2)) -->
    g_preposicional(GP),
    g_nominal(GN),
    g_verbal(GV1),
    conjuncion(C),
    g_verbal(GV2).

%  GADV + GN + GV1 + conj + GV2
oracion(oc(GADV, GN, GV1, C, GV2)) -->
    g_adverbial(GADV),
    g_nominal(GN),
    g_verbal(GV1),
    conjuncion(C),
    g_verbal(GV2).

%  O1 + conj + O2  — sujetos distintos
oracion(oc(O1, C, O2)) -->
    clausula_base(O1),
    conjuncion(C),
    clausula_base(O2).

%  Correlativa "not only … but also"
%  — Oración 7: "Planck was not only finally able to explain… but also laid…"
oracion(oc(GP, GN, notonly(GV1), butalso(GV2))) -->
    g_preposicional(GP),
    g_nominal(GN),
    [not, only],
    g_verbal(GV1),
    [but, also],
    g_verbal(GV2).

oracion(oc(GN, notonly(GV1), butalso(GV2))) -->
    g_nominal(GN),
    [not, only],
    g_verbal(GV1),
    [but, also],
    g_verbal(GV2).

%  Correlativa con auxiliar entre GN y "not only"
%  — "Planck was not only finally able to explain… but also laid…"
oracion(oc(GN, V, notonly(GV1), butalso(GV2))) -->
    g_nominal(GN),
    verbo(V),
    [not, only],
    g_verbal(GV1),
    [but, also],
    g_verbal(GV2).

oracion(oc(GP, GN, V, notonly(GV1), butalso(GV2))) -->
    g_preposicional(GP),
    g_nominal(GN),
    verbo(V),
    [not, only],
    g_verbal(GV1),
    [but, also],
    g_verbal(GV2).

%  GN + GV + CR + conj + GV2  — relativo en primera coord. + segunda coordinada
oracion(oc(GN, GV, CR, C, GV2)) -->
    g_nominal(GN),
    g_verbal(GV),
    clausula_relativa(CR),
    conjuncion(C),
    g_verbal(GV2).


% ===========================================================
%  ORACIÓN SUBORDINADA DE RELATIVO  (or)
%  La oración principal lleva una cláusula de relativo que
%  modifica el sujeto GN, el objeto GN o el complemento GP.
% ===========================================================

%  GN + GV + CR
oracion(or(GN, GV, CR)) -->
    g_nominal(GN), g_verbal(GV), clausula_relativa(CR).

%  GADV + GN + GV + CR
oracion(or(GADV, GN, GV, CR)) -->
    g_adverbial(GADV), g_nominal(GN), g_verbal(GV), clausula_relativa(CR).

%  GP + GN + GV + CR
oracion(or(GP, GN, GV, CR)) -->
    g_preposicional(GP), g_nominal(GN), g_verbal(GV), clausula_relativa(CR).

%  GN1 + GV + GN2 + CR  — CR modifica objeto GN2
%  — Oración 16: "…were the pillars that made this new conception…"
oracion(or(GN1, GV, GN2, CR)) -->
    g_nominal(GN1), g_verbal(GV), g_nominal(GN2), clausula_relativa(CR).

%  GP + GN1 + GV + GN2 + CR
%  — Oración 15: "Fortunately, [physicists] contributed to [breakthroughs that consolidated…]"
oracion(or(GP, GN1, GV, GN2, CR)) -->
    g_preposicional(GP),
    g_nominal(GN1), g_verbal(GV), g_nominal(GN2), clausula_relativa(CR).

oracion(or(GADV, GN1, GV, GN2, CR)) -->
    g_adverbial(GADV),
    g_nominal(GN1), g_verbal(GV), g_nominal(GN2), clausula_relativa(CR).

%  GN + GV + GP + CR  — CR tras complemento preposicional
%  — Oración 23: "…through quantum phenomena…, which definitively consolidated…"
oracion(or(GN, GV, GP, CR)) -->
    g_nominal(GN), g_verbal(GV), g_preposicional(GP), clausula_relativa(CR).

%  GP1 + GN + GV + GP2 + CR
oracion(or(GP1, GN, GV, GP2, CR)) -->
    g_preposicional(GP1),
    g_nominal(GN), g_verbal(GV), g_preposicional(GP2),
    clausula_relativa(CR).

%  GN_coord + GV + CR  — sujeto coordinado + relativo
%  — Oración 16: "duality, the principle and mechanics were the pillars that…"
oracion(or(GNC, GV, CR)) -->
    g_nominal_coord(GNC), g_verbal(GV), clausula_relativa(CR).

oracion(or(GP, GNC, GV, CR)) -->
    g_preposicional(GP), g_nominal_coord(GNC), g_verbal(GV), clausula_relativa(CR).

oracion(or(GP, GNC, GV, GN2, CR)) -->
    g_preposicional(GP),
    g_nominal_coord(GNC), g_verbal(GV), g_nominal(GN2), clausula_relativa(CR).


% ===========================================================
%  ORACIÓN COMPUESTA  (ocm)
%  Combinaciones de subordinadas sustantivas ([that]),
%  adverbiales ([although], [and,although]), gerundios clausales,
%  y coordinación con cláusulas de relativo.
% ===========================================================

%  --- Sustantiva directa ---

%  GN + GV + [that] + clausula_base
%  — Oración 2 (principal): "It is often said that…"
oracion(ocm(GN, GV, conj(that), O)) -->
    g_nominal(GN), g_verbal(GV), [that], clausula_base(O).

%  GN + GV + [that] + clausula_base + CR  (sustantiva con relativo anidado)
%  — Oración 2 completa: "…that quantum physics is a discipline that challenges…"
oracion(ocm(GN, GV, conj(that), O, CR)) -->
    g_nominal(GN), g_verbal(GV), [that], clausula_base(O), clausula_relativa(CR).

%  GADV + GN + GV + [that] + clausula_base
oracion(ocm(GADV, GN, GV, conj(that), O)) -->
    g_adverbial(GADV), g_nominal(GN), g_verbal(GV), [that], clausula_base(O).

oracion(ocm(GADV, GN, GV, conj(that), O, CR)) -->
    g_adverbial(GADV), g_nominal(GN), g_verbal(GV),
    [that], clausula_base(O), clausula_relativa(CR).

%  GP + GN + GV + [that] + clausula_base
oracion(ocm(GP, GN, GV, conj(that), O)) -->
    g_preposicional(GP), g_nominal(GN), g_verbal(GV), [that], clausula_base(O).

%  GN + GV + GN_obj + [that] + clausula_base
%  — Oración 12: "he expounded the idea that the energy emitted was not a constant value…"
oracion(ocm(GN1, GV, GN2, conj(that), O)) -->
    g_nominal(GN1), g_verbal(GV), g_nominal(GN2), [that], clausula_base(O).

oracion(ocm(GP, GN1, GV, GN2, conj(that), O)) -->
    g_preposicional(GP),
    g_nominal(GN1), g_verbal(GV), g_nominal(GN2), [that], clausula_base(O).

%  GI + GN + GV + GN_obj + [that] + clausula_base
%  — Oración 25: "To establish this idea, Einstein used the hypothesis that…"
oracion(ocm(GI, GN1, GV, GN2, conj(that), O)) -->
    g_infinitivo(GI),
    g_nominal(GN1), g_verbal(GV), g_nominal(GN2), [that], clausula_base(O).

oracion(ocm(GI, GN, GV, conj(that), O)) -->
    g_infinitivo(GI), g_nominal(GN), g_verbal(GV), [that], clausula_base(O).

%  GN + GV + GP + [that] + clausula_base  (sustantiva en obj preposicional)
%  — Oración 21: "The idea of this approach states that it is impossible…"
oracion(ocm(GN, GV, GP, conj(that), O)) -->
    g_nominal(GN), g_verbal(GV), g_preposicional(GP), [that], clausula_base(O).

%  --- Adverbial concesiva ---

%  [although] + O_sub + O_main
%  — Oración 3: "Well, although it is a somewhat poetic phrase, it can be considered true."
oracion(ocm(conj(although), O_sub, O_main)) -->
    [although], clausula_base(O_sub), clausula_base(O_main).

oracion(ocm(GADV, conj(although), O_sub, O_main)) -->
    g_adverbial(GADV), [although], clausula_base(O_sub), clausula_base(O_main).

%  O1 + [and] + [although] + O_sub + O2
%  — Oración 14: "Planck's proposal was bold, and although it seemed…, it contradicted…"
oracion(ocm(O1, conj(and), conj(although), O_sub, O2)) -->
    clausula_base(O1), [and], [although], clausula_base(O_sub), clausula_base(O2).

%  --- Coordinada de GV + CR ---

%  GN + GV1 + conj + GV2 + CR
%  — Oración 28: "…confirmed this duality and highlighted the need…, which…"
oracion(ocm(GN, GV1, C, GV2, CR)) -->
    g_nominal(GN), g_verbal(GV1), conjuncion(C), g_verbal(GV2), clausula_relativa(CR).

%  GN + CR_parent + GV1 + conj + GV2  (relativo parentético en GN)
%  — Oración 28: "This phenomenon, which came to be known…, confirmed… and highlighted…"
oracion(ocm(GN, CR, GV1, C, GV2)) -->
    g_nominal(GN), clausula_relativa(CR),
    g_verbal(GV1), conjuncion(C), g_verbal(GV2).

%  GP + GN + GV1 + conj + GV2 + CR
oracion(ocm(GP, GN, GV1, C, GV2, CR)) -->
    g_preposicional(GP),
    g_nominal(GN), g_verbal(GV1), conjuncion(C), g_verbal(GV2),
    clausula_relativa(CR).

%  GN + GV + CR1 + conj + CR2  (dos relativas coordinadas)
%  — Oración 9: "dilemmas that they could not explain and for which there were no… laws"
oracion(ocm(GN, GV, CR1, C, CR2)) -->
    g_nominal(GN), g_verbal(GV),
    clausula_relativa(CR1), conjuncion(C), clausula_relativa(CR2).

%  --- Adjunto gerundival ---

%  GN + GV + GV_ger
%  — Oración 26: "…laying the foundation for the wave-particle duality"
oracion(ocm(GN, GV, GV_ger)) -->
    g_nominal(GN), g_verbal(GV), g_verbal(GV_ger).

oracion(ocm(GP, GN, GV, GV_ger)) -->
    g_preposicional(GP), g_nominal(GN), g_verbal(GV), g_verbal(GV_ger).

oracion(ocm(GADV, GP, GN, GV, GV_ger)) -->
    g_adverbial(GADV), g_preposicional(GP),
    g_nominal(GN), g_verbal(GV), g_verbal(GV_ger).

oracion(ocm(GADV, GN, GV, GV_ger)) -->
    g_adverbial(GADV), g_nominal(GN), g_verbal(GV), g_verbal(GV_ger).

%  GN + GV + GP + GV_ger
%  — Oración 22: "…appears as an impediment, as if it were a limitation…"
oracion(ocm(GN, GV, GP, GV_ger)) -->
    g_nominal(GN), g_verbal(GV), g_preposicional(GP), g_verbal(GV_ger).

oracion(ocm(GP1, GN, GV, GP2, GV_ger)) -->
    g_preposicional(GP1),
    g_nominal(GN), g_verbal(GV), g_preposicional(GP2), g_verbal(GV_ger).

%  GN + GV + GV_ger + [that] + clausula_base
%  — Oración 24: "…proposed…, betting that light hitting a metal ejects electrons"
%  — Oración 27: "…conducted experiments…, showing that they exhibited…"
oracion(ocm(GN, GV, GV_ger, conj(that), O)) -->
    g_nominal(GN), g_verbal(GV), g_verbal(GV_ger), [that], clausula_base(O).

oracion(ocm(GP, GN, GV, GV_ger, conj(that), O)) -->
    g_preposicional(GP),
    g_nominal(GN), g_verbal(GV), g_verbal(GV_ger), [that], clausula_base(O).

oracion(ocm(GADV, GP, GN, GV, GV_ger, conj(that), O)) -->
    g_adverbial(GADV), g_preposicional(GP),
    g_nominal(GN), g_verbal(GV), g_verbal(GV_ger), [that], clausula_base(O).

%  --- Sujeto coordinado con adjunto gerundival ---

%  GNC + GV + GV_ger
oracion(ocm(GNC, GV, GV_ger)) -->
    g_nominal_coord(GNC), g_verbal(GV), g_verbal(GV_ger).

%  GNC + GV + GV_ger + [that] + clausula_base
oracion(ocm(GNC, GV, GV_ger, conj(that), O)) -->
    g_nominal_coord(GNC), g_verbal(GV), g_verbal(GV_ger), [that], clausula_base(O).

%  --- Comparativa concesiva "as if" ---
%  — "it appears as an impediment, as if it were a limitation"

%  GN + GV + [as if] + clausula_base
oracion(ocm(GN, GV, conj(as_if), O_sub)) -->
    g_nominal(GN), g_verbal(GV), [as, if], clausula_base(O_sub).

%  GN + GV + GP + [as if] + clausula_base
oracion(ocm(GN, GV, GP, conj(as_if), O_sub)) -->
    g_nominal(GN), g_verbal(GV), g_preposicional(GP), [as, if], clausula_base(O_sub).

%  --- Adjunto distributivo postnominal "each with ..." ---
%  — GN + GV + ',' + each + GP
oracion(ocm(GN, GV, dist(det(each), GP))) -->
    g_nominal(GN), g_verbal(GV), [','], [each], g_preposicional(GP).


% ===========================================================
%  SIMPLIFICACIÓN DE ORACIONES COMPLEJAS
%
%  simplificar(+Tokens, -Simples)
%  Tokens  — lista de átomos que representa la oración compleja.
%  Simples — lista de listas; cada sublista es una oración simple.
%
%  Estrategia (por prioridad):
%    1. Coordinación adversativa : but / but also
%    2. Coordinación "and although": detecta el marcador compuesto
%    3. Coordinación copulativa  : and + inicio de nueva cláusula
%    4. Subordinada adverbial    : although (al inicio o tras prefijo corto)
%    5. Cláusula relativa        : which / who / where / prep+which
%    6. Complemento sustantivo   : that
%
%  Ejemplo de uso:
%    ?- frase(14, _, T), simplificar(T, S), maplist(writeln, S).
% ===========================================================

simplificar(Tokens, Simples) :-
    split_compleja(Tokens, P1, P2), !,
    simplificar(P1, L1),
    simplificar(P2, L2),
    append(L1, L2, Simples).
simplificar(Tokens, [Tokens]).

% ----------------------------------------------------------
%  split_compleja/3 — primera frontera de cláusula detectada
% ----------------------------------------------------------

split_compleja(T, P1, P2) :- split_coord_adv(T, P1, P2), !.
split_compleja(T, P1, P2) :- split_coord_cop(T, P1, P2), !.
split_compleja(T, P1, P2) :- split_adverbial(T, P1, P2), !.
split_compleja(T, P1, P2) :- split_relativa(T, P1, P2), !.
split_compleja(T, P1, P2) :- split_complemento(T, P1, P2), !.

% ----------------------------------------------------------
%  1. Coordinación adversativa
%     Detecta: "but also" (correlativa) y "but" simple.
%     También "and although" para separar la cláusula principal
%     de la concesiva antes de pasar por split_adverbial.
% ----------------------------------------------------------

split_coord_adv(T, P1, P2) :-
    split_en(T, [but, also], P1, P2), !.
split_coord_adv(T, P1, P2) :-
    split_en(T, [but], P1, P2), !.
split_coord_adv(T, P1, P2) :-
    append(P1, [and|P2], T),
    P2 = [although|_],
    P1 \= [].

% ----------------------------------------------------------
%  2. Coordinación copulativa: "and" entre dos cláusulas
%     Heurístico: la cláusula derecha comienza con pronombre
%     o determinante (evita dividir sintagmas nominales coord.)
% ----------------------------------------------------------

split_coord_cop(T, P1, P2) :-
    split_en(T, [and], P1, P2),
    P2 = [W|_],
    ( pron(W) ; det(W) ).

% ----------------------------------------------------------
%  3. Subordinada adverbial con "although"
%     Divide Resto (= lo que sigue a "although") en:
%       Sub  — la cláusula subordinada
%       Main — la cláusula principal
%     Criterio de frontera: Main empieza con pronombre sujeto.
%     El prefijo previo a "although" (p.ej. "well") se descarta
%     porque no forma cláusula independiente.
% ----------------------------------------------------------

split_adverbial([although|Resto], Sub, Main) :- !,
    append(Sub, Main, Resto),
    Sub \= [],
    Main = [W|_],
    pron(W).
split_adverbial(T, Sub, Main) :-
    split_en(T, [although], _, Resto),
    append(Sub, Main, Resto),
    Sub \= [],
    Main = [W|_],
    pron(W).

% ----------------------------------------------------------
%  4. Cláusula de relativo
%     Relativos preposicionales primero (in which, for which…)
%     para evitar que "in" quede huérfano en P1.
%     Después pronombres relativos simples: which, who, where.
% ----------------------------------------------------------

split_relativa(T, P1, P2) :-
    append(P1, [Prep, which|P2], T),
    prep(Prep),
    P1 \= [], P2 \= [], !.
split_relativa(T, P1, P2) :-
    split_en(T, [which], P1, P2), !.
split_relativa(T, P1, P2) :-
    split_en(T, [who], P1, P2), !.
split_relativa(T, P1, P2) :-
    split_en(T, [where], P1, P2), !.

% ----------------------------------------------------------
%  5. Complemento sustantivo con "that"
%     Captura tanto relativas de "that" como subordinadas
%     sustantivas: se divide siempre en la primera ocurrencia.
% ----------------------------------------------------------

split_complemento(T, P1, P2) :-
    split_en(T, [that], P1, P2).

% ----------------------------------------------------------
%  split_en/4 — divide en la PRIMERA ocurrencia del separador
%  split_en(+Lista, +Separador, -Antes, -Despues)
%  Falla si Antes o Despues quedan vacíos.
% ----------------------------------------------------------

split_en(Lista, Sep, Antes, Despues) :-
    append(Antes, Medio, Lista),
    append(Sep, Despues, Medio),
    Antes \= [],
    Despues \= [].


% ===========================================================
%  CONSULTAS DE PRUEBA — ORACIONES COMPLEJAS
%
%  Oración 7 (oc — correlativa "not only…but also"):
%    ?- oracion(X,[in,a,completely,revolutionary,work,planck,was,
%         not,only,finally,able,to,explain,a,great,many,of,the,
%         anxieties,of,the,time,but,also,laid,the,groundwork,
%         for,a,new,era,in,physics],[]), draw(X).
%
%  Oración 10 (oc — adversativa, sujeto compartido):
%    ?- oracion(X,[one,such,problem,was,radiation,from,the,black,
%         body,that,is,an,object,that,absorbs,all,of,the,radiation,
%         that,strikes,it,but,radiates,a,quantity,of,energy,
%         characteristic,of,it],[]), draw(X).
%
%  Oración 2 (ocm — sustantiva + relativa anidada):
%    ?- oracion(X,[it,is,often,said,that,quantum,physics,is,a,
%         discipline,that,challenges,the,perception,of,reality],[]),
%       draw(X).
%
%  Oración 3 (ocm — adverbial concesiva):
%    ?- oracion(X,[well,although,it,is,a,somewhat,poetic,phrase,
%         it,can,be,considered,true],[]), draw(X).
%
%  Oración 15 (or — relativo sobre objeto):
%    ?- oracion(X,[fortunately,other,physicists,of,great,importance,
%         contributed,to,other,fundamental,breakthroughs,that,
%         eventually,consolidated,'planck''s',theory],[]), draw(X).
%
%  Oración 16 (or — sujeto coord. + relativo):
%    ?- oracion(X,['wave-particle',duality,and,quantum,mechanics,
%         were,the,pillars,that,made,this,new,conception,of,the,
%         microscopic,world,grow],[]), draw(X).
%
%  Oración 9 (ocm — dos relativas coordinadas):
%    ?- oracion(X,[scientists,began,to,find,perplexing,dilemmas,
%         that,they,could,not,explain,and,for,which,there,were,
%         no,coherent,laws],[]), draw(X).
%
%  Oración 30 (or — relativo preposicional):
%    ?- oracion(X,[this,is,a,phenomenon,in,which,particles,are,
%         able,to,pass,through,classically,forbidden,energy,
%         barriers],[]), draw(X).
% ===========================================================
