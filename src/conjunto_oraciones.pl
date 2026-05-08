/*=============================================================================
 * conjunto_oraciones.pl — Corpus de oraciones del dominio (inglés)
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Dominio:  Fisica cuántica — La constante de Planck
 * Fuente:   National Geographic España (traducido con El Mundo Traductor)
 *           https://www.nationalgeographic.com.es/ciencia/constante-planck-papel-crucial-fisica-cuantica_21424
 *           https://www.elmundo.es/traductor/
 * Tamaño:   30 oraciones
 *
 * Formato de cada oración:
 *
 *   oracion(ID, Tipo, Clase, TokensEN).
 *   oracion_es(ID, TokensES).
 *
 *   ID      — identificador numérico único
 *   Tipo    — o | oc | or | ocm
 *   Clase   — correcta | ambigua | problematica
 *   TokensEN — lista de átomos en minúsculas sin puntuación (inglés)
 *   TokensES — lista de átomos en minúsculas sin puntuación (español, referencia)
 *
 * Tipos de oración (estructura sintáctica):
 *   o   — oración simple
 *   oc  — oración coordinada
 *   or  — oración de relativo
 *   ocm — oración compuesta / mixta
 *
 * Clases:
 *   correcta    — traducción sintácticamente fiel al original
 *   ambigua     — traducción con posible ambigüedad léxica o estructural
 *   problematica — traducción con desviaciones sintácticas respecto al original
 *=============================================================================*/

:- module(conjunto_oraciones, [oracion/4, oracion_es/2]).

:- discontiguous oracion/4.
:- discontiguous oracion_es/2.

% ---------------------------------------------------------------------------
% Oración 1 — Simple (o) | Correcta
% ES: Esta constante desempeñó un papel esencial en la formulación de otro
%     de los grandes planteamientos de la cuántica: el principio de
%     incertidumbre de Heisenberg.
% EN: This constant played an essential role in the formulation of another
%     of the great quantum approaches: the Heisenberg uncertainty principle.
% ---------------------------------------------------------------------------
oracion(1, o, correcta,
    [this, constant, played, an, essential, role, in, the, formulation,
     of, another, of, the, great, quantum, approaches, the, heisenberg,
     uncertainty, principle]).

oracion_es(1,
    [esta, constante, desempeno, un, papel, esencial, en, la, formulacion,
     de, otro, de, los, grandes, planteamientos, de, la, cuantica, el,
     principio, de, incertidumbre, de, heisenberg]).

% ---------------------------------------------------------------------------
% Oración 2 — Compuesta subordinada sustantiva + relativa (ocm) | Correcta
% ES: Se suele decir que la física cuántica es una disciplina que desafía
%     la percepción de la realidad.
% EN: It is often said that quantum physics is a discipline that challenges
%     the perception of reality.
% ---------------------------------------------------------------------------
oracion(2, ocm, correcta,
    [it, is, often, said, that, quantum, physics, is, a, discipline,
     that, challenges, the, perception, of, reality]).

oracion_es(2,
    [se, suele, decir, que, la, fisica, cuantica, es, una, disciplina,
     que, desafia, la, percepcion, de, la, realidad]).

% ---------------------------------------------------------------------------
% Oración 3 — Compuesta subordinada adverbial (ocm) | Correcta
% ES: Pues bien, aunque es una frase algo poética y romántica, en parte,
%     puede considerarse cierta.
% EN: Well, although it is a somewhat poetic and romantic phrase, in part,
%     it can be considered true.
% ---------------------------------------------------------------------------
oracion(3, ocm, correcta,
    [well, although, it, is, a, somewhat, poetic, and, romantic, phrase,
     in, part, it, can, be, considered, true]).

oracion_es(3,
    [pues, bien, aunque, es, una, frase, algo, poetica, y, romantica,
     en, parte, puede, considerarse, cierta]).

