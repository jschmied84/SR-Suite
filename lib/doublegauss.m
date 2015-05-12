function [A1,xc1,w1,A2,xc2,w2] = doublegauss(xhn,yhn)

figure(5)
plot(xhn,yhn);

figure(5)
[border,bordery] = (ginput(1));

in1 = 1;
in2 = 1;

for r=1:length(xhn)
    if(xhn(r) < border)
        lxhn(in1) = xhn(r);
        lyhn(in1) = yhn(r);
        in1 = in1 + 1;
    else
        rxhn(in2) = xhn(r);
        ryhn(in2) = yhn(r);
        in2 = in2 + 1;
    end
end
        
%% left Spot
figure(7)
clf
plot(lxhn,lyhn,'color','green');

clear Starting1

Starting1(1) = max(lyhn);
Starting1(2) = mean(mean(lxhn));
Starting1(3) = std(lxhn);

options=optimset('Display','iter');
Estimates1=fminsearch(@myfitsinggauss,Starting1,options,lxhn,lyhn);

A1 = Estimates1(1)
xc1 = Estimates1(2)
w1 = Estimates1(3)

t1 = min(lxhn):0.01:max(rxhn);
figure(7)
hold on;
plot(t1,A1*exp(-0.5*((t1-xc1)/w1).^2),'r','LineWidth',1,'color','red');

%% right Spot 
figure(8)
clf
plot(rxhn,ryhn,'color','green');

clear Starting2

Starting2(1) = max(ryhn);
Starting2(2) = mean(mean(rxhn));
Starting2(3) = std(rxhn);


options=optimset('Display','iter');
Estimates2=fminsearch(@myfitsinggauss,Starting2,options,rxhn,ryhn);

A2 = Estimates2(1)
xc2 = Estimates2(2)
w2 = Estimates2(3)

t2 = min(lxhn):0.01:max(rxhn);
figure(8)
hold on;
plot(t2,A2*exp(-0.5*((t2-xc2)/w2).^2),'r','LineWidth',1,'color','red');

%% double spot
t = xhn;
Data = yhn;

Starting(1) = A1;
Starting(2) = A2;
Starting(3) = xc1;
Starting(4) = xc2;
Starting(5) = w1;
Starting(6) = w2;


options=optimset('Display','iter');
Estimates3=fminsearch(@myfitdoublegauss,Starting,options,t,Data);

A1n=Estimates3(1);
A2n=Estimates3(2);
xc1n=Estimates3(3);
xc2n=Estimates3(4);
w1n=Estimates3(5);
w2n=Estimates3(6);

figure(9)
clf
xval=xc1n-2*w1n:0.001:xc2n+2*w2n;
plot(xval,A1n*exp(-0.5*((xval-xc1n)/w1n).^2) + A2n*exp(-0.5*((xval-xc2n)/w2n).^2),'r','LineWidth',1,'color','red');
hold on
plot(xhn,yhn,'color','black');

