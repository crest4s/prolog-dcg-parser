/*=============================================================================
 * semantico.pl — Enriquecimiento semántico
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Hechos de la forma:  tipo(+Palabra, +Categoría)
 *
 * Ejemplos:
 *   tipo(inflacion, fenomeno_economico).
 *   tipo(banco, institucion_financiera).
 *   tipo(banco, objeto_fisico).
 *   tipo(crecer, proceso).
 *   tipo(comer, accion_fisica).
 *=============================================================================*/

:- module(semantico, [tipo/2, categoria_semantica/2]).

categoria_semantica(Palabra, Categoria) :-
	tipo(Palabra, Categoria).

% -----------------------------------------------------------------------------
% Personas y grupos científicos
% -----------------------------------------------------------------------------

tipo(albert, persona_cientifica).
tipo(einstein, persona_cientifica).
tipo(niels, persona_cientifica).
tipo(bohr, persona_cientifica).
tipo(werner, persona_cientifica).
tipo(heisenberg, persona_cientifica).
tipo(max, persona_cientifica).
tipo(planck, persona_cientifica).
tipo(clinton, persona_cientifica).
tipo(davisson, persona_cientifica).
tipo(lester, persona_cientifica).
tipo(germer, persona_cientifica).
tipo(fisico, profesional_cientifico).
tipo(fisicos, grupo_cientifico).
tipo(cientificos, grupo_cientifico).

% -----------------------------------------------------------------------------
% Disciplinas, teorías y conceptos científicos
% -----------------------------------------------------------------------------

tipo(fisica, disciplina_cientifica).
tipo(cuantica, disciplina_cientifica).
tipo(mecanica, disciplina_cientifica).
tipo(teoria, teoria_cientifica).
tipo(principio, principio_fisico).
tipo(incertidumbre, principio_fisico).
tipo(cuantizacion, proceso_cientifico).
tipo(formulacion, proceso_cientifico).
tipo(postulacion, proceso_cientifico).
tipo(concepcion, marco_conceptual).
tipo(propuesta, propuesta_cientifica).
tipo(hipotesis, hipotesis_cientifica).
tipo(idea, idea_cientifica).
tipo(planteamiento, propuesta_cientifica).
tipo(planteamientos, propuesta_cientifica).
tipo(explicacion, explicacion_cientifica).
tipo(solucion, solucion_cientifica).
tipo(contexto, marco_referencia).
tipo(realidad, concepto_abstracto).
tipo(presencia, existencia).
tipo(importancia, relevancia).
tipo(necesidad, requisito).
tipo(contradiccion, incoherencia_logica).
tipo(papel, rol_funcional).
tipo(protagonista, entidad_relevante).
tipo(honor, reconocimiento_social).
tipo(parte, fraccion).
tipo(forma, modo_o_configuracion).
tipo(letra, simbolo_linguistico).
tipo(elemento, componente).
tipo(principios, principio_fisico).
tipo(problemas, dificultad_analitica).
tipo(dilemas, dificultad_analitica).
tipo(inquietudes, preocupacion_cientifica).
tipo(objetivo, meta_cientifica).
tipo(caso, situacion).
tipo(fenomeno, fenomeno_general).
tipo(fenomenos, fenomeno_general).
tipo(dualidad, concepto_fisico).
tipo(emision, fenomeno_fisico).
tipo(radiacion, fenomeno_fisico).
tipo(difraccion, fenomeno_fisico).
tipo(efecto, fenomeno_fisico).
tipo(comportamiento, comportamiento_fisico).
tipo(comportamientos, comportamiento_fisico).
tipo(estudio, actividad_cientifica).
tipo(investigaciones, actividad_cientifica).
tipo(experimentos, actividad_cientifica).
tipo(invencion, desarrollo_tecnologico).
tipo(trabajo, actividad_cientifica).
tipo(avance, progreso_cientifico).
tipo(avances, progreso_cientifico).
tipo(base, fundamento_cientifico).
tipo(bases, fundamento_cientifico).
tipo(leyes, ley_fisica).
tipo(frase, expresion_linguistica).
tipo(palabras, expresion_linguistica).
tipo(testimonio, fuente_documental).

% -----------------------------------------------------------------------------
% Magnitudes, medidas, tiempo y espacio
% -----------------------------------------------------------------------------

