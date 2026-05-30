set terminal epslatex lw 2 standalone header "\\usepackage{graphicx}    \\usepackage{dutchcal}"  size 5in, 5*0.7 in
set output "time_prog49_bigmem.tex"

set multiplot
set key left top

set pointsize 2

set xlabel "$L$"
set ylabel "Times ($s$)" 

set logscale xy

set xtics ("16" 16, "32" 32, "64" 64, "128" 128, "256" 256, "512" 512, "1024" 1024, "2048" 2048, "4096" 4096, "8192" 8192)
set ytics ("$10^{-3}$" 1e-3, "$10^{-1}$" 1e-1, "$10^{1}$" 1e1, "$10^{3}$" 1e3)

set xtics nomirror
set ytics nomirror

set xrange [12:11000]
set yrange [2e-4:4e3]

set samples 500

file1 = 'raw_data/time_mean.dat'
file2 = 'raw_data/java_time.dat'
y1 = 2.3
y2 = 2.3

plot file1 u 1:($2/64):($3/64) with err lc "red" pt 4 title "ifort" ,\
     file2 u 1:2:3 with err lc "blue" pt 4 title "Java" ,\
     4e-7*x**y1 lw 2 lc "red" dt 42 tit sprintf("$L^{%g}$", y1) ,\
     3e-6*x**y2 lw 2 lc "blue" dt 42 tit sprintf("$L^{%g}$", y2)
      
