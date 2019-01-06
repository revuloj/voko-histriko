set datafile separator ","
set terminal png size 1600,500
set title "Voko-iloj-ŝanĝoj"
set style data histogram 
set style histogram columnstacked
set key autotitle columnheader
set ylabel "Ŝanĝoj laŭ dosierujo kaj jarkvarono"
set xlabel "Jaro"
set xdata time
set timefmt "%s"
set format x "%Y"
#set xtics 907113600,22896000
set key left top
set grid
#set y2tics 0, 100
#set ytics nomirror
set auto x
unset xtics

#https://newspaint.wordpress.com/2013/09/11/creating-a-filled-stack-graph-in-gnuplot/

plot \
  "voko_svn.dat" using 3:xtic(1), for [i=3:21] '' using i
#  "voko_svn.dat" using 1:2 axis x1y2 title '# dosieroj' with lines lw 2 lt 8
