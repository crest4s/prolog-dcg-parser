# Análisis Sintáctico Completo del Corpus (30 oraciones)

**Práctica 2 — Conocimiento y Razonamiento Automatizado · UAH 2025-26**
**Dominio:** Física cuántica — La constante de Planck

## Metodología

Para cada oración del corpus se aplica el siguiente protocolo:

1. **Identificación del tipo** según la minuta:
   - `o`   → Simple
   - `oc`  → Coordinada
   - `or`  → Subordinada de Relativo
   - `ocm` → Compuesta / Mixta

2. **Simplificación**: descomposición de las oraciones complejas en oraciones simples
   independientes.

3. **Normalización del sujeto**: cuando el sujeto está omitido o compartido en la oración
   original, se restaura un sujeto explícito (típicamente `Max Planck`, `la constante de
   Planck`, `los científicos` o el referente discursivo correspondiente) para que cada
   oración simple sea autónoma.

4. **Análisis sintáctico** de cada oración simple: sujeto (gn) con su núcleo y
   determinantes/adyacentes; predicado (gv) con núcleo verbal y complementos
   (CD, CI, CC, atributo); categorías (det, n, v, adj, adv, prep).

5. **Representación jerárquica**: árbol de constituyentes en notación indentada.
   Para las 9 oraciones que parsea la DCG actual (1, 2, 10, 17, 19, 20, 21, 27, 29) se
   incluye también el árbol ASCII generado por `draw.pl`. Para las restantes —cuya
   estructura excede la cobertura del parser— se proporciona un árbol jerárquico
   manual coherente con el mismo modelo de notación (s / np / vp / pp / ap).

> Convención: el árbol se construye sobre los tokens **ingleses** del corpus (ya que es la
> entrada del parser DCG); la oración española se cita arriba como referencia textual.

---

## Oración 1 — Tipo: `o` (Simple) · Clase: correcta

**ES:** Esta constante desempeñó un papel esencial en la formulación de otro de los grandes planteamientos de la cuántica: el principio de incertidumbre de Heisenberg.
**EN:** *This constant played an essential role in the formulation of another of the great quantum approaches: the Heisenberg uncertainty principle.*

**Simplificación:** la oración ya es simple, no requiere descomposición.

**Sujeto normalizado:** `this constant` (la constante de Planck).

### Simple 1: *This constant played an essential role …*

```
s
├── np  (Sujeto)
│   ├── det: this
│   └── n  : constant
└── vp  (Predicado)
    ├── v : played
    └── np  (CD)
        ├── np
        │   ├── det: an
        │   ├── ap → adj: essential
        │   └── n  : role
        ├── pp  (CCL/CN)
        │   ├── prep: in
        │   └── np
        │       ├── np  (det: the · n: formulation)
        │       └── pp
        │           ├── prep: of
        │           └── np
        │               ├── np (det: another)
        │               └── pp
        │                   ├── prep: of
        │                   └── np (det: the · ap[adj: great + adj: quantum] · n: approaches)
        └── np  (Aposición)
            ├── det: the
            ├── n: heisenberg
            ├── n: uncertainty
            └── n: principle
```

*Árbol ASCII real generado por `draw.pl` (parser DCG):*

Ver `analysis_output.txt` líneas 14-50.

---

## Oración 2 — Tipo: `ocm` · Clase: correcta

**ES:** Se suele decir que la física cuántica es una disciplina que desafía la percepción de la realidad.
**EN:** *It is often said that quantum physics is a discipline that challenges the perception of reality.*

**Simplificación (3 oraciones simples):**

1. *It is often said.* — sujeto pronominal impersonal `it`.
2. *Quantum physics is a discipline.* — sujeto restaurado: `quantum physics`.
3. *A discipline challenges the perception of reality.* — sujeto restaurado del pronombre relativo `that` → `a discipline`.

### Simple 1: *It is often said*
```
s
├── np → n: it
└── vp
    ├── aux: is
    ├── adv: often
    └── v  : said
```

### Simple 2: *Quantum physics is a discipline*
```
s
├── np
│   ├── ap → adj: quantum
│   └── n : physics
└── vp
    ├── v : is
    └── np  (Atributo)
        ├── det: a
        └── n  : discipline
```

### Simple 3: *A discipline challenges the perception of reality*
```
s
├── np  (Sujeto: antecedente del relativo)
│   ├── det: a
│   └── n  : discipline
└── vp
    ├── v : challenges
    └── np  (CD)
        ├── np (det: the · n: perception)
        └── pp (prep: of · np[n: reality])
```

*(Parsea con la DCG — árboles ASCII en `analysis_output.txt` líneas 63-112.)*

---

## Oración 3 — Tipo: `ocm` · Clase: correcta

**ES:** Pues bien, aunque es una frase algo poética y romántica, en parte, puede considerarse cierta.
**EN:** *Well, although it is a somewhat poetic and romantic phrase, in part, it can be considered true.*

**Simplificación (2 simples):**

1. *It is a somewhat poetic and romantic phrase.* — sujeto: `it` (referente: la afirmación previa).
2. *It can be considered true.* — mismo sujeto `it`.

