; asu_gxm_calc_model_data
; Calculates emulated RATAN scans by GX-simulator-modelled radiomaps
;
; Parameters description (see also section Comments below):
;
; Parameters required (in):
;   data       (3-D double)     - list of radiomaps (R/L), as it generated by GX-simulator (sfu).  (1,2-D - coordinates, 3-D - frequencies)
;   index      (1-D struct)     - corresponding index stuctures (for each frequency)
;
; Parameters required (out):
;   scans      (2-D double)     - resulting scans (sfu/arcsec). 1-D - scans themselves, 2-D - frequencies
;   xarc       (1-D real)       - positions of scan points (arcsec)
;   
; Parameters optional (in):
;   beam_mode  (integer)        - RATAN beam type, default = 3 (other modes will be specified)
;   scan_lim   (2-elem. real)   - limits for scan calculation (arcsec). If omitted, scan limits are the same as (maybe rotated) map limits on X-axis.
;   pos_angle  (real)           - RATAN position angle (default = 0). See asu_ratan_position_angle.pro, asu_ratan_position_angle_by_fits.pro.
;                                 If maps in 'maplist' are already rotated to the RATAN position angle, should be omitted or set to 0.
;   subtr      (3-D real)       - if specified, shouild be of the same size as radiomaps (1,2-D - coordinates, 3-D - frequencies). Will be subtract
;                                 from the maps in 'maplist' before scan calculation
;
; Parameters optional (out):
;   out_data   (3-D double)     - radiomaps to calculate scans ((1,2-D - coordinates, 3-D - frequencies)). See Comment (*)
;   out_index  (1-D struct)     - corresponding index stuctures (for each frequency). See Comment (*)
;
; Comments:
;   (*) If 'pos_angle' is omitted or zero, 'out_data', 'out_index' are the same as 'data', 'index',
;           otherwise 'out_data' is rotated maps, and 'out_index' corresponds to this rotated data (xcen, ycen, crpix1,2 recalculated).
;
; (c) Alexey G. Stupishin, Saint Petersburg State University, Saint Petersburg, Russia, 2023
;     mailto:agstup@yandex.ru
;
;--------------------------------------------------------------------------;
;             Here comes the Sun, and I say                                ;
;     \|/     It's alright                                        \|/      ;
;    --O--                                                       --O--     ;
;     /|\                                         The Beatles     /|\      ;
;                                          "Abbey Road", 1969              ;
;--------------------------------------------------------------------------;
;
;-------------------------------------------------------------------------------------------------
pro asu_gxm_calc_model_data, data, index $ ; obligatory in, data R/L, sfu
                           , scans, xarc $ ; obligatory out
                           , beam_mode = beam_mode, scan_lim = scan_lim, pos_angle = pos_angle $ ; optional in
                           , subtr = subtr $ ; optional in
                           , out_data = out_data, out_index = out_index ; optional out, out_data in sfu
compile_opt idl2

out_data = data
out_index = index

if data eq !NULL then begin
    scans = !NULL
    return
endif

if n_elements(pos_angle) ne 0 && pos_angle ne 0 then asu_fits_rotate, data, index, pos_angle, out_data, out_index
if n_elements(subtr) ne 0 then out_data -= subtr

freqs = index.freq * 1d9
scans = rtu_get_scans_by_data(out_data, out_index, freqs, xarc, scan_lim = scan_lim, beam_mode = beam_mode)

end 