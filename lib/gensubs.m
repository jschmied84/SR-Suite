function [xsub,ysub] = gensubs(x,y,t,tincr,start)

indiz = find(t >= start & t <= start+tincr);

in = 1;

for i = 1:length(indiz)
    xsub(in) = x(indiz(i));
    ysub(in) = y(indiz(i));
    in = in + 1;
end

end