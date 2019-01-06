%:- module(stats,[]).

:-use_module(library(sgml)).
:-use_module(library(xpath)).

:- dynamic commit/4, rev/5, revy/4, aggy/4, revm/4, aggm/4, revq/4, aggq/4.

cvs_stats_file('repo-statistics.xml').
svn_log_file('vokosvn-log.xml').

stats_dos('revo_dos.dat').
stats_lin('revo_lin.dat').
stats_dos_lin('revo_dos_lin.dat').

stats_svn_jar('voko_svn_jar.dat').
stats_svn_qua('voko_svn_qua.dat').
stats_svn_mon('voko_svn_mon.dat').

cvs :-
    load_cvs_commits,
    write_stats_dos_lin.

svn :-
    load_svn_revs,
    write_stats_svn_years,
    write_stats_svn_quarters.

load_cvs_commits :-
    load_cvs_stats(DOM),
    retractall(commit(_,_,_,_)),
    forall(
        commit(DOM,Date,Auth,DeltaFiles,DeltaLines),
        assertz(commit(Date,Auth,DeltaFiles,DeltaLines))
    ).

load_svn_revs :-
    load_svn_log(DOM),
    retractall(rev(_,_,_,_,_)),
    forall(
        revision(DOM,Date,Rev,DeltaFiles,ChangedFiles,ChangesByModule),
        asserta(rev(Date,Rev,DeltaFiles,ChangedFiles,ChangesByModule))
    ),
    agg_revs_by_year,
    agg_revs_by_month,
    agg_revs_by_quarter.

agg_revs_by_year :-
    retractall(revy(_,_,_,_)),
    retractall(aggy(_,_,_,_)),
    forall(
        rev(Date,_,DF,CF,CM),
        (
            sub_atom(Date,0,4,_,Year),
            assertz(revy(Year,DF,CF,CM))
        )
    ),
    rev_years(Years),
    maplist(agg_rev_year,Years).


agg_rev_year(Year) :-
    findall(DF-CF-CM,revy(Year,DF,CF,CM),List),
    foldl(sum_rev,List,0-0-_{},DFyear-CFyear-CMyear),
    assertz(aggy(Year,DFyear,CFyear,CMyear)).

agg_revs_by_quarter :-
    retractall(revq(_,_,_,_)),
    retractall(aggq(_,_,_,_)),
    forall(
        rev(Date,_,DF,CF,CM),
        (
            sub_atom(Date,0,4,_,Y),
            sub_atom(Date,5,2,_,M),
            atom_number(M,M_),
            Q is M_ - ((M_-1) mod 3),
            format(atom(Quarter),'~w-~|~`0t~d~2+',[Y,Q]),
            assertz(revq(Quarter,DF,CF,CM))
        )
    ),
    rev_quarters(Qs),
    maplist(agg_rev_quarter,Qs).

agg_rev_quarter(Qu) :-
    findall(DF-CF-CM,revq(Qu,DF,CF,CM),List),
    foldl(sum_rev,List,0-0-_{},DFq-CFq-CMq),
    assertz(aggq(Qu,DFq,CFq,CMq)).

agg_revs_by_month :-
    retractall(revy(_,_,_,_)),
    retractall(aggy(_,_,_,_)),
    forall(
        rev(Date,_,DF,CF,CM),
        (
            sub_atom(Date,0,7,_,Month),
            assertz(revm(Month,DF,CF,CM))
        )
    ),
    rev_months(Months),
    maplist(agg_rev_month,Months).

agg_rev_month(Month) :-
    findall(DF-CF-CM,revm(Month,DF,CF,CM),List),
    foldl(sum_rev,List,0-0-_{},DFmonth-CFmonth-CMmonth),
    assertz(aggm(Month,DFmonth,CFmonth,CMmonth)).

sum_rev(DF-CF-CM,DF0-CF0-CM0,DF1-CF1-CM1) :-
    DF1 is DF0 + DF,
    CF1 is CF0 + CF,
    dict_add(CM0,CM,CM1).

write_stats_dos :-
    stats_dos(File),
    open(File,write,Out,[]),
    call_cleanup(
        (
            format(Out,'# time, +/-files~n'),
            lazy_findall(Time-Delta,commit(Time,_,Delta,_),Commits),
            write_stats_(Out,Commits,0)
        ),
        close(Out)
    ).

