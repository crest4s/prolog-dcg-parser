#!/usr/bin/env bash
# run_tests.sh — Ejecuta los 30 tests de parsing DCG del corpus

set -euo pipefail

if ! command -v swipl &>/dev/null; then
    echo "ERROR: 'swipl' no encontrado en el PATH. Instala SWI-Prolog."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROLOG_TMP="$SCRIPT_DIR/.run_tests_tmp.pl"

cleanup() { rm -f "$PROLOG_TMP"; }
trap cleanup EXIT

cat > "$PROLOG_TMP" << 'PROLOG'
:- use_module(library(lists)).
:- use_module(library(time)).
:- use_module(library(apply)).

:- consult(sintactico).

test( 1, [this,constant,played,an,essential,role,in,the,formulation,of,another,of,the,great,quantum,approaches]).
test( 2, [it,is,often,said,that,quantum,physics,is,a,discipline,that,challenges,the,perception,of,reality]).
test( 3, [well,although,it,is,a,somewhat,poetic,and,romantic,phrase,in,part,it,can,be,considered,true]).
test( 4, [quantum,physics,is,what,governs,the,behavior,of,subatomic,particles,those,so,small,that,they,are,not,perceptible,to,our,eyes,and,their,study,often,plunges,scientists,into,research,where,the,usual,laws,do,not,exist]).
test( 5, [in,this,context,there,is,a,protagonist,which,you,have,surely,heard,of,that,acts,as,a,master,key,to,understanding,this,miniature,world]).
test( 6, [named,after,the,physicist,who,introduced,it,max,planck,the,constant,was,first,named,in,the,early,'20th',century]).
test( 7, [in,a,completely,revolutionary,work,planck,was,not,only,finally,able,to,explain,a,great,many,of,the,anxieties,of,the,time,but,also,laid,the,groundwork,for,a,new,era,in,physics]).
test( 8, [since,the,early,'20th',century,progress,in,physics,seemed,to,have,stalled]).
test( 9, [scientists,began,to,find,perplexing,dilemmas,that,they,could,not,explain,and,for,which,there,were,no,coherent,and,efficient,laws]).
test(10, [one,such,problem,was,radiation,from,the,black,body,that,is,an,object,that,absorbs,all,of,the,radiation,that,strikes,it,but,radiates,a,quantity,of,energy,characteristic,of,it]).
test(11, [in,order,to,solve,this,phenomenon,max,planck,presented,in,'1900',an,innovative,idea,about,the,quantization,of,energy,he,proposed,that,energy,was,discretized,into,small,intervals,or,pockets,which,he,called,quanta]).
test(12, [in,other,words,he,expounded,the,idea,that,the,energy,emitted,was,not,a,constant,value,but,was,emitted,in,small,quantities,always,proportional,to,one,value]).
test(13, [however,acceptance,of,this,idea,was,far,from,immediate]).
test(14, ['planck''s',proposal,was,bold,and,although,it,seemed,to,explain,certain,phenomena,it,contradicted,many,theories,then,in,force]).
test(15, [fortunately,other,physicists,of,great,importance,at,the,time,such,as,albert,einstein,niels,bohr,or,werner,heisenberg,contributed,to,other,fundamental,breakthroughs,that,eventually,consolidated,'planck''s',theory]).
test(16, [in,general,'wave-particle',duality,the,uncertainty,principle,and,quantum,mechanics,were,the,pillars,that,made,this,new,conception,of,the,microscopic,world,grow]).
test(17, [in,this,way,the,planck,constant,represented,by,the,letter,h,became,established,as,one,of,the,fundamental,pillars,of,quantum,physics,playing,a,fundamental,role,in,the,quantization,of,phenomena,taking,place,in,nature]).
test(18, [until,that,time,it,was,considered,that,an,emission,of,energy,could,have,any,value,but,with,the,planck,postulate,it,was,determined,that,it,should,always,be,quantized,into,quantities,which,were,multiple,integers,of,the,constant,h]).
test(19, [to,be,exact,its,value,is,'6.626x10-34',joules,per,second,according,to,the,international,system,of,units]).
test(20, [likewise,the,planck,constant,also,played,an,essential,role,in,formulating,another,of,'quantum''s',great,approaches]).
test(21, [the,idea,of,this,approach,states,that,it,is,impossible,to,know,with,absolute,precision,the,position,and,momentum,of,a,particle]).
test(22, [in,this,case,the,planck,constant,appears,as,an,impediment,as,if,it,were,a,limitation,on,the,ability,to,measure,certain,quantities,accurately]).
test(23, [its,presence,deduced,in,a,theoretical,way,manages,to,give,explanation,and,manifest,itself,through,quantum,phenomena,observed,in,different,experiments,which,definitively,consolidated,its,importance]).
test(24, [for,example,based,on,the,testimony,of,planck,albert,einstein,proposed,in,1905,a,quantum,explanation,for,the,photoelectric,effect,betting,that,light,hitting,a,metal,ejects,electrons]).
test(25, [to,establish,this,idea,einstein,used,the,hypothesis,that,light,is,composed,of,particles,called,photons,each,with,energy,proportional,to,'planck''s',constant]).
test(26, [it,was,precisely,this,phenomenon,that,managed,to,explain,that,light,had,both,wave,and,particle,behaviors,laying,the,foundation,for,the,'wave-particle',duality]).
test(27, [likewise,in,1927,clinton,davisson,and,lester,germer,conducted,different,experiments,of,electron,diffraction,showing,that,they,exhibited,wavelike,behaviors,very,similar,to,light,waves]).
test(28, [this,phenomenon,which,came,to,be,known,as,electron,diffraction,confirmed,this,'wave-particle',duality,and,highlighted,the,need,to,consider,the,planck,constant,as,an,indispensable,element,in,the,study,of,the,microscopic,world]).
test(29, [also,in,1981,it,played,a,very,important,role,during,the,invention,of,the,tunnel,effect,microscope]).
test(30, [this,is,a,phenomenon,in,which,particles,are,able,to,pass,through,classically,forbidden,energy,barriers,which,is,directly,related,to,the,energy,they,possess,quantified,in,multiples,of,the,planck,constant]).

:- dynamic ok_count/1, ko_count/1.
ok_count(0).
ko_count(0).

pad(N, Str) :-
    ( N < 10 -> format(atom(Str), "0~w", [N]) ; format(atom(Str), "~w", [N]) ).

run_test(N) :-
    test(N, Tokens),
    pad(N, P),
    (   catch(call_with_time_limit(15, oracion(_, Tokens, [])), _, fail)
    ->  retract(ok_count(C)), C1 is C+1, assertz(ok_count(C1)),
        format("  OR. ~w  OK~n", [P])
    ;   retract(ko_count(C)), C1 is C+1, assertz(ko_count(C1)),
        format("  OR. ~w  FAIL~n", [P])
    ).

:- initialization(main, main).

main :-
    format("~n========================================~n"),
    format("  DCG Parse Tests — Corpus (30 or.)~n"),
    format("========================================~n~n"),
    numlist(1, 30, Ns),
    maplist(run_test, Ns),
    ok_count(OK), ko_count(KO),
    Total is OK + KO,
    format("~n----------------------------------------~n"),
    format("  RESULTADO: ~w/~w OK  |  ~w FAIL~n", [OK, Total, KO]),
    format("========================================~n~n"),
    halt(0).
PROLOG

cd "$SCRIPT_DIR"
swipl --quiet "$PROLOG_TMP"
