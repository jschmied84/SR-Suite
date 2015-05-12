function sse=myfit(params,Input,Actual_Output)

A1=params(1);
A2=params(2);
xc=params(3);
b=params(4);
w=params(5);

Fitted_Curve=A1*Input.*exp(-b*Input.^2)+A2*exp(-0.5*((Input-xc)/w).^2);
Error_Vector=Fitted_Curve - Actual_Output;


% When curvefitting, a typical quantity to
% minimize is the sum of squares error
sse=sum(Error_Vector.^2);
% You could also write sse as
% sse=Error_Vector(:)'*Error_Vector(:);