% ---------------------------------------------------------------------------
% Oración 4 — Compuesta relativa + coordinada + relativa (ocm) | Problemática
% ES: La física cuántica es la que gobierna el comportamiento de las
%     partículas subatómicas, aquellas tan pequeñas que no son perceptibles
%     para nuestros ojos y, su estudio, a menudo sumerge a los científicos
%     en investigaciones donde las leyes habituales no existen.
% EN: Quantum physics is what governs the behavior of subatomic particles,
%     those so small that they are not perceptible to our eyes, and their
%     study often plunges scientists into research where the usual laws do
%     not exist.
% PROBLEMA: La subordinada de relativo explicativa con "aquellas" pierde
%           la referencia anafórica al traducirse como "those so small that".
% ---------------------------------------------------------------------------
oracion(4, ocm, problematica,
    [quantum, physics, is, what, governs, the, behavior, of, subatomic,
     particles, those, so, small, that, they, are, not, perceptible,
     to, our, eyes, and, their, study, often, plunges, scientists,
     into, research, where, the, usual, laws, do, not, exist]).

oracion_es(4,
    [la, fisica, cuantica, es, la, que, gobierna, el, comportamiento,
     de, las, particulas, subatomicas, aquellas, tan, pequenas, que, no,
     son, perceptibles, para, nuestros, ojos, y, su, estudio, a, menudo,
     sumerge, a, los, cientificos, en, investigaciones, donde, las,
     leyes, habituales, no, existen]).

% ---------------------------------------------------------------------------
% Oración 5 — Compuesta de relativo (or) | Correcta
% ES: En este contexto, existe una protagonista, de la cual seguramente
%     hayas oído hablar, que actúa como una llave maestra para entender
%     este mundo en miniatura: la constante de Planck.
% EN: In this context, there is a protagonist, which you have surely heard
%     of, that acts as a master key to understanding this miniature world:
%     the Planck constant.
% ---------------------------------------------------------------------------
oracion(5, or, correcta,
    [in, this, context, there, is, a, protagonist, which, you, have,
     surely, heard, of, that, acts, as, a, master, key, to, understanding,
     this, miniature, world, the, planck, constant]).

oracion_es(5,
    [en, este, contexto, existe, una, protagonista, de, la, cual,
     seguramente, hayas, oido, hablar, que, actua, como, una, llave,
     maestra, para, entender, este, mundo, en, miniatura, la, constante,
     de, planck]).

% ---------------------------------------------------------------------------
% Oración 6 — Simple (o) | Correcta
% ES: Llamada así en honor al físico que la introdujo, Max Planck,
%     la constante fue nombrada por primera vez a principios del siglo XX.
% EN: Named after the physicist who introduced it, Max Planck, the constant
%     was first named in the early 20th century.
% ---------------------------------------------------------------------------
oracion(6, o, correcta,
    [named, after, the, physicist, who, introduced, it, max, planck,
     the, constant, was, first, named, in, the, early, century]).

oracion_es(6,
    [llamada, asi, en, honor, al, fisico, que, la, introdujo, max,
     planck, la, constante, fue, nombrada, por, primera, vez, a,
     principios, del, siglo, xx]).

% ---------------------------------------------------------------------------
% Oración 7 — Coordinada adversativa (oc) | Correcta
% ES: En un trabajo completamente revolucionario, Planck no solo pudo
%     finalmente dar explicación a una gran cantidad de inquietudes de la
%     época, sino que sentó las bases para abrir paso a una nueva era en
%     la física: la cuántica.
% EN: In a completely revolutionary work, Planck was not only finally able
%     to explain a great many of the anxieties of the time, but also laid
%     the groundwork for a new era in physics: quantum.
% ---------------------------------------------------------------------------
oracion(7, oc, correcta,
    [in, a, completely, revolutionary, work, planck, was, not, only,
     finally, able, to, explain, a, great, many, of, the, anxieties,
     of, the, time, but, also, laid, the, groundwork, for, a, new,
     era, in, physics, quantum]).

oracion_es(7,
    [en, un, trabajo, completamente, revolucionario, planck, no, solo,
     pudo, finalmente, dar, explicacion, a, una, gran, cantidad, de,
     inquietudes, de, la, epoca, sino, que, sento, las, bases, para,
     abrir, paso, a, una, nueva, era, en, la, fisica, la, cuantica]).

