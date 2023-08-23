function [ rim ] = dscram( cip,r1,r2 )
%   DSCRAM 解密
%   此处显示详细说明

[m,n]=size(cip);
rim = cip;

v1 = -floor(mod(r1(1:m)*10^10,n));
v2 = -floor(mod(r2(1:n)*10^10,m));

for i=1:n
    rim(:,i)=circshift(rim(:,i),[v2(i),0]);
end

for i=1:m
    rim(i,:)=circshift(rim(i,:),[0,v1(i)]); 
end

end

