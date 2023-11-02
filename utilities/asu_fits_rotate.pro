pro asu_fits_rotate, data, index, alpha, out_data, out_index, missing = missing

if n_elements(missing) eq 0 then missing = 0

ca = cos(alpha*!dtor)
sa = sin(alpha*!dtor)

sz = size(data)
n3 = sz[0] eq 2 ? 1 : sz[3] 
out_data = dblarr(sz[1], sz[2], n3)
out_index = index

for k = 0, n3-1 do begin
    out_data[*,*,k] = rot(data[*,*,k], alpha, missing = missing)
    out_index[k].xcen = index[k].xcen*ca - index[k].ycen*sa
    out_index[k].ycen = index[k].ycen*ca + index[k].xcen*sa
    out_index[k].crpix1 = out_index[k].xcen/out_index[k].cdelt1 + (sz[1]-1)/2d 
    out_index[k].crpix2 = out_index[k].ycen/out_index[k].cdelt2 + (sz[2]-1)/2d 
endfor

end