% ---------------------------------------------------------------------------
% Oración 8 — Simple (o) | Correcta
% ES: Desde los comienzos del siglo XX, el avance en física parecía
%     haberse estancado.
% EN: Since the early 20th century, progress in physics seemed to have
%     stalled.
% ---------------------------------------------------------------------------
oracion(8, o, correcta,
    [since, the, early, century, progress, in, physics, seemed,
     to, have, stalled]).

oracion_es(8,
    [desde, los, comienzos, del, siglo, xx, el, avance, en, fisica,
     parecia, haberse, estancado]).

% ---------------------------------------------------------------------------
% Oración 9 — Compuesta subordinada de relativo + coordinada (ocm) | Correcta
% ES: Los científicos comenzaron a encontrar dilemas desconcertantes a los
%     que no conseguían dar explicación y para los cuales no existían unas
%     leyes coherentes y eficientes.
% EN: Scientists began to find perplexing dilemmas that they could not
%     explain and for which there were no coherent and efficient laws.
% ---------------------------------------------------------------------------
oracion(9, ocm, correcta,
    [scientists, began, to, find, perplexing, dilemmas, that, they,
     could, not, explain, and, for, which, there, were, no, coherent,
     and, efficient, laws]).

oracion_es(9,
    [los, cientificos, comenzaron, a, encontrar, dilemas, desconcertantes,
     a, los, que, no, conseguian, dar, explicacion, y, para, los, cuales,
     no, existian, unas, leyes, coherentes, y, eficientes]).

% ---------------------------------------------------------------------------
% Oración 10 — Coordinada explicativa y adversativa (oc) | Ambigua
% ES: Uno de esos problemas era el de la radiación del cuerpo negro, es
%     decir, un objeto que absorbe toda la radiación que incide sobre él,
%     pero irradia una cantidad de energía característica de él.
% EN: One such problem was radiation from the black body, that is, an
%     object that absorbs all of the radiation that strikes it but radiates
%     a quantity of energy characteristic of it.
% AMBIGÜEDAD: "characteristic of it" puede referirse tanto al objeto como
%             a la energía (ambigüedad pronominal de "it").
% ---------------------------------------------------------------------------
oracion(10, oc, ambigua,
    [one, such, problem, was, radiation, from, the, black, body,
     that, is, an, object, that, absorbs, all, of, the, radiation,
     that, strikes, it, but, radiates, a, quantity, of, energy,
     characteristic, of, it]).

oracion_es(10,
    [uno, de, esos, problemas, era, el, de, la, radiacion, del,
     cuerpo, negro, es, decir, un, objeto, que, absorbe, toda, la,
     radiacion, que, incide, sobre, el, pero, irradia, una, cantidad,
     de, energia, caracteristica, de, el]).

% ---------------------------------------------------------------------------
% Oración 11 — Compuesta yuxtapuesta + subordinada sustantiva (ocm) | Correcta
% ES: Con el objetivo de dar solución a ese fenómeno, Max Planck presentó
%     en el año 1900 una idea innovadora sobre la cuantización de la
%     energía: propuso que la energía estaba discretizada en pequeños
%     intervalos o bolsas, a los que llamó "cuantos".
% EN: In order to solve this phenomenon, Max Planck presented in 1900 an
%     innovative idea about the quantization of energy: he proposed that
%     energy was discretized into small intervals or pockets, which he
%     called quanta.
% ---------------------------------------------------------------------------
oracion(11, ocm, correcta,
    [in, order, to, solve, this, phenomenon, max, planck, presented,
     in, '1900', an, innovative, idea, about, the, quantization, of,
     energy, he, proposed, that, energy, was, discretized, into,
     small, intervals, or, pockets, which, he, called, quanta]).

oracion_es(11,
    [con, el, objetivo, de, dar, solucion, a, ese, fenomeno, max,
     planck, presento, en, el, ano, '1900', una, idea, innovadora,
     sobre, la, cuantizacion, de, la, energia, propuso, que, la,
     energia, estaba, discretizada, en, pequenos, intervalos, o,
     bolsas, a, los, que, llamo, cuantos]).

