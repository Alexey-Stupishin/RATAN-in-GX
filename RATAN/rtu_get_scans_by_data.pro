function rtu_get_scans_by_data, data, index, freqs
compile_opt idl2

sz = size(data)
if sz[0] eq 2 then sz[3] = 1
basev = (-(sz[2]-1)/2d)*index[0].cdelt2 + index[0].ycen
steps = [index[0].cdelt1, index[0].cdelt2]
scans = dblarr(sz[1], sz[3])
for k = 0, sz[3]-1 do begin
    rtu_create_ratan_diagrams, freqs[k], sz[1:2], steps, [0, basev], diagrH, diagrV
    scans[*,k] = rtu_map_convolve(data[*,*,k]/steps[0]/steps[1], diagrH, diagrV, steps)
endfor  

return, scans

end
