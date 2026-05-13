% ===========================================================================
%  lexico.pl  —  Léxico completo del corpus (30 oraciones, física cuántica)
%  Categorías: det, pron, n, v, adj, adv, conj, prep
%  Encoding: UTF-8  (solo ASCII en este archivo)
% ===========================================================================

% ---------------------------------------------------------------------------
%  DETERMINANTES  (det)
%  Incluye artículos, demostrativos, posesivos, cuantificadores
% ---------------------------------------------------------------------------

det(the).       % artículo definido
det(a).         % artículo indefinido
det(an).        % artículo indefinido ante vocal
det(this).      % demostrativo singular
det(that).      % demostrativo / relativo como det
det(those).     % demostrativo plural
det(another).   % determinante indefinido
det(other).     % determinante "otro/otros"
det(each).      % cada
det(any).       % cualquier
det(no).        % ningún
det(both).      % ambos (también conj)
det(many).      % muchos
det(all).       % todo/todos
det(one).       % uno (también pron/n)
det(its).       % posesivo 3sg neutro
det(our).       % posesivo 1pl
det(their).     % posesivo 3pl
det(such).      % tal, semejante

% ---------------------------------------------------------------------------
%  PRONOMBRES  (pron)
% ---------------------------------------------------------------------------

pron(it).       % pronombre sujeto/objeto 3sg neutro
pron(they).     % pronombre sujeto 3pl
pron(he).       % pronombre sujeto 3sg masc
pron(you).      % pronombre sujeto 2a persona
pron(which).    % pronombre relativo (también conj)
pron(who).      % pronombre relativo personal
pron(what).     % pronombre relativo / wh-word
pron(itself).   % reflexivo 3sg neutro
pron(those).    % pronombre demostrativo plural
pron(this).     % pronombre demostrativo singular
pron(one).      % pronombre indefinido
pron(there).    % expletivo existencial ("there is")
pron(them).     % pronombre objeto 3pl

% ---------------------------------------------------------------------------
%  NOMBRES COMUNES  (n)
%  Incluye sustantivos en singular y plural, y nombres propios
% ---------------------------------------------------------------------------

% A
n(ability).         % capacidad
n(acceptance).      % aceptación
n(anxiety).         % inquietud
n(anxieties).       % inquietudes (plural)
n(approach).        % planteamiento / enfoque
n(approaches).      % planteamientos (plural)

% B
n(barrier).         % barrera
n(barriers).        % barreras (plural)
n(behavior).        % comportamiento
n(behaviors).       % comportamientos (plural)
n(body).            % cuerpo (black body)
n(breakthrough).    % avance, descubrimiento
n(breakthroughs).   % avances (plural)

% C
n(case).            % caso
n(century).         % siglo
n(conception).      % concepción
n(constant).        % constante (también adj)
n(context).         % contexto

% D
n(diffraction).     % difracción
n(dilemma).         % dilema
n(dilemmas).        % dilemas (plural)
n(discipline).      % disciplina
n(duality).         % dualidad

% E
n(effect).          % efecto
n(element).         % elemento
n(electron).        % electrón
n(electrons).       % electrones (plural)
n(emission).        % emisión
n(energy).          % energía
n(era).             % era, época
n(example).         % ejemplo
n(experiment).      % experimento
n(experiments).     % experimentos (plural)
n(explanation).     % explicación
n(eye).             % ojo
n(eyes).            % ojos (plural)

% F
n(force).           % fuerza / vigencia ("in force")
n(formulation).     % formulación
n(foundation).      % base, fundamento

% G
n(general).         % general (también adj)
n(groundwork).      % base, fundamento

% H
n(h).               % símbolo de la constante de Planck
n(hypothesis).      % hipótesis

% I
n(idea).            % idea
n(impediment).      % impedimento
n(importance).      % importancia
n(integer).         % entero (número)
n(integers).        % enteros (plural)
n(interval).        % intervalo
n(intervals).       % intervalos (plural)
n(invention).       % invención

% J
n(joule).           % julio (unidad)
n(joules).          % julios (plural)

% K
n(key).             % llave, clave

% L
n(law).             % ley
n(laws).            % leyes (plural)
n(letter).          % letra
n(light).           % luz (también adj ante n)
n(limitation).      % limitación