% ---------------------------------------------------------------------------
% Oración 12 — Subordinada sustantiva + coordinada adversativa (ocm) | Correcta
% ES: En otras palabras, expuso la idea de que la energía emitida no tenía
%     un valor constante, sino que se emitía en pequeñas cantidades
%     proporcionales siempre a un valor: la constante de Planck.
% EN: In other words, he expounded the idea that the energy emitted was
%     not a constant value, but was emitted in small quantities always
%     proportional to one value: the Planck constant.
% ---------------------------------------------------------------------------
oracion(12, ocm, correcta,
    [in, other, words, he, expounded, the, idea, that, the, energy,
     emitted, was, not, a, constant, value, but, was, emitted, in,
     small, quantities, always, proportional, to, one, value,
     the, planck, constant]).

oracion_es(12,
    [en, otras, palabras, expuso, la, idea, de, que, la, energia,
     emitida, no, tenia, un, valor, constante, sino, que, se, emitia,
     en, pequenas, cantidades, proporcionales, siempre, a, un, valor,
     la, constante, de, planck]).

% ---------------------------------------------------------------------------
% Oración 13 — Simple (o) | Correcta
% ES: Sin embargo, la aceptación de esta idea no fue, ni mucho menos,
%     inmediata.
% EN: However, acceptance of this idea was far from immediate.
% ---------------------------------------------------------------------------
oracion(13, o, correcta,
    [however, acceptance, of, this, idea, was, far, from, immediate]).

oracion_es(13,
    [sin, embargo, la, aceptacion, de, esta, idea, no, fue, ni,
     mucho, menos, inmediata]).

% ---------------------------------------------------------------------------
% Oración 14 — Coordinada copulativa + subordinada adverbial (ocm) | Correcta
% ES: La propuesta de Planck era atrevida y, aunque parecía explicar
%     ciertos fenómenos, entraba en contradicción con muchas teorías
%     vigentes por aquel momento.
% EN: Planck s proposal was bold, and although it seemed to explain certain
%     phenomena, it contradicted many theories then in force.
% ---------------------------------------------------------------------------
oracion(14, ocm, correcta,
    [planck, proposal, was, bold, and, although, it, seemed, to,
     explain, certain, phenomena, it, contradicted, many, theories,
     then, in, force]).

oracion_es(14,
    [la, propuesta, de, planck, era, atrevida, y, aunque, parecia,
     explicar, ciertos, fenomenos, entraba, en, contradiccion, con,
     muchas, teorias, vigentes, por, aquel, momento]).

% ---------------------------------------------------------------------------
% Oración 15 — Compuesta subordinada relativa (or) | Correcta
% ES: Afortunadamente, otros físicos de gran importancia de la época,
%     como Albert Einstein, Niels Bohr o Werner Heisenberg, contribuyeron
%     con otros avances fundamentales que terminaron por consolidar la
%     teoría de Planck.
% EN: Fortunately, other physicists of great importance at the time,
%     such as Albert Einstein, Niels Bohr or Werner Heisenberg, contributed
%     to other fundamental breakthroughs that eventually consolidated
%     Planck s theory.
% ---------------------------------------------------------------------------
oracion(15, or, correcta,
    [fortunately, other, physicists, of, great, importance, at, the,
     time, such, as, albert, einstein, niels, bohr, or, werner,
     heisenberg, contributed, to, other, fundamental, breakthroughs,
     that, eventually, consolidated, planck, theory]).

oracion_es(15,
    [afortunadamente, otros, fisicos, de, gran, importancia, de, la,
     epoca, como, albert, einstein, niels, bohr, o, werner, heisenberg,
     contribuyeron, con, otros, avances, fundamentales, que, terminaron,
     por, consolidar, la, teoria, de, planck]).

