# voko-histriko
Kreas historian statistikon pri Reta Vortaro

Historia statistiko estas kreata pri la nombro de artikoloj, ŝanĝoj kaj linioj ekde la fondado. La artikoloj estas arĥivataj per CVS, kiu baze tenas ĉiujn bezonatajn informojn. Do por krei la statistikojn vi bezonas kopion de CVSROOT/revo, kiu ne enestas en tiu kodejo. (Do petu provizore ĉe mi)

Krome estas bezonata:
- cvs
- statcvs
- swiprolog
- gnuplot

La ordo de kreado estas:
- per cvs log estas eltirataj la revisio-informoj laŭ ŝanĝtempoj
- per statcvs estas kreata XML-dosiero kun bazaj statitikaj informoj
- per swiprolog-programo tiuj estas transformataj kiel fonto-dosieroj por gnuplot
- gnuplot kreas la statistikojn


La nomo "histriko" estas elektita pro aliteracioj kun historio kaj statistiko.
