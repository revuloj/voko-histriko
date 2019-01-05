:-use_module(library(sgml)).
:-use_module(library(xpath)).

:- dynamic commit/4.

stats_file('repo-statistics.xml').
stats_dos('revo_dos.dat').
stats_lin('revo_lin.dat').
stats_dos_lin('revo_dos_lin.dat').

load_commits :-
    load_stats(DOM),
    retractall(commit(_,_,_,_)),
    forall(
        commit(DOM,Date,Auth,DeltaFiles,DeltaLines),
        assertz(commit(Date,Auth,DeltaFiles,DeltaLines))
    ).

write_stats_dos :-
    stats_dos(File),
    open(File,write,Out,[]),
    call_cleanup(
        (
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
            lazy_findall(Time-DA-DB,commit(Time,_,DA,DB),Commits),
            write_stats_(Out,Commits,0-0)
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
    time_epoch(Time,Epoch),
    D1 is D0+Delta,
    format(Out,'~w,~w~n',[Epoch,D1]),
    write_stats_(Out,Rest,D1).

load_stats(DOM) :-
  stats_file(File),
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

time_epoch(TimeStr,Epoch) :-
    atomic_list_concat(Parts,' ',TimeStr),
    format(atom(T),'~wT~wZ',Parts),
    parse_time(T,iso_8601,Epoch).
