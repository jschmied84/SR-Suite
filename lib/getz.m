function [z,D]=getz(wx,wy,p,st,en)

%st = 0;
%en = 1200;
in = 1;
wmh = (wx)-(wy);

for i=st:en
    
    w(in) = polyval(p,i);
    xk(in) = i;
    
    D(in) = abs(w(in)-wmh);
       
    in = in + 1;
    
end

% figure(7)
% plot(D);


[val,ind] = min(D);
z = xk(ind)
