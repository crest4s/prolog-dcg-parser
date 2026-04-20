/*=============================================================================
 * conjunto_oraciones.pl — Corpus de oraciones del dominio
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Dominio:  (completar)
 * Fuente:   (completar con referencia completa: autor, título, año, URL/editorial)
 * Tamaño:   ≥ 30 oraciones  (+5 por cada integrante adicional sobre 3)
 *
 * Formato de cada oración:
 *
 *   oracion(ID, Tipo, Clase, Tokens).
 *
 *   ID     — identificador numérico único
 *   Tipo   — o | oc | or | ocm
 *   Clase  — correcta | ambigua | problematica
 *   Tokens — lista de átomos en minúsculas sin puntuación
 *
 * Ejemplo:
 *   oracion(1, o, correcta,
 *       [el, banco, central, subio, los, tipos, de, interes]).
 *   oracion(2, oc, ambigua,
 *       [el, banco, esta, en, la, esquina, y, guarda, los, ahorros]).
 *   oracion(3, o, problematica,
 *       [la, inflacion, come, los, ahorros]).
 *=============================================================================*/

:- module(conjunto_oraciones, [oracion/4]).

oracion(1, o, correcta,
	[esta, constante, desempeno, un, papel, esencial, en, la, formulacion, de, otro, de, los, grandes, planteamientos, de, la, cuantica, el, principio, de, incertidumbre, de, heisenberg]).

oracion(2, or, correcta,
	[se, suele, decir, que, la, fisica, cuantica, es, una, disciplina, que, desafia, la, percepcion, de, la, realidad]).

oracion(3, ocm, correcta,
	[pues, bien, aunque, es, una, frase, algo, poetica, y, romantica, en, parte, puede, considerarse, cierta]).

oracion(4, ocm, problematica,
	[la, fisica, cuantica, es, la, que, gobierna, el, comportamiento, de, las, particulas, subatomicas, aquellas, tan, pequenas, que, no, son, perceptibles, para, nuestros, ojos, y, su, estudio, a, menudo, sumerge, a, los, cientificos, en, investigaciones, donde, las, leyes, habituales, no, existen]).

oracion(5, ocm, correcta,
	[en, este, contexto, existe, una, protagonista, de, la, cual, seguramente, hayas, oido, hablar, que, actua, como, una, llave, maestra, para, entender, este, mundo, en, miniatura, la, constante, de, planck]).

oracion(6, o, correcta,
	[llamada, asi, en, honor, al, fisico, que, la, introdujo, max, planck, la, constante, fue, nombrada, por, primera, vez, a, principios, del, siglo, xx]).

oracion(7, ocm, correcta,
	[en, un, trabajo, completamente, revolucionario, planck, no, solo, pudo, finalmente, dar, explicacion, a, una, gran, cantidad, de, inquietudes, de, la, epoca, sino, que, sento, las, bases, para, abrir, paso, a, una, nueva, era, en, la, fisica, la, cuantica]).

oracion(8, o, correcta,
	[desde, los, comienzos, del, siglo, xx, el, avance, en, fisica, parecia, haberse, estancado]).

oracion(9, ocm, correcta,
	[los, cientificos, comenzaron, a, encontrar, dilemas, desconcertantes, a, los, que, no, conseguian, dar, explicacion, y, para, los, cuales, no, existian, unas, leyes, coherentes, y, eficientes]).

oracion(10, ocm, ambigua,
	[uno, de, esos, problemas, era, el, de, la, radiacion, del, cuerpo, negro, es, decir, un, objeto, que, absorbe, toda, la, radiacion, que, incide, sobre, el, pero, irradia, una, cantidad, de, energia, caracteristica, de, el]).

oracion(11, ocm, correcta,
	[con, el, objetivo, de, dar, solucion, a, ese, fenomeno, max, planck, presento, en, el, ano, 1900, una, idea, innovadora, sobre, la, cuantizacion, de, la, energia, propuso, que, la, energia, estaba, discretizada, en, pequenos, intervalos, o, bolsas, a, los, que, llamo, cuantos]).

oracion(12, ocm, correcta,
	[en, otras, palabras, expuso, la, idea, de, que, la, energia, emitida, no, tenia, un, valor, constante, sino, que, se, emitia, en, pequenas, cantidades, proporcionales, siempre, a, un, valor, la, constante, de, planck]).

oracion(13, o, correcta,
	[sin, embargo, la, aceptacion, de, esta, idea, no, fue, ni, mucho, menos, inmediata]).

oracion(14, ocm, correcta,
	[la, propuesta, de, planck, era, atrevida, y, aunque, parecia, explicar, ciertos, fenomenos, entraba, en, contradiccion, con, muchas, teorias, vigentes, por, aquel, momento]).

