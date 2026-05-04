% *=============================================================================
% * main.pl — Punto de entrada del sistema
% * Practica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
% * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
% *=============================================================================*/

:- module(main, [analizar/1, analizar_arbol/2, detectar/1, comparar/1, analizar_semantico/1]).

:- use_module(sintactico).
:- use_module(semantico).
:- use_module(deteccion).
:- use_module(mejoras).
:- use_module(conjunto_oraciones).
:- use_module(draw).

% =============================================================================
% analizar(+ID)     — analiza la oración inglesa con ese ID del corpus
% analizar(+Tokens) — analiza directamente una lista de tokens en inglés
% =============================================================================

analizar(ID) :-
    integer(ID), !,
    (   conjunto_oraciones:oracion(ID, Tipo, Clase, Tokens)
    ->  format("~`=t~60|~n"),
        format("Sentence ~w | Type: ~w | Class: ~w~n", [ID, Tipo, Clase]),
        format("Tokens: ~w~n", [Tokens]),
        format("~`-t~60|~n"),
        sintactico:simplificar_y_dibujar(Tokens)
    ;   format("No sentence with ID ~w in the corpus.~n", [ID])
    ).

analizar(Tokens) :-
    is_list(Tokens), !,
    sintactico:simplificar_y_dibujar(Tokens).

% =============================================================================
% analizar_arbol(+Tokens, -Arboles)
% Parsea los tokens y devuelve la lista de árboles sintácticos.
% =============================================================================

analizar_arbol(Tokens, Arboles) :-
    sintactico:oración(Arboles, Tokens, []).

% =============================================================================
% analizar_semantico(+ID)
% Análisis semántico de la oración: muestra categorías semánticas presentes.
% =============================================================================

analizar_semantico(ID) :-
    integer(ID), !,
    (   conjunto_oraciones:oracion(ID, Tipo, Clase, Tokens)
    ->  format("~`=t~60|~n"),
        format("Semantic Analysis — Sentence ~w | Type: ~w | Class: ~w~n",
               [ID, Tipo, Clase]),
        format("~`-t~60|~n"),
        semantico:categoria_semantica(Tokens, Categorias),
        format("Semantic categories found:~n"),
        forall(member(Cat-Palabra, Categorias),
               format("  ~w  →  ~w~n", [Palabra, Cat])),
        format("~`-t~60|~n"),
        (   sintactico:oración(Arboles, Tokens, [])
        ->  sintactico:simplificar(Arboles, Simples),
            forall(member(Arbol, Simples),
                   analizar_roles(Arbol))
        ;   format("(Sentence does not fully parse with the current grammar.)~n")
        )
    ;   format("No sentence with ID ~w in the corpus.~n", [ID])
    ).

analizar_roles(Arbol) :-
    format("~nSyntactic roles:~n"),
    ( semantico:rol_semantico(Arbol, sujeto, Suj)
    -> format("  Subject   : ~w~n", [Suj])
    ;  true
    ),
    ( semantico:rol_semantico(Arbol, predicado, Pred)
    -> format("  Predicate : ~w~n", [Pred])
    ;  true
    ),
    ( semantico:rol_semantico(Arbol, objeto, Obj)
    -> format("  Object    : ~w~n", [Obj])
    ;  true
    ),
    ( semantico:rol_semantico(Arbol, complemento, Comp)
    -> format("  Complement: ~w~n", [Comp])
    ;  true
    ).

% =============================================================================
% detectar(+ID)
% Informa sobre la clase de la oración y muestra el análisis de traducción.
% =============================================================================

detectar(ID) :-
    integer(ID), !,
    (   conjunto_oraciones:oracion(ID, Tipo, Clase, Tokens)
    ->  format("~`=t~60|~n"),
        format("Detection — Sentence ~w | Type: ~w~n", [ID, Tipo]),
        format("~`-t~60|~n"),
        detectar_clase(Clase, Tokens)
    ;   format("No sentence with ID ~w in the corpus.~n", [ID])
    ).

detectar_clase(correcta, _) :-
    format("Class: correcta — No problems detected.~n").
detectar_clase(ambigua, Tokens) :-
    format("Class: ambigua — Sentence presents potential lexical or structural ambiguity.~n"),
    format("Tokens: ~w~n", [Tokens]).
detectar_clase(problematica, Tokens) :-
    format("Class: problematica — Sentence contains non-standard or divergent usage.~n"),
    format("Tokens: ~w~n", [Tokens]).

% =============================================================================
% comparar(+ID)
% Compara la oración española original con su traducción al inglés:
%   - Muestra ambas versiones
%   - Indica el tipo sintáctico asignado
%   - Comprueba si la traducción inglesa parsea según la gramática
%   - Muestra el análisis de problemas si la clase es ambigua o problemática
% =============================================================================

comparar(ID) :-
    integer(ID), !,
    (   conjunto_oraciones:oracion(ID, Tipo, Clase, TokensEN),
        conjunto_oraciones:oracion_es(ID, TokensES)
    ->  format("~`=t~60|~n"),
        format("Translation Comparison — Sentence ~w~n", [ID]),
        format("~`=t~60|~n"),
        format("Type      : ~w~n", [Tipo]),
        format("Class     : ~w~n", [Clase]),
        format("~`-t~60|~n"),
        format("Spanish (original):~n  ~w~n", [TokensES]),
        format("English (translation):~n  ~w~n", [TokensEN]),
        format("~`-t~60|~n"),
        % Verificar si la oración inglesa parsea con la gramática DCG
        (   sintactico:oración(Arboles, TokensEN, [])
        ->  sintactico:simplificar(Arboles, Simples),
            length(Simples, N),
            format("DCG parse (EN): OK — ~w simple sentence(s) extracted~n", [N])
        ;   format("DCG parse (EN): the sentence does not fully parse (complex structure)~n")
        ),
        format("~`-t~60|~n"),
        % Análisis de problemas de traducción
        detectar_clase_comparacion(ID, Clase)
    ;   format("No sentence with ID ~w in the corpus.~n", [ID])
    ).

detectar_clase_comparacion(_, correcta) :-
    format("Translation assessment: CORRECT~n"),
    format("  The English translation preserves the syntactic structure~n"),
    format("  of the original Spanish sentence.~n").

detectar_clase_comparacion(ID, ambigua) :-
    format("Translation assessment: AMBIGUOUS~n"),
    (   deteccion:ambiguedad(ID, Desc)
    ->  format("  ~w~n", [Desc])
    ;   format("  Potential ambiguity detected (see class annotation).~n")
    ).

detectar_clase_comparacion(ID, problematica) :-
    format("Translation assessment: PROBLEMATIC~n"),
    (   deteccion:problema_traduccion(ID, TipoProb, Desc)
    ->  format("  Problem type: ~w~n", [TipoProb]),
        format("  ~w~n", [Desc])
    ;   format("  Syntactic divergence detected (see class annotation).~n")
    ).
