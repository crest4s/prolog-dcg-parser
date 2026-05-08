:- use_module(sintactico).

run :-
    catch(
        call_with_time_limit(5,
            (   sintactico:parse(T, [in, part, it, can, be, considered, true], [])
            ->  format("S2: ~w~n", [T])
            ;   format("S2 FAIL~n")
            )),
        time_limit_exceeded,
        format("S2 TO~n")
    ),
    catch(
        call_with_time_limit(5,
            (   sintactico:parse(T2, [it, is, a, somewhat, poetic, and, romantic, phrase], [])
            ->  format("S1: ~w~n", [T2])
            ;   format("S1 FAIL~n")
            )),
        time_limit_exceeded,
        format("S1 TO~n")
    ),
    catch(
        call_with_time_limit(5,
            (   sintactico:parse(T3, [it, can, be, considered, true], [])
            ->  format("Inner: ~w~n", [T3])
            ;   format("Inner FAIL~n")
            )),
        time_limit_exceeded,
        format("Inner TO~n")
    ).

:- initialization((run, halt)).
