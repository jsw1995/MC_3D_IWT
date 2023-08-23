function [ cip ] = scram( im,r1,r2 )
%   SCRAM ����ѭ����λ
%   �˴���ʾ��ϸ˵��

[m,n]=size(im);
cip = im;
v1 = floor(mod(r1(1:m)*10^10,n));
v2 = floor(mod(r2(1:n)*10^10,m));

for i=1:m
    cip(i,:)=circshift(cip(i,:),[0,v1(i)]); 
end

for i=1:n
    cip(:,i)=circshift(cip(:,i),[v2(i),0]);
end

end