tipo(constante, magnitud_fisica).
tipo(energia, magnitud_fisica).
tipo(cantidad, magnitud_mensurable).
tipo(cantidades, magnitud_mensurable).
tipo(valor, magnitud_mensurable).
tipo(posicion, magnitud_fisica).
tipo(momento, magnitud_fisica).
tipo(precision, precision_medicion).
tipo(capacidad, capacidad_medicion).
tipo(limitacion, restriccion).
tipo(impedimento, obstaculo).
tipo(ano, tiempo_historico).
tipo(siglo, tiempo_historico).
tipo(epoca, tiempo_historico).
tipo(vez, instante_temporal).
tipo(miniatura, escala_reducida).
tipo(mundo, entorno_fisico).
tipo(naturaleza, entorno_fisico).
tipo(lugar, ubicacion).
tipo(cuerpo, objeto_fisico).
tipo(objeto, objeto_fisico).
tipo(metal, material).
tipo(llave, objeto_fisico).
tipo(microscopio, instrumento_cientifico).
tipo(barreras, obstaculo_fisico).
tipo(bolsas, contenedor).
tipo(intervalos, intervalo).
tipo(sistema, sistema_medicion).
tipo(unidades, unidad_medida).
tipo(julios, unidad_medida).
tipo(segundo, unidad_medida).
tipo(h, simbolo_fisico).

% -----------------------------------------------------------------------------
% Partículas, ondas y otros objetos físicos
% -----------------------------------------------------------------------------

tipo(luz, entidad_energetica).
tipo(onda, onda_fisica).
tipo(ondas, onda_fisica).
tipo(particula, particula_fisica).
tipo(particulas, particula_fisica).
tipo(electrones, particula_fisica).
tipo(fotones, particula_fisica).

% -----------------------------------------------------------------------------
% Atributos y adjetivos del corpus
% -----------------------------------------------------------------------------

tipo(esencial, cualidad_relevante).
tipo(fundamental, cualidad_relevante).
tipo(fundamentales, cualidad_relevante).
tipo(importante, cualidad_relevante).
tipo(indispensable, cualidad_relevante).
tipo(innovadora, cualidad_innovadora).
tipo(revolucionario, cualidad_innovadora).
tipo(atrevida, cualidad_innovadora).
tipo(poetica, cualidad_estetica).
tipo(romantica, cualidad_estetica).
tipo(cierta, indeterminacion).
tipo(ciertos, indeterminacion).
tipo(ciertas, indeterminacion).
tipo(cualquier, indeterminacion).
tipo(otro, alteridad).
tipo(otros, alteridad).
tipo(otras, alteridad).
tipo(general, alcance_general).
tipo(subatomicas, escala_microscopica).
tipo(pequenas, escala_reducida).
tipo(pequenos, escala_reducida).
tipo(microscopico, escala_microscopica).
tipo(gran, intensidad).
tipo(grandes, intensidad).
tipo(nueva, novedad).
tipo(primera, orden_temporal).
tipo(inmediata, inmediatez).
tipo(desconcertantes, dificultad_interpretativa).
tipo(coherentes, coherencia).
tipo(eficientes, eficiencia).
tipo(habituales, frecuencia).
tipo(vigentes, vigencia).
tipo(perceptibles, perceptibilidad).
tipo(estancado, estado_procesual).
tipo(negro, color).
tipo(caracteristica, caracteristica).
tipo(discretizada, estado_discreto).
tipo(emitida, emision).
tipo(proporcional, proporcionalidad).
tipo(proporcionales, proporcionalidad).
tipo(enteros, integridad_numerica).
tipo(exactos, exactitud).
tipo(internacional, ambito_global).
tipo(imposible, imposibilidad).
tipo(absoluta, absolutidad).
tipo(tal, analogia).
tipo(deducida, inferencia).
tipo(teorica, teoricidad).
tipo(cuanticos, caracter_cuantico).
tipo(cuantica, caracter_cuantico).
tipo(observados, observacion).
tipo(diferentes, diversidad).
tipo(fotoelectrico, efecto_fotoelectrico).
tipo(compuesta, composicion).
tipo(llamada, denominacion).
tipo(llamadas, denominacion).
tipo(maestra, funcion_estrategica).
tipo(ondulatorios, caracter_ondulatorio).
tipo(similares, similitud).
tipo(capaces, capacidad).
tipo(energeticas, energia).
tipo(prohibidas, prohibicion).
tipo(cuantizada, cuantificacion).
tipo(cuantificada, cuantificacion).
tipo(representada, representacion).
tipo(determinante, relevancia).

