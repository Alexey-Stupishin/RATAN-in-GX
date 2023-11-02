pro asu_gxm_freq_filter, index, data, freqs = freqs, freq_set = freq_set

sz = size(data)

freq_set = index.freq * 1e9
n = n_elements(freqs)
if n ne 0 then begin
    xdata = dblarr(sz[1], sz[2], n)
    xindex = replicate(index[0], n)
    xfreq_set = dblarr(n)
    for k = 0, n-1 do begin
        mm = min(abs(freqs[k]-freq_set), idx)
        xdata[*,*,k] = data[*,*,idx]
        xindex[k] = index[idx]
        xfreq_set[k] = freq_set[idx]
    endfor
    data = xdata
    index = xindex
    freq_set = xfreq_set
endif

end
