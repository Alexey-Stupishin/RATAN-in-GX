;---------------------------------------------------------------------------
function rtu_read_headline_try_convert, value

valid = 0
on_ioerror, noconv
    out = double(strsplit(value, ' ', /EXTRACT))
    if n_elements(out) eq 1 then out = out[0]
    valid = 1
noconv: if ~valid then out = value

return, out

end

;---------------------------------------------------------------------------
function rtu_read_headline_nokey_string, line, sample, psect, pkey, sect, key, value

found = 0

p = strpos(line, sample)
if p ge 0 then begin
    p += strlen(sample)
    sect = psect
    key = pkey
    value = rtu_read_headline_try_convert(strtrim(strmid(line, p), 2))
    found = 1
endif

return, found

end

;---------------------------------------------------------------------------
function rtu_read_headline_key_string, line, psect, sect, key, value

found = 0
pattern = '# +([.a-zA-Z0-9_-]+) *= *(.*)'
supsect = 'PAR'
pattpar = supsect + '.(.*)'
if stregex(line, pattern, /boolean) then begin
    expr =  stregex(line, pattern, /subexpr, /extract)
    if stregex(expr[1], pattpar, /boolean) then begin
        exppar = stregex(expr[1], pattpar, /subexpr, /extract)
        sect = supsect
        key = exppar[1]
    endif else begin
        sect = psect
        key = expr[1]
    endelse
    value = strtrim(expr[2])
    if ~strcmp(key, 'DATE-OBS') and ~strcmp(key, 'TIME-OBS') then value = rtu_read_headline_try_convert(value)
    key = strreplace(key, '-', '_')
    found = 1
endif

return, found

end

;---------------------------------------------------------------------------
function rtu_read_headline, line, sect, key, value

sect = 'none'
key = ''
value = 0

if strmid(line, 0, 1) eq '#' then begin
    
    ; non 'key = value' items (predefined)
    if rtu_read_headline_nokey_string(line, 'RATAN Selected Scans Data File', 'MAIN', 'VERSION', sect, key, value) then return, 1
    if rtu_read_headline_nokey_string(line, 'generated at', 'MAIN', 'CREATED', sect, key, value) then return, 1
    if rtu_read_headline_nokey_string(line, 'frequencies selected by user for scan', 'MAIN', 'SELFREQS', sect, key, value) then return, 1
    
    ; 'key = value' items
    if rtu_read_headline_key_string(line, 'MAIN', sect, key, value) then return, 1
    
    return, 0 ; undefined header item, ignore
endif else begin
    return, -1
endelse

end
