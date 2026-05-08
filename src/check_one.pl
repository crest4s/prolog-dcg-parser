:- use_module(sintactico).
:- use_module(conjunto_oraciones).

run :-
    current_prolog_flag(argv, [IDA|_]),
    atom_number(IDA, ID),
    conjunto_oraciones:oracion(ID, _, _, Tokens),
    format("Tokens: ~w~n", [Tokens]),
    catch(
        call_with_time_limit(8,
            (   sintactico:parse(Trees, Tokens, [])
            ->  format("PARSED: ~w~n", [Trees]),
                sintactico:simplify(Trees, Simples),
                length(Simples, N),
                format("~w simples~n", [N]),
                forall(member(S, Simples), format("  - ~w~n", [S]))
            ;   format("FAIL~n")
            )),
        time_limit_exceeded,
        format("TIMEOUT~n")
    ).

:- initialization((run, halt)).