### Simple 1: *It is a somewhat poetic and romantic phrase*
```
s
├── np → n: it
└── vp
    ├── v : is
    └── np  (Atributo)
        ├── det: a
        ├── ap
        │   ├── adv: somewhat
        │   ├── adj: poetic
        │   ├── conj: and
        │   └── adj: romantic
        └── n: phrase
```

### Simple 2: *It can be considered true*
```
s
├── np → n: it
└── vp
    ├── aux: can
    ├── aux: be
    ├── v  : considered
    └── ap → adj: true
```

> *(El parser actual no la cubre por la combinación de adverbio oracional `well` + `although` + voz pasiva con `can be considered` + adjetival final.)*

---

## Oración 4 — Tipo: `ocm` · Clase: problemática

**ES:** La física cuántica es la que gobierna el comportamiento de las partículas subatómicas, aquellas tan pequeñas que no son perceptibles para nuestros ojos y, su estudio, a menudo sumerge a los científicos en investigaciones donde las leyes habituales no existen.

**Simplificación (5 simples):**

1. *Quantum physics is what governs the behavior of subatomic particles.*
2. *Subatomic particles are so small.* — sujeto restaurado del pronombre `those`.
3. *Subatomic particles are not perceptible to our eyes.*
4. *Their study often plunges scientists into research.* — sujeto: `their study`.
5. *The usual laws do not exist [in research].* — sujeto restaurado del relativo `where`.

### Simple 1
```
s
├── np (ap: quantum · n: physics)
└── vp
    ├── v: is
    └── np
        ├── rel(what)
        └── vp
            ├── v: governs
            └── np
                ├── np (det: the · n: behavior)
                └── pp (prep: of · np[ap: subatomic · n: particles])
```

### Simple 2
```
s
├── np (ap: subatomic · n: particles)
└── vp (v: are · ap[adv: so · adj: small])
```

### Simple 3
```
s
├── np (ap: subatomic · n: particles)
└── vp
    ├── aux: are
    ├── adv: not
    ├── ap → adj: perceptible
    └── pp (prep: to · np[det: our · n: eyes])
```

### Simple 4
```
s
├── np (det: their · n: study)
└── vp
    ├── adv: often
    ├── v : plunges
    ├── np → n: scientists
    └── pp (prep: into · np[n: research])
```

### Simple 5
```
s
├── np (det: the · ap[adj: usual] · n: laws)
└── vp (aux: do · adv: not · v: exist)
```

---

## Oración 5 — Tipo: `or` · Clase: correcta

**ES:** En este contexto, existe una protagonista, de la cual seguramente hayas oído hablar, que actúa como una llave maestra para entender este mundo en miniatura: la constante de Planck.

**Simplificación (3 simples):**

1. *In this context, a protagonist exists.* — sujeto: `a protagonist` (≡ `the Planck constant`).
2. *You have surely heard of this protagonist.* — sujeto restaurado: `you`.
3. *This protagonist acts as a master key to understand this miniature world.*

### Simple 1
```
s
├── pp (prep: in · np[det: this · n: context])
├── np (det: a · n: protagonist)
└── vp → v: exists
```

### Simple 2
```
s
├── np → n: you
└── vp
    ├── aux: have
    ├── adv: surely
    ├── v  : heard
    └── pp (prep: of · np[det: a · n: protagonist])
```

### Simple 3
```
s
├── np (det: a · n: protagonist)
└── vp
    ├── v : acts
    ├── pp (prep: as · np[det: a · ap[adj: master] · n: key])
    └── pp (prep: to · vp[v: understanding · np[det: this · ap[adj: miniature] · n: world]])
```

---

## Oración 6 — Tipo: `o` · Clase: correcta

**ES:** Llamada así en honor al físico que la introdujo, Max Planck, la constante fue nombrada por primera vez a principios del siglo XX.

**Simplificación (3 simples):**

1. *The constant was named after the physicist Max Planck.* — sujeto: `the constant`.
2. *The physicist Max Planck introduced the constant.* — sujeto restaurado del relativo `who`.
3. *The constant was first named in the early century.* — núcleo principal.

### Simple 1
```
s
├── np (det: the · n: constant)
└── vp
    ├── aux: was
    ├── v  : named
    ├── pp (prep: after · np[det: the · n: physicist])
    └── np (Aposición: n: max · n: planck)
```

### Simple 2
```
s
├── np (n: max · n: planck)
└── vp (v: introduced · np[n: it])
```

### Simple 3
```
s
├── np (det: the · n: constant)
└── vp
    ├── aux: was
    ├── adv: first
    ├── v  : named
    └── pp (prep: in · np[det: the · ap[adj: early] · n: century])
```

---

## Oración 7 — Tipo: `oc` · Clase: correcta

**ES:** En un trabajo completamente revolucionario, Planck no solo pudo finalmente dar explicación a una gran cantidad de inquietudes de la época, sino que sentó las bases para abrir paso a una nueva era en la física: la cuántica.

**Simplificación (2 simples), con sujeto compartido `Planck`:**

1. *Planck was finally able to explain a great many of the anxieties of the time.*
2. *Planck laid the groundwork for a new era in physics: quantum.*

