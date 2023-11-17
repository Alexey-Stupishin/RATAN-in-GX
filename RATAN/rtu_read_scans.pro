; rtu_read_scans
; Reads RATAN scans (format version 1.0.20.520)
;
; Parameters description (see also section Comments below):
;
; Parameters required (in):
;   filename    (string)       - RATAN scans data filename
;
; Parameters required (out):
;   scans_R     (2-D double)   - observed scans, R-polarisation (sfu/arcsec). 1-D - scans themselves, 2-D - frequencies (see Comment (*), (**))
;   scans_L     (2-D double)   - observed scans, L-polarisation (sfu/arcsec). 1-D - scans themselves, 2-D - frequencies (see Comment (*), (**))
;   xarc        (1-D double)   - positions of scan points (arcsec) (see Comment (***))
;   freqs       (1-D double)   - observation frequencies (Hz)
;   pos_angle   (double)       - RATAN positional angle (degrees)
;
; Parameters optional (out):
;   date_obs    (string)       - observation date/time
;   index       (struct)       - data index (incl. CDELT1, CRVAL1, CRPIX1, NAXIS1, ...) (see Comment (***))
;   parstr      (struct)       - parameters set used for data preparation (internal use)
;   verbose     (integer, key) - if set, forces header info console output
;   
; Comments:
;   (*) Quiet Sun level was subtracted!
;   (**) Left and Right polarization scans might be swapped (if SWAP_RL field in the header is defined and not zero)
;   (***) If SHIFT_HMI field in the header is defined, it can be used to correct scan positioning (xarc += SHIFT_HMI)
;
; (c) Alexey G. Stupishin, Saint Petersburg State University, Saint Petersburg, Russia, 2020-2023
;     mailto:agstup@yandex.ru
;     Courtesily following by Tatyana I. Kaltman
;
;--------------------------------------------------------------------------;
;             I will battle for the Sun                                    ;
;     \|/     And I won’t stop until I’m done                     \|/      ;
;    --O--                                                       --O--     ;
;     /|\                                             Placebo     /|\      ;
;                                  "Battle for the Sun", 2009              ;
;--------------------------------------------------------------------------;
;
;-------------------------------------------------------------------------------------------------
pro rtu_read_scans, filename $ ; in
                  , scans_R, scans_L, xarc, freqs, pos_angle $ ; out
                  , date_obs = date_obs, index = index, parstr = parstr $ ; optional out
                  , verbose = verbose ; optional out
compile_opt idl2

openr, unit, filename, /GET_LUN 

line = ''
fstate = 'header'
scans_R = !NULL
scans_L = !NULL
xarc = !NULL
freqs = !NULL
index = !NULL
parstr = !NULL
shift_hmi = 0d
swap_RL = 0L
while ~eof(unit) do begin
    readf, unit, line
    case fstate of
        'header': begin
            cstate = rtu_read_headline(line, sect, key, value)
            if n_elements(verbose) gt 0 && verbose then print, sect, '.', key, ' = ', value
            if strcmp(sect, 'MAIN') then begin
                foo = where(key eq ['N_FREQS', 'N_POINTS', 'SWAP_RL'], count)
                if count gt 0 then value = fix(value)
                index = create_struct(key, value, index)
                if strcmp(key, 'N_FREQS') then n_freqs = value
                if strcmp(key, 'N_POINTS') then n_points = value
                if strcmp(key, 'SHIFT_HMI') then shift_hmi = value
                if strcmp(key, 'SWAP_RL') then swap_RL = value
            endif
            if strcmp(sect, 'PAR') then begin
                parstr = create_struct(key, value, parstr)
            endif
            if cstate eq -1 then begin ; read data header
                xarc = dblarr(n_points)
                freqs = dblarr(n_freqs)
                scans_R = dblarr(n_points, n_freqs)
                scans_L = dblarr(n_points, n_freqs)
                
                ; fill data header
                out = double(strsplit(line, ' ', /EXTRACT))
                for k = 0, n_freqs-1 do freqs[k] = out[3*k + 1]
                
                fstate = 'data'
                cnt = 0
            end
        end
        else: begin
            out = double(strsplit(line, ' ', /EXTRACT))
            xarc[cnt] = out[0]
            for k = 0, n_freqs-1 do begin
                scans_R[cnt, k] = out[3*k + 1]
                scans_L[cnt, k] = out[3*k + 2]
            endfor
            cnt++
            if cnt ge n_points then break
        end
    endcase
endwhile

if swap_RL then begin
    foo = scans_R
    scans_R = scans_L
    scans_L = foo
endif

index = create_struct('NAXIS', 2L, index)
index = create_struct('NAXIS1', n_points, index)
index = create_struct('NAXIS2', n_freqs, index)
index = create_struct('CRVAL1', 0d, index)
index = create_struct('CRPIX1', -xarc[0]/index.CDELT1 + 1, index)
center = (xarc[0]+xarc[-1])/2d
index = create_struct('XCEN', center, index)
index = create_struct('XC', center, index)
freqs *= 1d9
scans_R *= 1d-4
scans_L *= 1d-4
pos_angle = index.RATAN_P
date_obs = index.DATE_OBS + 'T' + index.TIME_OBS
date_obs = strreplace(date_obs, '/', '-')
index.date_obs = date_obs

asu_set_struct_field_safe, index, 'SHIFT_HMI', shift_hmi
asu_set_struct_field_safe, index, 'SWAP_RL', swap_RL

close, unit
free_lun, unit

end