write_stats_lin :-
    stats_lin(File),
    open(File,write,Out,[]),
    call_cleanup(
        (
            format(Out,'# time, +/-lines~n'),
            lazy_findall(Time-Delta,commit(Time,_,_,Delta),Commits),
            write_stats_(Out,Commits,0)
        ),
        close(Out)
    ).

write_stats_dos_lin :-
    stats_dos_lin(File),
    open(File,write,Out,[]),
    call_cleanup(
        (
            format(Out,'# time, +/-files, +/-lines~n'),
            lazy_findall(Time-DA-DB,commit(Time,_,DA,DB),Commits),
            write_stats_(Out,Commits,0-0)
        ),
        close(Out)
    ).

write_stats_svn_years :-
    rev_modules(ModSet),
    reverse(ModSet,MSreversed),
    stats_svn_jar(File),
    open(File,write,Out,[]),
    call_cleanup(
        (
            atomic_list_concat(ModSet,',',MStr),
            format(Out,'#startofyear,+/-files,~w~n',[MStr]),
            findall(r(Year,DF,CM),aggy(Year,DF,_,CM),Recs),
            write_stats_(Out,MSreversed,Recs,0)
        ),
        close(Out)
    ).

write_stats_svn_quarters :-
    rev_modules(ModSet),
    reverse(ModSet,MSreversed),
    stats_svn_qua(File),
    open(File,write,Out,[]),
    call_cleanup(
        (
            atomic_list_concat(ModSet,',',MStr),
            format(Out,'#startofquarter,+/-files,~w~n',[MStr]),
            findall(r(Mon,DF,CM),aggq(Mon,DF,_,CM),Recs),
            write_stats_(Out,MSreversed,Recs,0)
        ),
        close(Out)
    ).

write_stats_svn_months :-
    rev_modules(ModSet),
    reverse(ModSet,MSreversed),
    stats_svn_mon(File),
    open(File,write,Out,[]),
    call_cleanup(
        (
            atomic_list_concat(ModSet,',',MStr),
            format(Out,'#month,+/-files,~w~n',[MStr]),
            findall(r(Mon,DF,CM),aggm(Mon,DF,_,CM),Recs),
            write_stats_(Out,MSreversed,Recs,0)
        ),
        close(Out)
    ).

write_stats_(_,[],_) :- false.

write_stats_(Out,[Time-DA-DB|Rest],DA0-DB0) :-
    !, time_epoch(Time,Epoch),
    DA1 is DA0+DA, DB1 is DB0+DB,
    format(Out,'~w,~w,~w~n',[Epoch,DA1,DB1]),
    write_stats_(Out,Rest,DA1-DB1).

write_stats_(Out,[Time-Delta|Rest],D0) :-
    !, time_epoch(Time,Epoch),
    D1 is D0+Delta,
    format(Out,'~w,~w~n',[Epoch,D1]),
    write_stats_(Out,Rest,D1).

write_stats_(Out,ModSet,[r(Year,DF,CM)|Rest],D0) :-
    time_epoch(Year,Epoch),
    D1 is D0+DF,
    mod_changes(CM,ModSet,CMods),
    format(Out,'~w,~w,~w~n',[Epoch,D1,CMods]),
    write_stats_(Out,ModSet,Rest,D1).

mod_changes(CM,ModSet,CMods) :-
    foldl(mod_change_list(CM),ModSet,[],L),
    atomic_list_concat(L,',',CMods).

mod_change_list(CM,Key,L0,[Val|L0]) :- once((Val = CM.get(Key); Val=0)).

load_cvs_stats(DOM) :-
  cvs_stats_file(File),
  load_xml(File,DOM,[]).

load_svn_log(DOM) :-
    svn_log_file(File),
    load_xml(File,DOM,[]).
  
