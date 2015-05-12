function [im] = crim(xrawn,yrawn,binsize,imsz)

y = round(binsize*yrawn);
x = round(binsize*xrawn);
    
im = zeros(imsz);
for i=1:length(x)
    if(x(i) > 0 && y(i) > 0 && x(i) < imsz && y(i) < imsz)
        im(y(i),x(i)) = im(y(i),x(i)) + 1;
    end
end

end