set datafile separator ","
set terminal png size 1600,500 font "Helvetica, 12"
#set terminal png font "/Library/Fonts/Arial.ttf"
#set terminal pngcairo font "LibreSans, 14"
set title "Voko-iloj-ŝanĝoj"
set ylabel "Ŝanĝoj laŭ dosierujo kaj jarkvarono"
set y2label "Nombro da dosieroj"
set xlabel "Jaro"
set xdata time
set timefmt "%s"
set format x "%Y"
set xtics 907113600,22896000
#set xrange [907113600:...]
set key left top
set grid
set y2tics 0, 100
set ytics nomirror

set label " transiro de SGML+DSSSL al XML+XSLT" at 954460800,5 point pt 5 front font "Helvetica-Bold,10" #point ps 3 front
set label " aldono de prototipa\n vortanalizilo" at 985996800,35 point pt 5 front font "Helvetica-Bold,10"
set label " enkonduko de Ant\n kaj Javo" at 1135987200,65 point pt 5 front font "Helvetica-Bold,10" 
set label " plibonigado de redaktilo\n kaj serĉo-DB" at 1222732800,45 point pt 5 front font "Helvetica-Bold,10" 
set label " OWL/RDF: aldono de vortklasoj\n kun laŭkategoriaj indeksoj" at 1372550400,185 point pt 5 front font "Helvetica-Bold,10" 
set label " vortanalizilo per\n Revo-radikaro\n kaj Prologo (git)" at 1400086400,65 point pt 5 front font "Helvetica-Bold,10" 
set label " nova redaktilo surbaze de\n Prologo + jQuery UI" at 1451520000,125 point pt 5 front font "Helvetica-Bold,10" 
#https://newspaint.wordpress.com/2013/09/11/creating-a-filled-stack-graph-in-gnuplot/

# ellasu:
#  6 - cfg
#  8 - div
# 12 - eta
# 17 - sql
# 20 - tst

plot \
  "voko_svn.dat" using 1:($3+$4+$5+$7+$9+$10+$11+$13+$14+$15+$16+$18+$19+$21+$22) title 'ana' with filledcurves x1 fs pattern 6, \
  "voko_svn.dat" using 1:($4+$5+$7+$9+$10+$11+$13+$14+$15+$16+$18+$19+$21+$22) title 'ant' with filledcurves x1, \
  "voko_svn.dat" using 1:($5+$7+$9+$10+$11+$13+$14+$15+$16+$18+$19+$21+$22) title 'bin' with filledcurves x1, \
  "voko_svn.dat" using 1:($7+$9+$10+$11+$13+$14+$15+$16+$18+$19+$21+$22) title 'cgi' with filledcurves x1 fs pattern 6, \
  "voko_svn.dat" using 1:($9+$10+$11+$13+$14+$15+$16+$18+$19+$21+$22) title 'dok' with filledcurves x1 lc rgb "red", \
  "voko_svn.dat" using 1:($10+$11+$13+$14+$15+$16+$18+$19+$21+$22) title 'dsl' with filledcurves x1 fs pattern 6, \
  "voko_svn.dat" using 1:($11+$13+$14+$15+$16+$18+$19+$21+$22) title 'dtd' with filledcurves x1 fs pattern 5, \
  "voko_svn.dat" using 1:($13+$14+$15+$16+$18+$19+$21+$22) title 'jav' with filledcurves x1 fs pattern 5, \
  "voko_svn.dat" using 1:($14+$15+$16+$18+$19+$21+$22) title 'jsc' with filledcurves x1 fs pattern 7, \
  "voko_svn.dat" using 1:($15+$16+$18+$19+$21+$22) title 'owl' with filledcurves x1 fs pattern 2, \
  "voko_svn.dat" using 1:($16+$18+$19+$21+$22) title 'smb' with filledcurves x1 lc rgb "seagreen" , \
  "voko_svn.dat" using 1:($18+$19+$21+$22) title 'stl' with filledcurves x1 fs pattern 7, \
  "voko_svn.dat" using 1:($19+$21+$22) title 'swi' with filledcurves x1, \
  "voko_svn.dat" using 1:($21+$22) title 'ujo' with filledcurves x1 fs pattern 6, \
  "voko_svn.dat" using 1:($22) title 'xsl' with filledcurves x1 fs solid lc rgb "dark-orange", \
  "voko_svn.dat" using 1:2 axis x1y2 title '# dosieroj' with lines lw 2 lt 8
