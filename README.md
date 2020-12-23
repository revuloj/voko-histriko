# voko-histriko
Kreas historian statistikon (do kronikon) pri Reta Vortaro

Historia statistiko estas kreata pri la nombro de artikoloj, ŝanĝoj kaj linioj ekde la fondado. La artikoloj estas arĥivataj per CVS, kiu ja tenas ĉiujn bezonatajn informojn. Do por krei la statistikojn vi bezonas kopion de CVSROOT/revo, kiu ne enestas en tiu kodejo. (Do petu provizore ĉe mi)

[Evoluo de artikoloj kaj linioj de Revo](revo_commits.png)

Krome estas bezonata:
- cvs
- statcvs
- swiprolog
- gnuplot

La ordo de kreado estas:
- per cvs log estas eltirataj la revizio-informoj laŭ ŝanĝtempoj
- per statcvs estas kreata XML-dosiero kun bazaj statistikaj informoj
- per swiprolog-programo tiuj estas transformataj kiel fonto-dosieroj por gnuplot
- gnuplot kreas la statistikojn


La nomo "histriko" estas elektita pro aliteracioj kun historio kaj statistiko.
