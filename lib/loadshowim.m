function loadshowim(name,minv,maxv,imsz,binsize,photfilterlog,gain,camfact,photlimit,ellfilterlog,elllimit,kosmetikfilter,kosmetikfilterthr,zfilter,zfiltermin,zfiltermax)

clear x y
clear global xrawbin yrawbin xraw yraw zraw frn counts bg 
global xrawbin yrawbin zrawbin xraw yraw zraw frn counts bg

dat = load(name);
rxraw = dat(:,1);
ryraw = dat(:,2);
rfrn = dat(:,3);
rcounts = dat(:,4);
rbg = dat(:,5);
rzval = dat(:,6);
rsigx = dat(:,7);
rsigy = dat(:,8);
photons = (rcounts./gain)*camfact;
ell = abs(rsigx./rsigy - 1);


for i=1:length(rxraw)
    if(photons(i) < photlimit)
        photfilter(i) = 1;
    else
        photfilter(i) = 0;
    end
end

for i=1:length(rxraw)
    if(rzval(i) > zfiltermax || rzval(i) < zfiltermin)
        zfilterval(i) = 1;
    else
        zfilterval(i) = 0;
    end
end



for i=1:length(rxraw)
    if(ell(i) > elllimit)
        ellfilter(i) = 1;
    else
        ellfilter(i) = 0;
    end
end


for i=1:length(rxraw)
    filterlog(i) = photfilterlog*photfilter(i) + ellfilterlog*ellfilter(i) + zfilter*zfilterval(i);
end


in = 1;

for i=1:length(rxraw)
    if(filterlog(i) == 0)
        xraw(in) = rxraw(i);
        yraw(in) = ryraw(i);
        zraw(in) = rzval(i);
        frn(in) = rfrn(i);
        counts(in) = rcounts(i);
        bg(in) = rbg(i);
        in = in + 1;
    end    
end


if(filterlog == 0)
    xraw = rxraw;
    yraw = ryraw;
    zraw(in) = rzval(i);
    frn = rfrn;
    counts = rcounts;
    bg = rbg;
end
        

xrawbin = binsize*xraw;
yrawbin = binsize*yraw;
zrawbin = binsize*zraw;

y = round(binsize*yraw);
x = round(binsize*xraw);
z = zraw;

length(x)

% im = 5000*ones(imsz);
im =  zeros(imsz);
im3d = ones(imsz);


for i=1:length(x)
    if(x(i) > 0 && y(i) > 0 && x(i) < imsz && y(i) < imsz)
        if(im(y(i),x(i)) == 5000)
            im(y(i),x(i)) = 0;
        end
        im(y(i),x(i)) = im(y(i),x(i)) + 1; 
        im3d(y(i),x(i)) = im3d(y(i),x(i)) + z(i); 
    end   
end

% in = 1;
% for i=1:imsz
%     for j=1:imsz
%         if(im(i,j) > 0)
%             im3d(i,j) = im3d(i,j)/im(i,j);
%             if(i>1 && j>1 && i < (imsz-1) && j < (imsz-1))
%                 vec = [im3d(i,j) im3d(i-1,j) im3d(i-1,j-1) im3d(i-1,j+1) im3d(i,j-1) im3d(i,j+1) im3d(i+1,j) im3d(i+1,j-1) im3d(i+1,j+1)];
%             else
%                 vec = 0;
%             end
%             indexToNonZero = vec~=0;
%             imstd(i,j) = std(vec(indexToNonZero));
%             imhist(in) = im3d(i,j);
%             imhiststd(in) = imstd(i,j);
%             in = in + 1;
%         end
%     end
% end

%figure(14)
%hist(imhist,100);

%figure(16)
%hist(imhiststd,100);

kosmim = im;

if(kosmetikfilter == 1)
    for i=2:imsz-1
        for j=2:imsz-1
            sum = im(i,j) + im(i-1,j) + im(i-1,j-1) + im(i-1,j+1) + im(i,j-1) + im(i,j+1) + im(i+1,j) + im(i+1,j-1) + im(i+1,j+1);
            if(sum <= kosmetikfilterthr)
                kosmim(i,j) = 0;
            end
        end
    end
end
     
[cmap]=buildcmap('kbgyw'); 
% %try the output cmap: 
% im=imread('cameraman.tif'); 
% imshow(im), colorbar 
% colormap(cmap) %will use the output colormap

figure(1)
if(maxv == 0)
    maxv = 0.5*max(max(kosmim));
end
imshow(kosmim,[minv,maxv]), colorbar
colormap('hot');

%figure(11)
%imshow(im3d,[0,1000]);
%colormap('jet');

%figure(15)
%imshow(imstd,[0,1000]);
%colormap('hot');

savename = [name,'SR-im.png'];
kosmim = (kosmim./maxv);
kosmim = (round(255*kosmim));
imwrite(kosmim,hot,savename);
