% ===========================================================
%  conjunto_oraciones.pl
%  Corpus de 30 oraciones en inglés como hechos Prolog.
%
%  Formato: frase(Id, Tipo, ListaDePalabras)
%    Id   — número de oración (1-30)
%    Tipo — etiqueta sintáctica: o | oc | or | ocm
%    ListaDePalabras — tokens en minúscula, átomos
%
%  Notas de codificación:
%    - Posesivos sajones: 'planck''s', 'quantum''s'
%    - Palabras con guion: 'wave-particle'
%    - Años como enteros: 1900, 1905, 1927, 1981
%    - Ordinales y símbolos como átomos: '20th', '6.626x10-34'
%    - Aposiciones tras dos puntos (:) se omiten del token list
%      cuando no forman cláusula sintáctica independiente.
%
%  Carga:
%    ?- consult('conjunto_oraciones.pl').
%    ?- frase(1, Tipo, Tokens).
% ===========================================================

% ----------------------------------------------------------
%  ORACIONES SIMPLES  (o)
% ----------------------------------------------------------

% 1 — Correcta
% "This constant played an essential role in the formulation
%  of another of the great quantum approaches."
frase(1, o,
    [this, constant, played, an, essential, role,
     in, the, formulation, of, another, of,
     the, great, quantum, approaches]).

% 6 — Correcta
% "Named after the physicist who introduced it, Max Planck,
%  the constant was first named in the early 20th century."
frase(6, o,
    [named, after, the, physicist, who, introduced, it,
     max, planck, the, constant, was, first, named,
     in, the, early, '20th', century]).

% 8 — Correcta
% "Since the early 20th century, progress in physics
%  seemed to have stalled."
frase(8, o,
    [since, the, early, '20th', century,
     progress, in, physics, seemed, to, have, stalled]).

% 13 — Correcta
% "However, acceptance of this idea was far from immediate."
frase(13, o,
    [however, acceptance, of, this, idea,
     was, far, from, immediate]).

% 19 — Correcta
% "To be exact, its value is 6.626x10-34 joules per second,
%  according to the International System of Units."
frase(19, o,
    [to, be, exact, its, value, is, '6.626x10-34',
     joules, per, second, according, to,
     the, international, system, of, units]).

% 20 — Problemática
% "Likewise, the Planck constant also played an essential role
%  in formulating another of quantum's great approaches."
frase(20, o,
    [likewise, the, planck, constant, also, played,
     an, essential, role, in, formulating,
     another, of, 'quantum''s', great, approaches]).

% 29 — Problemática
% "Also in 1981 it played a very important role during
%  the invention of the tunnel effect microscope."
frase(29, o,
    [also, in, 1981, it, played, a, very, important, role,
     during, the, invention, of, the, tunnel, effect, microscope]).

% ----------------------------------------------------------
%  ORACIONES COORDINADAS  (oc)
% ----------------------------------------------------------

% 7 — Correcta  (correlativa "not only … but also")
% "In a completely revolutionary work, Planck was not only
%  finally able to explain a great many of the anxieties of
%  the time, but also laid the groundwork for a new era
%  in physics."
frase(7, oc,
    [in, a, completely, revolutionary, work, planck,
     was, not, only, finally, able, to, explain,
     a, great, many, of, the, anxieties, of, the, time,
     but, also, laid, the, groundwork, for, a, new, era,
     in, physics]).

% 10 — Ambigua  (adversativa, sujeto compartido)
% "One such problem was radiation from the black body,
%  that is, an object that absorbs all of the radiation
%  that strikes it but radiates a quantity of energy
%  characteristic of it."
frase(10, oc,
    [one, such, problem, was, radiation, from, the, black, body,
     that, is, an, object, that, absorbs, all, of, the, radiation,
     that, strikes, it, but, radiates, a, quantity, of, energy,
     characteristic, of, it]).

% ----------------------------------------------------------
%  ORACIONES SUBORDINADAS DE RELATIVO  (or)
% ----------------------------------------------------------

% 5 — Correcta
% "In this context, there is a protagonist, which you have
%  surely heard of, that acts as a master key to
%  understanding this miniature world."
frase(5, or,
    [in, this, context, there, is, a, protagonist,
     which, you, have, surely, heard, of,
     that, acts, as, a, master, key,
     to, understanding, this, miniature, world]).

