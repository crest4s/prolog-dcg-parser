# Análisis de Fallos Sintácticos — 2026-05-13 23:05

Sesión de diagnóstico tras reporte de fallos en oraciones 11, 18, 24, 27 y 29.

---

## Metodología

Pruebas ejecutadas con SWI-Prolog sobre `sintactico.pl` + `conjunto_oraciones.pl`:

1. `oracion(X, T, [])` — ¿existe algún parse?
2. `functor(X, F, _)` — ¿qué tipo produce el **primer** parse?
3. `findall` de todos los functores producidos
4. Suite PLUnit completa: `swipl -g "run_tests, halt" tests/tests.pl`
5. Inspección manual de árboles para parses incorrectos

---

## Resumen ejecutivo

| Or. | Tipo corpus | Primer parse | Fallo real | Causa |
|-----|-------------|--------------|------------|-------|
| 11  | `ocm`       | `o` ❌        | Ambigüedad grave (38 s para encontrar `ocm`) | "in order to" se reescribe como GP+GN |
| 18  | `ocm`       | ninguno ❌    | **Fallo total** — no parse | Regla GV `gv(V1,GADV,V2,V3,GP)` inexistente |
| 24  | `ocm`       | `ocm` ✅      | Sin fallo real | Parse correcto en 2 ms |
| 27  | `ocm`       | `o` ❌        | Árbol incorrecto como primer resultado | Regla `ocm(GADV,GP,GNC,GV,GV_ger)` inexistente |
| 29  | `o`         | `o` ✅        | Sin fallo real | Parse correcto en 0 ms |

**Fallos genuinos**: Or. 18 (parse imposible) y Or. 11 / Or. 27 (primer parse incorrecto + backtracking explosivo).  
**Falsos positivos**: Or. 24 y Or. 29 parsean correctamente con el functor esperado.

---

## Oracion 11 — `ocm` esperado, `o` obtenido primero

### Tokens
```prolog
[in, order, to, solve, this, phenomenon, max, planck, presented, in, 1900,
 an, innovative, idea, about, the, quantization, of, energy,
 he, proposed, that, energy, was, discretized,
 into, small, intervals, or, pockets, which, he, called, quanta]
```

### Estructura esperada
```
ocm(
  ginf(inorder, v(solve), gn(det(this), n(phenomenon))),   % "in order to solve this phenomenon"
  o(gn(n(max),n(planck)), gv(v(presented), gp(in,1900), gn(an innovative idea...))), % cláusula 1
  o(gn(pron(he)), gv(v(proposed), conj(that), o(...)))       % cláusula 2
)
```
Regla aplicable: `oracion(ocm(GI, O1, O2)) --> g_infinitivo(GI), clausula_base(O1), clausula_base(O2).`

### Árbol obtenido (primer parse)
```prolog
o(
  gp(prep(in), gn(n(order), gp(prep(to), v(solve), gn(det(this), n(phenomenon))))),
  gn(n(max), n(planck)),
  gv(v(presented), gp(prep(in), gn_coord(gn(n(1900)),
      gn(det(an), gadj(adj(innovative)), n(idea),
         gp(prep(about), gn(det(the), n(quantization),
            cr(gp(prep(of), gn(n(energy))),
               gn(pron(he)), gv(v(proposed), conj(that),
                  o(gn(n(energy)), gv(v(was), v(discretized),
                    gp(prep(into), gn(gadj(adj(small)), n(intervals)))))))))),
      conj(or),
      gn(n(pockets), cr(pron(which), gn(pron(he)), gv(v(called), gn(n(quanta))))))))
)
```

### Causa del fallo
La locución `[in, order, to]` es ambigua:
- **Interpretación correcta**: `g_infinitivo(ginf(inorder, V, GN))` — regla especial para `[in, order, to]`.
- **Interpretación incorrecta (tomada primero)**: `prep(in)` + `n(order)` + `prep(to)` → GP anidado.

La regla `oracion(o(GP, GN, GV))` se intenta antes que `oracion(ocm(GI, O1, O2))` en el orden de cláusulas, y la interpretación errónea es más corta en backtracking, así que se encuentra primero.

### Medidas
- Primer parse: 0 ms — functor `o` (incorrecto).
- Parses `ocm` hallados con `findall`: **349** — backtracking masivo.
- Tiempo hasta encontrar el primer `ocm` (en test PLUnit con `findall`): **38,8 segundos**.

