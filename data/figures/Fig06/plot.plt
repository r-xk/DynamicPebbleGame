#set terminal wxt enhanced
set terminal epslatex lw 2 standalone header "\\usepackage{graphicx} \\usepackage{amsmath}"  size 5in, 3.5 in
set output "N_zong.tex"

set multiplot

set key right top samplen 1.5
set logscale y
set xtics nomirror
set ytics nomirror
set pointsize 1

set xlabel "$x=K_{\\mathrm{max}}/[L^{0.81}(1+c/L)]$" offset 0, 0.5
set ylabel "$P(x)$" offset 1, 0

set xtics (0, 35, 70)
set ytics ("$10^{-1}$" 1e-1, "$10^{-3}$" 1e-3, "$~10^{-5}$" 1e-5, "$10^{-7}$" 1e-7, "$10^{-9}$" 1e-9, "$10^{-11}$" 1e-11,)
set xtics offset 0, 0.4

set xrange [-2:75]
set yrange [6e-8:0.25]

set samples 500

filenum = 4
array L_values[filenum] = [256, 512, 1024, 2048]
array files[filenum]
array titles[filenum]
do for [i=1:filenum] {
    files[i] = sprintf("raw_data/unum_max_L%d", L_values[i])
    len = strlen(sprintf("%d", L_values[i]))
    if (len == 2) {
        titles[i] = sprintf("$\\phantom{11}%d$", L_values[i])
    } else {
        if (len == 3) {
            titles[i] = sprintf("$\\phantom{1}%d$", L_values[i])
        } else {
            titles[i] = sprintf("$%d$", L_values[i])
        }
    }
}

array colors[filenum] = ["black", "red", "orange", "purple"]
array point[filenum] = [6, 8, 10, 12]

# set label 1 "$x=N_{max}/L^{0.76}$" at graph 0.38, 0.1

df = 0.81
# df = 0.81
yO2 = -2.08
yO3 = -1.7
yO4 = -2.1

range = -1
plot for [i=1:filenum] files[i] using (($2>range && i>1) ? $2/(L_values[i])**df-410.0/L_values[i] : 1/0):($4*(L_values[i])**df) lc rgb colors[i] pt point[i] tit titles[i]  # ,\
     0.27*x**(yO2) lw 3 lc "cyan" dt 42 notit

set size 0.5, 0.43
set origin 0.18, 0.1

set logscale xy

set xtics nomirror
set ytics nomirror
set xlabel "\\footnotesize{$L$}" offset 0, 1
unset xlabel
unset x2label
# set ylabel "\\footnotesize{$n$}" offset 3.5
set ylabel ""
unset y2label

set pointsize 1

unset x2tics
unset y2tics
set xtics ("\\footnotesize{32}" 32, "\\footnotesize{256}" 256, "\\footnotesize{2048}" 2048)
set ytics ("\\footnotesize{$10^{2}$}" 1e2, "\\footnotesize{$10^{3}$}" 1e3, "\\footnotesize{$10^{4}$}" 1e4)
set xrange [12:3800]
set yrange [20:2e4]

set xtics offset 0, 0.5
set ytics offset .5, 0

set label 1 "\\textcolor{red}{\\scriptsize{$K_{\\mathrm{max}} \\sim L^{0.81(4)}$}}" at graph 0.05, 0.85
set label 2 "\\textcolor{blue}{\\scriptsize{$\\sigma_{K_{\\mathrm{max}}} \\sim L^{0.84(4)}$}}" at graph 0.23, 0.17

file3 = 'raw_data/cmp.unum_max'
file4 = 'raw_data/cmp.unum_max_cor'


yO2 = 0.81  
yO3 = 0.84

plot file3 u 1:($2*$1**2*3):($3*$1**2*3) with err lc "red" pt 6  notit  ,\
     file4 u 1:($2*$1**2*3):($3*$1**2*3) with err lc "blue" pt 8  notit  ,\
     12.9*x**(yO2) lw 2 lc "red" dt 42 notit ,\
     4*x**(yO3) lw 2 lc "blue" dt 42 notit
    #  400*x**(yO2*2) lw 2 lc "blue" dt 42 notit


unset multiplot
