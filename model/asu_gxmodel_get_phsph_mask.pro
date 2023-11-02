function asu_gxmodel_get_phsph_mask, model, map_magnetogram = map_magnetogram, map_continuum = map_continuum
compile_opt idl2

model->GetProperty, refmaps = refmaps
for i=0, *refmaps.get(/count)-1 do begin
    if *refmaps.get(i,/id) eq 'Bz_reference' then magnetogram = *refmaps.get(i,/map)
    if *refmaps.get(i,/id) eq 'Ic_reference' then continuum = *refmaps.get(i,/map)
endfor

chromo_mask = decompose(magnetogram.data, continuum.data)

fov = model->GetFovMap()
maps = fov.getlist()
rmap = maps[0]
szp = size(rmap.data)
map_xlim = rmap.xc + [-0.5d, 0.5d]*szp[1]*rmap.dx
map_x = linspace(map_xlim[0], map_xlim[1], szp[1])
map_ylim = rmap.yc + [-0.5d, 0.5d]*szp[2]*rmap.dy
map_y = linspace(map_ylim[0], map_ylim[1], szp[2])

szm = size(magnetogram.data)
mag_xlim = magnetogram.xc + [-0.5d, 0.5d]*szm[1]*magnetogram.dx
mag_x = linspace(mag_xlim[0], mag_xlim[1], szm[1])
mag_ylim = magnetogram.yc + [-0.5d, 0.5d]*szm[2]*magnetogram.dy
mag_y = linspace(mag_ylim[0], mag_ylim[1], szm[2])

x_idx_map_in_mag = intarr(szp[1])
for i = 0, szp[1]-1 do begin
    foo = min(abs(map_x[i]-mag_x), idx)
    x_idx_map_in_mag[i] = idx
endfor
    
y_idx_map_in_mag = intarr(szp[2])
for i = 0, szp[2]-1 do begin
    foo = min(abs(map_y[i]-mag_y), idx)
    y_idx_map_in_mag[i] = idx
endfor

t = chromo_mask[x_idx_map_in_mag, *]
map_chromo_mask = t[*, y_idx_map_in_mag]

map_x_norm = (map_x-mag_x[0])/(mag_x[-1]-mag_x[0])*(n_elements(mag_x)-1)
map_y_norm = (map_y-mag_y[0])/(mag_y[-1]-mag_y[0])*(n_elements(mag_y)-1)
map_magnetogram = interpolate(magnetogram.data, map_x_norm, map_y_norm, /GRID)
map_continuum = interpolate(continuum.data, map_x_norm, map_y_norm, /GRID)

return, map_chromo_mask

end
