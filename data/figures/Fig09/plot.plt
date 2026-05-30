set terminal epslatex lw 2 standalone header "\\usepackage{graphicx} \\usepackage{amsmath}"  size 4.3in, 3.7in
set output "PG_plots.tex"

set multiplot

xoffset = -0.02

ybottom = 3e-20
yupper = 5e0

filenum = 5
startnum = 1
array L_values[filenum] = [8, 32, 128, 512, 2048]
array colors[filenum] = ["black", "red", "blue", "#90EE90", "purple"]
array point[filenum] = [4, 6, 8, 10, 12]

#################### Upper plot - t_e = T_G ####################
set size 1.0-xoffset, 0.59
set origin 0.0+xoffset, 0.47

set key left bottom samplen 0.5 spacing 0.8 width -1
set logscale x2y
set logscale xy
set xtics nomirror
set ytics nomirror
set pointsize 0.5

set x2label "" offset 0, -0.5
set ylabel "$\\mathcal{P}_G$" offset 1.5

set x2tics mirror
set x2tics ("" 1e1, "" 1e3, "" 1e5, "" 1e7)
set xtics ("" 1e7)
set ytics ("$10^{-3}$" 1e-3, "$10^{-8}$" 1e-8, "$10^{-13}$" 1e-13, "$10^{-18}$" 1e-18)

set format x ""
set x2range [0.3:1.5e7]
set yrange [ybottom:yupper]

set samples 500

set label 2 "(a) $t_e = \\mathcal{T}_G$" at graph 0.41, 0.92
yO2 = -2.08
set label 3 sprintf("$\\textcolor{red}{\\sim s^{%g}}$", yO2) at graph 0.7, 0.53

array files[filenum]
array titles[filenum]
do for [i=1:filenum] {
    files[i] = sprintf("raw_data/gap_small_pL_L%d", L_values[i])
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

df = 0
yN = 0
range = -1

plot for [i=startnum:filenum] files[i] using ($2>range ? $2/(L_values[i])**df : 1/0):($4/(L_values[i])**yN) axes x2y1 lc rgb colors[i] pt point[i] title titles[i], \
     0.13*x**(yO2) axes x2y1 lw 3 lc "red" dt 42 notit

#################### Lower plot - t_e = 1 ####################
set size 1.0-xoffset, 0.592
set origin 0.0+xoffset, 0

unset key
set pointsize 0.6

set xtics mirror
set ytics nomirror
set logscale xy
set ylabel "$\\mathcal{P}_G$" offset 1.5
set xlabel "$s$" offset 0, 0.6

unset x2label
unset x2tics
unset y2label
unset y2tics

set xtics ("$10^1$" 1e1, "$10^3$" 1e3, "$10^5$" 1e5, "$10^7$" 1e7)
set ytics ("$10^{-3}$" 1e-3, "$10^{-8}$" 1e-8, "$10^{-13}$" 1e-13, "$10^{-18}$" 1e-18)

set xrange [0.3:1.5e7]
set yrange [ybottom:yupper]

set label 2 "(b) $t_e = 1$" at graph 0.42, 0.92
yO2 = -2.08
set label 3 sprintf("$\\textcolor{red}{\\sim s^{%g}}$", yO2) at graph 0.7, 0.53

array files[filenum]
array titles[filenum]
do for [i=1:filenum] {
    files[i] = sprintf("raw_data/gap_small_L%d", L_values[i])
    len = strlen(sprintf("%d", L_values[i]))
    if (i == 1) {
        titles[i] = sprintf("$V=\\phantom{11}%d^2$", L_values[i])
    } else {
        if (len == 2) {
            titles[i] = sprintf("$\\phantom{11}%d^2$", L_values[i])
        } else {
            if (len == 3) {
                titles[i] = sprintf("$\\phantom{1}%d^2$", L_values[i])
            } else {
                titles[i] = sprintf("$%d^2$", L_values[i])
            }
        }
    }
}

df = 0
yN = 0
range = -1

plot for [i=startnum:filenum] files[i] using ($2>range ? $2/(L_values[i])**df : 1/0):($4/(L_values[i])**yN) lc rgb colors[i] pt point[i] notit, \
     0.13*x**(yO2) lw 3 lc "red" dt 42 notit

unset multiplot
