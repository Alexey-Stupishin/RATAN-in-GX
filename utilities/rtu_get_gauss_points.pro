function rtu_get_gauss_points, hw, points

a0 = points[0];
n = n_elements(points) - 1;
P = (points[n] - a0)/n;
m = alog(2)/hw^2
k = indgen(n+1)

return, exp(-((k*P + a0)^2)*m)

end
