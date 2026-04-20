## 1

Realizado por: Prof. Alvaro Olmedo

# ANÁLISIS SINTÁCTICO Y SEMÁNTICO DE ORACIONES

# EN CONTEXTOS REALES

```
Práctica 2: Conocimiento y Razonamiento Automatizado
(Adaptado para la asignatura de Conocimiento y Razonamiento Automatizado, Curso 2025-26)
```
**1. Objetivos**
    - Construir una Gramática de Cláusulas Definidas (DCG) en Prolog para analizar
       sintácticamente oraciones.
    - Generar árboles de constituyentes a partir de oraciones reales.
    - Incorporar información semántica básica asociada a palabras del contexto.
    - Detectar posibles problemas de interpretación en oraciones:
       o Ambigüedad léxica
       o Incoherencia semántica
       o Uso no literal (metáforas simples)

```
Nota: “El análisis sintáctico y semántico se realizará en un único idioma (preferentemente
español)”
```
**2. Práctica a Entregar**

```
2.1 Análisis Sintáctico
La práctica consistirá en la creación de una gramática que valide y represente el árbol de
constituyentes, así como en la simplificación de oraciones complejas de los siguientes tipos:
```
- Oración Simple (o).
- Oración Coordinada (oc).
- Oración Subordinada de Relativo (or).
- Oraciones Compuestas, es decir, combinaciones de oraciones simples, coordinadas y
    de relativo (ocm).
- **_Nota:_** _Se debe identificar cada grupo de oraciones en la minuta 1._

```
Además, se deben incluir reglas que soporten los siguientes tipos de grupos sintácticos:
```
- Grupo Nominal (gn).
- Grupo Adjetival (gadj).
- Grupo Adverbial (gadv).
- Grupo Preposicional (gp).
- Grupo Verbal (gv).

```
Esto implica la definición de los siguientes tipos de términos:
```
- Determinantes (det).
- Nombres (n).
- Verbos (v).
- Adjetivos (adj).
- Adverbios (adv).
- Conjunciones (conj).
- Preposiciones (prep).


## 2

Realizado por: Prof. Alvaro Olmedo

```
La simplificación de oraciones complejas (coordinadas, subordinadas de relativo o
compuestas) consistirá en descomponerlas en tantas oraciones simples como sea necesario.
```
```
Ejemplos de Simplificación:
```
- "JOSÉ estudia Filosofía, pero MARÍA estudia Derecho" se debe descomponer en:
    "JOSÉ estudia Filosofía" y "MARÍA estudia Derecho".
- "JOSÉ come y bebe mientras MARÍA lee" se debe descomponer en: "JOSÉ come",
    "JOSÉ bebe" y "MARÍA lee".
- "JOSÉ, que es muy alto, tiene el pelo rubio" se debe descomponer en: "JOSÉ es muy
    alto" y "JOSÉ tiene el pelo rubio".
- "JOSÉ, que es muy alto, tiene el pelo rubio, pero MARÍA es morena" se debe
    descomponer en: "JOSÉ es muy alto", "JOSÉ tiene el pelo rubio" y "MARÍA es morena".

```
El análisis sintáctico se debe realizar a partir de un conjunto de al menos 30 oraciones como
mínimo en un contexto que el profesor indicará para cada grupo. Los grupos con más de tres
integrantes deben incrementar en 5 el número de oraciones por cada participante adicional.
Las oraciones deben corresponderse con las reportadas en la minuta 1. El contexto de donde
vengas las oraciones debe estar debidamente referenciado en el trabajo.
```
```
El código en prolog de este apartado 2.1 deberá entregarse en dos ficheros :
```
1. **El programa principal.**
2. **La utilidad draw.pl** , que representará gráficamente los árboles de constituyentes.

