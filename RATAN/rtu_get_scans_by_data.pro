function rtu_get_scans_by_data, data, index, freqs, xarc, scan_lim = scan_lim, beam_mode = beam_mode
compile_opt idl2

default, beam_mode, 8

sz = size(data)
if sz[0] eq 2 then sz[3] = 1
steps = [index[0].cdelt1, index[0].cdelt2]
basev = (-(sz[2]-1)/2d)*index[0].cdelt2 + index[0].ycen

left = (-(sz[1]-1)/2d)*index[0].cdelt1 + index[0].xcen
right = left + (sz[1]-1)*index[0].cdelt1
default, scan_lim, [left, right]
left_wing = round((left-scan_lim[0])/index[0].cdelt1)
right_wing = round((scan_lim[1]-right)/index[0].cdelt1)
lng_src = sz[1]
lng_dst = lng_src + left_wing + right_wing
xarc = linspace(left-left_wing*index[0].cdelt1, right+right_wing*index[0].cdelt1, lng_dst)

from_src = 0
from_dst = 0
if left_wing ge 0 then from_dst += left_wing else from_src -= left_wing
to_src = lng_src-1
to_dst = lng_dst-1
if right_wing ge 0 then to_dst -= right_wing else to_src += right_wing

scans = dblarr(lng_dst, sz[3])
for k = 0, sz[3]-1 do begin
    rtu_create_ratan_diagrams, freqs[k], [lng_dst, sz[2]], steps, [0, basev], diagrH, diagrV, mode = beam_mode
    dk = dblarr(lng_dst, sz[2])
    dk[from_dst:to_dst, *] = data[from_src:to_src,*,k]
    scans[*,k] = rtu_map_convolve(dk/steps[0]/steps[1], diagrH, diagrV, steps)
endfor  

return, scans

end
