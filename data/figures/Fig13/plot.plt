#set terminal wxt enhanced
set terminal epslatex lw 2 standalone header "\\usepackage{graphicx}" size 5.7in, 4.3in
set output "C1p_PDF.tex"

set multiplot

# Common settings
set pointsize 0.6
set samples 500

# Layout adjustment parameter
ySizeAdjust = 0.02
xSizeAdjust = 0.073
xShift = -0.087

xSizeShift2 = -0.048

filenum = 5
array L_values[filenum] = [64, 128, 256, 512, 1024]
array colors[filenum] = ["#90EE90", "blue", "red", "purple", "orange"]
array point[filenum] = [6, 8, 10, 12, 14]

# Function to generate titles with proper spacing
array titles[filenum]
do for [i=1:filenum] {
    len = strlen(sprintf("%d", L_values[i]))
    if (len == 2) {
        titles[i] = sprintf("$\\phantom{111}%d$", L_values[i])
    } else {
        if (len == 3) {
            titles[i] = sprintf("$\\phantom{11}%d$", L_values[i])
        } else {
            titles[i] = sprintf("$%d$", L_values[i])
        }
    }
}

#=== First row, left: C_{1,G}^+ ===
set size 0.5+xSizeAdjust, 0.5
set origin 0.0, 0.5

set xlabel "$x=C_{1,G}^+/L^{d_f}$"
set ylabel "$P(x)$" offset 1,0
set key right top samplen 0.5
set xtics nomirror
set ytics nomirror

set yrange [0:1.8]
set ytics ("0.0" 0, "0.5" 0.5, "1.0" 1.0, "1.5" 1.5)
set xrange [0:2.2]
set xtics ("0.0" 0, "0.5" 0.5, "1.0" 1.0, "1.5" 1.5, "2.0" 2.0)

df1 = 1.85
array files1[filenum]
do for [i=1:filenum] {
    files1[i] = sprintf("raw_data/C1p_L%d", L_values[i])
}

set label 1 sprintf("$d_f = %g$", df1) at graph 0.3,0.1
set label 2 "(a)" at graph 0.03,0.9

plot for [i=1:filenum] files1[i] u ($2/L_values[i]**df1):($4*L_values[i]**df1) lc rgb colors[i] pt point[i] title titles[i]

#=== First row, right: C_{1,G} ===
set size 0.5+xSizeAdjust, 0.5
set origin 0.5+xSizeAdjust+xShift, 0.5

set xlabel "$x=C_{1,G}/L^{d_f}$"
unset ylabel
set y2label "$P(x)$" offset -1,0
set key right top samplen 0.5
unset ytics
set y2tics nomirror

df2 = 1.84
array files2[filenum]
do for [i=1:filenum] {
    files2[i] = sprintf("raw_data/C1pmi_L%d", L_values[i])
}

set y2range [0:1.8]
set y2tics ("0.0" 0, "0.5" 0.5, "1.0" 1.0, "1.5" 1.5)
set xrange [0:2.2]
set xtics ("0.0" 0, "0.5" 0.5, "1.0" 1.0, "1.5" 1.5, "2.0" 2.0)

unset label 1
unset label 2
set label 1 sprintf("$d_f = %g$", df2) at graph 0.15,0.1
set label 2 "(b)" at graph 0.88,0.9

plot for [i=1:filenum] files2[i] u ($2/L_values[i]**df2):($4*L_values[i]**df2) axes x1y2 lc rgb colors[i] pt point[i] notitle

#=== Second row: C_{1,t_c} (bottom) ===
set size 1.0+xSizeShift2, 0.5 + ySizeAdjust
set origin 0.0, 0.0

set xlabel "$x=C_{1,t_c}/L^{d_f}$"
set ylabel "$P(x)$" offset 1,0
unset y2label
unset y2tics
set ytics nomirror
set key right bottom samplen 0.5
set yrange [0:1.9]
set ytics ("0.0" 0, "0.5" 0.5, "1.0" 1.0, "1.5" 1.5)
set xrange [0:1.9]
set xtics ("0.0" 0, "0.5" 0.5, "1.0" 1.0, "1.5" 1.5)

df3 = 1.85
array files3[filenum]
do for [i=1:filenum] {
    files3[i] = sprintf("raw_data/ns_C1_L%d", L_values[i])
}

unset label 1
unset label 2
set label 1 sprintf("$d_f = %g$", df3) at graph 0.45,0.1
set label 2 "(c)" at graph 0.93,0.9

plot for [i=1:filenum] files3[i] u ($2/L_values[i]**df3):($4*L_values[i]**df3) lc rgb colors[i] pt point[i] notitle

#=== Second row: C_{1,t_c} (inset) ===
set size 0.45, 0.29
set origin 0.07, 0.2

set pointsize 0.5

set xlabel ""
set ylabel "" 
unset y2label
unset y2tics
set ytics nomirror

set xtics ("\\footnotesize{0}" 0, "\\footnotesize{0.5}" 0.5, "\\footnotesize{1.0}" 1.0, "\\footnotesize{1.5}" 1.5) offset 0, 0.4
set ytics ("\\footnotesize{0}" 0, "\\footnotesize{0.5}" 0.5, "\\footnotesize{1.0}" 1.0, "\\footnotesize{1.5}" 1.5) offset 0.4, 0

df3_minus = 1.84

unset label 1
unset label 2
set label 1 sprintf("\\footnotesize{$d_f^- = %g$}", df3_minus) at graph 0.1,0.8

plot for [i=1:filenum] files3[i] u ($2/L_values[i]**df3_minus):($4*L_values[i]**df3_minus) lc rgb colors[i] pt point[i] notitle

unset multiplot