oracion(15, ocm, correcta,
	[afortunadamente, otros, fisicos, de, gran, importancia, de, la, epoca, como, albert, einstein, niels, bohr, o, werner, heisenberg, contribuyeron, con, otros, avances, fundamentales, que, terminaron, por, consolidar, la, teoria, de, planck]).

oracion(16, ocm, problematica,
	[en, general, la, dualidad, onda, particula, el, principio, de, incertidumbre, y, la, mecanica, cuantica, fueron, los, pilares, que, hicieron, crecer, esa, nueva, concepcion, del, mundo, microscopico]).

oracion(17, ocm, problematica,
	[de, esta, forma, la, constante, de, planck, representada, por, la, letra, h, se, asento, como, uno, de, los, pilares, fundamentales, de, la, fisica, cuantica, jugando, un, papel, fundamental, en, la, cuantizacion, de, los, fenomenos, que, tienen, lugar, en, la, naturaleza]).

oracion(18, ocm, correcta,
	[hasta, ese, momento, se, consideraba, que, una, emision, de, energia, podia, tener, cualquier, valor, pero, con, la, postulacion, de, planck, se, determino, que, siempre, debia, estar, cuantizada, en, cantidades, que, fueran, multiplos, enteros, de, la, constante, h]).

oracion(19, o, correcta,
	[para, ser, exactos, su, valor, es, de, '6.626x10-34', julios, por, segundo, segun, el, sistema, internacional, de, unidades]).

oracion(20, o, problematica,
	[asimismo, la, constante, de, planck, tambien, desempeno, un, papel, esencial, en, la, formulacion, de, otro, de, los, grandes, planteamientos, de, la, cuantica, el, principio, de, incertidumbre, de, heisenberg]).

oracion(21, ocm, correcta,
	[la, idea, de, ese, planteamiento, establece, que, es, imposible, conocer, con, absoluta, precision, la, posicion, y, la, cantidad, de, momento, de, una, particula]).

oracion(22, ocm, correcta,
	[en, este, caso, la, constante, de, planck, aparece, como, un, impedimento, tal, y, como, si, fuera, una, limitacion, en, la, capacidad, para, medir, ciertas, cantidades, con, precision]).

oracion(23, ocm, correcta,
	[su, presencia, deducida, de, forma, teorica, consigue, dar, explicacion, y, manifestarse, a, traves, de, fenomenos, cuanticos, observados, en, diferentes, experimentos, los, cuales, consolidaron, definitivamente, su, importancia]).

oracion(24, ocm, problematica,
	[por, ejemplo, basandose, en, el, testimonio, de, planck, albert, einstein, propuso, en, 1905, una, explicacion, cuantica, para, el, efecto, fotoelectrico, apostando, a, que, la, luz, que, incide, sobre, un, metal, arranca, electrones]).

oracion(25, ocm, correcta,
	[para, establecer, esta, idea, einstein, utilizo, como, hipotesis, que, la, luz, esta, compuesta, por, particulas, llamadas, fotones, cada, uno, con, energia, proporcional, a, la, constante, de, planck]).

oracion(26, ocm, correcta,
	[fue, justamente, este, fenomeno, el, que, consiguio, explicar, que, la, luz, presentaba, comportamientos, tan, de, onda, como, de, particula, sentando, las, bases, para, la, dualidad, onda, particula]).

oracion(27, ocm, correcta,
	[asimismo, en, el, ano, 1927, clinton, davisson, y, lester, germer, realizaron, diferentes, experimentos, de, difraccion, de, electrones, demostrando, que, estos, exhibian, comportamientos, ondulatorios, muy, similares, a, las, ondas, de, luz]).

oracion(28, ocm, correcta,
	[este, fenomeno, que, paso, a, conocerse, como, difraccion, de, electrones, confirmo, esa, dualidad, onda, particula, y, resalto, la, necesidad, de, considerar, la, constante, de, planck, como, un, elemento, indispensable, en, el, estudio, del, mundo, microscopico]).

oracion(29, o, problematica,
	[tambien, en, el, ano, 1981, jugo, un, papel, muy, importante, durante, la, invencion, del, microscopio, de, efecto, tunel]).

oracion(30, ocm, problematica,
	[se, trata, de, un, fenomeno, en, el, cual, las, particulas, son, capaces, de, atravesar, barreras, energeticas, prohibidas, clasicamente, lo, cual, se, relaciona, directamente, con, la, energia, que, posee, cuantificada, en, multiplos, de, la, constante, de, planck]).
