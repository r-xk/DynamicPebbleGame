set terminal epslatex lw 2 standalone header "\\usepackage{graphicx}"  size 5in, 5*0.7 in
set output "PK.tex"

set multiplot

# 主图设置 - 来自 N_zong3.plt 的第二个图 (P_K vs K)
set pointsize .8
set ytics nomirror
set logscale xy
set key left bottom samplen 1.5
set xlabel "$s$" offset 0, 0.5
set ylabel "$\\mathcal{P}_K$" offset 1.5

set xtics offset 0, 0
set y2tics offset 0, 0

unset x2label
unset x2tics
unset y2label
unset y2tics

set xrange [0.7:4e4]
set xtics ("$10^0$" 1, "$10^1$" 10, "$10^2$" 1e2, "$10^3$" 1e3, "$10^4$" 1e4, "$10^5$" 1e5, "$10^6$" 1e6)
set yrange [1e-16:3]
set ytics ("$10^{-2}$" 1e-2, "$10^{-6}$" 1e-6, "$10^{-10}$" 1e-10, "$10^{-14}$" 1e-14)

set samples 500

filenum = 5
array L_values[filenum] = [128, 256, 512, 1024, 2048]
array files[filenum]
array titles[filenum]
array colors[filenum] = ["blue", "black", "red", "orange", "purple"]
array point[filenum] = [4, 6, 8, 10, 12]

do for [i=1:filenum] {
    files[i] = sprintf("raw_data/unum_big_L%d", L_values[i])
	len = strlen(sprintf("%d", L_values[i]))
    if (i == 1) {
        titles[i] = sprintf("$\\phantom{11}%d$", L_values[i])
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

df = 0
yN = 2
yO3 = -3.47

set label 1 "$\\sim s^{-3.47}$" at graph 0.7, 0.62
set label 3 "$t_e = 1$" at graph 0.46,0.92

range = 65
plot for [i=1:filenum] files[i] u ($2<range ? $2/(L_values[i])**df : 1/0):($4/(L_values[i])**yN/2) lc rgb colors[i] pt point[i] title titles[i],\
     for [i=1:filenum] files[i] u ($2>=range ? $2/(L_values[i])**df : 1/0):($4/(L_values[i])**yN) lc rgb colors[i] pt point[i] notit ,\
     1000*x**(yO3) lw 2 lc "black" dt 42 notit 

unset multiplot 