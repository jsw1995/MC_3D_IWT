function [ x,y ] = ICSM_2D( init,para,L )
%   IICM 
%   此处显示详细说明

x = []; y= [];
x(1)=init(1);y(1)=init(2);
a=para(1);b=para(2);
M = exp(1)^pi;

for i=1:L+1000
    x(i+1)=mod(M/sin(a/x(i)) * b/(sin(pi*y(i))),1);
    y(i+1)=mod(M/sin(a/y(i)) * b/(sin(pi*x(i))),1);
end

x=x(1001:L+1000);
y=y(1001:L+1000);

end