% M
n(mechanics).       % mecánica (quantum mechanics)
n(metal).           % metal
n(microscope).      % microscopio
n(momentum).        % momento (cantidad de movimiento)
n(multiple).        % múltiplo (también adj)
n(multiples).       % múltiplos (plural)

% N
n(nature).          % naturaleza
n(need).            % necesidad

% O
n(object).          % objeto
n(order).           % orden ("in order to")

% P
n(part).            % parte
n(particle).        % partícula
n(particles).       % partículas (plural)
n(perception).      % percepción
n(phenomenon).      % fenómeno
n(phenomena).       % fenómenos (plural)
n(photon).          % fotón
n(photons).         % fotones (plural)
n(phrase).          % frase
n(physicist).       % físico (persona)
n(physicists).      % físicos (plural)
n(physics).         % física (ciencia)
n(pillar).          % pilar
n(pillars).         % pilares (plural)
n(place).           % lugar ("taking place")
n(pocket).          % bolsa, paquete (energy pocket)
n(pockets).         % bolsas (plural)
n(position).        % posición
n(postulate).       % postulado
n(precision).       % precisión
n(presence).        % presencia
n(principle).       % principio
n(problem).         % problema
n(progress).        % progreso
n(protagonist).     % protagonista
n(proposal).        % propuesta

% Q
n(quanta).          % cuantos (plural técnico de quantum)
n(quantization).    % cuantización
n(quantity).        % cantidad
n(quantities).      % cantidades (plural)

% R
n(radiation).       % radiación
n(reality).         % realidad
n(research).        % investigación
n(role).            % papel, rol

% S
n(scientist).       % científico
n(scientists).      % científicos (plural)
n(second).          % segundo (unidad de tiempo)
n(study).           % estudio
n(system).          % sistema

% T
n(testimony).       % testimonio
n(theory).          % teoría
n(theories).        % teorías (plural)
n(time).            % tiempo, época
n(tunnel).          % túnel (también adj)

% U
n(uncertainty).     % incertidumbre (también adj ante n)
n(unit).            % unidad
n(units).           % unidades (plural)

% V
n(value).           % valor

% W
n(wave).            % onda
n(waves).           % ondas (plural)
n(way).             % forma, manera ("in this way")
n(word).            % palabra
n(words).           % palabras (plural)
n(work).            % trabajo, obra
n(world).           % mundo

% --- Nombres propios (tratados como n) ---
n(planck).      % Max Planck
n(heisenberg).  % Werner Heisenberg
n(einstein).    % Albert Einstein
n(bohr).        % Niels Bohr
n(max).         % (nombre de pila)
n(albert).      % (nombre de pila)
n(niels).       % (nombre de pila)
n(werner).      % (nombre de pila)
n(clinton).     % Clinton Davisson
n(davisson).    % (apellido)
n(lester).      % Lester Germer
n(germer).      % (apellido)

% --- Formas posesivas (átomos con apóstrofe) ---
n('planck''s').   % "Planck's" — posesivo sajón
n('quantum''s').  % "quantum's" — posesivo sajón

% --- Años y números del corpus ---
n('1900').          % año de presentación de la constante
n('1905').          % año del efecto fotoeléctrico (Einstein)
n('1927').          % año de experimentos Davisson-Germer
n('1981').          % año del microscopio de efecto túnel

% --- Símbolos y expresiones especiales ---
n('20th').          % ordinal: "the early 20th century"
n('6.626x10-34').   % valor numérico de la constante de Planck
n('wave-particle'). % compuesto con guion: "wave-particle duality"

% ---------------------------------------------------------------------------
%  VERBOS  (v)  —  todas las formas del corpus (base + inflexiones)
% ---------------------------------------------------------------------------

% Verbo BE (cópula y auxiliar)
v(be).   v(is).   v(are).   v(was).   v(were).   v(been).

% Verbo HAVE (auxiliar y principal)
v(have). v(has).  v(had).

% Verbos modales
v(can).    v(could).  v(should).  v(may).  v(might).  v(will).  v(would).

% Auxiliar DO (negaciones y énfasis)
v(do).   v(does).   v(did).

