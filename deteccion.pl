% ===========================================================================
%  deteccion.pl  —  Detección de anomalías semánticas en el corpus
%  Requiere: semantico.pl cargado; lexico.pl cargado (vía sintactico.pl).
%
%  Predicados principales:
%    ambiguedad_lexica(+Tokens, -Info)
%        Info = lista de Palabra-[Tipo1,Tipo2,...] para cada token ambiguo.
%
%    incoherencia_semantica(+Tokens, -Info)
%        Info = lista de incoherencia(Sujeto, TipoSujeto, Verbo).
%        Detecta sujetos cuyo tipo semántico es incompatible con el
%        verbo principal (p.ej., disciplina realizando acción física).
%
%    uso_no_literal(+Tokens, -Info)
%        Info = lista de metafora(Verbo, Descripcion).
%        Detecta verbos usados fuera de su contexto habitual en física.
%
%    analizar_oracion(+Tokens)
%        Ejecuta los tres análisis e imprime los resultados.
%
%    analizar(+Id)
%        Carga la oración Id desde conjunto_oraciones.pl y la analiza.
%        Requiere conjunto_oraciones.pl consultado previamente.
% ===========================================================================

:- consult(semantico).


% ===========================================================================
%  CLASIFICACIÓN DE VERBOS
% ===========================================================================

% verbo_fisico(+Verbo)
% Verbos que denotan acción física corporal directa. Un sujeto abstracto
% o de tipo magnitud/fenómeno que aparezca antes de uno de estos verbos
% produce incoherencia semántica.

verbo_fisico(plunge).     verbo_fisico(plunges).
verbo_fisico(hit).        verbo_fisico(hitting).
verbo_fisico(eject).      verbo_fisico(ejects).
verbo_fisico(absorb).     verbo_fisico(absorbs).
verbo_fisico(strike).     verbo_fisico(strikes).
verbo_fisico(emit).       verbo_fisico(emitted).
verbo_fisico(pass).
verbo_fisico(radiate).    verbo_fisico(radiates).


% verbo_metaforico(+Verbo, +Descripcion)
% Verbos cuyo significado original es ajeno al dominio científico
% pero que se usan en el corpus en sentido figurado o idiomático.

verbo_metaforico(play,         'acción teatral/lúdica → asignación de papel funcional').
verbo_metaforico(played,       'acción teatral/lúdica → asignación de papel funcional').
verbo_metaforico(playing,      'acción teatral/lúdica → asignación de papel funcional').
verbo_metaforico(bet,          'acción de apuesta → hipótesis científica audaz').
verbo_metaforico(betting,      'acción de apuesta → hipótesis científica audaz').
verbo_metaforico(plunge,       'inmersión física → sumersión intelectual/investigadora').
verbo_metaforico(plunges,      'inmersión física → sumersión intelectual/investigadora').
verbo_metaforico(hit,          'golpe físico → incidencia de luz/partícula sobre material').
verbo_metaforico(hitting,      'golpe físico → incidencia de luz/partícula sobre material').
verbo_metaforico(lay,          'colocación física → sentar las bases (idioma)').
verbo_metaforico(laid,         'colocación física → sentar las bases (idioma)').
verbo_metaforico(laying,       'colocación física → sentar las bases (idioma)').
verbo_metaforico(govern,       'acción política → regir leyes físicas').
verbo_metaforico(governs,      'acción política → regir leyes físicas').
verbo_metaforico(grow,         'crecimiento biológico → expansión conceptual abstracta').
verbo_metaforico(grew,         'crecimiento biológico → expansión conceptual abstracta').
verbo_metaforico(stall,        'parada mecánica → estancamiento del progreso').
verbo_metaforico(stalled,      'parada mecánica → estancamiento del progreso').


% ===========================================================================
%  TIPOS INCOMPATIBLES CON ROL DE AGENTE ACTIVO
%  Sujetos de estos tipos no pueden realizar acciones físicas directas;
%  si aparecen antes de un verbo_fisico se detecta incoherencia semántica.
% ===========================================================================

tipo_no_agente(physical_quantity).
tipo_no_agente(physical_phenomenon).
tipo_no_agente(discipline).


% ===========================================================================
%  AUXILIARES PARA EXTRACCIÓN DEL SUJETO
% ===========================================================================

% tokens_preverbal(+Tokens, -PreV)
% PreV = subcadena de Tokens desde el inicio hasta (sin incluir) el primer
% token que sea verbo.  Sirve como aproximación al constituyente sujeto.

tokens_preverbal([], []).
tokens_preverbal([T|_], []) :- v(T), !.
tokens_preverbal([T|Rest], [T|R]) :- tokens_preverbal(Rest, R).


% candidatos_sujeto(+Tokens, -Cands)
% Cands = nombres (n/pron) de la zona pre-verbal que tienen tipo semántico.

