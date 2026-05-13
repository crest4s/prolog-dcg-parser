% ===========================================================================
%  mejoras.pl  —  Mejoras del sistema de análisis
%  Práctica 2: Conocimiento y Razonamiento Automatizado, UAH 2025-26
%
%  Mejora 1: Preprocesamiento de cadena a lista de tokens
%    preprocesar(+StringOAtomo, -Tokens)
%
%  Mejora 2: Flexión morfológica — normalización de plurales
%    normalizar_tokens(+Tokens, -Normalizados)
%    singular(+Plural, -Singular)
%
%  Mejora 3: Explicaciones en español
%    explicar_analisis(+Tokens)
%
%  Requiere: sintactico.pl, deteccion.pl cargados (via main.pl).
% ===========================================================================


% ===========================================================================
%  MEJORA 1 — PREPROCESAMIENTO
%  Convierte un átomo o string en lista de átomos listos para el parser.
%  Pasos: (a) pasar a minúsculas, (b) eliminar puntuación terminal,
%         (c) dividir por espacios.
%
%  Ejemplo:
%    ?- preprocesar('This constant played an essential role.', Ts).
%    Ts = [this, constant, played, an, essential, role]
% ===========================================================================

preprocesar(Input, Tokens) :-
    ( atom(Input) -> Atom = Input ; atom_string(Atom, Input) ),
    downcase_atom(Atom, Lower),
    atom_string(Lower, S),
    split_string(S, " \t\n", "", Parts),
    include([P]>>(P \= ""), Parts, Parts2),
    maplist(limpiar_token, Parts2, Tokens).

% limpiar_token(+StringToken, -Atomo)
% Quita puntuación terminal ( . , ; : ! ? ) y convierte a átomo.
limpiar_token(S, Atom) :-
    ( string_concat(Base, ".", S) -> true
    ; string_concat(Base, ",", S) -> true
    ; string_concat(Base, ";", S) -> true
    ; string_concat(Base, ":", S) -> true
    ; string_concat(Base, "!", S) -> true
    ; string_concat(Base, "?", S) -> true
    ; Base = S
    ),
    atom_string(Atom, Base).


% ===========================================================================
%  MEJORA 2 — FLEXIÓN MORFOLÓGICA (normalización de plurales)
%  Mapea plurales irregulares y regulares presentes en el corpus
%  a su forma singular canónica, permitiendo que el lexicón acepte
%  formas flexionadas sin duplicar entradas.
%
%  singular(+Plural, -Singular)
%
%  normalizar_tokens(+Tokens, -Normalizados)
%  Aplica singular/2 cuando existe; deja el token intacto si no.
%
%  Ejemplos:
%    ?- singular(particles, X).   X = particle
%    ?- singular(theories, X).    X = theory
%    ?- normalizar_tokens([the, particles, absorbed, energies], Ns).
%    Ns = [the, particle, absorbed, energy]
% ===========================================================================

% Plurales irregulares del corpus
singular(phenomena,      phenomenon).
singular(quanta,         quantum).
singular(anxieties,      anxiety).
singular(dilemmas,       dilemma).
singular(theories,       theory).
singular(breakthroughs,  breakthrough).
singular(experiments,    experiment).
singular(quantities,     quantity).
singular(intervals,      interval).
singular(integers,       integer).
singular(approaches,     approach).
singular(laws,           law).
singular(words,          word).
singular(behaviors,      behavior).
singular(barriers,       barrier).
singular(units,          unit).
singular(joules,         joule).
singular(photons,        photon).
singular(electrons,      electron).
singular(particles,      particle).
singular(physicists,     physicist).
singular(scientists,     scientist).
singular(pillars,        pillar).
singular(waves,          wave).
singular(pockets,        pocket).
singular(multiples,      multiple).
singular(energies,       energy).
singular(behaviors,      behavior).

