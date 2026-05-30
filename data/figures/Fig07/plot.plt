set terminal epslatex lw 2 standalone header "\\usepackage{graphicx} \\usepackage{amsmath}"  size 5in, 3.5 in
set output "nspc.tex"

set key right top samplen 1.5
set logscale xy
set xtics nomirror
set ytics nomirror
set pointsize 1

set xlabel "$s$" offset 0, 0.5
set ylabel "$P_S$" offset 1, 0

set xtics ("$10^0$" 1, "$10^2$" 1e2,  "$10^4$" 1e4,"$10^6$" 1e6)
set ytics ("$10^{-2}$" 1e-2, "$10^{-6}$" 1e-6, "$10^{-10}$" 1e-10, "$10^{-14}$" 1e-14)

set xrange [0.8:6e6]
set yrange [1e-17:8e0]

set samples 500

filenum = 6
array L_values[filenum] = [64, 128, 256, 512, 1024, 2048]
array files[filenum]
array titles[filenum]
do for [i=1:filenum] {
    files[i] = sprintf("raw_data/ns_L%d", L_values[i])
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

array colors[filenum] = ["black", "red", "blue", "#90EE90", "purple", "orange"]
array point[filenum] = [4, 6, 8, 10, 12, 14]

df = 0
yN = 0
yO2 = -1.92
yO3 = -1.96
yO4 = -2.08

set label 2 "$p=t_c$" at graph 0.42,0.1
set label 4 sprintf("slope: $%g > -2$", yO3) at graph 0.2,0.4
set label 5 sprintf("\\color{blue}{$\\sim s^{%g}$}", yO4) at graph 0.7,0.5

range = -1
plot for [i=1:6] files[i] using ($2>range ? $2/(L_values[i])**df : 1/0):($4/(L_values[i])**yN) lc rgb colors[i] pt point[i] title titles[i] ,\
     0.0235*x**(yO3) lw 4 lc "black" dt 42 notit ,\
     (x>2e3 && x<3.8e6 ? 5*x**(yO4) : 1/0) lw 4 lc "blue" dt 42 notit

