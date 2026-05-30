#!/usr/bin/env gnuplot

reset

set terminal epslatex lw 2 standalone header "\\usepackage{graphicx} \\usepackage{amsmath}" size 5in, 5in
set output "C1p_df_broken_plt.tex"

set pointsize 2
set key right bottom

set xlabel "$L$" offset 0,1
set ylabel "$\\mathcal{O}/L^{d_f}$" offset 1,0

set logscale x
set xtics ("256" 256, "512" 512, "1024" 1024, "2048" 2048, "4096" 4096, "8192" 8192)
set xtics nomirror
set ytics nomirror

set xrange [200:10000]
set samples 500

filenum = 3
array files[filenum]
files[1] = "raw_data/cmp.C1p_minus"
files[2] = "raw_data/cmp.incre"
files[3] = "raw_data/cmp.C1p"

array titles[filenum] = ["$C_{1,G}$", "$G_1$", "$C_{1,G}^+$"]
array colors[filenum] = ["red", "blue", "black"]
array point[filenum] = [4, 6, 8]
array dfzong[filenum] = [1.837, 1.872, 1.8525]
array a0[filenum] = [0.605, 0.357, 0.951]

tick_spacing = 0.01
n_ticks = 3.0
pad = 0.003

round_tick(x, s) = s * floor(x / s + 0.5)

lm = 0.12
rm = 0.98
bm = 0.08
tm = 0.98
gap = 0.015
h = (tm - bm - 2.0 * gap) / 3.0

b1 = bm
t1 = bm + h
b2 = t1 + gap
t2 = b2 + h
b3 = t2 + gap
t3 = tm

dx = 0.007
dy = 0.007

set label 100 "$\\mathcal{O}/L^{d_f}$" at screen 0.024, screen 0.52 center rotate by 90 front

set arrow 101 from screen (lm - dx), screen (b3 - dy) to screen (lm + dx), screen (b3 + dy) nohead lw 1 front
set arrow 102 from screen (rm - dx), screen (b3 - dy) to screen (rm + dx), screen (b3 + dy) nohead lw 1 front
set arrow 103 from screen (lm - dx), screen (t2 - dy) to screen (lm + dx), screen (t2 + dy) nohead lw 1 front
set arrow 104 from screen (rm - dx), screen (t2 - dy) to screen (rm + dx), screen (t2 + dy) nohead lw 1 front
set arrow 105 from screen (lm - dx), screen (b2 - dy) to screen (lm + dx), screen (b2 + dy) nohead lw 1 front
set arrow 106 from screen (rm - dx), screen (b2 - dy) to screen (rm + dx), screen (b2 + dy) nohead lw 1 front
set arrow 107 from screen (lm - dx), screen (t1 - dy) to screen (lm + dx), screen (t1 + dy) nohead lw 1 front
set arrow 108 from screen (rm - dx), screen (t1 - dy) to screen (rm + dx), screen (t1 + dy) nohead lw 1 front

set multiplot

# top panel: C_{1, G}^+
set yrange [*:*]
stats files[3] using ($1 >= 256 ? $2 / $1**(dfzong[3] - 2.0) : 1/0) nooutput
ymin = STATS_min
ymax = STATS_max
center = (ymin + ymax) / 2.0
center_tick = round_tick(center, tick_spacing)
half_range = (n_ticks - 1.0) / 2.0 * tick_spacing
ylow = center_tick - half_range - pad
yhigh = center_tick + half_range + pad
yt1 = center_tick - tick_spacing
yt2 = center_tick
yt3 = center_tick + tick_spacing
set lmargin at screen lm
set rmargin at screen rm
set bmargin at screen b3
set tmargin at screen t3
set yrange [ylow:yhigh]
set ytics (sprintf("%.2f", yt1) yt1, sprintf("%.2f", yt2) yt2, sprintf("%.2f", yt3) yt3)
unset xtics
unset mxtics
unset x2tics
unset mx2tics
unset xlabel
unset ylabel
set border 2+4+8
set key right bottom
set label 1 sprintf("\\color{black}{$d_{f} = %.3f$}", dfzong[3]) at first 600, first (ylow + 0.15 * (yhigh - ylow)) front
plot files[3] u ($1 >= 256 ? $1 : 1/0):($2 / $1**(dfzong[3] - 2)):($3 / $1**(dfzong[3] - 2)) \
    with err lc rgb colors[3] pt point[3] title titles[3], \
    a0[3] lw 2 lc rgb colors[3] dt 42 notit
