:-use_module(library(sgml)).
:-use_module(library(xpath)).

stats_file('repo-statistics.xml').

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
        Act = changed, DF_1 = DF_0
        ;
        throw(unexpected_action(Act))
    )).
