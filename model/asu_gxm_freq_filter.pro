pro asu_gxm_freq_filter, index, data, freqs = freqs, freq_set = freq_set, tolerance = tolerance
compile_opt idl2

sz = size(data)

default, tolerance, 1d-2

freq_set = index.freq * 1d9
n = n_elements(freqs)
if n ne 0 then begin
    xdata = dblarr(sz[1], sz[2], n)
    xindex = replicate(index[0], n)
    xfreq_set = dblarr(n)
    cnt = 0
    for k = 0, n-1 do begin
        mm = min(abs(freqs[k]-freq_set)/freqs[k], idx)
        if mm le tolerance then begin
            xdata[*,*,cnt] = data[*,*,idx]
            xindex[cnt] = index[idx]
            xfreq_set[cnt] = freq_set[idx]
            cnt++
        endif    
    endfor
    if cnt eq 0 then begin
        data = !NULL
        index = !NULL
        freq_set = !NULL
    endif else begin
        data = xdata[*,*,0:cnt-1]
        index = xindex[0:cnt-1]
        freq_set = xfreq_set[0:cnt-1]
    endelse
endif

end
