function rtu_get_ratan_twosinc_hpbw_loss, t
common G_TWOSINC_ROOT, kapp, f0

return, (asm_twosinc(t, kapp)/f0)^2 - 0.5

end

function rtu_get_ratan_twosinc_hpbw, c
common G_TWOSINC_ROOT, kapp, f0

kapp = c
f0 = asm_twosinc(0, kapp)

val = fx_root([0, 1, 2], 'rtu_get_ratan_twosinc_hpbw_loss', /DOUBLE)

return, val

end