% ---------------------------------------------------------------------------
% Oración 16 — Compuesta subordinada adjetival (or) | Problemática
% ES: En general, la dualidad onda-partícula, el principio de
%     incertidumbre y la mecánica cuántica fueron los pilares que
%     hicieron crecer esa nueva concepción del mundo microscópico.
% EN: In general, wave-particle duality, the uncertainty principle and
%     quantum mechanics were the pillars that made this new conception of
%     the microscopic world grow.
% PROBLEMA: El demostrativo "esa" (esa nueva concepción) se traduce por
%           "this" en vez de "that", alterando la deixis original.
% ---------------------------------------------------------------------------
oracion(16, or, problematica,
    [in, general, wave, particle, duality, the, uncertainty, principle,
     and, quantum, mechanics, were, the, pillars, that, made, this,
     new, conception, of, the, microscopic, world, grow]).

oracion_es(16,
    [en, general, la, dualidad, onda, particula, el, principio, de,
     incertidumbre, y, la, mecanica, cuantica, fueron, los, pilares,
     que, hicieron, crecer, esa, nueva, concepcion, del, mundo,
     microscopico]).

% ---------------------------------------------------------------------------
% Oración 17 — Compuesta 2 yuxtapuestas + subordinada adjetival (ocm) | Problemática
% ES: De esta forma, la constante de Planck, representada por la letra h,
%     se asentó como uno de los pilares fundamentales de la física
%     cuántica, jugando un papel fundamental en la cuantización de los
%     fenómenos que tienen lugar en la naturaleza.
% EN: In this way, the Planck constant, represented by the letter h,
%     became established as one of the fundamental pillars of quantum
%     physics, playing a fundamental role in the quantization of phenomena
%     taking place in nature.
% PROBLEMA: El gerundio "jugando" (acción simultánea) se traduce como
%           "playing", perdiendo el matiz de causa-efecto que tiene en
%           español al introducir una nueva subordinada.
% ---------------------------------------------------------------------------
oracion(17, ocm, problematica,
    [in, this, way, the, planck, constant, represented, by, the,
     letter, h, became, established, as, one, of, the, fundamental,
     pillars, of, quantum, physics, playing, a, fundamental, role,
     in, the, quantization, of, phenomena, taking, place, in, nature]).

oracion_es(17,
    [de, esta, forma, la, constante, de, planck, representada, por,
     la, letra, h, se, asento, como, uno, de, los, pilares,
     fundamentales, de, la, fisica, cuantica, jugando, un, papel,
     fundamental, en, la, cuantizacion, de, los, fenomenos, que,
     tienen, lugar, en, la, naturaleza]).

% ---------------------------------------------------------------------------
% Oración 18 — Subordinada sustantiva + coordinada adversativa + relativa (ocm) | Correcta
% ES: Hasta ese momento, se consideraba que una emisión de energía podía
%     tener cualquier valor pero, con la postulación de Planck, se
%     determinó que siempre debía estar cuantizada en cantidades que
%     fueran multiplos enteros de la constante, h.
% EN: Until that time, it was considered that an emission of energy could
%     have any value but, with the Planck postulate, it was determined that
%     it should always be quantized into quantities which were multiple
%     integers of the constant, h.
% ---------------------------------------------------------------------------
oracion(18, ocm, correcta,
    [until, that, time, it, was, considered, that, an, emission, of,
     energy, could, have, any, value, but, with, the, planck, postulate,
     it, was, determined, that, it, should, always, be, quantized,
     into, quantities, which, were, multiple, integers, of, the,
     constant, h]).

oracion_es(18,
    [hasta, ese, momento, se, consideraba, que, una, emision, de,
     energia, podia, tener, cualquier, valor, pero, con, la,
     postulacion, de, planck, se, determino, que, siempre, debia,
     estar, cuantizada, en, cantidades, que, fueran, multiplos,
     enteros, de, la, constante, h]).

% ---------------------------------------------------------------------------
% Oración 19 — Simple (o) | Correcta
% ES: Para ser exactos, su valor es de 6.626x10-34 julios por segundo,
%     según el Sistema Internacional de Unidades.
% EN: To be exact, its value is 6.626x10-34 joules per second, according
%     to the International System of Units.
% ---------------------------------------------------------------------------
oracion(19, o, correcta,
    [to, be, exact, its, value, is, '6.626x10-34', joules, per,
     second, according, to, the, international, system, of, units]).

