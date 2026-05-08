% Verifica las 30 oraciones con timeout corto, una línea por oración.
:- use_module(sintactico).
:- use_module(conjunto_oraciones).

run_all :-
    findall(ID, conjunto_oraciones:oracion(ID,_,_,_), IDs),
    forall(member(ID, IDs), check_one(ID)).

check_one(ID) :-
    conjunto_oraciones:oracion(ID, _, _, Tokens),
    catch(
        call_with_time_limit(5,
            (   sintactico:parse(Trees, Tokens, [])
            ->  sintactico:simplify(Trees, Simples),
                length(Simples, N),
                format("S~w OK (~w simples)~n", [ID, N])
            ;   format("S~w FAIL~n", [ID])
            )),
        time_limit_exceeded,
        format("S~w TIMEOUT~n", [ID])
    ),
    flush_output.

:- initialization((run_all, halt)).
