iptsetpref('ImshowBorder','tight');

imsz = 100;
im2 = zeros(imsz);

std = 0.5;
std2 = 0.05;

nofl = 10000;



minv = 0;
maxv = 100;

binsize = 10;
nofmol = 1;

xcent = 5;
ycent = 5;

figure(1);
subplot(1,2,2);
imshow(im2,[minv,maxv]);

aviobj = avifile('mymovie.avi','fps',25);
in2 = 1;
for o=1:300
    
 
    im =  zeros(imsz);
    in = 1;
    for i=1:nofmol
        for j=1:nofl
            x(in) = xcent + std*randn() ;
            y(in) = ycent + std*randn() ;
            in = in + 1;
        end
    end
    
    y = round(binsize*y);
    x = round(binsize*x);
    
    for i=1:length(x)
        if(x(i) > 0 && y(i) > 0 && x(i) < imsz && y(i) < imsz)
            if(im(y(i),x(i)) == 5000)
                im(y(i),x(i)) = 0;
            end
            im(y(i),x(i)) = im(y(i),x(i)) + 1;
        end
    end
    
    figure(1)
    subplot(1,2,1);
    imshow(im,[minv,maxv]);
    colormap('gray');
    
    figure(1)
    subplot(1,2,1);
    hold on;
    colormap('gray');
    xnow(in2) = 10*(xcent + std2*randn());
    ynow(in2) = 10*(ycent + std2*randn());
    plot(xnow(in2),ynow(in2),'x','Markersize',15,'color','red','linewidth',3);
    
    h = figure(1)
    subplot(1,2,2);
    hold on;
    plot(xnow(in2),ynow(in2),'.','Markersize',5,'color','red');
    set(h, 'color', [1 1 1])
    
    in2 = in2 + 1;
    
    frame = getframe(h);
    aviobj = addframe(aviobj,frame);
end

aviobj = close(aviobj);

h = figure(2)
imshow(im,[minv,maxv]);
colormap('gray');

saveas(h, 'subplot1.png', 'png')

h =  figure(3)
imshow(im2,[minv,maxv]);
hold on;
plot(xnow,ynow,'.','Markersize',5,'color','red');
saveas(h, 'subplot2.png', 'png')