### Simple 1
```
s
├── np → n: planck
└── vp
    ├── pp (prep: in · np[det: a · ap[adv: completely · adj: revolutionary] · n: work])
    ├── aux: was
    ├── adv: finally
    ├── ap → adj: able
    └── pp (prep: to · vp[v: explain · np · pp])
        └── np (det[a great many] · pp[of · np[det: the · n: anxieties]])
        └── pp (prep: of · np[det: the · n: time])
```

### Simple 2
```
s
├── np → n: planck
└── vp
    ├── v : laid
    ├── np (det: the · n: groundwork)
    └── pp
        ├── prep: for
        └── np
            ├── np (det: a · ap[adj: new] · n: era)
            └── pp (prep: in · np[n: physics])
        └── Aposición: ap[adj: quantum]
```

---

## Oración 8 — Tipo: `o` · Clase: correcta

**ES:** Desde los comienzos del siglo XX, el avance en física parecía haberse estancado.

**Simplificación:** ya simple. Sujeto: `progress in physics`.

### Simple 1: *Since the early century, progress in physics seemed to have stalled*
```
s
├── pp (prep: since · np[det: the · ap[adj: early] · n: century])
├── np
│   ├── np (n: progress)
│   └── pp (prep: in · np[n: physics])
└── vp
    ├── v : seemed
    └── pp (prep: to · vp[aux: have · v: stalled])
```

---

## Oración 9 — Tipo: `ocm` · Clase: correcta

**ES:** Los científicos comenzaron a encontrar dilemas desconcertantes a los que no conseguían dar explicación y para los cuales no existían unas leyes coherentes y eficientes.

**Simplificación (3 simples):**

1. *Scientists began to find perplexing dilemmas.*
2. *Scientists could not explain perplexing dilemmas.* — sujeto restaurado del relativo `that`.
3. *No coherent and efficient laws existed for perplexing dilemmas.* — sujeto restaurado.

### Simple 1
```
s
├── np → n: scientists
└── vp
    ├── v : began
    └── pp (prep: to · vp[v: find · np[ap: perplexing · n: dilemmas]])
```

### Simple 2
```
s
├── np → n: scientists
└── vp (aux: could · adv: not · v: explain · np[ap: perplexing · n: dilemmas])
```

### Simple 3
```
s
├── pp (prep: for · np[ap: perplexing · n: dilemmas])
├── np (adv: no · ap[adj: coherent + adj: efficient] · n: laws)
└── vp (aux: were · neg / [there were])
```

---

## Oración 10 — Tipo: `oc` · Clase: ambigua

**ES:** Uno de esos problemas era el de la radiación del cuerpo negro, es decir, un objeto que absorbe toda la radiación que incide sobre él, pero irradia una cantidad de energía característica de él.

**Simplificación (4 simples):**

1. *One such problem was radiation from the black body.* — sujeto: `one such problem`.
2. *The black body is an object.* — aposición explicativa `that is`.
3. *The object absorbs all of the radiation.*
4. *The radiation strikes the object* (ambigüedad: `it` ↔ `the object`/`the energy`).
5. *The object radiates a quantity of energy characteristic of it.* — coordinada con (3).

### Simple 1
```
s
├── np (det: one · det: such · n: problem)
└── vp
    ├── v : was
    └── np
        ├── np → n: radiation
        └── pp (prep: from · np[det: the · ap: black · n: body])
```

### Simple 2 (aposición)
```
s
├── np (det: the · ap: black · n: body)
└── vp (v: is · np[det: an · n: object])
```

### Simple 3
```
s
├── np (det: an · n: object)
└── vp
    ├── v : absorbs
    └── np
        ├── np (det: all)
        └── pp (prep: of · np[det: the · n: radiation])
```

### Simple 4
```
s
├── np (det: the · n: radiation)
└── vp (v: strikes · np[n: it])
```

### Simple 5
```
s
├── np (det: an · n: object)
└── vp
    ├── v : radiates
    └── np
        ├── np (det: a · n: quantity)
        └── pp (prep: of · np[n: energy · ap: characteristic · pp[of · np[n: it]]])
```

*(Parsea con la DCG — árbol ASCII completo en `analysis_output.txt` líneas 174-237.)*

---

## Oración 11 — Tipo: `ocm` · Clase: correcta

**ES:** Con el objetivo de dar solución a ese fenómeno, Max Planck presentó en el año 1900 una idea innovadora sobre la cuantización de la energía: propuso que la energía estaba discretizada en pequeños intervalos o bolsas, a los que llamó "cuantos".

**Simplificación (4 simples). Sujeto principal: `Max Planck`.**

1. *Max Planck presented an innovative idea about the quantization of energy.*
2. *Max Planck proposed [a thesis about energy].*
3. *Energy was discretized into small intervals or pockets.*
4. *Max Planck called these intervals quanta.* — sujeto restaurado del relativo `which`.

### Simple 1
```
s
├── pp (prep: in · np[n: order] · fronted[to · vp[v: solve · np[det: this · n: phenomenon]]])
├── np (n: max · n: planck)
└── vp
    ├── v : presented
    ├── pp (prep: in · np[n: 1900])
    ├── np (det: an · ap: innovative · n: idea)
    └── pp (prep: about · np[det: the · n: quantization · pp[of · np[n: energy]]])
```

