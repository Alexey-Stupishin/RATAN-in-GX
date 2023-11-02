; AGS Utilities collection
;   RATAN position angle as a function of observation azimuth, Solar declination, and Solar position angle 
;   
; Call:
;   posangle = asu_ratan_position_angle(azimuth, sol_dec, solar_p)
; 
; Parameters:
;     Required:
;         azimuth (in)  RATAN azimuth (usually in the range -30:30), degrees
;         sol_dec (in)  solar declination, degrees
;         solar_p (in)  solar position angle, degrees
;         
; Return value:
;     RATAN position angle (between "E-W" line and RATAN scan line), counter clock wise, degrees
;           (positive e.g. if the RATAN line goes from bottom-left to top-right direction)                    
; 
; Sources: Scientific report, SAO RAN, 1983
;    
; (c) Alexey G. Stupishin, Saint Petersburg State University, Saint Petersburg, Russia, 2017-2020
;     mailto:agstup@yandex.ru
;
;--------------------------------------------------------------------------;
;     \|/     Set the Controls for the Heart of the Sun           \|/      ;
;    --O--        Pink Floyd, "A Saucerful Of Secrets", 1968     --O--     ;
;     /|\                                                         /|\      ;  
;--------------------------------------------------------------------------;

function asu_ratan_position_angle, azimuth, sol_dec, solar_p

if (solar_p GT 180d) then solar_p = solar_p - 360d
if (solar_p LT -180d) then solar_p = solar_p + 360d

solrtn = solar_p + asin(-tan(azimuth*!dtor)* tan(sol_dec*!dtor)) /!dtor;

return, solrtn

end