candidatos_sujeto(Tokens, Cands) :-
    tokens_preverbal(Tokens, PreV),
    findall(N,
            (member(N, PreV), (n(N) ; pron(N)), tipo(N, _)),
            Cands).


% primera_pos(+Elem, +Lista, -Pos)
% Pos = índice (base 1) de la primera ocurrencia de Elem en Lista.
% Falla si Elem no está en Lista.

primera_pos(Elem, Lista, Pos) :- nth1(Pos, Lista, Elem), !.


% antes_en_lista(+X, +Y, +Lista)
% Cierto si X aparece en Lista antes que Y (comparando primera ocurrencia).

antes_en_lista(X, Y, Lista) :-
    primera_pos(X, Lista, Px),
    primera_pos(Y, Lista, Py),
    Px < Py.


% ===========================================================================
%  1. AMBIGÜEDAD LÉXICA
%     Una palabra es léxicamente ambigua si tiene más de un tipo semántico.
% ===========================================================================

% ambiguedad_lexica(+Tokens, -Resultado)
% Resultado = lista de Palabra-Tipos para cada token con N tipos > 1.
% Duplicados eliminados mediante sort/2.

ambiguedad_lexica(Tokens, Resultado) :-
    findall(Palabra-Tipos,
            (member(Palabra, Tokens),
             findall(T, tipo(Palabra, T), Tipos),
             length(Tipos, N), N > 1),
            Raw),
    sort(Raw, Resultado).


% ===========================================================================
%  2. INCOHERENCIA SEMÁNTICA
%     Se verifica si algún candidato a sujeto (zona pre-verbal, con tipo
%     no-agente) aparece antes de un verbo físico en la misma oración.
%     La ordenación posicional actúa como proxy de relación sujeto-verbo.
% ===========================================================================

% incoherencia_semantica(+Tokens, -Resultado)
% Resultado = lista de incoherencia(Sujeto, TipoSujeto, Verbo).

incoherencia_semantica(Tokens, Resultado) :-
    candidatos_sujeto(Tokens, Cands),
    findall(incoherencia(Sujeto, TipoS, Verbo),
            (member(Sujeto, Cands),
             tipo(Sujeto, TipoS),
             tipo_no_agente(TipoS),
             member(Verbo, Tokens),
             verbo_fisico(Verbo),
             antes_en_lista(Sujeto, Verbo, Tokens)),
            Raw),
    sort(Raw, Resultado).


% ===========================================================================
%  3. USO NO LITERAL / METÁFORAS
%     Detecta verbos cuyo significado originario es ajeno al dominio
%     físico y que aparecen en el corpus con uso figurado o idiomático.
% ===========================================================================

% uso_no_literal(+Tokens, -Resultado)
% Resultado = lista de metafora(Verbo, Descripcion).

uso_no_literal(Tokens, Resultado) :-
    findall(metafora(Verbo, Desc),
            (member(Verbo, Tokens),
             verbo_metaforico(Verbo, Desc)),
            Raw),
    sort(Raw, Resultado).


% ===========================================================================
%  ANÁLISIS COMPLETO
% ===========================================================================

% analizar_oracion(+Tokens)
% Ejecuta los tres análisis sobre la lista de tokens e imprime los resultados.

analizar_oracion(Tokens) :-
    ambiguedad_lexica(Tokens, Amb),
    incoherencia_semantica(Tokens, Inc),
    uso_no_literal(Tokens, Met),
    format("~n--- Análisis semántico ---~n"),
    format("Oración: ~w~n~n", [Tokens]),
    ( Amb \= []
    -> format("  [Ambigüedad léxica]~n"),
       forall(member(P-TS, Amb),
              format("    ~w  →  tipos: ~w~n", [P, TS]))
    ;  format("  [Sin ambigüedad léxica]~n")
    ),
    ( Inc \= []
    -> format("~n  [Incoherencia semántica]~n"),
       forall(member(incoherencia(S, TS, V), Inc),
              format("    Sujeto '~w' (tipo: ~w)  +  verbo físico '~w'~n", [S, TS, V]))
    ;  format("~n  [Sin incoherencia semántica]~n")
    ),
    ( Met \= []
    -> format("~n  [Uso no literal / metáfora]~n"),
       forall(member(metafora(V, Desc), Met),
              format("    '~w'  →  ~w~n", [V, Desc]))
    ;  format("~n  [Sin uso metafórico detectado]~n")
    ),
    format("~n").


% analizar(+Id)
% Recupera la oración Id de conjunto_oraciones.pl y la analiza.
% Requiere que frase/3 esté definido (consultar conjunto_oraciones.pl antes).

analizar(Id) :-
    ( current_predicate(frase/3)
    -> true
    ;  consult(conjunto_oraciones)
    ),
    frase(Id, Tipo, Tokens),
    format("~nOración ~w  [tipo sintáctico: ~w]~n", [Id, Tipo]),
    analizar_oracion(Tokens).
