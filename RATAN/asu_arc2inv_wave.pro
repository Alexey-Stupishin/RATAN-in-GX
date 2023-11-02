function asu_arc2inv_wave, arcsec, freq

return, arcsec /(3600d*180d) *(2d *!PI^2) *freq / 299792458d

end