% 15 — Correcta
% "Fortunately, other physicists of great importance at
%  the time, such as Albert Einstein, Niels Bohr or Werner
%  Heisenberg, contributed to other fundamental breakthroughs
%  that eventually consolidated Planck's theory."
frase(15, or,
    [fortunately, other, physicists, of, great, importance,
     at, the, time, such, as, albert, einstein,
     niels, bohr, or, werner, heisenberg,
     contributed, to, other, fundamental, breakthroughs,
     that, eventually, consolidated, 'planck''s', theory]).

% 16 — Problemática
% "In general, wave-particle duality, the uncertainty
%  principle and quantum mechanics were the pillars that
%  made this new conception of the microscopic world grow."
frase(16, or,
    [in, general, 'wave-particle', duality, ',',
     the, uncertainty, principle, and, quantum, mechanics,
     were, the, pillars, that, made, this, new,
     conception, of, the, microscopic, world, grow]).

% 23 — Correcta
% "Its presence, deduced in a theoretical way, manages to
%  give explanation and manifest itself through quantum
%  phenomena observed in different experiments, which
%  definitively consolidated its importance."
frase(23, or,
    [its, presence, deduced, in, a, theoretical, way,
     manages, to, give, explanation, and, manifest, itself,
     through, quantum, phenomena, observed,
     in, different, experiments,
     which, definitively, consolidated, its, importance]).

% 30 — Problemática
% "This is a phenomenon in which particles are able to pass
%  through classically forbidden energy barriers, which is
%  directly related to the energy they possess, quantified
%  in multiples of the Planck constant."
frase(30, or,
    [this, is, a, phenomenon, in, which, particles,
     are, able, to, pass, through, classically,
     forbidden, energy, barriers, which, is, directly,
     related, to, the, energy, they, possess,
     quantified, in, multiples, of, the, planck, constant]).

% ----------------------------------------------------------
%  ORACIONES COMPUESTAS  (ocm)
% ----------------------------------------------------------

% 2 — Correcta  (sustantiva + relativa anidada)
% "It is often said that quantum physics is a discipline
%  that challenges the perception of reality."
frase(2, ocm,
    [it, is, often, said, that, quantum, physics,
     is, a, discipline, that, challenges,
     the, perception, of, reality]).

% 3 — Correcta  (adverbial concesiva)
% "Well, although it is a somewhat poetic and romantic
%  phrase, in part, it can be considered true."
frase(3, ocm,
    [well, although, it, is, a, somewhat, poetic,
     and, romantic, phrase, in, part,
     it, can, be, considered, true]).

% 4 — Problemática  (relativa + coord. copulativa + relativa)
% "Quantum physics is what governs the behavior of subatomic
%  particles, those so small that they are not perceptible
%  to our eyes, and their study often plunges scientists
%  into research where the usual laws do not exist."
frase(4, ocm,
    [quantum, physics, is, what, governs,
     the, behavior, of, subatomic, particles,
     those, so, small, that, they, are, not,
     perceptible, to, our, eyes, and, their, study,
     often, plunges, scientists, into, research,
     where, the, usual, laws, do, not, exist]).

% 9 — Correcta  (dos relativas coordinadas)
% "Scientists began to find perplexing dilemmas that they
%  could not explain and for which there were no coherent
%  and efficient laws."
frase(9, ocm,
    [scientists, began, to, find, perplexing, dilemmas,
     that, they, could, not, explain,
     and, for, which, there, were, no,
     coherent, and, efficient, laws]).

% 11 — Correcta  (yuxtapuesta + sustantiva)
% "In order to solve this phenomenon, Max Planck presented
%  in 1900 an innovative idea about the quantization of
%  energy: he proposed that energy was discretized into
%  small intervals or pockets, which he called quanta."
frase(11, ocm,
    [in, order, to, solve, this, phenomenon,
     max, planck, presented, in, 1900,
     an, innovative, idea, about, the, quantization, of, energy,
     he, proposed, that, energy, was, discretized,
     into, small, intervals, or, pockets,
     which, he, called, quanta]).

% 12 — Correcta  (sustantiva + adversativa)
% "In other words, he expounded the idea that the energy
%  emitted was not a constant value, but was emitted in
%  small quantities always proportional to one value:
%  the Planck constant."
frase(12, ocm,
    [in, other, words, he, expounded, the, idea,
     that, the, energy, emitted, was, not, a, constant, value,
     but, was, emitted, in, small, quantities,
     always, proportional, to, one, value]).

% 14 — Correcta  (coord. copulativa + adverbial concesiva)
% "Planck's proposal was bold, and although it seemed to
%  explain certain phenomena, it contradicted many theories
%  then in force."
frase(14, ocm,
    ['planck''s', proposal, was, bold, and,
     although, it, seemed, to, explain, certain, phenomena,
     it, contradicted, many, theories, then, in, force]).

