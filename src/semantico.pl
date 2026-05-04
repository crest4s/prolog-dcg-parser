/*=============================================================================
 * semantico.pl — Enriquecimiento semántico (inglés)
 * Práctica 2: Análisis Sintáctico y Semántico de Oraciones en Contextos Reales
 * Conocimiento y Razonamiento Automatizado · UAH · Curso 2025-26
 *=============================================================================
 *
 * Categorías semánticas del dominio de la física cuántica:
 *
 *   constante_fisica   — valores numéricos con rol fundamental en la física
 *   fenomeno_fisico    — fenómenos observables en la naturaleza
 *   entidad_fisica     — partículas, objetos físicos
 *   persona            — científicos e investigadores
 *   propiedad          — atributos o características de entidades
 *   proceso            — acciones o transformaciones
 *   cantidad           — magnitudes y medidas
 *   concepto_teorico   — principios, teorías, leyes
 *
 * Predicados exportados:
 *   tipo/2             — tipo(+Palabra, -Categoria)
 *   categoria_semantica/2 — categoria_semantica(+ListaTokens, -Analisis)
 *   rol_semantico/3    — rol_semantico(+Arbol, +Rol, -Palabra)
 *=============================================================================*/

:- module(semantico, [tipo/2, categoria_semantica/2, rol_semantico/3]).

% =============================================================================
% tipo/2 — asigna categoría semántica a palabras del dominio
% =============================================================================

% Constantes físicas
tipo(constant,         constante_fisica).
tipo(planck,           constante_fisica).
tipo('6.626x10-34',    constante_fisica).
tipo(h,                constante_fisica).

% Fenómenos físicos
tipo(uncertainty,      fenomeno_fisico).
tipo(duality,          fenomeno_fisico).
tipo(diffraction,      fenomeno_fisico).
tipo(radiation,        fenomeno_fisico).
tipo(effect,           fenomeno_fisico).
tipo(phenomenon,       fenomeno_fisico).
tipo(quantization,     fenomeno_fisico).
tipo(emission,         fenomeno_fisico).
tipo(wave,             fenomeno_fisico).

% Entidades físicas (partículas, objetos)
tipo(particle,         entidad_fisica).
tipo(particles,        entidad_fisica).
tipo(photon,           entidad_fisica).
tipo(photons,          entidad_fisica).
tipo(electron,         entidad_fisica).
tipo(electrons,        entidad_fisica).
tipo(body,             entidad_fisica).
tipo(metal,            entidad_fisica).
tipo(light,            entidad_fisica).
tipo(barriers,         entidad_fisica).

% Personas
tipo(planck,           persona).  % también constante_fisica — ambigüedad léxica
tipo(einstein,         persona).
tipo(heisenberg,       persona).
tipo(bohr,             persona).
tipo(davisson,         persona).
tipo(germer,           persona).
tipo(max,              persona).
tipo(niels,            persona).
tipo(albert,           persona).
tipo(werner,           persona).
tipo(clinton,          persona).
tipo(lester,           persona).
tipo(physicist,        persona).
tipo(physicists,       persona).
tipo(scientists,       persona).

% Propiedades
tipo(essential,        propiedad).
tipo(fundamental,      propiedad).
tipo(innovative,       propiedad).
tipo(coherent,         propiedad).
tipo(efficient,        propiedad).
tipo(proportional,     propiedad).
tipo(indispensable,    propiedad).
tipo(characteristic,   propiedad).
tipo(forbidden,        propiedad).
tipo(wavelike,         propiedad).
tipo(subatomic,        propiedad).
tipo(microscopic,      propiedad).
tipo(theoretical,      propiedad).
tipo(quantized,        propiedad).
tipo(discretized,      propiedad).

% Procesos / acciones
tipo(formulation,      proceso).
tipo(formulating,      proceso).
tipo(quantization,     proceso).
tipo(consolidation,    proceso).
tipo(diffraction,      proceso).

% Cantidades y medidas
tipo(value,            cantidad).
tipo(quantity,         cantidad).
tipo(quantities,       cantidad).
tipo(energy,           cantidad).
tipo(momentum,         cantidad).
tipo(precision,        cantidad).
tipo(multiples,        cantidad).
tipo(integers,         cantidad).
tipo(joules,           cantidad).

% Conceptos teóricos
tipo(principle,        concepto_teorico).
tipo(theory,           concepto_teorico).
tipo(mechanics,        concepto_teorico).
tipo(physics,          concepto_teorico).
tipo(hypothesis,       concepto_teorico).
tipo(law,              concepto_teorico).
tipo(laws,             concepto_teorico).
tipo(postulate,        concepto_teorico).
tipo(approach,         concepto_teorico).
tipo(approaches,       concepto_teorico).

% =============================================================================
% categoria_semantica/2
% Analiza los tokens de una oración e identifica qué categorías aparecen
% categoria_semantica(+Tokens, -ListaCategorias)
% =============================================================================

categoria_semantica(Tokens, Categorias) :-
    findall(Cat-Palabra,
        (member(Palabra, Tokens), tipo(Palabra, Cat)),
        Pares),
    sort(Pares, Categorias).

% =============================================================================
% rol_semantico/3
% Extrae el rol semántico de un nodo del árbol sintáctico
% rol_semantico(+Arbol, +Rol, -Palabras)
%
%   Roles:  sujeto | predicado | objeto | complemento
% =============================================================================

rol_semantico(o(GN, _), sujeto, Palabras) :-
    palabras_gn(GN, Palabras).

rol_semantico(o(_, GV), predicado, Palabras) :-
    palabras_gv(GV, Palabras).

rol_semantico(o(_, gv(_, GN)), objeto, Palabras) :-
    palabras_gn(GN, Palabras).

rol_semantico(o(_, gv(_, _, GP)), complemento, Palabras) :-
    palabras_gp(GP, Palabras).

% Auxiliares para extraer palabras de los grupos
palabras_gn(gn(n(N)), [N]).
palabras_gn(gn(det(D), n(N)), [D, N]).
palabras_gn(gn(det(D), n(N), adj(A)), [D, N, A]).
palabras_gn(gn(det(D), n(N), gp(prep(P), GN2)), [D, N, P | Resto]) :-
    palabras_gn(GN2, Resto).
palabras_gn(gn(det(D), n(N), adj(A), gp(prep(P), GN2)), [D, N, A, P | Resto]) :-
    palabras_gn(GN2, Resto).

palabras_gv(gv(v(V)), [V]).
palabras_gv(gv(v(V), GN), [V | Resto]) :- palabras_gn(GN, Resto).
palabras_gv(gv(v(V), gadj(adj(A))), [V, A]).
palabras_gv(gv(aux(A), v(V)), [A, V]).
palabras_gv(gv(aux(A), v(V), GN), [A, V | Resto]) :- palabras_gn(GN, Resto).

palabras_gp(gp(prep(P), GN), [P | Resto]) :- palabras_gn(GN, Resto).

% =============================================================================
% analisis_semantico/2
% Genera un análisis completo de la oración a partir de su árbol
% analisis_semantico(+Arbol, -Informe)
% =============================================================================

analisis_semantico(o(GN, GV), informe(Sujeto, TiposSujeto, Predicado)) :-
    palabras_gn(GN, Sujeto),
    palabras_gv(GV, Predicado),
    findall(Cat, (member(P, Sujeto), tipo(P, Cat)), TiposSujeto0),
    sort(TiposSujeto0, TiposSujeto).
