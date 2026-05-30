#set terminal wxt enhanced
set terminal epslatex lw 2 standalone header "\\usepackage{graphicx} \\usepackage{amsmath}"  size 5in, 3.5 in
set output "t_K_tchi_compare.tex"

set multiplot

set pointsize 2

set xtics nomirror
set ytics nomirror
set logscale xy
set ylabel ""  offset 1.5
set key right top samplen 1.5
set xlabel "$L$" offset 0, 0.6

unset x2label
unset x2tics
unset y2label
unset y2tics

unset label 3

set xtics ("" 4, "" 8,"" 16, "32" 32, "64" 64, "128" 128, "256" 256, "512" 512, "1024" 1024, "2048" 2048, "4096" 4096, "8192" 8192)
set ytics ("$10^{0}$" 1, "$10^{-1}$" 1e-1, "$10^{-2}$" 1e-2, "$10^{-3}$" 1e-3, "$10^{-4}$" 1e-4, "$10^{-5}$" 1e-5,)

set xrange [28:10000]
set yrange [8e-6:2e-2]

file3 = 'raw_data/cmp.pL3'
file4 = 'raw_data/cmp.pL4'

Tc = 0.6602778

filenum = 6
array colors[filenum] = ["black", "red", "blue", "#90EE90", "purple", "orange"]
array point[filenum] = [4, 6, 8, 10, 12, 14]

set label 3 sprintf("$t_c = %.7f$", Tc) at graph 0.39,0.95
set label 1 sprintf("\\textcolor{black}{$\\sim L^{-1.09}$}") at graph 0.4,0.25
yO = -0.85
set label 2 sprintf("\\textcolor{red}{$\\sim L^{%g}$}", yO) at graph 0.6,0.75

y1 = -0.93
yO2 = -1.22
yO3 = -1.09
yO4 = -0.7
plot file4 u 1:(Tc-$2):3 with err lc rgb colors[1] pt point[1]  title "$t_{c}-t_{K}$"  ,\
     0.127*(100 < x && x < 1000 ? x**(yO3) : 1/0) lw 2 lc rgb colors[1] dt 42 notit ,\
     file3 u 1:(Tc-$2):3 with err lc rgb colors[2] pt point[2]  title "$t_{c}-t_{\\chi}$"  ,\
     0.26*x**(yO) lw 2 lc rgb colors[2] dt 42 notit

unset multiplot