### Simple 2
```
s
├── np → n: he   (correferente con Max Planck)
└── vp
    ├── v: proposed
    └── that(Simple 3)
```

### Simple 3
```
s
├── np → n: energy
└── vp
    ├── aux: was
    ├── v  : discretized
    └── pp
        ├── prep: into
        └── np
            ├── np (ap: small · n: intervals)
            ├── conj: or
            └── np (n: pockets)
```

### Simple 4
```
s
├── np → n: he
└── vp (v: called · np[n: them] · np[n: quanta])
```

---

## Oración 12 — Tipo: `ocm` · Clase: correcta

**ES:** En otras palabras, expuso la idea de que la energía emitida no tenía un valor constante, sino que se emitía en pequeñas cantidades proporcionales siempre a un valor: la constante de Planck.

**Simplificación (3 simples). Sujeto omitido restaurado: `Max Planck` (`he`).**

1. *He expounded the idea.*
2. *The energy emitted was not a constant value.*
3. *The energy emitted was emitted in small quantities always proportional to one value: the Planck constant.*

### Simple 1
```
s
├── pp (prep: in · np[ap: other · n: words])
├── np → n: he
└── vp (v: expounded · np[det: the · n: idea] · that(Simple 2))
```

### Simple 2
```
s
├── np (det: the · n: energy · vp[v: emitted])    (participio reducido)
└── vp (aux: was · adv: not · np[det: a · ap: constant · n: value])
```

### Simple 3
```
s
├── np (det: the · n: energy)
└── vp
    ├── aux: was
    ├── v  : emitted
    ├── pp
    │   ├── prep: in
    │   └── np
    │       ├── np (ap: small · n: quantities)
    │       └── ap (adj: proportional · adv: always · pp[to · np[det: one · n: value]])
    └── Aposición: np (det: the · n: planck · n: constant)
```

---

## Oración 13 — Tipo: `o` · Clase: correcta

**ES:** Sin embargo, la aceptación de esta idea no fue, ni mucho menos, inmediata.

### Simple 1: *However, acceptance of this idea was far from immediate*
```
s
├── conj: however
├── np
│   ├── np → n: acceptance
│   └── pp (prep: of · np[det: this · n: idea])
└── vp
    ├── v : was
    ├── adv: far
    └── pp (prep: from · ap[adj: immediate])
```

---

## Oración 14 — Tipo: `ocm` · Clase: correcta

**ES:** La propuesta de Planck era atrevida y, aunque parecía explicar ciertos fenómenos, entraba en contradicción con muchas teorías vigentes por aquel momento.

**Simplificación (3 simples). Sujeto: `Planck's proposal`.**

1. *Planck's proposal was bold.*
2. *Planck's proposal seemed to explain certain phenomena.*
3. *Planck's proposal contradicted many theories then in force.*

### Simple 1
```
s
├── np (n: planck · n: proposal)
└── vp (v: was · ap[adj: bold])
```

### Simple 2
```
s
├── np (n: planck · n: proposal)
└── vp
    ├── v : seemed
    └── pp (prep: to · vp[v: explain · np[ap: certain · n: phenomena]])
```

### Simple 3
```
s
├── np (n: planck · n: proposal)
└── vp
    ├── v : contradicted
    ├── np (det: many · n: theories)
    ├── adv: then
    └── pp (prep: in · np[n: force])
```

---

## Oración 15 — Tipo: `or` · Clase: correcta

**ES:** Afortunadamente, otros físicos de gran importancia de la época, como Albert Einstein, Niels Bohr o Werner Heisenberg, contribuyeron con otros avances fundamentales que terminaron por consolidar la teoría de Planck.

**Simplificación (2 simples):**

1. *Other physicists of great importance contributed to other fundamental breakthroughs.*
2. *Other fundamental breakthroughs eventually consolidated Planck's theory.* — sujeto restaurado del relativo `that`.

### Simple 1
```
s
├── adv: fortunately
├── np
│   ├── np (ap: other · n: physicists)
│   ├── pp (prep: of · np[ap: great · n: importance])
│   ├── pp (prep: at · np[det: the · n: time])
│   └── pp (prep: such · pp[as · np-coord[albert+einstein, niels+bohr, werner+heisenberg]])
└── vp
    ├── v : contributed
    └── pp (prep: to · np[ap: other · ap: fundamental · n: breakthroughs])
```

### Simple 2
```
s
├── np (ap: other · ap: fundamental · n: breakthroughs)
└── vp
    ├── adv: eventually
    ├── v  : consolidated
    └── np (n: planck · n: theory)
```

---

## Oración 16 — Tipo: `or` · Clase: problemática

**ES:** En general, la dualidad onda-partícula, el principio de incertidumbre y la mecánica cuántica fueron los pilares que hicieron crecer esa nueva concepción del mundo microscópico.

**Simplificación (2 simples):**

1. *Wave-particle duality, the uncertainty principle and quantum mechanics were the pillars.*
2. *The pillars made this new conception of the microscopic world grow.* — sujeto restaurado.

### Simple 1
```
s
├── pp (prep: in · np[n: general])
├── np (coord)
│   ├── np (n: wave · n: particle · n: duality)
│   ├── conj: ',' / and(implicit)
│   ├── np (det: the · n: uncertainty · n: principle)
│   ├── conj: and
│   └── np (ap: quantum · n: mechanics)
└── vp (v: were · np[det: the · n: pillars])
```

