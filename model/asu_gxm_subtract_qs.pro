function asu_gxm_subtract_qs, data, index, mode = mode, levels = levels, err_code = err_code, verbose = verbose

compile_opt idl2

err_code = 0

default, mode, 1

sz = size(data)
if mode eq 99 then begin
    if n_elements(levels) eq 0 then err_code = 1 & return, !NULL
    if n_elements(levels) ne sz[3] then err_code = 2 & return, !NULL
endif
if n_elements(levels) eq 0 then levels = dblarr(sz[3])

data_subtr = data
for k = 0, sz[3]-1 do begin
    case mode of
        1: levels[k] = asu_gxm_subtract_qs_hist(data[*, *, k], verbose = verbose)
    endcase
    
    data_subtr[*, *, k] = data[*, *, k] - levels[k]
endfor

idxs = where(data_subtr lt 0, count)
if count ne 0 then data_subtr[idxs] = 0

return, data_subtr

end
    