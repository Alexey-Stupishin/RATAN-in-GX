pro rtu_get_ratan_hpbw, freqs, vert, horz, mode = mode, c = c, b = b

lamb = 29979245800d/freqs
vert = 7.5d * 60d * lamb

default, mode, 6
if mode eq 8 then begin
    default, c, 0.2d
    default, b, 300d
endif else begin
    default, c, 0.009d
    default, b, 8.338d
endelse

case mode of
   1: horz =          8.5  *lamb ; simple, from SAO site
   2: horz =  4.38  + 6.87 *lamb ; theoretical for spiral feed, unrealistic
   3: horz =  0.009 + 8.338*lamb ; some last private letter (S. Tokchukova? Need to clarify)
;   4: horz =  user defined by table lookup, TODO
   5: horz =  0.2   + 9.4  *lamb ; wide, source unknown
   6: horz = -0.16  + 8.162*lamb ; 1-3 GHz, 2023 (spring) by N.Ovchinnikova/M.Lebedev
   7: horz = -0.006 + 8.397*lamb ; Sept 2023, TK Letter 27/09/2023
   8: horz = rtu_get_ratan_twosinc_hpbw(c) ; Sept 2023, TK Letter 27/09/2023, "twosinc", another semantics, seems do not need to calculate
   else: horz =  c  +     b*lamb ; default, see mode = 3
endcase

end
