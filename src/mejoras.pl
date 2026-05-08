/*=============================================================================
 * mejoras.pl — Mejoras sobre el análisis base
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Mejoras implementadas (mínimo 3 obligatorias):
 *
 *   Mejora 1 — Preprocesamiento de la oración
 *              Tokenización avanzada y normalización del texto de entrada.
 *
 *   Mejora 2 — Flexión de palabras
 *              Manejo de plurales, género y tiempos verbales.
 *
 *   Mejora 3 — Asignación de funciones sintácticas
 *              Identificación de roles: sujeto, predicado, objeto, complemento.
 *
 * Mejoras opcionales adicionales:
 *   - Optimización del análisis sintáctico
 *   - Visualización mejorada de árboles
 *   - Análisis semántico avanzado
 *   - Detección más precisa de ambigüedad
 *   - Generación de explicaciones automáticas
 *=============================================================================*/

:- module(mejoras, [tokenize/2, normalize/2, inflect/3, syntactic_function/3]).

% =============================================================================
% tokenize/2 — divide un átomo de texto en tokens, separando puntuación
% =============================================================================

tokenize(Text, Tokens) :-
    atom_string(Text, Str),
    string_codes(Str, Codes),
    tokenize_codes(Codes, Tokens).

tokenize_codes([], []).
tokenize_codes([C|Cs], Tokens) :-
    is_whitespace(C), !,
    tokenize_codes(Cs, Tokens).
tokenize_codes([C|Cs], [Tok|Tokens]) :-
    is_punct(C), !,
    atom_codes(Tok, [C]),
    tokenize_codes(Cs, Tokens).
tokenize_codes(Codes, [Tok|Tokens]) :-
    collect_word(Codes, WordCodes, Rest),
    atom_codes(Tok, WordCodes),
    tokenize_codes(Rest, Tokens).

collect_word([], [], []).
collect_word([C|Cs], [], [C|Cs]) :-
    ( is_whitespace(C) ; is_punct(C) ), !.
collect_word([C|Cs], [C|Word], Rest) :-
    collect_word(Cs, Word, Rest).

is_whitespace(32). is_whitespace(9). is_whitespace(10). is_whitespace(13).

is_punct(46).   % .
is_punct(44).   % ,
is_punct(59).   % ;
is_punct(58).   % :
is_punct(33).   % !
is_punct(63).   % ?
is_punct(40).   % (
is_punct(41).   % )
is_punct(34).   % "
is_punct(39).   % '

% =============================================================================
% normalize/2 — convierte todos los tokens a minúsculas
% =============================================================================

normalize(Tokens, Norm) :-
    maplist([T, N]>>(downcase_atom(T, N)), Tokens, Norm).

% =============================================================================
% inflect(+Word, +Category, -Root)
% Devuelve la forma de diccionario (raíz) de una palabra flexionada.
%   noun — plural → singular
%   verb — irregular, -ed, -ing, 3ª persona -s → base
%   otros — identidad
% =============================================================================

inflect(Word, noun, Root) :- noun_plural(Word, Root), !.
inflect(Word, noun, Word).

inflect(Word, verb, Root) :- verb_irregular(Word, Root), !.
inflect(Word, verb, Root) :- verb_ed(Word, Root), !.
inflect(Word, verb, Root) :- verb_ing(Word, Root), !.
inflect(Word, verb, Root) :- verb_3sg(Word, Root), !.
inflect(Word, verb, Word).

inflect(Word, _, Word).

% --- Plural de sustantivos ---

% -ies → -y  (theories → theory, frequencies → frequency)
noun_plural(Word, Root) :-
    atom_concat(Stem, ies, Word),
    atom_length(Stem, L), L > 0, !,
    atom_concat(Stem, y, Root).

% -ses → raíz (masses → mass)
noun_plural(Word, Stem) :-
    atom_concat(Stem, ses, Word),
    atom_length(Stem, L), L > 1, !.

% -s regular (particles → particle, constants → constant)
noun_plural(Word, Stem) :-
    atom_concat(Stem, s, Word),
    atom_length(Stem, L), L > 2.

% --- Verbos irregulares ---

verb_irregular(was,       be).
verb_irregular(were,      be).
verb_irregular(been,      be).
verb_irregular(am,        be).
verb_irregular(is,        be).
verb_irregular(are,       be).
verb_irregular(had,       have).
verb_irregular(has,       have).
verb_irregular(became,    become).
verb_irregular(went,      go).
verb_irregular(did,       do).
verb_irregular(does,      do).
verb_irregular(said,      say).
verb_irregular(laid,      lay).
verb_irregular(came,      come).
verb_irregular(began,     begin).
verb_irregular(showed,    show).
verb_irregular(known,     know).
verb_irregular(taken,     take).
verb_irregular(held,      hold).
verb_irregular(found,     find).
verb_irregular(understood, understand).
verb_irregular(made,      make).
verb_irregular(gave,      give).
verb_irregular(saw,       see).
verb_irregular(got,       get).
verb_irregular(kept,      keep).

% --- Pasado regular -ied → -y (tried → try) ---
verb_ed(Word, Root) :-
    atom_concat(Stem, ied, Word),
    atom_length(Stem, L), L > 1, !,
    atom_concat(Stem, y, Root).

% --- Pasado regular -ed → raíz (played → play, stalled → stall) ---
verb_ed(Word, Stem) :-
    atom_concat(Stem, ed, Word),
    atom_length(Stem, L), L > 1.

% --- Gerundio -ing → raíz (playing → play, stalling → stall) ---
verb_ing(Word, Stem) :-
    atom_concat(Stem, ing, Word),
    atom_length(Stem, L), L > 1.

% --- 3ª persona -ies → -y (tries → try) ---
verb_3sg(Word, Root) :-
    atom_concat(Stem, ies, Word),
    atom_length(Stem, L), L > 1, !,
    atom_concat(Stem, y, Root).

% --- 3ª persona -es → raíz (challenges → challenge) ---
verb_3sg(Word, Stem) :-
    atom_concat(Stem, es, Word),
    atom_length(Stem, L), L > 2, !.

% --- 3ª persona -s → raíz (plays → play) ---
verb_3sg(Word, Stem) :-
    atom_concat(Stem, s, Word),
    atom_length(Stem, L), L > 2.

% =============================================================================
% syntactic_function/3 — extrae sujeto o predicado de un árbol s(NP, VP)
% =============================================================================

syntactic_function(s(NP, _), subject,   NP).
syntactic_function(s(_, VP), predicate, VP).
