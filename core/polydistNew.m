function w=polydistNew(z, vertic)
% vertic(1) =vertic(end)
    m=length(vertic);
    if m == 1
        u = abs(z - vertic(m));
        w=u;
        return;
    end
    
    u=1000;
    for j=1:(m-1)
        u=min(u,mysegdist(z,vertic(j),vertic(j+1)));
    end
    w=u;
end

% Projection of a on L(b,c) is basea

% Intersection of L(a,b) and L(c,d) is LIS(a,b,c,d)
%LIS=@(a,b,c,d)((c-d)*(-a*conj(b)+conj(a)*b)- (a-b)*(-c*conj(d)+conj(c)*d))/...
%    ((c-d)*conj(a-b) - (a-b)*conj(c-d) );

function y=mysegdist(z,a,b)
    w=min([abs(z-a),abs(z-b)]);
    M=max([abs(z-a),abs(z-b)]);
    if M^2<w^2+abs(a-b)^2
        myreflect=@(z,a,b)( ((a-b)/conj(a-b))*conj(z)- (a*conj(b)-conj(a)*b)/(conj(a-b)) );
        % If w=myreflect(z,a,b), then trivially, the projection of 
        % z on L(a,b) is (z+w)/2
        basez=(z+myreflect(z,a,b))/2;
        w=min([w,abs(z-basez)]);
    end
    y=w;
end