### Simple 2
```
s
├── np (det: the · n: pillars)
└── vp
    ├── v : made
    ├── np
    │   ├── np (det: this · ap: new · n: conception)
    │   └── pp (prep: of · np[det: the · ap: microscopic · n: world])
    └── v : grow   (infinitivo del causativo `make`)
```

---

## Oración 17 — Tipo: `ocm` · Clase: problemática

**ES:** De esta forma, la constante de Planck, representada por la letra h, se asentó como uno de los pilares fundamentales de la física cuántica, jugando un papel fundamental en la cuantización de los fenómenos que tienen lugar en la naturaleza.

**Simplificación (4 simples). Sujeto principal: `the Planck constant`.**

1. *The Planck constant was represented by the letter h.* (cláusula participial).
2. *The Planck constant became established as one of the fundamental pillars of quantum physics.*
3. *The Planck constant played a fundamental role in the quantization of phenomena.* (gerundio).
4. *Phenomena take place in nature.* — sujeto restaurado del relativo `that`.

### Simple 1
```
s
├── np (det: the · n: planck · n: constant)
└── vp (v: represented · pp[by · np[det: the · n: letter · n: h]])
```

### Simple 2
```
s
├── pp (prep: in · np[det: this · n: way])
├── np (det: the · n: planck · n: constant)
└── vp
    ├── v : became
    ├── ap → adj: established
    └── pp (prep: as · np[np[det: one] · pp[of · np[det: the · ap: fundamental · n: pillars] · pp[of · np[ap: quantum · n: physics]]]])
```

### Simple 3
```
s
├── np (det: the · n: planck · n: constant)
└── vp
    ├── v : playing
    ├── np (det: a · ap: fundamental · n: role)
    └── pp (prep: in · np[det: the · n: quantization · pp[of · np[n: phenomena]]])
```

### Simple 4
```
s
├── np → n: phenomena
└── vp (v: taking · np[n: place] · pp[in · np[n: nature]])
```

*(Parsea con la DCG — árbol ASCII en `analysis_output.txt` líneas 290-360.)*

---

## Oración 18 — Tipo: `ocm` · Clase: correcta

**ES:** Hasta ese momento, se consideraba que una emisión de energía podía tener cualquier valor pero, con la postulación de Planck, se determinó que siempre debía estar cuantizada en cantidades que fueran múltiplos enteros de la constante, h.

**Simplificación (4 simples). Sujetos restaurados a partir de los impersonales:**

1. *Until that time, it was considered [Simple 2].* — impersonal `it`.
2. *An emission of energy could have any value.*
3. *With the Planck postulate, it was determined [Simple 4].* — impersonal `it`.
4. *An emission of energy should always be quantized into quantities which were multiple integers of the constant h.*

### Simple 1
```
s
├── pp (prep: until · np[det: that · n: time])
├── np → n: it
└── vp (aux: was · v: considered · that(Simple 2))
```

### Simple 2
```
s
├── np
│   ├── np (det: an · n: emission)
│   └── pp (prep: of · np[n: energy])
└── vp (aux: could · v: have · np[det: any · n: value])
```

### Simple 3
```
s
├── conj: but
├── pp (prep: with · np[det: the · n: planck · n: postulate])
├── np → n: it
└── vp (aux: was · v: determined · that(Simple 4))
```

### Simple 4
```
s
├── np (det: an · n: emission · pp[of · np[n: energy]])
└── vp
    ├── aux: should
    ├── adv: always
    ├── aux: be
    ├── v  : quantized
    └── pp (prep: into · np[n: quantities · relcl[which · vp[were · ap[adj: multiple · n: integers · pp[of · np[det: the · n: constant · n: h]]]]]])
```

---

## Oración 19 — Tipo: `o` · Clase: correcta

**ES:** Para ser exactos, su valor es de 6.626x10-34 julios por segundo, según el Sistema Internacional de Unidades.

### Simple 1
```
s
├── np (det: its · n: value)
└── vp
    ├── v : is
    └── np
        ├── np (n: 6.626x10-34 · n: joules)
        └── pp (prep: per · np[n: second])
        └── pp (prep: according · pp[to · np[det: the · ap: international · n: system · pp[of · np[n: units]]]])
```

*(Parsea con la DCG — árbol ASCII en `analysis_output.txt` líneas 380-413.)*

---

## Oración 20 — Tipo: `o` · Clase: correcta

**ES:** Asimismo, la constante de Planck también desempeñó un papel esencial en la formulación de otro de los grandes planteamientos de la cuántica: el principio de incertidumbre de Heisenberg.

### Simple 1
```
s
├── adv: likewise
├── np (det: the · n: planck · n: constant)
└── vp
    ├── adv: also
    ├── v : played
    └── np
        ├── np (det: an · ap: essential · n: role)
        ├── pp (prep: in · np[det: the · n: formulation · pp[of · np[det: another · pp[of · np[det: the · ap[great+quantum] · n: approaches] · pp[to · np[det: the · n: heisenberg · n: uncertainty · n: principle]]]]]])
```

