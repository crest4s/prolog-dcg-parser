# prolog-dcg-parser

Syntactic and semantic analyser for natural-language sentences written in SWI-Prolog with Definite Clause Grammars (DCG). It parses sentences into constituency trees, draws them in ASCII, splits complex sentences into simple clauses and detects interpretation problems: lexical ambiguity, semantic incoherence and non-literal (metaphorical) use.

The corpus is a set of 30 sentences taken from a text about quantum physics, translated into English (the grammar and lexicon work on the English version; `oraciones.md` lists every sentence with its original and translation).

Lab project (lab 2) for the *Conocimiento y Razonamiento Automatizado* (Automated Knowledge and Reasoning) course at the University of Alcalá (UAH), 2025–26 academic year.

## Grammar

- **Sentences** (`oracion`): simple (`o`), coordinated (`oc`), relative subordinate (`or`) and compound (`ocm`).
- **Phrases**: noun (`g_nominal`), verb (`g_verbal`), infinitive (`g_infinitivo`), adjectival (`g_adjetival`), adverbial (`g_adverbial`) and prepositional (`g_preposicional`).
- **Terminals** (`lexico.pl`): determiners, nouns, verbs, adjectives, adverbs, conjunctions, prepositions...

## Modules

| File | Content |
|------|---------|
| `main.pl` | Entry point: loads every module, `inicio/0` (help menu) and `demo/0` |
| `sintactico.pl` | DCG grammar, constituency trees and simplification of complex sentences into simple clauses |
| `lexico.pl` | Lexicon |
| `semantico.pl` | Semantic categories (`tipo/2`) for the words of the corpus |
| `deteccion.pl` | Detection of lexical ambiguity, semantic incoherence and non-literal use |
| `mejoras.pl` | Improvements: text preprocessing into tokens, plural normalisation, explanations in Spanish |
| `conjunto_oraciones.pl` | Corpus: 30 sentences (`frase/3`) labelled as correct, ambiguous or problematic |
| `draw.pl` | ASCII tree drawing, by Mark Holcomb (public domain) |
| `tests/tests.pl`, `run_tests.sh` | Parsing tests over the whole corpus |

## Usage

Requires [SWI-Prolog](https://www.swi-prolog.org/) 9 or later.

```prolog
?- consult('main.pl').
?- inicio.                 % list of available predicates
?- demo.                   % analyses sentences 1, 4 and 10

% Parse a corpus sentence and draw its tree
?- frase(1, _, T), oracion(X, T, []), draw(X).

% Full semantic analysis of a corpus sentence
?- analizar(10).           % lexical ambiguity

% Analysis from free text
?- analizar_texto('This constant played an essential role.').

% Split a complex sentence into simple clauses
?- frase(14, _, T), simplificar(T, S), maplist(writeln, S).
```

Run the test suite from the shell:

```bash
./run_tests.sh
```

`comandos.md` (Spanish) has the full list of commands, and `pruebas.md` the queries used to test every sentence.

## Authors

- Adrián Morales Rodríguez ([@crest4s](https://github.com/crest4s))
- [@aliciasiguenza](https://github.com/aliciasiguenza)
- [@avuren13](https://github.com/avuren13)

## License

[MIT](LICENSE)
