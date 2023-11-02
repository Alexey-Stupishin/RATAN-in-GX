pro asu_gxm_calc_model_data, data, index $ ; obligatory in, data R/L, sfu
                           , out_data, out_index, xarc $   ; obligatory out, out_data in sfu
                           , freqs = freqs, subtr = subtr, pos_angle = pos_angle $ ; optional in
                           , scans = scans, visstep = visstep ; optional out
compile_opt idl2

out_data = data
out_index = index

if n_elements(pos_angle) ne 0 then begin
    asu_fits_rotate, data, index, pos_angle, out_data, out_index
endif
if n_elements(subtr) ne 0 then out_data -= subtr

visstep = out_index[0].cdelt1
sz = size(out_data)
xarc = (indgen(sz[1])-(sz[1]-1)/2d)*visstep + out_index[0].xcen

if arg_present(scans) then begin
    scans = rtu_get_scans_by_data(out_data, out_index, freqs)
end

end 