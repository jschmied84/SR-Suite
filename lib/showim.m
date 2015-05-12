function showim(xraw,yraw,fignum,imsz,binsize)

xim = round(xraw.*binsize);
yim = round(yraw.*binsize);

im = zeros(imsz);

for i=1:length(xim)
    if(xim(i) > 0 && yim(i) > 0 && xim(i) < imsz && yim(i) < imsz)
        im(yim(i),xim(i)) = im(yim(i),xim(i)) + 1; 
    end    
end

% maxv = max(max(im));
maxv = 3;
figure(fignum);
imshow(im,[0,maxv]);
colormap('hot');