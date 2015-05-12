dato = load('82_oben.txt');
datu = load('82_unten.txt');

xo = dato(:,1);
yo = dato(:,2);
zo = dato(:,3);

xom = mean(xo)
yom = mean(yo)
zom = mean(zo)

xu = datu(:,1);
yu = datu(:,2);
zu = datu(:,3);

xum = mean(xu)
yum = mean(yu)
zum = mean(zu)

dist = sqrt((xom-xum)^2 + (yom-yum)^2 + (0.6*zom-0.6*zum)^2)

x = [xu;xo];
y = [yu;yo];
z = [zu;zo];

z = z - max(max(z));
z = -z;
z = z*0.6;

x = x-mean(x);
y = y-mean(y);

figure(1)
plot3(x,y,z,'.','color','red');
axis equal

res = fopen('rocket.3d','w');

for i=1:length(x)
    fprintf(res,'%6.5f \t %6.5f \t %6.5f \t %6.5f \t %6.5f \n', x(i), y(i), z(i), 1000, i);
end

resz = fopen('rocketz.txt','w');

for i=1:length(z)
    fprintf(resz,'%6.5f \n',z(i));
end

figure(2)
hist(z);