oracion_es(19,
    [para, ser, exactos, su, valor, es, de, '6.626x10-34', julios,
     por, segundo, segun, el, sistema, internacional, de, unidades]).

% ---------------------------------------------------------------------------
% Oración 20 — Simple (o) | Correcta
% ES: Asimismo, la constante de Planck también desempeñó un papel
%     esencial en la formulación de otro de los grandes planteamientos
%     de la cuántica: el principio de incertidumbre de Heisenberg.
% EN: Likewise, the Planck constant also played an essential role in
%     the formulation of another of the great quantum approaches to the
%     Heisenberg uncertainty principle.
% ---------------------------------------------------------------------------
oracion(20, o, correcta,
    [likewise, the, planck, constant, also, played, an, essential,
     role, in, the, formulation, of, another, of, the, great,
     quantum, approaches, to, the, heisenberg, uncertainty,
     principle]).

oracion_es(20,
    [asimismo, la, constante, de, planck, tambien, desempeno, un,
     papel, esencial, en, la, formulacion, de, otro, de, los, grandes,
     planteamientos, de, la, cuantica, el, principio, de, incertidumbre,
     de, heisenberg]).

% ---------------------------------------------------------------------------
% Oración 21 — Compuesta subordinada de complemento directo (ocm) | Correcta
% ES: La idea de ese planteamiento establece que es imposible conocer con
%     absoluta precisión la posición y la cantidad de momento de una
%     partícula.
% EN: The idea of this approach states that it is impossible to know with
%     absolute precision the position and momentum of a particle.
% ---------------------------------------------------------------------------
oracion(21, ocm, correcta,
    [the, idea, of, this, approach, states, that, it, is, impossible,
     to, know, with, absolute, precision, the, position, and,
     momentum, of, a, particle]).

oracion_es(21,
    [la, idea, de, ese, planteamiento, establece, que, es, imposible,
     conocer, con, absoluta, precision, la, posicion, y, la, cantidad,
     de, momento, de, una, particula]).

% ---------------------------------------------------------------------------
% Oración 22 — Subordinada adverbial (ocm) | Correcta
% ES: En este caso, la constante de Planck aparece como un impedimento,
%     tal y como si fuera una limitación en la capacidad para medir
%     ciertas cantidades con precisión.
% EN: In this case, the Planck constant appears as an impediment, as if
%     it were a limitation on the ability to measure certain quantities
%     accurately.
% ---------------------------------------------------------------------------
oracion(22, ocm, correcta,
    [in, this, case, the, planck, constant, appears, as, an,
     impediment, as, if, it, were, a, limitation, on, the, ability,
     to, measure, certain, quantities, accurately]).

oracion_es(22,
    [en, este, caso, la, constante, de, planck, aparece, como, un,
     impedimento, tal, y, como, si, fuera, una, limitacion, en, la,
     capacidad, para, medir, ciertas, cantidades, con, precision]).

% ---------------------------------------------------------------------------
% Oración 23 — Subordinada de relativo (or) | Correcta
% ES: Su presencia, deducida de forma teórica, consigue dar explicación
%     y manifestarse a través de fenómenos cuánticos observados en
%     diferentes experimentos, los cuales, consolidaron definitivamente
%     su importancia.
% EN: Its presence, deduced in a theoretical way, manages to give
%     explanation and manifest itself through quantum phenomena observed
%     in different experiments, which definitively consolidated its
%     importance.
% ---------------------------------------------------------------------------
oracion(23, or, correcta,
    [its, presence, deduced, in, a, theoretical, way, manages, to,
     give, explanation, and, manifest, itself, through, quantum,
     phenomena, observed, in, different, experiments, which,
     definitively, consolidated, its, importance]).

oracion_es(23,
    [su, presencia, deducida, de, forma, teorica, consigue, dar,
     explicacion, y, manifestarse, a, traves, de, fenomenos, cuanticos,
     observados, en, diferentes, experimentos, los, cuales, consolidaron,
     definitivamente, su, importancia]).

