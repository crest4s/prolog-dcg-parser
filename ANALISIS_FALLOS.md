# Análisis de Fallos y Funcionalidades Incompletas

> Generado: 2026-05-13 | Estado actual: **11 de 30 oraciones parsean**

---

## Resultado global por tipo de oración

| Tipo | Pasan | Fallan | Total |
|------|-------|--------|-------|
| `o`  | 6     | 1 (o6) | 7     |
| `oc` | 0     | 2      | 2     |
| `or` | 0     | 5      | 5     |
| `ocm`| 5 (o2,o3,o9,o14,o28) | 11 | 16 |
| **Total** | **11** | **19** | **30** |

---

## 1. Reglas de GV ausentes en `sintactico.pl`

Causa raíz de la mayoría de fallos.

### 1.1 `gv(V, GADJ, GI)` — V + adjetivo predicativo + infinitivo
- **Falta:** `g_verbal(gv(V, GADJ, GI)) --> verbo(V), g_adjetival(GADJ), g_infinitivo(GI).`
- **Afecta:** o7 ("was able to explain"), o21 ("is impossible to know"), o30 ("are able to pass through")

### 1.2 `gv(V, GP, GN)` — V + GP + GN (GP precede al objeto directo)
- **Falta:** `g_verbal(gv(V, GP, GN)) --> verbo(V), g_preposicional(GP), g_nominal(GN).`
- **Afecta:** o11 ("presented **in 1900** an innovative idea"), o24 ("proposed **in 1905** a quantum explanation")

### 1.3 `gv(V, GADV, GN)` — V + adverbio + GN
- **Falta:** `g_verbal(gv(V, GADV, GN)) --> verbo(V), g_adverbial(GADV), g_nominal(GN).`
- **Afecta:** o26 ("was **precisely** this phenomenon")

### 1.4 `gv(V, GN, GADJ)` — V + GN + GADJ predicativo postnominal
- **Falta:** `g_verbal(gv(V, GN, GADJ)) --> verbo(V), g_nominal(GN), g_adjetival(GADJ).`
- **Afecta:** o27 ("exhibited wavelike behaviors **very similar to light waves**")

### 1.5 Preposición varada (stranded preposition)
- La gramática exige siempre `prep + GN`. No hay regla para preposición al final de GV sin complemento.
- **Afecta:** o5 ("heard **of**" — preposición sin objeto)

### 1.6 GV con cláusula sustantiva embebida (`that + CB`)
- El GV no puede contener `[that] + clausula_base`. Solo `oracion` y `clausula_base` gestionan `[that]`.
- **Afecta:** o18 ("was determined **that** it should always be quantized…")

### 1.7 GV coordinado complejo (`GI + conj + V + GN + GP`)
- **Afecta:** o23 ("manages to give explanation **and** manifest itself through quantum phenomena")

---

## 2. Reglas de GI y GADJ ausentes en `sintactico.pl`

### 2.1 `ginf(V, GP)` — infinitivo con complemento preposicional
- Solo existe `ginf(V, GN)`. Falta `ginf(V, GP)`.
- **Afecta:** o30 ("to pass **through** classically forbidden energy barriers")

### 2.2 `gadj(A, GI)` — adjetivo + complemento infinitivo
- Solo existe `gadj(A, GP)`. Falta `gadj(A, GI)`.
- **Afecta:** o7, o21, o30 ("able **to explain**", "impossible **to know**", "able **to pass**")

### 2.3 Regla correlativa `not only…but also` no incluye el auxiliar
- La regla `oracion(oc(GP, GN, notonly(GV1), butalso(GV2)))` salta de `GN` a `[not,only]` sin consumir el auxiliar `was` que aparece entre ellos.
- **Afecta:** o7 — "Planck **was** not only finally able to explain…"

---

## 3. Fallos en GN, GN_coord y CR en `sintactico.pl`

### 3.1 `pron(this)` ausente en `lexico.pl`
- `this` está declarado solo como `det(this)`, nunca como `pron(this)`.
- `g_nominal(gn(pron(this)))` falla, por lo que "**This** is a phenomenon" no puede parsearse.
- **Afecta:** o30

### 3.2 `g_nominal_coord` solo admite 2 GN
- Solo existe `gn_coord(GN1, C, GN2)`. No hay soporte para listas de 3+.
- **Afecta:** o15 ("albert einstein, niels bohr **or** werner heisenberg"), o16 (sujeto de 3 elementos)

### 3.3 CR anidada dentro de GN
- El GN no acepta cláusula de relativo embebida.
- **Afecta:** o10 ("an object **that absorbs** all of the radiation **that strikes** it"), o18 ("quantities **which were** multiple integers")

### 3.4 GN con participio adjetival parentético
- No hay regla para GN con participio intercalado antes del GV.
- **Afecta:** o17 ("the Planck constant, **represented by the letter h**, became…"), o23 ("its presence, **deduced in a theoretical way**, manages…")

