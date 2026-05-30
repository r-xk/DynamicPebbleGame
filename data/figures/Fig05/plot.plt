set terminal epslatex lw 2 standalone header "\\usepackage{graphicx}"  size 5in, 5*0.7 in
set output "N_cri.tex"

set multiplot

set key left top samplen 1.5

set pointsize 1

set xlabel "$t$" offset 0, 0.5
set ylabel "$K$" offset 1,0

set xrange [0.57:0.75]
set yrange [0:12.5]
set xtics (0.58, 0.62, 0.66, "0.70" 0.70, 0.74)
set ytics ("0" 0, "4" 4, "8" 8, "12" 12)

set xtics nomirror
set ytics nomirror

set samples 500

#set label 1 "(2D, 0D, $g(L)$)" at graph 0.35,0.95
set dashtype 1 (3,3)
set arrow 10 from 0.660278,graph(0,0) to 0.660278,graph(1,1) nohead lc rgb "orange" lw 2 dashtype 1

filenum = 4
array files[filenum]
array titles[filenum]
array L_values[filenum] = [256, 512, 1024, 2048]
do for [i=1:filenum] {
    files[i] = sprintf("raw_data/unumpc_cri_L%d", L_values[i])
    if (i == filenum){
        files[i] = sprintf("raw_data/unumpc_L%d", L_values[i])
    }
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

array colors[filenum] = ["black", "red", "blue", "purple"]
array point[filenum] = [4, 6, 8, 10]

df = 0.0
xnu = 1.11
xnu = 0.

# set label 1 sprintf("$1/\\nu = %g, \\,\\, y_N = %g$", xnu, df) at graph 0.35,0.05

offsety = 0.06

plot for [i=1:filenum] files[i] u ($2*L_values[i]**xnu+0.660278):($3*L_values[i]**(-df)) lc rgb colors[i] pt point[i] title titles[i]  at graph 0.12, 0.7 + i*offsety



set size 0.5, 0.4
set origin 0.5, 0.6

set xtics nomirror
set xlabel ""
# set xlabel "\\footnotesize{$p-p_c$}" offset 0, 1.5
unset x2label
# set ylabel "\\footnotesize{$n$}" offset 3.5
set ylabel ""

set pointsize 1

unset x2tics
set xrange [0.57:0.75]
set xtics ("\\footnotesize{0.60}" 0.60, "\\footnotesize{0.66}" 0.66, "\\footnotesize{0.72}" 0.72)
set ytics ("\\footnotesize{0}" 0, "\\footnotesize{0.4}" 0.4, "\\footnotesize{0.8}" 0.8)
set yrange [-0.05:1.]

set xtics offset 0, 0.5
set ytics offset 0.5, 0

set label 1 "\\footnotesize{$n$ near $t_c$}" at graph 0.05, 0.2
unset label 2
unset label 11
unset label 12

do for [i=1:filenum] {
    files[i] = sprintf("raw_data/nkpc_cri_L%d", L_values[i])
    if (i == filenum){
        files[i] = sprintf("raw_data/nkpc_L%d", L_values[i])
    }
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

df = 2
xnu = 0

plot for [i=1:filenum] files[i] u ($2*L_values[i]**xnu+0.660278):($3*L_values[i]**(-df)) lc rgb colors[i] pt point[i] notit