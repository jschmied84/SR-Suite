FWHM=200;
sig=FWHM/2.3548
c1=300;
c2=c1+0.8*FWHM;
x=0:0.1:800;
y1=gaussmf(x,[sig c1]);
y2=gaussmf(x,[sig c2]);
y3=y1+y2;

figure(1)
plot(x,y1,'LineWidth',3,'color','blue');
hold on;
plot(x,y2,'LineWidth',3,'color','green');
hold on;
plot(x,y3,'LineWidth',5,'color','red');
xlabel('Center Position (nm)');
ylabel('Amplitue (a.u.)');