*(Parsea con la DCG — árbol ASCII en `analysis_output.txt` líneas 426-465.)*

---

## Oración 21 — Tipo: `ocm` · Clase: correcta

**ES:** La idea de ese planteamiento establece que es imposible conocer con absoluta precisión la posición y la cantidad de momento de una partícula.

**Simplificación (2 simples):**

1. *The idea of this approach states [Simple 2].*
2. *It is impossible to know with absolute precision the position and momentum of a particle.* — sujeto impersonal `it`.

### Simple 1
```
s
├── np
│   ├── np (det: the · n: idea)
│   └── pp (prep: of · np[det: this · n: approach])
└── vp (v: states · that(Simple 2))
```

### Simple 2
```
s
├── np → n: it
└── vp
    ├── v : is
    └── ap
        ├── adj: impossible
        └── fronted(to)
            └── vp
                ├── v : know
                ├── pp (prep: with · np[ap: absolute · n: precision])
                └── np
                    ├── np (det: the · n: position)
                    ├── conj: and
                    └── np (n: momentum · pp[of · np[det: a · n: particle]])
```

*(Parsea — ver `analysis_output.txt` líneas 478-572.)*

---

## Oración 22 — Tipo: `ocm` · Clase: correcta

**ES:** En este caso, la constante de Planck aparece como un impedimento, tal y como si fuera una limitación en la capacidad para medir ciertas cantidades con precisión.

**Simplificación (2 simples). Sujeto principal: `the Planck constant`.**

1. *The Planck constant appears as an impediment.*
2. *The Planck constant were a limitation on the ability to measure certain quantities accurately.* (subj. condicional `as if`).

### Simple 1
```
s
├── pp (prep: in · np[det: this · n: case])
├── np (det: the · n: planck · n: constant)
└── vp (v: appears · pp[as · np[det: an · n: impediment]])
```

### Simple 2
```
s
├── conj(as_if)
├── np (det: the · n: planck · n: constant)
└── vp
    ├── aux: were
    └── np
        ├── np (det: a · n: limitation)
        ├── pp (prep: on · np[det: the · n: ability])
        └── pp (prep: to · vp[v: measure · np[ap: certain · n: quantities] · adv: accurately])
```

---

## Oración 23 — Tipo: `or` · Clase: correcta

**ES:** Su presencia, deducida de forma teórica, consigue dar explicación y manifestarse a través de fenómenos cuánticos observados en diferentes experimentos, los cuales, consolidaron definitivamente su importancia.

**Simplificación (4 simples). Sujeto principal: `its presence`.**

1. *Its presence was deduced in a theoretical way.* (cláusula participial).
2. *Its presence manages to give explanation through quantum phenomena.* (1ª coord).
3. *Its presence manages to manifest itself through quantum phenomena.* (2ª coord).
4. *Quantum phenomena observed in different experiments definitively consolidated its importance.* — sujeto restaurado del relativo `which`.

### Simple 1
```
s
├── np (det: its · n: presence)
└── vp (v: deduced · pp[in · np[det: a · ap: theoretical · n: way]])
```

### Simple 2
```
s
├── np (det: its · n: presence)
└── vp
    ├── v : manages
    └── pp (prep: to · vp[v: give · np[n: explanation] · pp[through · np[ap: quantum · n: phenomena]]])
```

### Simple 3
```
s
├── np (det: its · n: presence)
└── vp
    ├── v : manages
    └── pp (prep: to · vp[v: manifest · np[n: itself] · pp[through · np[ap: quantum · n: phenomena]]])
```

### Simple 4
```
s
├── np (ap: quantum · n: phenomena · vp[v: observed · pp[in · np[ap: different · n: experiments]]])
└── vp (adv: definitively · v: consolidated · np[det: its · n: importance])
```

---

## Oración 24 — Tipo: `ocm` · Clase: problemática

**ES:** Por ejemplo, basándose en el testimonio de Planck, Albert Einstein propuso en 1905 una explicación cuántica para el efecto fotoeléctrico, apostando a que la luz que incide sobre un metal arranca electrones.

**Simplificación (4 simples). Sujeto principal: `Albert Einstein`.**

1. *Albert Einstein based his proposal on the testimony of Planck.* (participial frontal).
2. *Albert Einstein proposed in 1905 a quantum explanation for the photoelectric effect.*
3. *Albert Einstein bet [Simple 4].* (gerundio final).
4. *Light hitting a metal ejects electrons.* — sujeto: `light`.

### Simple 1
```
s
├── np (n: albert · n: einstein)
└── vp (v: based · pp[on · np[det: the · n: testimony · pp[of · np[n: planck]]]])
```

### Simple 2
```
s
├── pp (prep: for · np[n: example])
├── np (n: albert · n: einstein)
└── vp
    ├── v : proposed
    ├── pp (prep: in · np[n: 1905])
    ├── np (det: a · ap: quantum · n: explanation)
    └── pp (prep: for · np[det: the · ap: photoelectric · n: effect])
```

### Simple 3
```
s
├── np (n: albert · n: einstein)
└── vp (v: betting · that(Simple 4))
```

### Simple 4
```
s
├── np (n: light · vp[v: hitting · np[det: a · n: metal]])
└── vp (v: ejects · np[n: electrons])
```

