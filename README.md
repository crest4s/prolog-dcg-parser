# Analizador Sintáctico y Semántico en Prolog (DCG)

> Práctica 2 — Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26

---

## Descripción

Sistema de análisis sintáctico y semántico de oraciones en español implementado en **SWI-Prolog** mediante **Gramáticas de Cláusulas Definidas (DCG)**. El sistema parsea oraciones, genera árboles de constituyentes, enriquece el análisis con información semántica y detecta problemas de interpretación (ambigüedad léxica, incoherencia semántica y uso no literal).

El corpus de oraciones proviene de un dominio real específico (a definir por el grupo) debidamente referenciado.

---

## Arquitectura

```
prolog-dcg-parser/
│
├── src/                          # Código fuente Prolog
│   ├── main.pl                   # Punto de entrada; carga todos los módulos
│   ├── sintactico.pl             # Gramática DCG y árbol de constituyentes
│   ├── semantico.pl              # Hechos semánticos y categorías
│   ├── deteccion.pl              # Detección de ambigüedad, incoherencia y metáforas
│   ├── mejoras.pl                # Mejoras implementadas (tokenización, flexión, etc.)
│   ├── conjunto_oraciones.pl     # Corpus de ≥30 oraciones etiquetadas
│   └── draw.pl                   # Utilidad de visualización ASCII de árboles (M. Holcomb)
│
├── tests/                        # Pruebas y casos de validación
│
├── corpus/                       # Fuente de oraciones y referencias bibliográficas
│
├── docs/                         # Informe final (PDF) y documentación auxiliar
│
├── minutas/                      # Actas de progreso semanal (minutas 1–3)
│
├── .gitignore
├── .claudeignore
└── README.md
```

---

## Módulos

| Fichero | Responsabilidad |
|---|---|
| `main.pl` | Carga de módulos, predicados de entrada (`analizar/1`, `simplificar/1`) |
| `sintactico.pl` | Reglas DCG para o, oc, or, ocm · grupos gn, gv, gadj, gadv, gp · léxico (det, n, v, adj, adv, conj, prep) · simplificación de oraciones complejas |
| `semantico.pl` | Hechos `tipo/2` · asignación de categorías semánticas a palabras del corpus |
| `deteccion.pl` | Reglas para detectar ambigüedad léxica, incoherencia semántica y metáforas simples |
| `mejoras.pl` | Mejoras opcionales: preprocesamiento, flexión morfológica, asignación de funciones sintácticas, optimización, visualización extendida, análisis semántico avanzado |
| `conjunto_oraciones.pl` | Corpus ≥30 oraciones clasificadas como `correcta`, `ambigua` o `problematica` |
| `draw.pl` | Visualización ASCII de árboles de constituyentes (dominio público, Mark Holcomb) |

---

## Tipos sintácticos soportados

**Oraciones:** simple (`o`), coordinada (`oc`), subordinada de relativo (`or`), compuesta (`ocm`)

**Grupos:** nominal (`gn`), verbal (`gv`), adjetival (`gadj`), adverbial (`gadv`), preposicional (`gp`)

**Términos:** determinante (`det`), nombre (`n`), verbo (`v`), adjetivo (`adj`), adverbio (`adv`), conjunción (`conj`), preposición (`prep`)

---

## Uso rápido

```prolog
% Cargar el sistema
?- [src/main].

% Analizar una oración (lista de átomos)
?- analizar([el, banco, subio, los, tipos, de, interes]).

% Visualizar el árbol de constituyentes
?- analizar_arbol([el, banco, subio, los, tipos, de, interes], Arbol), draw(Arbol).

% Simplificar oración compuesta
?- simplificar([jose, estudia, filosofia, pero, maria, estudia, derecho], Simples).

% Detectar problemas semánticos
?- detectar([la, inflacion, come, los, ahorros]).
```

---

## Detección de problemas

| Tipo | Descripción | Ejemplo |
|---|---|---|
| Ambigüedad léxica | Palabra con múltiples significados en el dominio | *banco* → entidad financiera / objeto físico |
| Incoherencia semántica | Sujeto y predicado semánticamente incompatibles | *La inflación come los ahorros* |
| Uso no literal | Verbo empleado fuera de su contexto habitual (metáfora) | *El mercado se desplomó* |

---

## Mejoras implementadas

1. **Preprocesamiento** — tokenización y normalización del texto de entrada
2. **Flexión morfológica** — manejo de género, número y tiempos verbales
3. **Asignación de funciones** — identificación de CD, CI, CC, etc.

*(Se documentan en `mejoras.pl` y en el Informe)*

---

## Corpus

- **Dominio:** (a definir por el grupo)
- **Fuente:** (artículo / libro / prensa / informe — con referencia completa en `corpus/`)
- **Tamaño:** ≥ 30 oraciones (+ 5 por cada integrante adicional sobre 3)
- **Clasificación:** correcta · ambigua · problemática

---

## Entrega

| Elemento | Detalle |
|---|---|
| Plataforma | Campus Virtual UAH |
| Fecha límite | 14 de mayo de 2026 |
| Formato zip | `apellido1Apellido2Apellido3_PL2.zip` con los 7 ficheros `.pl` + `Informe.pdf` |
| Equipo | 3 integrantes · ≥ 3 mejoras implementadas |

---

## Requisitos

- [SWI-Prolog](https://www.swi-prolog.org/) >= 9.x

---

## Referencias

- Sintaxis española: https://sintaxis.org
- `draw.pl`: Mark Holcomb (dominio público)
- Fuente del corpus: *(completar con la referencia real del grupo)*
