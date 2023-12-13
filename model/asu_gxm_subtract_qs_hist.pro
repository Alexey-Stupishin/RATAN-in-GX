function asu_gxm_subtract_qs_hist_find_peak, data, main_peak = main_peak

compile_opt idl2

m = max(data, im)
prev = m
left = m
for k = im, 0, -1 do begin
    if data[k] gt prev then break
    left = k
    prev = data[k]
endfor
prev = m
right = m
for k = im, n_elements(data)-1 do begin
    if data[k] gt prev then break
    right = k
    prev = data[k]
endfor
main_peak = [left, right]

return, data[im]

end

function asu_gxm_subtract_qs_hist, rmap0, p_limit = p_limit, verbose = verbose
; initial approach uses Freedman-Diaconis rule, see Freedman, D. and Diaconis, P. (1981). Zeit. Wahr. ver. Geb., 57, 453–476. 

compile_opt idl2

default, verbose, 0
default, p_limit, 1.5d

level = 0

idxs = where(rmap0 ne 0, count)
rmap = alog10(rmap0[idxs])

med = median(rmap)
idxs = where(rmap lt med)
mleft = median(rmap[idxs])
idxs = where(rmap ge med)
mright = median(rmap[idxs])
IQR = mright - mleft
tot = n_elements(rmap)

bin_width = 2*IQR/tot^(1/3d)
h = HISTOGRAM(rmap, LOCATIONS = locs, BINSIZE = bin_width)
if verbose then plot, locs, h
nbins = n_elements(locs)

prev = !NULL
prevlocs = !NULL
for k = 0, 20 do begin
    if verbose then print, level
    center_m = asu_gxm_subtract_qs_hist_find_peak(h, main_peak = main_peak)
    level = 10^((locs[main_peak[0]] + locs[main_peak[1]]) / 2d)
    idxs = []
    if main_peak[0] ne 0 then begin
        idxs = [idxs, indgen(main_peak[0])]
    endif
    right = n_elements(h)-1-main_peak[1]
    if right ne 0 then begin
        idxs = [idxs, indgen(right)+main_peak[1]]
    endif
    center_l = asu_gxm_subtract_qs_hist_find_peak(h[idxs])
    p_ratio = double(center_m)/double(center_l)
    if prev ne !NULL && p_ratio le p_limit && p_ratio le prev then break
    prev = p_ratio
    nbins *= 2
    h = HISTOGRAM(rmap, LOCATIONS = locs, NBINS = nbins)
    if verbose then plot, locs, h
endfor

return, level

end
