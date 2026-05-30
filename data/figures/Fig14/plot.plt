#set terminal wxt enhanced
set terminal epslatex lw 2 standalone header "\\usepackage{graphicx} \\usepackage{amsmath}" size 5in, 4.3in
set output "C1p_critical_window.tex"

set multiplot

# Layout adjustment parameter
ySizeAdjust = 0.018

# Common settings
set pointsize 0.8
set samples 500

# Define system sizes
filenum = 5
array L_values[filenum] = [64, 128, 256, 512, 1024]
array colors[filenum] = ["#90EE90", "blue", "red", "purple", "orange"]
array point[filenum] = [6, 8, 10, 12, 14]

# Function to generate titles with proper spacing
array titles[filenum]
do for [i=1:filenum] {
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

#=== First figure: Pseudo-critical point (C1p5) ===
set size 1.0, 0.51 + ySizeAdjust
set origin 0.0, 0.471 - ySizeAdjust

set key right bottom
set xlabel ""
set xtics (" " -8, " " -4, " " 0, " " 4, " " 8) nomirror
set ylabel "$C_1/L^{d_f}$"
set ytics nomirror
set xrange [-8.5:8.5]
set yrange [-0.1:2.9]
set ytics ("0.0" 0, "0.5" 0.5, "1.0" 1.0, "1.5" 1.5, "2.0" 2.0, "2.5" 2.5)

df = 1.85
xnu = 0.85

array files1[filenum]
do for [i=1:filenum] {
    files1[i] = sprintf("raw_data/C1p5_L%d", L_values[i])
}

set label 1 sprintf("$1/\\nu = %g, \\,\\, d_f = %g$", xnu, df) at graph 0.35,0.95
set label 2 "(a)" at graph 0.05,0.85
set label 3 "$t_0 = \\mathcal{T}_G$" at graph 0.05,0.75

plot for [i=2:filenum] files1[i] u ($2*L_values[i]**xnu):($3*L_values[i]**(2-df)) lc rgb colors[i] pt point[i] notitle

#=== Second figure: Critical point (C1pc) ===
set size 1.0, 0.575 - ySizeAdjust
set origin 0.0, 0.0

set key right bottom
set xlabel "$(t-t_0)L^{1/\\nu}$" offset 0, 0.5
set xtics (-8, -4, 0, 4, 8) nomirror
set ytics nomirror
set ylabel "$C_1/L^{d_f}$"

array files2[filenum]
do for [i=1:filenum] {
    files2[i] = sprintf("raw_data/C1pc_L%d", L_values[i])
}

unset label 1
unset label 2
unset label 3
# set label 1 sprintf("$1/\\nu = %g, \\,\\, d_f = %g$", xnu, df) at graph 0.35,0.95
unset label 1
set label 2 "(b)" at graph 0.05,0.85
set label 3 "$t_0 = t_c$" at graph 0.05,0.75

plot for [i=2:filenum] files2[i] u ($2*L_values[i]**xnu):($3*L_values[i]**(2-df)) lc rgb colors[i] pt point[i] title titles[i]

unset multiplot