% Verbos principales — forma base + formas del corpus
v(absorb).      v(absorbs).                      % absorber
v(act).         v(acts).                         % actuar
v(appear).      v(appears).                      % aparecer
v(base).        v(based).                        % basar ("based on")
v(become).      v(became).                       % convertirse en
v(begin).       v(began).                        % comenzar
v(bet).         v(betting).                      % apostar (gerundio en corpus)
v(call).        v(called).                       % llamar
v(challenge).   v(challenges).                   % desafiar
v(come).        v(came).                         % venir, llegar a ser
v(compose).     v(composed).                     % componer, estar compuesto
v(confirm).     v(confirmed).                    % confirmar
v(consider).    v(considered).  v(considers).    % considerar
v(consolidate). v(consolidated).                 % consolidar
v(contradict).  v(contradicted).                 % contradecir
v(contribute).  v(contributed).                  % contribuir
v(conduct).     v(conducted).                    % llevar a cabo (experimentos)
v(deduce).      v(deduced).                      % deducir
v(determine).   v(determined).                   % determinar
v(discretize).  v(discretized).                  % discretizar
v(eject).       v(ejects).                       % expulsar, arrancar (electrones)
v(emit).        v(emitted).                      % emitir
v(establish).   v(established).                  % establecer
v(exhibit).     v(exhibited).                    % exhibir, mostrar
v(exist).       v(exists).      v(existed).      % existir
v(explain).     v(explained).                    % explicar
v(expound).     v(expounded).                    % exponer (una idea)
v(find).        v(found).                        % encontrar
v(give).        v(gave).                         % dar
v(govern).      v(governs).                      % gobernar, regir
v(grow).        v(grew).                         % crecer
v(hear).        v(heard).                        % oír
v(highlight).   v(highlighted).                  % resaltar
v(hit).         v(hitting).                      % golpear (gerundio)
v(introduce).   v(introduced).                   % introducir
v(know).        v(knew).        v(known).        % conocer, saber
v(lay).         v(laid).        v(laying).       % sentar (las bases)
v(manage).      v(manages).     v(managed).      % lograr, conseguir
v(make).        v(made).                         % hacer, causar (causativa)
v(manifest).    v(manifested).                   % manifestarse
v(measure).     v(measured).                     % medir
v(name).        v(named).                        % nombrar, llamar
v(observe).     v(observed).                     % observar
v(pass).        v(passed).                       % pasar (a través de)
v(play).        v(played).      v(playing).      % desempeñar (un papel)
v(plunge).      v(plunges).                      % sumergir
v(possess).     v(possesses).   v(possessed).    % poseer
v(present).     v(presented).                    % presentar
v(propose).     v(proposed).                     % proponer
v(quantify).    v(quantified).                   % cuantificar
v(quantize).    v(quantized).                    % cuantizar
v(radiate).     v(radiates).                     % irradiar
v(relate).      v(related).                      % relacionar
v(represent).   v(represented).                  % representar
v(say).         v(said).                         % decir
v(seem).        v(seemed).                       % parecer
v(show).        v(showed).      v(showing).      % mostrar (gerundio)
v(solve).       v(solved).                       % resolver
v(stall).       v(stalled).                      % estancarse
v(state).       v(states).      v(stated).       % establecer, afirmar
v(strike).      v(strikes).                      % incidir sobre
v(take).        v(taking).                       % tomar (gerundio: "taking place")
v(use).         v(used).                         % usar

% Gerundios con función nominal/adjetival en el corpus
v(understanding).  % "to understanding this miniature world"
v(formulating).    % "in formulating another of..."

% ---------------------------------------------------------------------------
%  ADJETIVOS  (adj)
% ---------------------------------------------------------------------------

