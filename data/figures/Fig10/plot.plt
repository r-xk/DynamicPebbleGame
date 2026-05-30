set terminal epslatex lw 2 standalone header "\\usepackage{graphicx} \\usepackage{amsmath}"  size 5in, 3.5in
set output "PS_tG.tex"

set key left bottom samplen 1.5
set logscale xy
set xtics nomirror
set ytics nomirror
set pointsize 1

set xlabel "$s$" offset 0, 0.5
set ylabel "$\\mathcal{P}_S$" offset 1, 0

set xtics ("$10^1$" 1e1, "$10^3$" 1e3, "$10^5$" 1e5, "$10^7$" 1e7)
set ytics ("$10^{-1}$" 1e-1, "$10^{-5}$" 1e-5, "$10^{-9}$" 1e-9, "$10^{-13}$" 1e-13)

ysbottom = 1e-15
yupper = 5e0
set xrange [0.3:1.5e7]
set yrange [ysbottom:yupper]

set samples 500

set label 2 "$t_e = \\mathcal{T}_G$" at graph 0.45, 0.92
yO3 = -1.5
set label 3 sprintf("$\\textcolor{red}{\\sim s^{%g}}$", yO3) at graph 0.7, 0.5

filenum = 5
startnum = 1
array L_values[filenum] = [8, 32, 128, 512, 2048]
array files[filenum]
array titles[filenum]
do for [i=1:filenum] {
    files[i] = sprintf("raw_data/gap_zong_pL_L%d", L_values[i])
    len = strlen(sprintf("%d", L_values[i]))
    if (len == 1) {
        titles[i] = sprintf("$\\phantom{111}%d$", L_values[i])
    } else {
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
}

array colors[filenum] = ["black", "red", "blue", "#90EE90", "purple"]
array point[filenum] = [4, 6, 8, 10, 12]

df = 0
yN = 0
range = -1

plot for [i=startnum:filenum] files[i] using ($2>range ? $2/(L_values[i])**df : 1/0):($4/(L_values[i])**yN) lc rgb colors[i] pt point[i] title titles[i], \
     0.092*x**(yO3) lw 3 lc "red" dt 42 notit
