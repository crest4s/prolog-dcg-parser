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
    (   conjunto_oraciones:oracion(ID, Type, Class, Tokens)
    ->  format("~`=t~60|~n"),
        format("Sentence ~w | Type: ~w | Class: ~w~n", [ID, Type, Class]),
        format("Tokens: ~w~n", [Tokens]),
        format("~`-t~60|~n"),
        sintactico:simplify_and_draw(Tokens)
    ;   format("No sentence with ID ~w in the corpus.~n", [ID])
    ).

analizar(Tokens) :-
    is_list(Tokens), !,
    sintactico:simplify_and_draw(Tokens).

% =============================================================================
% analizar_arbol(+Tokens, -Trees)
% Parsea los tokens y devuelve la lista de árboles sintácticos.
% =============================================================================

analizar_arbol(Tokens, Trees) :-
    sintactico:parse(Trees, Tokens, []).

% =============================================================================
% analizar_semantico(+ID)
% Análisis semántico de la oración: muestra categorías semánticas presentes.
% =============================================================================

analizar_semantico(ID) :-
    integer(ID), !,
    (   conjunto_oraciones:oracion(ID, Type, Class, Tokens)
    ->  format("~`=t~60|~n"),
        format("Semantic Analysis — Sentence ~w | Type: ~w | Class: ~w~n",
               [ID, Type, Class]),
        format("~`-t~60|~n"),
        semantico:semantic_category(Tokens, Categories),
        format("Semantic categories found:~n"),
        forall(member(Cat-Word, Categories),
               format("  ~w  →  ~w~n", [Word, Cat])),
        format("~`-t~60|~n"),
        (   sintactico:parse(Trees, Tokens, [])
        ->  sintactico:simplify(Trees, Simples),
            forall(member(Tree, Simples),
                   analyze_roles(Tree))
        ;   format("(Sentence does not fully parse with the current grammar.)~n")
        )
    ;   format("No sentence with ID ~w in the corpus.~n", [ID])
    ).

analyze_roles(Tree) :-
    format("~nSyntactic roles:~n"),
    ( semantico:semantic_role(Tree, subject, Subj)
    -> format("  Subject   : ~w~n", [Subj])
    ;  true
    ),
    ( semantico:semantic_role(Tree, predicate, Pred)
    -> format("  Predicate : ~w~n", [Pred])
    ;  true
    ),
    ( semantico:semantic_role(Tree, object, Obj)
    -> format("  Object    : ~w~n", [Obj])
    ;  true
    ),
    ( semantico:semantic_role(Tree, complement, Comp)
    -> format("  Complement: ~w~n", [Comp])
    ;  true
    ).

% =============================================================================
% detectar(+ID)
% Informa sobre la clase de la oración y muestra el análisis de traducción.
% =============================================================================

detectar(ID) :-
    integer(ID), !,
    (   conjunto_oraciones:oracion(ID, Type, Class, Tokens)
    ->  format("~`=t~60|~n"),
        format("Detection — Sentence ~w | Type: ~w~n", [ID, Type]),
        format("~`-t~60|~n"),
        show_class(Class, Tokens)
    ;   format("No sentence with ID ~w in the corpus.~n", [ID])
    ).

show_class(correcta, _) :-
    format("Class: correcta — No problems detected.~n").
show_class(ambigua, Tokens) :-
    format("Class: ambigua — Sentence presents potential lexical or structural ambiguity.~n"),
    format("Tokens: ~w~n", [Tokens]).
show_class(problematica, Tokens) :-
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
    (   conjunto_oraciones:oracion(ID, Type, Class, TokensEN),
        conjunto_oraciones:oracion_es(ID, TokensES)
    ->  format("~`=t~60|~n"),
        format("Translation Comparison — Sentence ~w~n", [ID]),
        format("~`=t~60|~n"),
        format("Type      : ~w~n", [Type]),
        format("Class     : ~w~n", [Class]),
        format("~`-t~60|~n"),
        format("Spanish (original):~n  ~w~n", [TokensES]),
        format("English (translation):~n  ~w~n", [TokensEN]),
        format("~`-t~60|~n"),
        % Verificar si la oración inglesa parsea con la gramática DCG
        (   sintactico:parse(Trees, TokensEN, [])
        ->  sintactico:simplify(Trees, Simples),
            length(Simples, N),
            format("DCG parse (EN): OK — ~w simple sentence(s) extracted~n", [N])
        ;   format("DCG parse (EN): the sentence does not fully parse (complex structure)~n")
        ),
        format("~`-t~60|~n"),
        % Análisis de problemas de traducción
        compare_class(ID, Class)
    ;   format("No sentence with ID ~w in the corpus.~n", [ID])
    ).

compare_class(_, correcta) :-
    format("Translation assessment: CORRECT~n"),
    format("  The English translation preserves the syntactic structure~n"),
    format("  of the original Spanish sentence.~n").

compare_class(ID, ambigua) :-
    format("Translation assessment: AMBIGUOUS~n"),
    (   deteccion:ambiguity(ID, Desc)
    ->  format("  ~w~n", [Desc])
    ;   format("  Potential ambiguity detected (see class annotation).~n")
    ).

compare_class(ID, problematica) :-
    format("Translation assessment: PROBLEMATIC~n"),
    (   deteccion:translation_problem(ID, ProbType, Desc)
    ->  format("  Problem type: ~w~n", [ProbType]),
        format("  ~w~n", [Desc])
    ;   format("  Syntactic divergence detected (see class annotation).~n")
    ).