```
Para refrescar los conceptos de análisis sintáctico (tipos de sintagmas, tipos de oración,
funciones de los sintagmas, ejemplos resueltos) se recomienda como referencia inicial la
página: https://sintaxis.org. El analizador que incluye no siempre es capaz de analizar las
oraciones propuestas en este enunciado, pero puede servir para resolver los ejemplos de la
propia página web.
```
```
2.2 Enriquecimiento Semántico
Se deberá ampliar el sistema incorporando información semántica básica mediante hechos en
Prolog. Ejemplo:
```
- tipo(inflacion, fenomeno_economico).
- tipo(banco, institucion_financiera).
- tipo(banco, objeto_fisico).
- tipo(crecer, proceso).
- tipo(comer, accion_fisica).

```
El sistema deberá poder asociar palabras a categorías semánticas.
```
```
La diferencia fundamental entre sintaxis y semántica es la misma que existe entre la forma de
una estructura y su significado. Mientras que la sintaxis se ocupa de las reglas de construcción,
la semántica se ocupa del contenido y el sentido. Ejemplo: "El mercado las acciones compró".
En la oración anterior existe un error sintáctico: el orden es incorrecto en español (vea el Anexo
1 para mayor comprensión).
```

## 3

Realizado por: Prof. Alvaro Olmedo

**2. 3 Detección de Problemas de Interpretación**
El sistema deberá implementar reglas que permitan identificar:

```
2.3.1. Ambigüedad léxica
Palabras con múltiples significados dentro del dominio.
Ejemplo:
```
- “banco” → entidad financiera / objeto físico

```
2.3.2. Incoherencia semántica
Combinaciones incompatibles entre sujeto y predicado.
Ejemplo:
```
- “La inflación come los ahorros” (uso no literal del verbo “comer”)

```
2.3.3. Uso no literal (metáforas simples)
Detección de verbos usados fuera de su contexto habitual.
Ejemplo:
```
- “El mercado se desplomó”

```
El sistema no tiene que resolver completamente el significado, sino detectar posibles
problemas o advertencias.
```
**3. Conjunto de Oraciones**

```
3.1 Selección del corpus: Cada grupo debe elegir un dominio específico:
```
- Economía
- Tecnología
- Científico (física cuántica)
- Clínico

```
3.2 Seleccionar una fuente real:
```
- Artículo científico
- Libro
- Prensa
- Informe técnico

```
3.3 Construcción del conjunto:
```
- Extraer un mínimo de 30 oraciones
- Identificar dentro del conjunto:
    o _Grupo de oraciones (Simple, Coordinada, Subordinada de Relativo, Compuestas)_

```
3.4 Clasificación
Cada oración deberá etiquetarse como:
```
```
Tipo Descripción
Correcta Sin problemas aparentes
Ambigua Puede interpretarse de varias formas
Problemática Contiene incoherencia o uso no literal
```

## 4

Realizado por: Prof. Alvaro Olmedo

```
Importante: El contexto de donde vengas las oraciones debe estar debidamente referenciado
en el trabajo. Cada grupo de 3 integrantes debe contar con un corpus de 30 oraciones. Integrante
adicional aporta 10 oraciones.
```
**4. Mejoras del Programa**
    **4.1. Posibles Mejoras**
       1. **Preprocesamiento de la Oración:**
          o Tokenización avanzada y normalización del texto.
       2. **Flexión de Palabras:**
          o Manejo de plurales, género y tiempos verbales.
       3. **Asignación de Funciones:**
          o Identificación de roles como Complemento Directo, Indirecto, etc.
       4. **Optimización del Análisis Sintáctico:**
          o Algoritmos eficientes y manejo de errores.
       5. **Visualización Mejorada de Árboles:**
          o Estilización e interactividad.
       **6. Mejora del análisis semántico**
       **7. Detección más precisa de ambigüedad**
       **8. Generación de explicaciones automáticas**

```
4.2. Metodología de Implementación de mejoras
```
1. Revisión teórica.
2. Propuesta de implementación.
3. Desarrollo del código en Prolog.
4. Pruebas y validación.
5. Análisis de resultados.
6. Conclusiones.
7. Documentación.
**5. Detalles de la Entrega**
- **Equipo:** De 3 personas, con al menos tres mejoras implementadas. Los equipos con más
de tres personas deben adicionar una mejora por cada integrante adicional.
- **Cada equipo debe presentar resultados parciales cada semana (ver mapa de minutas
en el Anexo 2) donde especificara tarea realizada, resultados obtenidos y próximo
paso.**
- **Formato del archivo:**
El archivo .zip debe tener la siguiente estructura:
 apellido1Apellido2Apellido3_PL2.zip
