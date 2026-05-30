#set terminal wxt enhanced
set terminal epslatex lw 2 standalone header "\\usepackage{graphicx} \\usepackage{amsmath}"  size 5in, 4.3 in
set output "tG_And_tchicombined.tex"


set multiplot

# First figure
ySizeAdjust = 0.008
set size 1.0,0.51 + ySizeAdjust
set origin 0.0,0.50 - ySizeAdjust

set logscale xy
set xtics nomirror
set ytics nomirror
set pointsize 1.5

set key right top
set xlabel ""

unset xtics
set ytics ("$10^{0}$" 1, "$10^{-1}$" 1e-1, "$10^{-2}$" 1e-2, "$10^{-3}$" 1e-3, "$10^{-4}$" 1e-4, "$10^{-11}$" 1e-11,)


set xrange [7:10000]
set yrange [4e-5:0.12]

set samples 500

filenum = 6
array colors[filenum] = ["black", "red", "blue", "#90EE90", "purple", "orange"]
array point[filenum] = [4, 6, 8, 10, 12, 14]

Tc = 0.6602778
set label 1 sprintf("$t_{c} = %.7f$", Tc) at graph 0.38,0.9
yO = -0.85
set label 2 sprintf("$\\sim L^{%g}$", yO) at graph 0.67,0.5

file3 = 'raw_data/cmp.pL'

plot file3 u 1:(Tc-$2):3 with err lc "black" pt 4 title "$t_c - t_G$"  ,\
     0.173*x**(yO) lw 2 lc "black" dt 42 notit
     

# Second figure
set size 1.0,0.575 - ySizeAdjust
set origin 0.0,00
set xtics nomirror
set ytics nomirror
set logscale xy
set xrange [7:10000]
set yrange [4e-5:1.5e-1]
# set ylabel "$\\sigma_{\\mathcal{T}}$"
set key right top
set xlabel "$L$" offset 0, 0.5

unset label 1

file3 = 'raw_data/cmp.pL3'

set xtics ("4" 4, "8" 8,"16" 16, "32" 32, "64" 64, "128" 128, "256" 256, "512" 512, "1024" 1024, "2048" 2048, "4096" 4096, "8192" 8192)
set ytics ("$10^{0}$" 1, "$10^{-1}$" 1e-1, "$10^{-2}$" 1e-2, "$10^{-3}$" 1e-3, "$10^{-4}$" 1e-4, "$10^{-11}$" 1e-11,)

plot file3 u 1:(Tc-$2):3 with err lc "black" pt 4 title "$t_c - t_{\\chi}$"  ,\
     0.26*x**(yO) lw 2 lc "black" dt 42 notit

# First inset
set size 0.49, 0.3
set origin 0.1, 0.5

set pointsize 1
set logscale xy2
unset x2label
unset xlabel

set xrange [12:10000]
set y2range [5e-5:7e-2]

set xtics nomirror
unset x2tics
set xtics ("\\footnotesize{32}" 32, "\\footnotesize{512}" 512, "\\footnotesize{8192}" 8192)
set y2tics ("\\footnotesize{$10^{-2}$}" 1e-2, "\\footnotesize{$10^{-3}$}" 1e-3)
unset ytics
set xtics offset 0, 0.5 
set y2tics offset -0.5, 0 

set label 1 sprintf("\\footnotesize{$\\sigma_{t_{G}} \\,\\, \\text{v.s.} \\,\\,  L$}") at graph 0.53,0.85
set label 2 sprintf("\\textcolor{red}{\\footnotesize{$\\sim L^{-0.85}$}}") at graph 0.6,0.53
set label 3 sprintf("\\textcolor{blue}{\\footnotesize{$\\sim L^{-0.5}$}}") at graph 0.1,0.33

file1 = 'raw_data/cmp.pL_cor'

Lmin = 2000
D1 = 0

plot file1 u 1:2:3 axes x1y2 with err lc "red" pt 6  notit  ,\
     [30:] 0.20*x**(-0.84) axes x1y2 lw 2 lc "red" dt 42 notit ,\
	[6:243] 0.043*x**(-0.5) axes x1y2 lw 2 lc "blue" dt 42 notit 


# Second inset
set size 0.49, 0.3
set origin 0.1, 0.075

set pointsize 1
set logscale xy2
unset x2label

set xrange [12:10000]
set y2range [5e-5:7e-2]

set xtics nomirror
unset x2tics
set xtics ("\\footnotesize{32}" 32, "\\footnotesize{512}" 512, "\\footnotesize{8192}" 8192)
set y2tics ("\\footnotesize{$10^{-2}$}" 1e-2, "\\footnotesize{$10^{-3}$}" 1e-3)
unset ytics
set xtics offset 0, 0.5 
set y2tics offset -0.5, 0 

set label 1 sprintf("\\footnotesize{$\\sigma_{t_{\\chi}} \\,\\, \\text{v.s.} \\,\\,  L$}") at graph 0.5,0.85
set label 2 sprintf("\\textcolor{red}{\\footnotesize{$\\sim L^{-0.85}$}}") at graph 0.6,0.53
unset label 3

file1 = 'raw_data/cmp.pL3_cor'

Lmin = 2000
D1 = 0

plot file1 u 1:2:3 axes x1y2 with err lc "red" pt 6  notit  ,\
     0.22*x**(-0.85) axes x1y2 lw 2 lc "red" dt 42 notit

unset multiplot
