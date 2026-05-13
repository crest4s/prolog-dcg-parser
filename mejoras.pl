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


% ===========================================================================
%  TOKENIZE/2  —  Tokenización básica (sin normalización morfológica)
%  Igual que preprocesar/2 pero expuesta con nombre canónico para
%  facilitar la interoperabilidad con otros módulos.
%
%  tokenize(+InputAtomOrString, -Tokens)
%
%  Ejemplo:
%    ?- tokenize('Particles absorbed energies.', Ts).
%    Ts = [particles, absorbed, energies]
% ===========================================================================

tokenize(Input, Tokens) :-
    ( atom(Input) -> Atom = Input ; atom_string(Atom, Input) ),
    downcase_atom(Atom, Lower),
    atom_string(Lower, S),
    split_string(S, " \t\n", "", Parts),
    include([P]>>(P \= ""), Parts, Parts2),
    maplist(limpiar_token, Parts2, Tokens).


% ===========================================================================
%  NORMALIZE/2  —  Tokenización + normalización morfológica en un paso
%  Convierte texto libre en lista de tokens con plurales normalizados.
%
%  normalize(+InputAtomOrString, -Normalized)
%
%  Ejemplo:
%    ?- normalize('Particles absorbed energies.', Ns).
%    Ns = [particle, absorbed, energy]
% ===========================================================================

normalize(Input, Normalized) :-
    tokenize(Input, Tokens),
    normalizar_tokens(Tokens, Normalized).


% ===========================================================================
%  INFLECT/3  —  Flexión morfológica dirigida
%  Dado el lema canónico y un rasgo morfológico, produce la forma flexionada.
%  Apoya los rasgos: singular | plural | base.
%
%  inflect(+Lema, +Rasgo, -Forma)
%
%  Ejemplos:
%    ?- inflect(phenomenon, plural, X).   X = phenomena
%    ?- inflect(particle, plural, X).     X = particles
%    ?- inflect(energy, singular, X).     X = energy
% ===========================================================================

inflect(Word, singular, Word) :- !.
inflect(Word, base,     Word) :- !.
inflect(Word, plural, Plural) :-
    ( singular(Plural, Word) -> true
    ; atom_concat(Word, s, Plural)
    ), !.
inflect(Word, _, Word).


% ===========================================================================
%  SYNTACTIC_FUNCTION/3  —  Categoría léxico-sintáctica de un token
%  Consulta el léxico para determinar la función sintáctica principal
%  de un átomo. El tercer argumento (contexto) está reservado para
%  extensiones futuras que requieran información posicional.
%
%  syntactic_function(+Token, -Categoria, +_Contexto)
%
%  Categorías devueltas: det | n | v | adj | adv | prep | pron | conj | unknown
%
%  Ejemplo:
%    ?- syntactic_function(constant, Cat, []).   Cat = n
%    ?- syntactic_function(played,   Cat, []).   Cat = v
% ===========================================================================

syntactic_function(Token, det,  _) :- det(Token),  !.
syntactic_function(Token, n,    _) :- n(Token),    !.
syntactic_function(Token, v,    _) :- v(Token),    !.
syntactic_function(Token, adj,  _) :- adj(Token),  !.
syntactic_function(Token, adv,  _) :- adv(Token),  !.
syntactic_function(Token, prep, _) :- prep(Token), !.
syntactic_function(Token, pron, _) :- pron(Token), !.
syntactic_function(Token, conj, _) :- conj(Token), !.
syntactic_function(_,     unknown, _).


% ===========================================================================
%  TRANSLATION_NOTE/2  —  Glosario de términos de física cuántica
%  Mapea términos especializados del corpus en inglés a su nota de
%  traducción en español, útil para el informe de análisis.
%
%  translation_note(+TerminoIngles, -NotaEspaniol)
%
%  Ejemplo:
%    ?- translation_note(quantum, N).   N = 'cuántico/cuántica'
% ===========================================================================

translation_note(quantum,       'cuántico/cuántica').
translation_note(constant,      'constante').
translation_note(energy,        'energía').
translation_note(photon,        'fotón').
translation_note(electron,      'electrón').
translation_note(particle,      'partícula').
translation_note(wave,          'onda').
translation_note(frequency,     'frecuencia').
translation_note(radiation,     'radiación').
translation_note(phenomenon,    'fenómeno').
translation_note(duality,       'dualidad').
translation_note(mechanics,     'mecánica').
translation_note(physics,       'física').
translation_note(theory,        'teoría').
translation_note(hypothesis,    'hipótesis').
translation_note(experiment,    'experimento').
translation_note(value,         'valor').
translation_note(integer,       'entero').
translation_note(multiple,      'múltiplo').
translation_note(joule,         'julio').
translation_note(barrier,       'barrera').
translation_note(breakthrough,  'avance/descubrimiento').
translation_note(formulation,   'formulación').
translation_note(conception,    'concepción').
translation_note(tunnel,        'túnel').
translation_note(microscope,    'microscopio').
translation_note(pillar,        'pilar').
translation_note(anxiety,       'inquietud/dilema').
translation_note(discipline,    'disciplina').
translation_note(dilemma,       'dilema').
translation_note(proposal,      'propuesta').
translation_note(groundwork,    'base/fundamento').
translation_note(conception,    'concepción').
translation_note(microscopic,   'microscópico/a').
translation_note(proportional,  'proporcional').
