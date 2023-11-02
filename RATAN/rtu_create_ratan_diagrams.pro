pro rtu_create_ratan_diagrams, freq, sz, step, basearc, diagrH, diagrV, mode = mode, c = c, b = b

default, mode, 6

lng = sz[0]
points = basearc[1]/step[1] + indgen(sz[1])
rtu_get_ratan_hpbw, freq, vert, horz, mode = mode, c = c, b = b
diagrV = rtu_get_gauss_points(vert/step[1]/2d, double(points))

if mode eq 8 then begin
    diagrH = rtu_get_twosinc_norm(freq, step[0], c, b/2, (lng-1)/2d + lng, 3*lng)
endif else begin
    diagrH = rtu_get_gauss_norm(horz/step[0]/2d, (lng-1)/2d + lng, 3*lng)
endelse

end
