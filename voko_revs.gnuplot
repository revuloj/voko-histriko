set datafile separator ","
set terminal png size 1000,600
set title "Voko-iloj-ŝanĝoj"
set ylabel "Ŝanĝoj laŭ dosierujo"
set xlabel "Jaro"
set xdata time
set timefmt "%s"
set format x "%Y"
set key left top
set grid
#set y2tics 300000, 200000
#set ytics nomirror

#https://newspaint.wordpress.com/2013/09/11/creating-a-filled-stack-graph-in-gnuplot/

plot \
  "voko_svn.dat" using 1:($3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22) title 'ana' with filledcurves x1 fs pattern 6, \
  "voko_svn.dat" using 1:($4+$5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22) title 'ant' with filledcurves x1, \
  "voko_svn.dat" using 1:($5+$6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22) title 'bin' with filledcurves x1, \
  "voko_svn.dat" using 1:($6+$7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22) title 'cfg' with filledcurves x1 fs pattern 4, \
  "voko_svn.dat" using 1:($7+$8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22) title 'cgi' with filledcurves x1 fs pattern 6, \
  "voko_svn.dat" using 1:($8+$9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22) title 'div' with filledcurves x1 fs pattern 6, \
  "voko_svn.dat" using 1:($9+$10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22) title 'dok' with filledcurves x1, \
  "voko_svn.dat" using 1:($10+$11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22) title 'dsl' with filledcurves x1 fs pattern 6, \
  "voko_svn.dat" using 1:($11+$12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22) title 'dtd' with filledcurves x1 fs pattern 5, \
  "voko_svn.dat" using 1:($12+$13+$14+$15+$16+$17+$18+$19+$20+$21+$22) title 'eta' with filledcurves x1 fs pattern 7, \
  "voko_svn.dat" using 1:($13+$14+$15+$16+$17+$18+$19+$20+$21+$22) title 'jav' with filledcurves x1 fs pattern 5, \
  "voko_svn.dat" using 1:($14+$15+$16+$17+$18+$19+$20+$21+$22) title 'jsc' with filledcurves x1 fs pattern 6, \
  "voko_svn.dat" using 1:($15+$16+$17+$18+$19+$20+$21+$22) title 'owl' with filledcurves x1 fs pattern 2, \
  "voko_svn.dat" using 1:($16+$17+$18+$19+$20+$21+$22) title 'smb' with filledcurves x1, \
  "voko_svn.dat" using 1:($17+$18+$19+$20+$21+$22) title 'sql' with filledcurves x1 fs pattern 6, \
  "voko_svn.dat" using 1:($18+$19+$20+$21+$22) title 'stl' with filledcurves x1 fs pattern 7, \
  "voko_svn.dat" using 1:($19+$20+$21+$22) title 'swi' with filledcurves x1, \
  "voko_svn.dat" using 1:($20+$21+$22) title 'tst' with filledcurves x1 fs pattern 7, \
  "voko_svn.dat" using 1:($21+$22) title 'ujo' with filledcurves x1 fs pattern 6, \
  "voko_svn.dat" using 1:($22) title 'xsl' with filledcurves x1 fs solid, \
  "voko_svn.dat" using 1:2 title '# dosieroj' with lines lw 2 lt 8