├── main.pl
├── sintactico.pl
├── draw.pl
├── semantico.pl
├── deteccion.pl
├── mejoras.pl
├── conjunto_oraciones.pl
└── Informe.pdf
 Use camelCase para el nombre del archivo


## 5

Realizado por: Prof. Alvaro Olmedo

- **Informe (15-20 páginas):**
     Portada.
     Resumen.
     Índice.
     Introducción.
     Objetivos.
     Desarrollo: gramática, simplificación, mejoras, otros aspectos.
     Resultados: análisis, simplificaciones, mejoras, otros aspectos.
     Conclusiones.
     Bibliografía ( **_OJO: es importante_** )
     Anexos.
- **Entrega:**
     Plataforma: Campus Virtual de la UAH.
     **14 de Mayo de 2026**
     Importante: Las oraciones deben ser de un único contexto referenciado y no repetirse
       entre grupos y no pueden ser de semestres anteriores.
- **Defensa** :
     **Día de la entrega final y fechas posteriores.
6. Aspectos de evaluación y rubrica**
- Cada práctica se evalúa en base a 100 puntos y se promedia la nota.
- Luego se le aplica el porcentaje estimado.
- Cada práctica se evalúa según la rúbrica que el profesor presentará.
- Para aceptar la práctica se deben aprobar un mínimo de minutas en defensa ante el
profesor.
- El profesor se reserva el derecho de consultar al estudiante y/o grupo cualquier aspecto
sobre la implementación de la práctica durante la evaluación.
- El estudiante tiene derecho a defender su práctica.
- Para poder evaluar el informe de práctica, su implementación debe funcionar.
- La primera minuta se entrega a la siguiente práctica después de que el profesor la entregue
y explique su contenido. Cada semana se deben presentar resultados parciales que son las
minutas. Con la entrega de una minuta el estudiante debe anuncias el siguiente paso.


## 6

Realizado por: Prof. Alvaro Olmedo

```
Anexo 1
```
**1. Análisis Sintáctico**

```
El análisis sintáctico se centra en la jerarquía y el orden de los componentes.
```
- **Sujeto:** " E l m e r c a d o ".
- **Predicado:** "las acciones compró".
- **Núcleo del Predicado (Verbo):** "compró".
- **Complemento Directo (CD):** "las acciones".

```
Veredicto Sintáctico: En español, el orden lógico y predominante es (Sujeto + Verbo +
Objeto). Al colocar el objeto ("las acciones") antes del verbo ("compro"), la oración incurre
en una estructura que el español actual solo permite bajo ciertas condiciones (como el
hipérbaton poético o el énfasis).
```
```
Corrección sintáctica estándar: "El mercado compró las acciones" o, si queremos
enfatizar el objeto: "Las acciones las compró el mercado".
```
**2. Análisis Semántico**

```
El análisis semántico se centra en el significado y la transmisión de la idea.
```
- **Significado de los términos:**
    o _Mercado:_ Entorno de intercambio económico.
    o _Compró:_ Acción de adquirir algo a cambio de un precio.
    o _Acciones:_ Títulos valores que representan parte del capital de una empresa.
- **Relación lógica:** Los mercados (o los agentes en ellos) tienen la capacidad de realizar
    compras de activos financieros.

```
Veredicto Semántico: Correcta / Coherente
A pesar de que el orden de las palabras es extraño (el error sintáctico), el cerebro humano
es capaz de extraer el significado sin ambigüedad. Entendemos perfectamente quién hizo
qué : el mercado adquirió los títulos. No hay contradicción lógica ni términos imposibles.
```
```
Anexo 2
```
**1. Mapa de minutas**

```
Minuta 1: distribución y organización del proyecto + corpus + 2.
Minuta 3: 2.
Minuta 3: 2.3 + posibles mejoras
```
```
Versión Revisada_1Abril 202
```

