% ===========================================================================
%  semantico.pl  —  Categorías semánticas del corpus (física cuántica)
%  Formato: tipo(+Palabra, ?CategoriaSemantica)
%
%  Una misma palabra puede tener más de un hecho tipo/2 si es ambigua.
%  Las palabras ambiguas están marcadas con el comentario % (*)
%
%  Categorías utilizadas:
%    physical_quantity   — magnitudes físicas medibles
%    physical_object     — entidades físicas tangibles
%    physical_phenomenon — fenómenos y procesos físicos
%    abstract_concept    — ideas, teorías, principios, relaciones abstractas
%    person              — personas y nombres propios
%    discipline          — campos del conocimiento científico
%    measurement_unit    — unidades de medida
%    symbolic            — símbolos y expresiones formales
%    time_period         — períodos temporales
%    time_point          — instantes o años concretos
%    place               — conceptos espaciales o entornos
% ===========================================================================


% ---------------------------------------------------------------------------
%  MAGNITUDES FÍSICAS  (physical_quantity)
% ---------------------------------------------------------------------------

tipo(energy,         physical_quantity).
tipo(momentum,       physical_quantity).
tipo(value,          physical_quantity).
tipo(quantity,       physical_quantity).
tipo(quantities,     physical_quantity).
tipo(integer,        physical_quantity).
tipo(integers,       physical_quantity).
tipo(interval,       physical_quantity).
tipo(intervals,      physical_quantity).
tipo('6.626x10-34',  physical_quantity).
tipo(constant,       physical_quantity).  % (*)  también abstract_concept
tipo(force,          physical_quantity).  % (*)  también abstract_concept ("in force")
tipo(h,              physical_quantity).  % (*)  también symbolic
tipo(multiple,       physical_quantity).  % (*)  también abstract_concept
tipo(multiples,      physical_quantity).  % (*)  también abstract_concept
tipo(position,       physical_quantity).  % (*)  también abstract_concept
tipo(precision,      physical_quantity).  % (*)  también abstract_concept
tipo(radiation,      physical_quantity).  % (*)  también physical_phenomenon
tipo(pocket,         physical_quantity).  % (*)  bolsas de energía cuántica; también place
tipo(pockets,        physical_quantity).  % (*)  también place


% ---------------------------------------------------------------------------
%  OBJETOS FÍSICOS  (physical_object)
% ---------------------------------------------------------------------------

tipo(particle,   physical_object).
tipo(particles,  physical_object).
tipo(photon,     physical_object).
tipo(photons,    physical_object).
tipo(electron,   physical_object).
tipo(electrons,  physical_object).
tipo(metal,      physical_object).
tipo(body,       physical_object).    % "cuerpo negro" (black body)
tipo(object,     physical_object).
tipo(microscope, physical_object).
tipo(barrier,    physical_object).
tipo(barriers,   physical_object).
tipo(eye,        physical_object).
tipo(eyes,       physical_object).
tipo(light,      physical_object).    % (*)  también physical_phenomenon
tipo(wave,       physical_object).    % (*)  también physical_phenomenon
tipo(waves,      physical_object).    % (*)  también physical_phenomenon
tipo(element,    physical_object).    % (*)  también abstract_concept
tipo(key,        physical_object).    % (*)  también abstract_concept ("master key")
tipo(pillar,     physical_object).    % (*)  también abstract_concept (metáfora)
tipo(pillars,    physical_object).    % (*)  también abstract_concept (metáfora)
tipo(system,     physical_object).    % (*)  también abstract_concept ("Sistema Internacional")


% ---------------------------------------------------------------------------
%  FENÓMENOS FÍSICOS  (physical_phenomenon)
% ---------------------------------------------------------------------------

tipo(diffraction,  physical_phenomenon).
tipo(emission,     physical_phenomenon).
tipo(quantization, physical_phenomenon).
tipo(quantum,      physical_phenomenon).
tipo(quanta,       physical_phenomenon).
tipo(phenomenon,   physical_phenomenon).
tipo(phenomena,    physical_phenomenon).
tipo(radiation,    physical_phenomenon).  % (*)  también physical_quantity
tipo(duality,      physical_phenomenon).  % (*)  también abstract_concept
tipo(effect,       physical_phenomenon).  % (*)  también abstract_concept ("in effect")
tipo(light,        physical_phenomenon).  % (*)  también physical_object
tipo(wave,         physical_phenomenon).  % (*)  también physical_object
tipo(waves,        physical_phenomenon).  % (*)  también physical_object
tipo(tunnel,       physical_phenomenon).  % (*)  efecto túnel; también place


% ---------------------------------------------------------------------------
%  CONCEPTOS ABSTRACTOS  (abstract_concept)
% ---------------------------------------------------------------------------

