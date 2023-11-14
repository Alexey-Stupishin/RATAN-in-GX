; rtu_read_scans
; Reads RATAN scans (format version 1.0.20.520)
;
; Parameters description (see also section Comments below):
;
; Parameters required (in):
;   filename    (string)       - RATAN scans data filename
;
; Parameters required (out):
;   scans_R     (2-D double)   - observed scans, R-polarisation (sfu/arcsec). 1-D - scans themselves, 2-D - frequencies
;   scans_L     (2-D double)   - observed scans, L-polarisation (sfu/arcsec). 1-D - scans themselves, 2-D - frequencies
;   xarc        (1-D double)   - positions of scan points (arcsec)
;   freqs       (1-D double)   - observation frequencies (Hz)
;   pos_angle   (double)       - RATAN positional angle (degrees)
;
; Parameters optional (out):
;   date_obs    (string)       - observation date/time
;   index       (struct)       - data index (incl. CDELT1, CRVAL1, CRPIX1, NAXIS1)
;   parstr      (struct)       - parameters set used for data preparation (internal use)
;   verbose     (integer)      - if set, forces header info console output
;   
; Comments:
;   Please note that quiet Sun level was subtracted!
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
                  , date_obs = date_obs, index = index, parstr = parstr $
                  , verbose = verbose 
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
offset = 0
while ~eof(unit) do begin
    readf, unit, line
    case fstate of
        'header': begin
            cstate = spectr_ratan_read_headline(line, sect, key, value)
            if n_elements(verbose) gt 0 && verbose then print, sect, '.', key, ' = ', value
            if strcmp(sect, 'MAIN') then begin
                index = create_struct(key, value, index)
                if strcmp(key, 'N_FREQS') then n_freqs = fix(value)
                if strcmp(key, 'N_POINTS') then n_points = fix(value)
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
                offset = out[0]
                index = create_struct('offset', offset, index)
                for k = 0, n_freqs-1 do freqs[k] = out[3*k + 1]
                
                fstate = 'data'
                cnt = 0
            end
        end
        else: begin
            out = double(strsplit(line, ' ', /EXTRACT))
            xarc[cnt] = out[0] + offset
            for k = 0, n_freqs-1 do begin
                scans_R[cnt, k] = out[3*k + 1]
                scans_L[cnt, k]  = out[3*k + 2]
            endfor
            cnt++
            if cnt ge n_points then break
        end
    endcase
endwhile

index = create_struct('NAXIS', 2, index)
index = create_struct('NAXIS1', n_points, index)
index = create_struct('NAXIS2', n_freqs, index)
index = create_struct('CRVAL1', 0, index)
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

close, unit
free_lun, unit

end