### 3.5 Reglas `ocm` con `GV_ger` no admiten GNC como sujeto
- `oracion(ocm(GADV, GP, GN, GV, GV_ger, conj(that), O))` exige `g_nominal` pero el sujeto es `g_nominal_coord`.
- **Afecta:** o27 ("clinton davisson **and** lester germer conducted…")

---

## 4. Construcciones específicas sin soporte

### 4.1 O4 — `is what governs` (pronombre relativo en posición de atributo)
- "Quantum physics is **what** governs…" — `what` es pronombre relativo, no verbo.
- No hay regla para GV copulativo seguido de pronombre relativo + GV.

### 4.2 O22 — Cláusula comparativa `as if`
- "appears as an impediment, **as if** it were a limitation…"
- `as if` es conjunción compuesta sin representación en el léxico ni regla en la gramática.

### 4.3 O25 — Post-nominal adjunto con `each`
- "…particles called photons, **each with energy proportional to Planck's constant**"
- No hay regla para adjunto distributivo tras GN.

### 4.4 O12 — Secuencia `Aux + V + GP + GADV + GADJ`
- "was emitted in small quantities **always proportional to one value**"
- No existe regla de GV para esta cadena.

---

## 5. Código perdido en el refactor (`mejoras.pl`)

El commit `d0dcb74` implementó estas funcionalidades en `src/mejoras.pl`. El commit `ef13e0d` migró los archivos pero **no transfirió estas implementaciones** al nuevo `mejoras.pl`:

| Predicado | Descripción |
|-----------|-------------|
| `inflect/3` | Flexión morfológica: plurales (-ies/-es/-s), pasados (-ed), gerundios (-ing), 3ª pers., irregulares |
| `tokenize/2` | Tokenizador que separa puntuación como tokens individuales |
| `normalize/2` | Normalización a minúsculas sobre lista de tokens |
| `syntactic_function/3` | Identificación de roles sintácticos (sujeto, objeto, complemento) |
| `translation_note/2` | Notas de traducción para oraciones correctas (estaba en `deteccion.pl`) |

---

## 6. Bug en `mejoras.pl`

**`singular(behaviors, behavior)` duplicado** — declarado en las líneas 84 y 98.  
No causa error pero es código redundante.

---

## 7. Cobertura insuficiente del test suite (`tests/tests.pl`)

### 7.1 Sin tests de parsing para `oc`, `or`, `ocm`
- Solo se prueban las oraciones 1, 8, 13 y 29 (todas tipo `o`).
- Los 52 tests pasan, dando una falsa sensación de completitud cuando el 63% del corpus falla.

### 7.2 Sin tests para `simplificar/2`
- La función existe pero no tiene ningún test unitario.

### 7.3 `simplificar/2` no copia el sujeto compartido
- El enunciado exige: "JOSÉ come y bebe" → ["JOSÉ come", "JOSÉ bebe"] (sujeto replicado en cada cláusula).
- La implementación hace un split léxico puro. La segunda cláusula de o7 queda como `[laid, the, groundwork, ...]` sin el sujeto `planck`.

---

## 8. `CLAUDE.md` desactualizado

La tabla de estado del archivo marca como **Pending** los módulos `main.pl`, `semantico.pl`, `deteccion.pl`, `mejoras.pl` y `conjunto_oraciones.pl`. Todos están implementados.

---

## 9. Falta el `Informe.pdf` (requisito de entrega)

El enunciado especifica un zip con `Informe.pdf` de 15-20 páginas (portada, resumen, índice, desarrollo, resultados, conclusiones, bibliografía). No existe en el repositorio. **Fecha límite: 14 mayo 2026.**

---

## Resumen de prioridades

| # | Problema | Oraciones afectadas | Severidad |
|---|----------|---------------------|-----------|
| 1 | Reglas GV ausentes (§1.1–1.7) | o5, o7, o11, o18, o21, o23, o24, o26, o27, o30 | Crítica |
| 2 | `gadj(A, GI)` y `ginf(V, GP)` ausentes (§2.1–2.2) | o7, o21, o30 | Crítica |
| 3 | Correlativa `not only/but also` sin auxiliar (§2.3) | o7 | Crítica |
| 4 | `pron(this)` ausente en léxico (§3.1) | o30 | Crítica |
| 5 | `gn_coord` de 3+ elementos (§3.2) | o15, o16 | Crítica |
| 6 | CR anidada en GN (§3.3) | o10, o18 | Crítica |
| 7 | GN con participio parentético (§3.4) | o17, o23 | Alta |
| 8 | Regla `ocm` sin GNC (§3.5) | o27 | Alta |
| 9 | Construcciones específicas (§4) | o4, o12, o22, o25 | Alta |
| 10 | Código perdido en refactor (§5) | — | Alta |
| 11 | `simplificar` sin copia de sujeto (§7.3) | todas las coord. | Media |
| 12 | Tests sin cobertura oc/or/ocm (§7.1–7.2) | — | Media |
| 13 | `singular` duplicado (§6) | — | Baja |
| 14 | `CLAUDE.md` desactualizado (§8) | — | Baja |
| 15 | Informe PDF ausente (§9) | — | Crítica (entrega) |
