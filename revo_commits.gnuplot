set datafile separator ","
set terminal png size 1000,600 font "Helvetica, 12"
set title "Revo - Artikoloj"
set ylabel "Artikoloj / Linioj"
set xlabel "Jaro"
set xdata time
set timefmt "%s"
set format x "%Y"
set key left top
set grid
#set y2range[210000:1.8e6]
set y2tics 200000, 200000
set ytics nomirror

set label "\n aldono de tradukoj\n cs, sk per skripto" at 1435968000,11180 point pt 5 front font "Helvetica-Bold,10"

plot "revo_dos_lin.dat" using 1:2 axis x1y1 with lines lw 2 lt 3 title 'artikoloj',"revo_dos_lin.dat" using 1:3 axis x1y2 with lines lw 2 lt 1 title 'linioj'
