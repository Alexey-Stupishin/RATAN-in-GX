pro asu_gxm_maplist2scans, maplist, out_data, out_index, xarc, freqs = freqs, freq_set = freq_set $
                         , pos_angle = pos_angle, visstep = visstep $
                         , scans = scans, subtr = subtr

asu_gxm_maplist2data, maplist, data, index, freqs = freqs, freq_set = freq_set
asu_gxm_calc_model_data, data, index $
                       , out_data, out_index, xarc $
                       , subtr = subtr, scans = scans $
                       , freqs = freq_set, pos_angle = pos_angle $
                       , visstep = visstep
                       
end
