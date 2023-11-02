function rtu_get_gauss_norm, hw, pos, lng

m = alog(2)/hw^2
k = indgen(lng)

return, sqrt(m/!PI)*exp(-((k-pos)^2)*m)

end