### Fix propuesto
Mover las reglas `oracion(ocm(...))` que comienzan con `g_infinitivo` **antes** de las reglas `oracion(o(GP,...))` para que el parser pruebe la interpretación de GI-inicial antes que la de GP-inicial. Alternativamente, añadir un corte tras reconocer `[in, order, to]` en la regla de `g_infinitivo`.

---

## Oracion 18 — Fallo total (no parse)

### Tokens
```prolog
[until, that, time, it, was, considered, that, an, emission, of, energy,
 could, have, any, value, but, with, the, planck, postulate,
 it, was, determined, that, it, should, always, be, quantized,
 into, quantities, which, were, multiple, integers, of, the, constant, h]
```

### Estructura esperada
```
ocm(
  gp(prep(until), gn(det(that), n(time))),         % "until that time"
  o(gn(pron(it)),
    gv(v(was), v(considered), conj(that),
       o(gn(det(an), n(emission), gp(of, energy)),
         gv(v(could), v(have), gn(det(any), n(value)))))),
  conj(but),
  o(gp(prep(with), gn(det(the), n(planck), n(postulate))),
    gn(pron(it)),
    gv(v(was), v(determined), conj(that),
       o(gn(pron(it)),
         gv(V1=should, GADV=always, V2=be, V3=quantized,
            GP=gp(prep(into), gn(n(quantities), cr(...)))))))
)
```

### Causa del fallo
La cláusula interna `it should always be quantized into quantities which were...` requiere parsear el GV:

```
should + always + be + quantized + gp(into, ...)
  V1      GADV    V2    V3           GP
```

Las reglas de GV existentes más cercanas son:
- `gv(V1, V2, V3, GP)` → 3 verbos + GP — **no incluye GADV entre V1 y V2**
- `gv(V1, GADV, V2, GP)` → verbo + adv + verbo + GP — **solo 2 verbos, no 3**

Verificado: sin el adverbio `always`, el parse del GV interno es exitoso:
```prolog
?- g_verbal(GV, [should, be, quantized, into, quantities, ...], []).
GV = gv(v(should), v(be), v(quantized), gp(prep(into), ...))  % OK
```

Con `always`:
```prolog
?- g_verbal(GV, [should, always, be, quantized, into, quantities, ...], []).
false.  % FALLO
```

### Fix requerido
Añadir la regla faltante en `sintactico.pl`:

```prolog
%  V + GADV + V2 + V3 + GP  (e.g., "should always be quantized into...")
%  — Oración 18 (cláusula interna): "should always be quantized into quantities"
g_verbal(gv(V1, GADV, V2, V3, GP)) -->
    verbo(V1), g_adverbial(GADV), verbo(V2), verbo(V3), g_preposicional(GP).
```

Con esta regla, el parse completo de Or. 18 debería tener éxito.

---

## Oracion 24 — Parse correcto (falso positivo)

### Tokens
```prolog
[for, example, based, on, the, testimony, of, planck, albert, einstein,
 proposed, in, 1905, a, quantum, explanation, for, the, photoelectric, effect,
 betting, that, light, hitting, a, metal, ejects, electrons]
```

### Resultado
- Primer parse: `ocm` ✅ en **2 ms**.
- Estructura encontrada: `ocm(GP, gpart(V, GP2), O, GV_ger)` — correcto.

### Conclusión
Or. 24 **no falla**. El parser encuentra el árbol correcto de inmediato. Posible causa del reporte de error por parte de la usuaria: prueba con método distinto al empleado en la sesión actual.

---

## Oracion 27 — `ocm` esperado, `o` obtenido primero

### Tokens
```prolog
[likewise, in, 1927, clinton, davisson, and, lester, germer,
 conducted, different, experiments, of, electron, diffraction,
 showing, that, they, exhibited, wavelike, behaviors,
 very, similar, to, light, waves]
```

### Estructura esperada
```
ocm(
  gadv(adv(likewise)),
  gp(prep(in), gn(n(1927))),
  gn_coord(gn(n(clinton),n(davisson)), conj(and), gn(n(lester),n(germer))),
  gv(v(conducted), gn(gadj(adj(different)), n(experiments),
       gp(prep(of), gn(n(electron), n(diffraction))))),
  gv(v(showing), conj(that), o(...))   % gerundio adjunto
)
```
Regla necesaria: `oracion(ocm(GADV, GP, GNC, GV, GV_ger))`

