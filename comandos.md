# Comandos para probar el sistema DCG

## 1. Cargar el sistema completo

```prolog
?- consult('main.pl').
?- inicio.
```

`inicio` muestra el menú de todos los predicados disponibles.

---

## 2. Demo automática (oraciones 1, 4 y 10)

```prolog
?- demo.
```

Analiza sintáctica y semánticamente tres oraciones representativas del corpus:
- Oración 1 — simple y correcta
- Oración 4 — uso metafórico (`played`)
- Oración 10 — ambigüedad léxica

---

## 3. Suite de tests completa (shell)

```bash
bash run_tests.sh
```

Ejecuta las 30 oraciones del corpus y reporta cuáles parsean correctamente.

---

## 4. Análisis sintáctico — parsear y dibujar árbol

```prolog
% Por ID de corpus
?- frase(1, _, T), oracion(X, T, []), draw(X).

% Oración específica por tokens
?- oracion(X, [the, planck, constant, is, a, fundamental, unit], []), draw(X).
```

---

## 5. Análisis sintáctico — probar un sintagma aislado

```prolog
?- consult('sintactico.pl').

% Sintagma nominal
?- g_nominal(X, [the, planck, constant], []).

% Sintagma verbal
?- g_verbal(X, [played, a, crucial, role], []).

% Sintagma preposicional
?- g_preposicional(X, [in, quantum, physics], []).
```

---

## 6. Análisis semántico completo por ID de corpus

```prolog
?- analizar(1).   % oración correcta
?- analizar(4).   % metáfora: "played"
?- analizar(10).  % ambigüedad: "constant"
?- analizar(17).  % incoherencia semántica
```

---

## 7. Análisis semántico manual (lista de tokens)

```prolog
?- analizar_oracion([quantum, physics, plunges, into, the, unknown]).
```

Detecta ambigüedad léxica, incoherencia semántica y uso metafórico.

---

## 8. Análisis desde texto libre (flujo completo)

```prolog
?- analizar_texto('This constant played an essential role.').
?- analizar_texto('Quantum mechanics governs the behavior of particles.').
```

Tokeniza, normaliza y analiza en un solo paso.

---

## 9. Preprocesar texto a tokens

```prolog
?- preprocesar('Planck laid the foundations of quantum theory.', Ts).
% Ts = [planck, laid, the, foundations, of, quantum, theory]
```

---

## 10. Dividir oración compleja en cláusulas simples

```prolog
?- frase(14, _, T), simplificar(T, S), maplist(writeln, S).
```

---

## 11. Consultar el corpus

```prolog
% Ver una oración por ID
?- frase(5, Tipo, Tokens).

% Listar todas las oraciones problemáticas
?- frase(Id, problematica, Tokens), writeln(Id-Tokens), fail ; true.

% Listar todas las oraciones ambiguas
?- frase(Id, ambigua, Tokens), writeln(Id-Tokens), fail ; true.
```

---

## 12. Detección semántica individual

```prolog
% Solo ambigüedad léxica
?- frase(10, _, T), ambiguedad_lexica(T, Amb), writeln(Amb).

% Solo incoherencia semántica
?- frase(17, _, T), incoherencia_semantica(T, Inc), writeln(Inc).

% Solo uso metafórico
?- frase(4, _, T), uso_no_literal(T, Met), writeln(Met).
```

---

## 13. Átomos especiales que requieren comillas

Los siguientes tokens deben escribirse con comillas simples:

```prolog
'20th'  '6.626x10-34'  'wave-particle'  'planck''s'  'quantum''s'
'1900'  '1905'  '1927'  '1981'
```

Ejemplo:
```prolog
?- frase(2, _, T), oracion(X, T, []), draw(X).
```
