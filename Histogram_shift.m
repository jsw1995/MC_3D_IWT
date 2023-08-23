function [ T3,TT ] = Histogram_shift( T2,MC )
%   DKEY 动态密钥生成
%   p明文，key动态密钥 

T2r = T2(:,:,1);
T2g = T2(:,:,2);
T2b = T2(:,:,3);
T3 = T2;

aa = zeros(256,1);
for x_value = 0:255
    aa(x_value+1)= sum(T2r(:)==x_value);
end
[~,indexr] = max (aa);
TTr = indexr-MC(1);
T3(:,:,1) = mod(T2r-TTr,256);


for x_value = 0:255
    aa(x_value+1)= sum(T2g(:)==x_value);
end
[~,indexg] = max (aa);
TTg = indexg-MC(2);
T3(:,:,2) = mod(T2g-TTg,256);


for x_value = 0:255
    aa(x_value+1)= sum(T2b(:)==x_value);
end
[~,indexb] = max (aa);
TTb = indexb-MC(3);
T3(:,:,3) = mod(T2b-TTb,256);

TT = cat(1,TTr,TTg,TTb);

end
