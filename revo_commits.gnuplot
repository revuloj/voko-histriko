set datafile separator ","
set terminal png size 1000,600
set title "Revo - Artikoloj"
set ylabel "Artikoloj / Linioj"
set xlabel "Jaro"
set xdata time
set timefmt "%s"
set format x "%Y"
set key left top
set grid
set y2tics 300000, 200000
set ytics nomirror
plot "revo_dos_lin.dat" using 1:2 axis x1y1 with lines lw 2 lt 3 title 'artikoloj',"revo_dos_lin.dat" using 1:3 axis x1y2 with lines lw 2 lt 1 title 'linioj'