commit(DOM,Date,Auth,DeltaFiles,DeltaLines) :-
    xpath(DOM,//'Commit'(@date=Date,@author=Committer),Commit),
    once((
        Committer=revo, 
        xpath(Commit,'Comment'(text),Cmt),
        atomic_list_concat([Auth,_|_],':',Cmt)
        ;
        Auth=Committer
    )),
    commit_stats(Commit,DeltaFiles,DeltaLines).   

% DeltaFiles: new - deleted
% DeltaLinees: LocAdd-LocRem
commit_stats(Commit,DeltaFiles,DeltaLines) :-
    xpath(Commit,'FilesAffected'(),Affected),
    bagof(File,xpath(Affected,'File'(),File),Files),
    foldl(file_stats,Files,0-0,DeltaFiles-DeltaLines).

file_stats(File,DF_0-DL_0,DF_1-DL_1) :-
    xpath(File,/self(@action=Act),_),
    once((
        xpath(File,'LocAdd'(number),LA)
        ;
        LA = 0
    )),
    once((
        xpath(File,'LocRem'(number),LR)
        ;
        LR = 0
    )),
    DL_1 is DL_0 + LA - LR,
    once((
        Act = new, DF_1 is DF_0 + 1
        ;
        Act = deleted, DF_1 is DF_0 - 1
        ;
        DF_1 = DF_0 % action=changed, 
        % action="binary file or keyword subst...", aperas en unu loko, throw(unexpected_action(Act))
    )).

revision(DOM,Date,Rev,DeltaFiles,ChangedFiles,ChangesByModule) :-
    xpath(DOM,//logentry(@revision=Rev),Entry),
    xpath(Entry,date(text),Date),
    xpath(Entry,paths(),Pathes),
    path_stats(Pathes,DeltaFiles,ChangedFiles,ChangesByModule).

rev_modules(Modules) :-
    lazy_findall(Keys,
        (
         rev(_,_,_,_,Mods),
         dict_keys(Mods,Keys)
        ),
        KeySets),
    ord_union(KeySets,Modules),!.

rev_years(Years) :-
    setof(Year,A^B^C^revy(Year,A,B,C),Years).


rev_quarters(Quarters) :-
    setof(Qu,A^B^C^revq(Qu,A,B,C),Quarters).

rev_months(Months) :-
    setof(Month,A^B^C^revm(Month,A,B,C),Months).

path_stats(Pathes,DeltaFiles,ChangedFiles,ChangesByModule) :-
    bagof(Act-File,xpath(Pathes,path(@action=Act,@kind=file,text),File),Files),
    foldl(svn_file_stats,Files,0-0-_{},DeltaFiles-ChangedFiles-ChangesByModule).

svn_file_stats(Act-File,DF0-CF0-CM0,DF1-CF1-CM1) :-
    CF1 is CF0 + 1,
    once((
        Act='A', DF1 is DF0 + 1
        ;
        Act='D', DF1 is DF0 - 1
        ;
        Act='M', DF1 = DF0
        )),
    once((
        atomic_list_concat(['',trunk,Mod|_],'/',File),
        atom_length(Mod,3), % ignoru dosierojn, ĉiuj dosierujoj estas tri-literaj fakte 
        add(CM0,Mod,1,CM1)
        ;
        CM1 = CM0
        )).

add(D0,Mod,Val,D1) :-
    once(( 
        NewVal is D0.get(Mod) + Val
        ;
        NewVal = Val
        )),
        D1 = D0.put(Mod,NewVal).

dict_add(D0,D,D1) :-
    dicts_to_same_keys([D0,D],dict_fill(0),[D0_,D_]),
    dict_add_(D0_,D_,D1).

dict_add_(D0,D1,DSum) :-
    dict_pairs(D0,_,P0),
    dict_pairs(D1,_,P1),
    append(P0,P1,Ps),
    sort(1, @>=, Ps,Psorted),
    group_pairs_by_key(Psorted,PL),
    maplist(pair_add,PL,PSum),
    dict_pairs(DSum,_,PSum).

pair_add(Key-[A1,A2],Key-Sum) :- Sum is A1+A2.

time_epoch(YearStr,Epoch) :-
    atom_length(YearStr,4),!,
    format(atom(T),'~w-01',[YearStr]),
    parse_time(T,iso_8601,Epoch).

time_epoch(MonStr,Epoch) :-
    atom_length(MonStr,7),!,
    parse_time(MonStr,iso_8601,Epoch).

time_epoch(TimeStr,Epoch) :-
    atom_length(TimeStr,L), L>12, !,
    atomic_list_concat(Parts,' ',TimeStr),
    format(atom(T),'~wT~wZ',Parts),
    parse_time(T,iso_8601,Epoch).


