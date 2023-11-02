function asu_gxmodel_get_phsph_filter, mask, filter_vals, invert = invert
compile_opt idl2

idxall = []
for i = 0, n_elements(filter_vals)-1 do begin
    idx = where(mask eq filter_vals[i], count)
    if count gt 0 then idxall = [idxall, idx]
endfor    

sz = size(mask)
filter = intarr(sz[1], sz[2])
if n_elements(invert) gt 0 then begin
    filter += 1
endif
if n_elements(idxall) gt 0 then begin
    filter[idxall] = n_elements(invert) eq 0 ? 1 : 0
endif    

return, filter

end