% ---------------------------------------------------------------------------
% Oración 24 — Compuesta subordinada sustantiva + relativa (ocm) | Problemática
% ES: Por ejemplo, basándose en el testimonio de Planck, Albert Einstein
%     propuso en 1905 una explicación cuántica para el efecto
%     fotoeléctrico, apostando a que la luz que incide sobre un metal
%     arranca electrones.
% EN: For example, based on the testimony of Planck, Albert Einstein
%     proposed in 1905 a quantum explanation for the photoelectric effect,
%     betting that light hitting a metal ejects electrons.
% PROBLEMA: El gerundio "apostando" introduce una subordinada sustantiva
%           en español; en inglés, "betting that" funciona como participio
%           libre, perdiendo la estructura de complemento directo.
% ---------------------------------------------------------------------------
oracion(24, ocm, problematica,
    [for, example, based, on, the, testimony, of, planck, albert,
     einstein, proposed, in, '1905', a, quantum, explanation, for,
     the, photoelectric, effect, betting, that, light, hitting,
     a, metal, ejects, electrons]).

oracion_es(24,
    [por, ejemplo, basandose, en, el, testimonio, de, planck, albert,
     einstein, propuso, en, '1905', una, explicacion, cuantica, para,
     el, efecto, fotoelectrico, apostando, a, que, la, luz, que,
     incide, sobre, un, metal, arranca, electrones]).

% ---------------------------------------------------------------------------
% Oración 25 — Compuesta subordinada sustantiva + participio (ocm) | Correcta
% ES: Para establecer esta idea, Einstein utilizó como hipótesis que la
%     luz está compuesta por partículas llamadas fotones, cada uno con
%     energía proporcional a la constante de Planck.
% EN: To establish this idea, Einstein used the hypothesis that light is
%     composed of particles called photons, each with energy proportional
%     to Planck s constant.
% ---------------------------------------------------------------------------
oracion(25, ocm, correcta,
    [to, establish, this, idea, einstein, used, the, hypothesis,
     that, light, is, composed, of, particles, called, photons,
     each, with, energy, proportional, to, planck, constant]).

oracion_es(25,
    [para, establecer, esta, idea, einstein, utilizo, como, hipotesis,
     que, la, luz, esta, compuesta, por, particulas, llamadas, fotones,
     cada, uno, con, energia, proporcional, a, la, constante, de,
     planck]).

% ---------------------------------------------------------------------------
% Oración 26 — Subordinada de relativo + sustantiva (ocm) | Correcta
% ES: Fue justamente este fenómeno el que consiguió explicar que la luz
%     presentaba comportamientos tan de onda como de partícula, sentando
%     las bases para la dualidad onda-partícula.
% EN: It was precisely this phenomenon that managed to explain that light
%     had both wave and particle behaviors, laying the foundation for the
%     wave-particle duality.
% ---------------------------------------------------------------------------
oracion(26, ocm, correcta,
    [it, was, precisely, this, phenomenon, that, managed, to, explain,
     that, light, had, both, wave, and, particle, behaviors, laying,
     the, foundation, for, the, wave, particle, duality]).

oracion_es(26,
    [fue, justamente, este, fenomeno, el, que, consiguio, explicar,
     que, la, luz, presentaba, comportamientos, tan, de, onda, como,
     de, particula, sentando, las, bases, para, la, dualidad, onda,
     particula]).

% ---------------------------------------------------------------------------
% Oración 27 — Subordinada adverbial (ocm) | Correcta
% ES: Asimismo, en el año 1927, Clinton Davisson y Lester Germer
%     realizaron diferentes experimentos de difracción de electrones,
%     demostrando que estos exhibían comportamientos ondulatorios muy
%     similares a las ondas de luz.
% EN: Likewise, in 1927, Clinton Davisson and Lester Germer conducted
%     different experiments of electron diffraction, showing that they
%     exhibited wavelike behaviors very similar to light waves.
% ---------------------------------------------------------------------------
oracion(27, ocm, correcta,
    [likewise, in, '1927', clinton, davisson, and, lester, germer,
     conducted, different, experiments, of, electron, diffraction,
     showing, that, they, exhibited, wavelike, behaviors, very,
     similar, to, light, waves]).