tipo(constant,      abstract_concept).  % (*)
tipo(force,         abstract_concept).  % (*)  "in force" = "en vigor"
tipo(multiple,      abstract_concept).  % (*)
tipo(multiples,     abstract_concept).  % (*)
tipo(position,      abstract_concept).  % (*)  posición / postura
tipo(precision,     abstract_concept).  % (*)
tipo(duality,       abstract_concept).  % (*)
tipo(effect,        abstract_concept).  % (*)
tipo(element,       abstract_concept).  % (*)
tipo(key,           abstract_concept).  % (*)  "master key" — metáfora
tipo(pillar,        abstract_concept).  % (*)  "pillar of science" — metáfora
tipo(pillars,       abstract_concept).  % (*)
tipo(system,        abstract_concept).  % (*)
tipo(idea,          abstract_concept).
tipo(hypothesis,    abstract_concept).
tipo(theory,        abstract_concept).
tipo(theories,      abstract_concept).
tipo(principle,     abstract_concept).
tipo(approach,      abstract_concept).
tipo(approaches,    abstract_concept).
tipo(law,           abstract_concept).
tipo(laws,          abstract_concept).
tipo(conception,    abstract_concept).
tipo(perception,    abstract_concept).
tipo(reality,       abstract_concept).
tipo(dilemma,       abstract_concept).
tipo(dilemmas,      abstract_concept).
tipo(behavior,      abstract_concept).
tipo(behaviors,     abstract_concept).
tipo(ability,       abstract_concept).
tipo(postulate,     abstract_concept).
tipo(proposal,      abstract_concept).
tipo(formulation,   abstract_concept).
tipo(explanation,   abstract_concept).
tipo(role,          abstract_concept).
tipo(importance,    abstract_concept).
tipo(need,          abstract_concept).
tipo(limitation,    abstract_concept).
tipo(impediment,    abstract_concept).
tipo(uncertainty,   abstract_concept).
tipo(acceptance,    abstract_concept).
tipo(anxiety,       abstract_concept).
tipo(anxieties,     abstract_concept).
tipo(breakthrough,  abstract_concept).
tipo(breakthroughs, abstract_concept).
tipo(research,      abstract_concept).
tipo(study,         abstract_concept).
tipo(progress,      abstract_concept).
tipo(foundation,    abstract_concept).
tipo(groundwork,    abstract_concept).
tipo(testimony,     abstract_concept).
tipo(problem,       abstract_concept).
tipo(case,          abstract_concept).
tipo(context,       abstract_concept).
tipo(example,       abstract_concept).
tipo(phrase,        abstract_concept).
tipo(word,          abstract_concept).
tipo(words,         abstract_concept).
tipo(work,          abstract_concept).
tipo(order,         abstract_concept).
tipo(part,          abstract_concept).
tipo(place,         abstract_concept).
tipo(way,           abstract_concept).
tipo(general,       abstract_concept).
tipo(experiment,    abstract_concept).
tipo(experiments,   abstract_concept).
tipo(presence,      abstract_concept).
tipo(invention,     abstract_concept).
tipo(era,           abstract_concept).    % (*)  también time_period
tipo(nature,        abstract_concept).    % (*)  también place
tipo(world,         abstract_concept).    % (*)  también place
tipo('quantum''s',  abstract_concept).    % posesivo: "quantum's approaches"
tipo('wave-particle', abstract_concept).  % compuesto: "wave-particle duality"


% ---------------------------------------------------------------------------
%  PERSONAS  (person)
% ---------------------------------------------------------------------------

tipo(physicist,    person).
tipo(physicists,   person).
tipo(scientist,    person).
tipo(scientists,   person).
tipo(protagonist,  person).   % metáfora: la constante como "protagonista"
tipo(planck,       person).
tipo(einstein,     person).
tipo(heisenberg,   person).
tipo(bohr,         person).
tipo(max,          person).
tipo(albert,       person).
tipo(niels,        person).
tipo(werner,       person).
tipo(clinton,      person).
tipo(lester,       person).
tipo(davisson,     person).
tipo(germer,       person).
tipo('planck''s',  person).   % posesivo sajón: referencia a la persona Planck


% ---------------------------------------------------------------------------
%  DISCIPLINAS  (discipline)
% ---------------------------------------------------------------------------

tipo(physics,    discipline).
tipo(mechanics,  discipline).
tipo(discipline, discipline).


% ---------------------------------------------------------------------------
%  UNIDADES DE MEDIDA  (measurement_unit)
% ---------------------------------------------------------------------------

tipo(joule,   measurement_unit).
tipo(joules,  measurement_unit).
tipo(unit,    measurement_unit).
tipo(units,   measurement_unit).
tipo(second,  measurement_unit).  % (*)  también time_period


% ---------------------------------------------------------------------------
%  SIMBÓLICO / FORMAL  (symbolic)
% ---------------------------------------------------------------------------

tipo(h,             symbolic).   % (*)  también physical_quantity
tipo(letter,        symbolic).
tipo('6.626x10-34', symbolic).   % también physical_quantity


% ---------------------------------------------------------------------------
%  PERÍODOS TEMPORALES  (time_period / time_point)
% ---------------------------------------------------------------------------

tipo(century, time_period).
tipo(time,    time_period).
tipo(era,     time_period).   % (*)  también abstract_concept
tipo(second,  time_period).   % (*)  también measurement_unit
tipo('20th',  time_period).

tipo(1900,    time_point).
tipo(1905,    time_point).
tipo(1927,    time_point).
tipo(1981,    time_point).


% ---------------------------------------------------------------------------
%  LUGARES / ENTORNOS  (place)
% ---------------------------------------------------------------------------

tipo(world,   place).   % (*)  también abstract_concept
tipo(nature,  place).   % (*)  también abstract_concept
tipo(tunnel,  place).   % (*)  también physical_phenomenon
tipo(pocket,  place).   % (*)  también physical_quantity
tipo(pockets, place).   % (*)  también physical_quantity
