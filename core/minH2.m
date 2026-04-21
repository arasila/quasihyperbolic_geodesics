function y = minH2(z, w, vertc)
% Approximate hyperbolic distance in a polygonal domain via boundary mapping
% Input:
%   z, w - points in the domain
%   vertc - boundary vertices
% Output:
%   y - approximate hyperbolic distance

m = length(vertc);
wg = inf;

for kk = 1:(m-1)
    a = vertc(kk);
    b = vertc(kk+1);
    A = 1 / (b - a);
    
    zz = A * (z - a);
    ww = A * (w - a);
    
    if (imag(zz) > 0) && (imag(ww) > 0)
        wg = min(wg, rhoH(zz, ww));
    elseif (imag(zz) > 0) && (imag(ww) < 0)
        wg = min(wg, rhoH(zz, conj(ww)));
    elseif (imag(zz) < 0) && (imag(ww) > 0)
        wg = min(wg, rhoH(ww, conj(zz)));
    else
        wg = min(wg, rhoH(conj(ww), conj(zz)));
    end
end

y = wg;
end