% Regla general para -s/-es: sólo se aplica si el singular resultante
% está reconocido en el léxico (n/2 o adj/2), evitando falsos positivos.
singular(Plural, Singular) :-
    \+ member(Plural, [this, was, is, has, does, his, its, as, thus]),
    ( atom_concat(Singular, s, Plural)
    ; atom_concat(Singular, es, Plural)
    ),
    ( n(Singular) ; adj(Singular) ; v(Singular) ).

% normalizar_tokens/2
normalizar_tokens([], []).
normalizar_tokens([T|Ts], [S|Ns]) :-
    ( singular(T, S) -> true ; S = T ),
    normalizar_tokens(Ts, Ns).


% ===========================================================================
%  MEJORA 3 — EXPLICACIONES EN ESPAÑOL
%  explicar_analisis(+Tokens)
%
%  Llama al parser sintáctico y a deteccion.pl e imprime un reporte
%  compacto en español con: tipo de oración, árbol (si parse OK),
%  y advertencias semánticas.
%
%  Ejemplo:
%    ?- explicar_analisis([this,constant,played,an,essential,role]).
% ===========================================================================

explicar_analisis(Tokens) :-
    format("~n========================================~n"),
    format("  ANÁLISIS DE LA ORACIÓN~n"),
    format("========================================~n"),
    format("Tokens: ~w~n~n", [Tokens]),
    % ---- análisis sintáctico ----
    ( oracion(Arbol, Tokens, [])
    -> functor(Arbol, TipoFunctor, _),
       etiqueta_tipo(TipoFunctor, Etiqueta),
       format("Tipo de oración: ~w~n~n", [Etiqueta]),
       format("Árbol de constituyentes:~n"),
       draw(Arbol)
    ;  format("[AVISO] La oración no es reconocida por la gramática.~n~n")
    ),
    % ---- análisis semántico ----
    format("~n--- Análisis semántico ---~n~n"),
    ambiguedad_lexica(Tokens, Amb),
    ( Amb \= []
    -> format("  Ambigüedad léxica detectada:~n"),
       forall(member(P-TS, Amb),
              format("    '~w'  puede ser: ~w~n", [P, TS]))
    ;  format("  Sin ambigüedad léxica.~n")
    ),
    incoherencia_semantica(Tokens, Inc),
    ( Inc \= []
    -> format("~n  Incoherencia semántica detectada:~n"),
       forall(member(incoherencia(S, TS, V), Inc),
              format("    Sujeto '~w' (tipo ~w) no puede realizar '~w' (verbo físico).~n",
                     [S, TS, V]))
    ;  format("~n  Sin incoherencia semántica.~n")
    ),
    uso_no_literal(Tokens, Met),
    ( Met \= []
    -> format("~n  Uso no literal / metáforas:~n"),
       forall(member(metafora(V, Desc), Met),
              format("    '~w'  →  ~w~n", [V, Desc]))
    ;  format("~n  Sin uso metafórico detectado.~n")
    ),
    format("~n========================================~n~n").

% etiqueta_tipo(+Functor, -Etiqueta)
etiqueta_tipo(o,   'Oración simple (o)').
etiqueta_tipo(oc,  'Oración coordinada (oc)').
etiqueta_tipo(or,  'Oración subordinada de relativo (or)').
etiqueta_tipo(ocm, 'Oración compuesta (ocm)').
etiqueta_tipo(_,   'Tipo desconocido').


% ===========================================================================
%  COMBINACIÓN: preprocesar + normalizar + explicar
%  analizar_texto(+StringOAtomo)
%  Acepta una cadena en texto libre, la tokeniza, normaliza y analiza.
%
%  Ejemplo:
%    ?- analizar_texto('This constant played an essential role.').
% ===========================================================================

analizar_texto(Input) :-
    preprocesar(Input, Tokens),
    normalizar_tokens(Tokens, Normalizados),
    ( Tokens \= Normalizados
    -> format("[Normalización] ~w → ~w~n", [Tokens, Normalizados])
    ;  true
    ),
    explicar_analisis(Normalizados).