unset label 1

# middle panel: C_{1, G}
set yrange [*:*]
stats files[1] using ($1 >= 256 ? $2 / $1**(dfzong[1] - 2.0) : 1/0) nooutput
ymin = STATS_min
ymax = STATS_max
center = (ymin + ymax) / 2.0
center_tick = round_tick(center, tick_spacing)
half_range = (n_ticks - 1.0) / 2.0 * tick_spacing
ylow = center_tick - half_range - pad
yhigh = center_tick + half_range + pad
yt1 = center_tick - tick_spacing
yt2 = center_tick
yt3 = center_tick + tick_spacing
set lmargin at screen lm
set rmargin at screen rm
set bmargin at screen b2
set tmargin at screen t2
set yrange [ylow:yhigh]
set ytics (sprintf("%.2f", yt1) yt1, sprintf("%.2f", yt2) yt2, sprintf("%.2f", yt3) yt3)
unset xtics
unset mxtics
unset x2tics
unset mx2tics
unset xlabel
unset ylabel
set border 2+8
set key right bottom
set label 2 sprintf("\\color{red}{$d_{f} = %.3f$}", dfzong[1]) at first 600, first (ylow + 0.15 * (yhigh - ylow)) front
plot files[1] u ($1 >= 256 ? $1 : 1/0):($2 / $1**(dfzong[1] - 2)):($3 / $1**(dfzong[1] - 2)) \
    with err lc rgb colors[1] pt point[1] title titles[1], \
    a0[1] lw 2 lc rgb colors[1] dt 42 notit
unset label 2

# bottom panel: G_1
set yrange [*:*]
stats files[2] using ($1 >= 256 ? $2 / $1**(dfzong[2] - 2.0) : 1/0) nooutput
ymin = STATS_min
ymax = STATS_max
center = (ymin + ymax) / 2.0
center_tick = round_tick(center, tick_spacing)
half_range = (n_ticks - 1.0) / 2.0 * tick_spacing
ylow = center_tick - half_range - pad
yhigh = center_tick + half_range + pad
yt1 = center_tick - tick_spacing
yt2 = center_tick
yt3 = center_tick + tick_spacing
set lmargin at screen lm
set rmargin at screen rm
set bmargin at screen b1
set tmargin at screen t1
set yrange [ylow:yhigh]
set ytics (sprintf("%.2f", yt1) yt1, sprintf("%.2f", yt2) yt2, sprintf("%.2f", yt3) yt3)
set xtics nomirror
set xtics ("256" 256, "512" 512, "1024" 1024, "2048" 2048, "4096" 4096, "8192" 8192)
unset x2tics
unset mx2tics
set xlabel "$L$" offset 0, 0.4
unset ylabel
set border 1+2+8
set key right bottom
set label 3 sprintf("\\color{blue}{$d_{f} = %.3f$}", dfzong[2]) at first 600, first (ylow + 0.15 * (yhigh - ylow)) front
plot files[2] u ($1 >= 256 ? $1 : 1/0):($2 / $1**(dfzong[2] - 2)):($3 / $1**(dfzong[2] - 2)) \
    with err lc rgb colors[2] pt point[2] title titles[2], \
    a0[2] lw 2 lc rgb colors[2] dt 42 notit
unset label 3

unset multiplot
set output