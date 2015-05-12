koo = load('dat.txt');

x = koo(:,1);
y = koo(:,2);

std = 0.5;

nofl = 10000;

nofmol = size(x,1);

in = 1;
for i=1:nofmol
    for j=1:nofl
       xloc(in) = x(i) + std*randn() ;
       yloc(in) = y(i) + std*randn() ;
       in = in + 1;
    end
end

figure(1)
plot(xloc,yloc,'.');
axis equal

simdata = fopen('simdata.dat','w');

for i=1:nofmol*nofl
    fprintf(simdata,'%6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \n',xloc(i),yloc(i),i,1000,1000,0,1,1);
end
