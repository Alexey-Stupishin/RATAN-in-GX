pro asu_gxm_get_index, rmap, index
compile_opt idl2

tags = tag_names(rmap)
out_tags = tags
idx = where(tags eq 'DATA', count)
if count gt 0 then begin
    ts = []
    if idx gt 0 then ts = tags[0:idx-1]  
    te = []
    if idx lt n_elements(tags)-1 then te = tags[idx+1:-1]  
    out_tags = [ts, te]
endif

index = {}
for k = 0, n_elements(out_tags)-1 do begin
    idx = where(tags eq out_tags[k], count)
    if count gt 0 then index = create_struct(index, create_struct(out_tags[k], rmap.(idx)))
endfor

sz = size(rmap.data)
crpix1 = rmap.xc/rmap.dx + (sz[1]-1)/2d 
crpix2 = rmap.yc/rmap.dy + (sz[2]-1)/2d

index = create_struct(index, create_struct('CDELT1', rmap.dx))
index = create_struct(index, create_struct('CDELT2', rmap.dy))
index = create_struct(index, create_struct('XCEN', rmap.xc))
index = create_struct(index, create_struct('YCEN', rmap.yc))
index = create_struct(index, create_struct('NAXIS', 2))
index = create_struct(index, create_struct('NAXIS1', sz[1]))
index = create_struct(index, create_struct('NAXIS2', sz[2]))
index = create_struct(index, create_struct('CRPIX1', crpix1))
index = create_struct(index, create_struct('CRPIX2', crpix2))
index = create_struct(index, create_struct('CRVAL1', 0))
index = create_struct(index, create_struct('CRVAL2', 0))

end