% 17 — Problemática  (yuxtapuestas + adjetival)
% "In this way, the Planck constant, represented by the
%  letter h, became established as one of the fundamental
%  pillars of quantum physics, playing a fundamental role
%  in the quantization of phenomena taking place in nature."
frase(17, ocm,
    [in, this, way, the, planck, constant,
     represented, by, the, letter, h,
     became, established, as, one, of,
     the, fundamental, pillars, of, quantum, physics,
     playing, a, fundamental, role,
     in, the, quantization, of, phenomena,
     taking, place, in, nature]).

% 18 — Correcta  (sustantiva + adversativa + sustantiva + adjetival)
% "Until that time, it was considered that an emission of
%  energy could have any value but, with the Planck
%  postulate, it was determined that it should always be
%  quantized into quantities which were multiple integers
%  of the constant, h."
frase(18, ocm,
    [until, that, time, it, was, considered,
     that, an, emission, of, energy, could, have, any, value,
     but, with, the, planck, postulate,
     it, was, determined, that, it, should, always,
     be, quantized, into, quantities,
     which, were, multiple, integers, of, the, constant, h]).

% 21 — Correcta  (sustantiva de complemento directo)
% "The idea of this approach states that it is impossible
%  to know with absolute precision the position and
%  momentum of a particle."
frase(21, ocm,
    [the, idea, of, this, approach, states, that,
     it, is, impossible, to, know, with, absolute, precision,
     the, position, and, momentum, of, a, particle]).

% 22 — Correcta  (adverbial comparativa)
% "In this case, the Planck constant appears as an
%  impediment, as if it were a limitation on the ability
%  to measure certain quantities accurately."
frase(22, ocm,
    [in, this, case, the, planck, constant,
     appears, as, an, impediment,
     as, if, it, were, a, limitation,
     on, the, ability, to, measure, certain, quantities,
     accurately]).

% 24 — Problemática  (sustantiva + gerundio + sustantiva)
% "For example, based on the testimony of Planck, Albert
%  Einstein proposed in 1905 a quantum explanation for the
%  photoelectric effect, betting that light hitting a metal
%  ejects electrons."
frase(24, ocm,
    [for, example, based, on, the, testimony, of, planck,
     albert, einstein, proposed, in, 1905,
     a, quantum, explanation, for, the, photoelectric, effect,
     betting, that, light, hitting, a, metal, ejects, electrons]).

% 25 — Correcta  (infinitivo + sustantiva + participio)
% "To establish this idea, Einstein used the hypothesis that
%  light is composed of particles called photons, each with
%  energy proportional to Planck's constant."
frase(25, ocm,
    [to, establish, this, idea, einstein,
     used, the, hypothesis, that,
     light, is, composed, of, particles, called, photons,
     each, with, energy, proportional, to, 'planck''s', constant]).

% 26 — Correcta  (relativa + sustantiva + gerundio)
% "It was precisely this phenomenon that managed to explain
%  that light had both wave and particle behaviors, laying
%  the foundation for the wave-particle duality."
frase(26, ocm,
    [it, was, precisely, this, phenomenon,
     that, managed, to, explain,
     that, light, had, both, wave, and, particle, behaviors,
     laying, the, foundation, for, the, 'wave-particle', duality]).

% 27 — Correcta  (adverbial + gerundio + sustantiva)
% "Likewise, in 1927, Clinton Davisson and Lester Germer
%  conducted different experiments of electron diffraction,
%  showing that they exhibited wavelike behaviors very
%  similar to light waves."
frase(27, ocm,
    [likewise, in, 1927, clinton, davisson,
     and, lester, germer,
     conducted, different, experiments,
     of, electron, diffraction,
     showing, that, they, exhibited, wavelike, behaviors,
     very, similar, to, light, waves]).

% 28 — Correcta  (relativa parentética + coord. copulativa)
% "This phenomenon, which came to be known as electron
%  diffraction, confirmed this wave-particle duality and
%  highlighted the need to consider the Planck constant as
%  an indispensable element in the study of the
%  microscopic world."
frase(28, ocm,
    [this, phenomenon, which, came, to, be, known,
     as, electron, diffraction,
     confirmed, this, 'wave-particle', duality,
     and, highlighted, the, need, to, consider,
     the, planck, constant, as, an, indispensable, element,
     in, the, study, of, the, microscopic, world]).
