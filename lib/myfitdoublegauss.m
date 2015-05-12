function sse=myfitdoublegauss(params,Input,Actual_Output)

A1=params(1);
A2=params(2);
xc1=params(3);
xc2=params(4);
w1=params(5);
w2=params(6);

Fitted_Curve=A1*exp(-0.5*((Input-xc1)/w1).^2) + A2*exp(-0.5*((Input-xc2)/w2).^2);
Error_Vector=Fitted_Curve - Actual_Output;


% When curvefitting, a typical quantity to
% minimize is the sum of squares error
sse=sum(Error_Vector.^2);
% You could also write sse as
% sse=Error_Vector(:)'*Error_Vector(:);
