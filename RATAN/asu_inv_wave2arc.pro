function asu_inv_wave2arc, iw, freq

return, iw *(3600d*180d) /(2d *!PI^2) /freq * 299792458d

end