adj(able).           % capaz
adj(absolute).       % absoluto
adj(black).          % negro (black body)
adj(bold).           % atrevido, audaz
adj(certain).        % cierto, determinado
adj(characteristic). % característico
adj(coherent).       % coherente
adj(complete).       % completo
adj(constant).       % constante (también n)
adj(deduced).        % deducido (participio adj)
adj(different).      % diferente
adj(early).          % temprano, de principios de
adj(efficient).      % eficiente
adj(emitted).        % emitida (participio adj)
adj(essential).      % esencial
adj(established).    % establecido (participio adj)
adj(exact).          % exacto ("to be exact")
adj(forbidden).      % prohibido (classically forbidden)
adj(fundamental).    % fundamental
adj(general).        % general (también n)
adj(great).          % grande, importante
adj(immediate).      % inmediato ("far from immediate")
adj(important).      % importante
adj(impossible).     % imposible
adj(indispensable).  % indispensable
adj(innovative).     % innovador
adj(international).  % internacional
adj(known).          % conocido (participio adj: "known as")
adj(light).          % luminoso (ante n, p.ej. "light waves")
adj(many).           % cuantificador: "a great many of"
adj(master).         % maestro, principal ("master key")
adj(microscopic).    % microscópico
adj(miniature).      % en miniatura
adj(multiple).       % multiple (también n)
adj(new).            % nuevo
adj(observed).       % observado (participio adj)
adj(other).          % otro
adj(perceptible).    % perceptible
adj(perplexing).     % desconcertante
adj(photoelectric).  % fotoeléctrico
adj(poetic).         % poético
adj(proportional).   % proporcional
adj(quantum).        % cuántico (también n)
adj(related).        % relacionado (participio adj)
adj(represented).    % representado (participio adj)
adj(revolutionary).  % revolucionario
adj(romantic).       % romántico
adj(similar).        % similar
adj(small).          % pequeño
adj(subatomic).      % subatómico
adj(such).           % tal, semejante (también det)
adj(theoretical).    % teórico
adj(true).           % verdadero, cierto
adj(tunnel).         % de túnel (también n)
adj(usual).          % habitual, usual
adj(wavelike).       % ondulatorio, de tipo onda

% ---------------------------------------------------------------------------
%  ADVERBIOS  (adv)
% ---------------------------------------------------------------------------

adv(accurately).   % con precisión
adv(also).         % también
adv(always).       % siempre
adv(classically).  % clásicamente
adv(completely).   % completamente
adv(definitively). % definitivamente
adv(directly).     % directamente
adv(eventually).   % eventualmente, finalmente
adv(far).          % lejos ("far from immediate")
adv(finally).      % finalmente
adv(first).        % primero, por primera vez
adv(fortunately).  % afortunadamente
adv(however).      % sin embargo
adv(likewise).     % asimismo, igualmente
adv(not).          % negación
adv(often).        % a menudo
adv(only).         % solo, únicamente
adv(precisely).    % precisamente
adv(so).           % tan ("so small")
adv(somewhat).     % algo, un tanto
adv(surely).       % seguramente
adv(then).         % entonces, en ese momento
adv(there).        % ahí; expletivo existencial ("there is")
adv(very).         % muy
adv(well).         % bien; marcador discursivo
adv(where).        % donde (también conj relativo)

% ---------------------------------------------------------------------------
%  CONJUNCIONES  (conj)
%  Incluye coordinantes, subordinantes y pronombres relativos conjuntivos
% ---------------------------------------------------------------------------

conj(although).  % aunque (subordinante concesiva)
conj(and).       % y (coordinante copulativa)
conj(as).        % como, a medida que (también prep)
conj(both).      % ambos — "both ... and" (también det)
conj(but).       % pero (coordinante adversativa)
conj(if).        % si (subordinante condicional)
conj(or).        % o (coordinante disyuntiva)
conj(since).     % desde que / puesto que (también prep)
conj(that).      % que (subordinante sustantiva / relativo)
conj(which).     % que / el cual (relativo; también pron)
conj(who).       % quien / que (relativo personal; también pron)
conj(where).     % donde (relativo de lugar; también adv)

% ---------------------------------------------------------------------------
%  PREPOSICIONES  (prep)
% ---------------------------------------------------------------------------

prep(about).      % sobre, acerca de
prep(according).  % según — siempre con "to": "according to"
prep(after).      % después de, en honor a
prep(as).         % como (también conj)
prep(at).         % en, a (tiempo/lugar)
prep(by).         % por (agente en pasiva; mediante)
prep(during).     % durante
prep(for).        % para, por
prep(from).       % de, desde
prep(in).         % en
prep(into).       % en, dentro de (con movimiento)
prep(of).         % de (genitivo)
prep(on).         % sobre, en
prep(per).        % por (división: "joules per second")
prep(since).      % desde (también conj)
prep(through).    % a través de
prep(to).         % a, hacia; partícula de infinitivo
prep(until).      % hasta
prep(with).       % con
prep(without).    % sin
