function asu_gxm_subtract_data, data_gs = data_gs, data_ff = data_ff, params = params

data_subtr = data_ff
data_subtr[*] = 0

if n_elements(params) eq 0 then return, data_subtr

names = tag_names(params)
idx_exc = where(names eq 'NONE')
if idx_exc ge 0 then return, data_subtr

data_subtr = data_ff

idx_exc = where(names eq 'THRESHOLD')
if idx_exc ge 0 then begin
    excess = (data_gs-data_ff)/data_ff
    data_subtr = data_ff
    idx = where(excess gt params.threshold, count)
    if count gt 0 then data_subtr[idx] = 0
endif    

idx_mask = where(names eq 'MASK')
if idx_mask ge 0 then begin
    data_subtr = data_ff
    idx = where(params.mask gt 0, count)
    if count gt 0 then begin
        sz = size(data_subtr)
        for k = 0, sz[3]-1 do begin
            t = data_subtr[*,*,k] 
            t[idx] = 0
            data_subtr[*,*,k] = t 
        endfor    
    endif
endif    

return, data_subtr 

end
    