oracion_es(27,
    [asimismo, en, el, ano, '1927', clinton, davisson, y, lester,
     germer, realizaron, diferentes, experimentos, de, difraccion,
     de, electrones, demostrando, que, estos, exhibian,
     comportamientos, ondulatorios, muy, similares, a, las, ondas,
     de, luz]).

% ---------------------------------------------------------------------------
% Oración 28 — Subordinada de relativo + coordinada copulativa (ocm) | Correcta
% ES: Este fenómeno, que pasó a conocerse como difracción de electrones,
%     confirmó esa dualidad onda-partícula y resaltó la necesidad de
%     considerar la constante de Planck como un elemento indispensable
%     en el estudio del mundo microscópico.
% EN: This phenomenon, which came to be known as electron diffraction,
%     confirmed this wave-particle duality and highlighted the need to
%     consider the Planck constant as an indispensable element in the
%     study of the microscopic world.
% ---------------------------------------------------------------------------
oracion(28, ocm, correcta,
    [this, phenomenon, which, came, to, be, known, as, electron,
     diffraction, confirmed, this, wave, particle, duality, and,
     highlighted, the, need, to, consider, the, planck, constant,
     as, an, indispensable, element, in, the, study, of, the,
     microscopic, world]).

oracion_es(28,
    [este, fenomeno, que, paso, a, conocerse, como, difraccion, de,
     electrones, confirmo, esa, dualidad, onda, particula, y, resalto,
     la, necesidad, de, considerar, la, constante, de, planck, como,
     un, elemento, indispensable, en, el, estudio, del, mundo,
     microscopico]).

% ---------------------------------------------------------------------------
% Oración 29 — Simple (o) | Problemática
% ES: También en el año 1981 jugó un papel muy importante durante la
%     invención del microscopio de efecto túnel.
% EN: Also in 1981 it played a very important role during the invention
%     of the tunnel effect microscope.
% PROBLEMA: El sujeto de "jugó" en español está omitido (sujeto
%           gramatical implícito); en inglés se añade "it" explícito,
%           introduciendo ambigüedad sobre a qué referente alude.
% ---------------------------------------------------------------------------
oracion(29, o, problematica,
    [also, in, '1981', it, played, a, very, important, role, during,
     the, invention, of, the, tunnel, effect, microscope]).

oracion_es(29,
    [tambien, en, el, ano, '1981', jugo, un, papel, muy, importante,
     durante, la, invencion, del, microscopio, de, efecto, tunel]).

% ---------------------------------------------------------------------------
% Oración 30 — Subordinada de relativo multiple (or) | Problemática
% ES: Se trata de un fenómeno en el cual las partículas son capaces de
%     atravesar barreras energéticas prohibidas clásicamente, lo cual se
%     relaciona directamente con la energía que posee, cuantificada en
%     multiplos de la constante de Planck.
% EN: This is a phenomenon in which particles are able to pass through
%     classically forbidden energy barriers, which is directly related to
%     the energy they possess, quantified in multiples of the Planck
%     constant.
% PROBLEMA: La pronominalización de "lo cual" (referencia a la proposición
%           completa) se traduce como "which", que en inglés puede referirse
%           al sustantivo mas cercano ("barriers"), creando ambigüedad.
% ---------------------------------------------------------------------------
oracion(30, or, problematica,
    [this, is, a, phenomenon, in, which, particles, are, able, to,
     pass, through, classically, forbidden, energy, barriers, which,
     is, directly, related, to, the, energy, they, possess,
     quantified, in, multiples, of, the, planck, constant]).

oracion_es(30,
    [se, trata, de, un, fenomeno, en, el, cual, las, particulas,
     son, capaces, de, atravesar, barreras, energeticas, prohibidas,
     clasicamente, lo, cual, se, relaciona, directamente, con, la,
     energia, que, posee, cuantificada, en, multiplos, de, la,
     constante, de, planck]).
