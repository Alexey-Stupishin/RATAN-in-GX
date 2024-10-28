pro asu_gxm_maplist2data, map, data, index, freqs = freqs, freq_set = freq_set, tolerance = tolerance
compile_opt idl2

data = !NULL
index = !NULL

rmap = map
if isa(rmap, 'string') then begin
    restore, rmap
    rmap = map
endif
if isa(rmap, 'map') then begin
    rmap = rmap.getlist()
endif

nlist = rmap.Count()

asu_gxm_get_index, rmap[0], index0
sz = size(rmap[0].data)

for k = 0, nlist-1 do begin
    map_k = rmap[k]
    if data eq !NULL then begin
        asu_gxm_get_index, map_k, index1
        data = reform(dblarr(sz[1], sz[2], nlist), sz[1], sz[2], nlist)
        index = replicate(index1, nlist)
    endif
    asu_gxm_map2data, map_k, data1, index1
    data[*,*,k] = data1
    index[k] = index1    
endfor

asu_gxm_freq_filter, index, data, freqs = freqs, freq_set = freq_set, tolerance = tolerance

end
