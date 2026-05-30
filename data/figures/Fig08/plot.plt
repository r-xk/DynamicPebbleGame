set terminal epslatex lw 2 standalone header "\\usepackage{graphicx} \\usepackage{amsmath}"  size 4.3in, 3.7 in
set output "nstK.tex"

set multiplot

xoffset = -0.02

# Upper plot - before maximum merged cluster (run14/ns6)
set size 1.0-xoffset,0.59
set origin 0.0+xoffset,0.47

set key right top samplen 1.5
set logscale x2y
set logscale xy
set xtics nomirror
set ytics nomirror
set pointsize 0.5

set x2label "" offset 0, -0.5
set ylabel "$P_S$"  offset 1.5

set x2tics mirror
set x2tics ("" 1, "" 1e2,  "" 1e4, "" 1e6)
set xtics ("" 1e6)
set ytics ("$10^{-2}$" 1e-2, "$10^{-6}$" 1e-6, "$10^{-10}$" 1e-10, "$10^{-14}$" 1e-14)

set format x ""
set x2range [0.6:5e6]
set yrange [1e-17:8e0]

set samples 500

filenum = 6
array L_values[filenum] = [64, 128, 256, 512, 1024, 2048]
array files[filenum]
array titles[filenum]
do for [i=1:filenum] {
    files[i] = sprintf("raw_data/ns6_L%d", L_values[i])
	len = strlen(sprintf("%d", L_values[i]))
    if (i == 1) {
        titles[i] = sprintf("$\\phantom{L=11}%d$", L_values[i])
    }
    else{
        if (len == 2) {
            titles[i] = sprintf("$\\phantom{L=11}%d$", L_values[i])
        } else {
            if (len == 3) {
                titles[i] = sprintf("$\\phantom{L=1}%d$", L_values[i])
            } else {
                titles[i] = sprintf("$\\phantom{L=}%d$", L_values[i])
            }
        }
    }
}

array colors[filenum] = ["black", "red", "blue", "#90EE90", "purple", "orange"]
array point[filenum] = [4, 6, 8, 10, 12, 14]

df = 0
yN = 0
yO2 = -1.92

set label 2 "(a) $t=t_\\mathcal{K}^-$" at graph 0.4,0.1
set label 4 sprintf("slope: $%g > -2$", yO2) at graph 0.37,0.7

range = -1
plot for [i=1:6] files[i] using ($2>range ? $2/(L_values[i])**df : 1/0):($4/(L_values[i])**yN) axes x2y1 lc rgb colors[i] pt point[i] title titles[i] ,\
     0.019*x**(yO2) axes x2y1 lw 3 lc "cyan" dt 42 notit

# Lower plot - after maximum merged cluster (run14/ns4) as full plot
set size 1.0-xoffset,0.592
set origin 0.0+xoffset,0

unset key
set pointsize 0.5

set xtics mirror
set ytics nomirror
set logscale xy
set ylabel "$P_S$"  offset 1.5
set xlabel "$s$" offset 0, 0.6

unset x2label
unset x2tics
unset y2label
unset y2tics

unset label 1
unset label 2
unset label 3
unset label 4

set xtics ("$10^0$" 1, "$10^2$" 1e2,  "$10^4$" 1e4,"$10^6$" 1e6)
set ytics ("$10^{-2}$" 1e-2, "$10^{-6}$" 1e-6, "$10^{-10}$" 1e-10, "$10^{-14}$" 1e-14)

set xrange [0.6:5e6]
set yrange [1e-17:1e0]

filenum = 6
array L_values[filenum] = [64, 128, 256, 512, 1024, 2048]
array files[filenum]
array titles[filenum]
do for [i=1:filenum] {
    files[i] = sprintf("raw_data/ns4_L%d", L_values[i])
	len = strlen(sprintf("%d", L_values[i]))
    if (i == 1) {
        titles[i] = sprintf("$\\phantom{L=11}%d$", L_values[i])
    }
    else{
        if (len == 2) {
            titles[i] = sprintf("$\\phantom{L=11}%d$", L_values[i])
        } else {
            if (len == 3) {
                titles[i] = sprintf("$\\phantom{L=1}%d$", L_values[i])
            } else {
                titles[i] = sprintf("$\\phantom{L=}%d$", L_values[i])
            }
        }
    }
}

array colors[filenum] = ["black", "red", "blue", "#90EE90", "purple", "orange"]
array point[filenum] = [4, 6, 8, 10, 12, 14]

yO2 = -1.96

set label 2 "(b) $t=t_\\mathcal{K}^+$" at graph 0.4,0.1
set label 4 sprintf("slope: $%g > -2$", yO2) at graph 0.4,0.7

range = -1
plot for [i=1:filenum] files[i] using ($2>range ? $2/(L_values[i])**df : 1/0):($4/(L_values[i])**yN) lc rgb colors[i] pt point[i] notit ,\
     0.023*x**(yO2) lw 3 lc "cyan" dt 42 notit

unset multiplot
