function asu_ratan_position_angle_by_fits, fits_file, data = data, header = header, azimuth = azimuth

data = readfits(fits_file, header)
solar_p = fxpar(header,"SOLAR_P")
sol_dec = fxpar(header,'SOL_DEC')
azimuth = fxpar(header,"AZIMUTH")

return, asu_ratan_position_angle(azimuth, sol_dec, solar_p)

end
