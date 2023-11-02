function rtu_get_twosinc_norm, freq, step, kapp, scale, pos, length

counts = (findgen(length) - pos) * step

;hhpbw = asu_inv_wave2arc(horz/scale, freq)
;counts /= hhpbw

counts = asu_arc2inv_wave(counts*scale, freq)

v = (asm_twosinc(counts, kapp))^2

return, v/total(v)

end