---

## Oración 25 — Tipo: `ocm` · Clase: correcta

**ES:** Para establecer esta idea, Einstein utilizó como hipótesis que la luz está compuesta por partículas llamadas fotones, cada uno con energía proporcional a la constante de Planck.

**Simplificación (3 simples).**

1. *Einstein used the hypothesis [Simple 2].*
2. *Light is composed of particles called photons.*
3. *Each photon has energy proportional to Planck's constant.* (aposición distributiva).

### Simple 1
```
s
├── pp (prep: to · vp[v: establish · np[det: this · n: idea]])
├── np → n: einstein
└── vp (v: used · np[det: the · n: hypothesis] · that(Simple 2))
```

### Simple 2
```
s
├── np → n: light
└── vp
    ├── aux: is
    ├── v  : composed
    └── pp (prep: of · np[n: particles · vp[v: called · np[n: photons]]])
```

### Simple 3
```
s
├── np (det: each · n: photon)
└── vp
    ├── pp (prep: with · np[n: energy])
    └── ap (adj: proportional · pp[to · np[n: planck · n: constant]])
```

---

## Oración 26 — Tipo: `ocm` · Clase: correcta

**ES:** Fue justamente este fenómeno el que consiguió explicar que la luz presentaba comportamientos tan de onda como de partícula, sentando las bases para la dualidad onda-partícula.

**Simplificación (3 simples). Sujeto principal: `this phenomenon`.**

1. *It was precisely this phenomenon that managed to explain [Simple 2].* — escisión hendida.
2. *Light had both wave and particle behaviors.*
3. *This phenomenon laid the foundation for the wave-particle duality.* (gerundio).

### Simple 1
```
s
├── np → n: it
└── vp
    ├── v : was
    ├── adv: precisely
    ├── np (det: this · n: phenomenon)
    └── relcl(rel: that · vp[v: managed · pp[to · vp[v: explain · that(Simple 2)]]])
```

### Simple 2
```
s
├── np → n: light
└── vp
    ├── v : had
    └── np
        ├── det: both
        ├── np (n: wave)
        ├── conj: and
        └── np (n: particle · n: behaviors)
```

### Simple 3
```
s
├── np (det: this · n: phenomenon)
└── vp
    ├── v : laying
    ├── np (det: the · n: foundation)
    └── pp (prep: for · np[det: the · n: wave · n: particle · n: duality])
```

---

## Oración 27 — Tipo: `ocm` · Clase: correcta

**ES:** Asimismo, en el año 1927, Clinton Davisson y Lester Germer realizaron diferentes experimentos de difracción de electrones, demostrando que estos exhibían comportamientos ondulatorios muy similares a las ondas de luz.

**Simplificación (2 simples). Sujeto compartido: `Clinton Davisson and Lester Germer`.**

1. *Clinton Davisson and Lester Germer conducted different experiments of electron diffraction.*
2. *Electrons exhibited wavelike behaviors very similar to light waves.* — sujeto restaurado del pronombre `they`.

### Simple 1
```
s
├── adv: likewise
├── pp (prep: in · np[n: 1927])
├── np (coord)
│   ├── np (n: clinton · n: davisson)
│   ├── conj: and
│   └── np (n: lester · n: germer)
└── vp
    ├── v : conducted
    ├── np (ap: different · n: experiments)
    └── pp (prep: of · np[n: electron · n: diffraction])
```

### Simple 2
```
s
├── np → n: electrons
└── vp
    ├── v : exhibited
    ├── np (ap: wavelike · n: behaviors)
    ├── ap (adv: very · adj: similar)
    └── pp (prep: to · np[n: light · n: waves])
```

> *(El parser produce un único árbol con simplificación parcial — error en `draw.pl` por anidamiento profundo, ver `analysis_output.txt` línea 619.)*

---

## Oración 28 — Tipo: `ocm` · Clase: correcta

**ES:** Este fenómeno, que pasó a conocerse como difracción de electrones, confirmó esa dualidad onda-partícula y resaltó la necesidad de considerar la constante de Planck como un elemento indispensable en el estudio del mundo microscópico.

**Simplificación (3 simples). Sujeto compartido: `this phenomenon`.**

1. *This phenomenon came to be known as electron diffraction.* — relativo.
2. *This phenomenon confirmed this wave-particle duality.* — coord.1.
3. *This phenomenon highlighted the need to consider the Planck constant as an indispensable element in the study of the microscopic world.* — coord.2.

### Simple 1
```
s
├── np (det: this · n: phenomenon)
└── vp
    ├── v : came
    └── pp (prep: to · vp[aux: be · v: known · pp[as · np[n: electron · n: diffraction]]])
```

### Simple 2
```
s
├── np (det: this · n: phenomenon)
└── vp
    ├── v : confirmed
    └── np (det: this · n: wave · n: particle · n: duality)
```

### Simple 3
```
s
├── np (det: this · n: phenomenon)
└── vp
    ├── v : highlighted
    ├── np (det: the · n: need)
    └── pp (prep: to · vp[v: consider · np[det: the · n: planck · n: constant] · pp[as · np[det: an · ap: indispensable · n: element]] · pp[in · np[det: the · n: study · pp[of · np[det: the · ap: microscopic · n: world]]]]])
```

