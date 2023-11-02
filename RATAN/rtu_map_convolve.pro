function rtu_map_convolve, fluxmap, dH, dV, step, mode = mode, c = c, b = b

szmap = size(fluxmap)
ndH = n_elements(dH)
;assert, szmap[2] = n_elements(dV)

purescan = fluxmap # dV
ndS = n_elements(purescan)
nzeros = floor((ndH-ndS)/2d)
slast = ndH-ndS-1
exscan = [dblarr(nzeros), purescan, dblarr(ndH-nzeros-ndS)]

;scan = convol(purescan, dH, /EDGE_TRUNCATE) / step[0]
exconv = convol(exscan, dH, /EDGE_ZERO, /CENTER) / step[0]
scan = exconv[nzeros:slast]

return, scan

end