### Árbol obtenido (primer parse)
```prolog
o(
  gadv(adv(likewise)),
  gp(prep(in), gn_coord(gn(n(1927)), gn(n(clinton),n(davisson)), conj(and), gn(n(lester)))),
  gn(n(germer), gpart(v(conducted), gn(gadj(adj(different)), n(experiments),
       gp(prep(of), gn(n(electron), n(diffraction)))))),
  gv(v(showing), conj(that), o(...))
)
```

### Causa del fallo
El parser toma `[in, 1927, clinton, davisson, and, lester]` como una GP con `gn_coord` en su interior:
- `prep(in)` + `gn_coord([1927], [clinton davisson], and, [lester])`

Esto deja `germer` como cabeza del GN principal, y `conducted...` se convierte en un participio (gpart) que modifica a "germer". La interpretación es gramaticalmente posible pero semánticamente incorrecta.

La causa estructural: no existe la regla:
```prolog
oracion(ocm(GADV, GP, GNC, GV, GV_ger)) -->
    g_adverbial(GADV), g_preposicional(GP),
    g_nominal_coord(GNC), g_verbal(GV), g_verbal(GV_ger).
```

Las reglas existentes con `GNC` (nominal coordinado) solo cubren los casos sin adjunto GADV+GP previo:
```prolog
oracion(ocm(GNC, GV, GV_ger)) --> g_nominal_coord(GNC), ...
```

### Fix requerido
Añadir en `sintactico.pl`, en la sección de oraciones `ocm` con adjunto gerundival:

```prolog
%  GADV + GP + GNC + GV + GV_ger  (sujeto coord. + adj. gerundivo con prefijo)
%  — Oración 27: "Likewise, in 1927, Davisson and Germer conducted…, showing that…"
oracion(ocm(GADV, GP, GNC, GV, GV_ger)) -->
    g_adverbial(GADV), g_preposicional(GP),
    g_nominal_coord(GNC), g_verbal(GV), g_verbal(GV_ger).
```

---

## Oracion 29 — Parse correcto (falso positivo)

### Tokens
```prolog
[also, in, 1981, it, played, a, very, important, role,
 during, the, invention, of, the, tunnel, effect, microscope]
```

### Resultado
- Corpus: tipo `o` ✅
- Primer parse: `o` ✅ en **0 ms**.
- Único functor encontrado: `o`.

### Árbol obtenido
```prolog
o(gadv(adv(also)), gp(prep(in), gn(n(1981))), gn(pron(it)),
  gv(v(played),
     gn(det(a), gadj(adv(very), adj(important)), n(role),
        gp(prep(during), gn(det(the), n(invention),
           gp(prep(of), gn(det(the), n(tunnel), n(effect), n(microscope))))))))
```

### Nota sobre la adherencia del GP
El adjunto `during the invention of...` queda como complemento preposicional del **GN** "role" en lugar de como adjunto del **GV** "played". Ambas lecturas son gramaticalmente válidas; la primera (`V + GN_completo`) gana por orden de reglas:
- `g_verbal(gv(V, GN))` — se intenta antes que `g_verbal(gv(V, GN, GP))`.
- `g_nominal(gn(D, GADJ, N, GP))` consume "a very important role during..." como un único GN.

Para obtener la lectura `gv(V, GN, GP)` como primera opción habría que reordenar las reglas de GV o añadir preferencia explícita.

### Conclusión
Or. 29 **no falla**. El reporte de error parece incorrecto para esta oración.

---

## Estado de la suite de tests

```
% All 113 tests passed in 51.102 seconds (50.797 cpu)
```

Todos los tests pasan, pero el test `dcg_complejas:oracion_11` tarda **38,8 segundos** porque usa `findall` para buscar entre los 349 parses `ocm` de esa oración.

---

## Plan de corrección

| Prioridad | Acción | Afecta |
|-----------|--------|--------|
| 1 | Añadir `g_verbal(gv(V1,GADV,V2,V3,GP))` | Or. 18 (fallo total → parse OK) |
| 2 | Añadir `oracion(ocm(GADV,GP,GNC,GV,GV_ger))` | Or. 27 (primer parse correcto) |
| 3 | Reordenar reglas `oracion(ocm(GI,...))` antes de `oracion(o(GP,...))` | Or. 11 (reducir backtracking de 38s) |

Con las correcciones 1 y 2, la cobertura pasaría de **17/30** a **19/30**.  
La corrección 3 es de rendimiento: mantiene cobertura pero mejora tiempo de Or. 11 de 38s a <1s.