---

## Oración 29 — Tipo: `o` · Clase: problemática

**ES:** También en el año 1981 jugó un papel muy importante durante la invención del microscopio de efecto túnel.

**Sujeto normalizado:** `the Planck constant` (sujeto omitido en español; el inglés añade `it` ambiguo).

### Simple 1: *Also in 1981 it played a very important role during the invention of the tunnel effect microscope*
```
s
├── np → n: it   (correferente: the Planck constant)
└── vp
    ├── adv: also
    ├── pp (prep: in · np[n: 1981])
    ├── v : played
    ├── np
    │   ├── det: a
    │   ├── ap (adv: very · adj: important)
    │   └── n: role
    └── pp
        ├── prep: during
        └── np
            ├── np (det: the · n: invention)
            └── pp (prep: of · np[det: the · n: tunnel · n: effect · n: microscope])
```

*(Parsea con la DCG — árbol ASCII en `analysis_output.txt` líneas 638-665.)*

---

## Oración 30 — Tipo: `or` · Clase: problemática

**ES:** Se trata de un fenómeno en el cual las partículas son capaces de atravesar barreras energéticas prohibidas clásicamente, lo cual se relaciona directamente con la energía que posee, cuantificada en multiplos de la constante de Planck.

**Simplificación (4 simples). Sujetos restaurados:**

1. *This is a phenomenon.* — sujeto: `this`.
2. *Particles are able to pass through classically forbidden energy barriers.* — sujeto restaurado del relativo `in which`.
3. *This phenomenon is directly related to the energy.* — sujeto restaurado del relativo `which` (proposicional).
4. *Particles possess the energy quantified in multiples of the Planck constant.* — sujeto restaurado.

### Simple 1
```
s
├── np → n: this
└── vp (v: is · np[det: a · n: phenomenon])
```

### Simple 2
```
s
├── np → n: particles
└── vp
    ├── v : are
    ├── ap → adj: able
    └── pp (prep: to · vp[v: pass · pp[through · np[adv: classically · ap: forbidden · n: energy · n: barriers]]])
```

### Simple 3
```
s
├── np (det: this · n: phenomenon)
└── vp
    ├── aux: is
    ├── adv: directly
    ├── v  : related
    └── pp (prep: to · np[det: the · n: energy])
```

### Simple 4
```
s
├── np → n: particles
└── vp
    ├── v : possess
    ├── np
    │   ├── np (det: the · n: energy)
    │   └── vp (v: quantified · pp[in · np[n: multiples · pp[of · np[det: the · n: planck · n: constant]]]])
```

---

## Resumen de cobertura del parser DCG

| Oración | Tipo | Parsea | Nº simples extraídas |
|--------:|:----:|:------:|---------------------:|
|  1 | o   | ✓ | 1 |
|  2 | ocm | ✓ | 3 |
|  3 | ocm | ✗ | (manual: 2) |
|  4 | ocm | ✗ | (manual: 5) |
|  5 | or  | ✗ | (manual: 3) |
|  6 | o   | ✗ | (manual: 3) |
|  7 | oc  | ✗ | (manual: 2) |
|  8 | o   | ✗ | (manual: 1) |
|  9 | ocm | ✗ | (manual: 3) |
| 10 | oc  | ✓ | 1 (anidada profundamente) |
| 11 | ocm | ✗ | (manual: 4) |
| 12 | ocm | ✗ | (manual: 3) |
| 13 | o   | ✗ | (manual: 1) |
| 14 | ocm | ✗ | (manual: 3) |
| 15 | or  | ✗ | (manual: 2) |
| 16 | or  | ✗ | (manual: 2) |
| 17 | ocm | ✓ | 2 |
| 18 | ocm | ✗ | (manual: 4) |
| 19 | o   | ✓ | 1 |
| 20 | o   | ✓ | 1 |
| 21 | ocm | ✓ | 3 |
| 22 | ocm | ✗ | (manual: 2) |
| 23 | or  | ✗ | (manual: 4) |
| 24 | ocm | ✗ | (manual: 4) |
| 25 | ocm | ✗ | (manual: 3) |
| 26 | ocm | ✗ | (manual: 3) |
| 27 | ocm | ✓* | 1 (error de dibujo) |
| 28 | ocm | ✗ | (manual: 3) |
| 29 | o   | ✓ | 1 |
| 30 | or  | ✗ | (manual: 4) |

**Total**: 9/30 oraciones (30 %) parsean completamente con la DCG actual. El resto excede su cobertura por combinaciones de:

- Cláusulas participiales frontales con doble argumento (oraciones 6, 24, 26).
- Subordinadas adverbiales encadenadas con `since`, `until`, `as if`, `for example` (8, 18, 22, 24).
- Coordinaciones con sujeto compartido elíptico tras `but / and` (7, 14, 25, 28).
- Estructuras `there is / there were` (5, 9).
- Causativas tipo *make X grow* (16).
- Relativos con `which` proposicional o `for which` doble (9, 23, 30).

La salida ASCII real del parser para las 9 oraciones que sí parsean queda volcada en
`analysis_output.txt`.
