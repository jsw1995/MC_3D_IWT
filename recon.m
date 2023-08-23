function [ rim ] = recon( T1,AA,R1,R2,im_shape )

% 压缩率为 0.25
m=im_shape(1);n=im_shape(2);k=im_shape(3);
% a1=ceil(0.7*m);b1=ceil(0.7*n);
% a2=ceil(0.4*m);b2=ceil(0.4*n);
% a3=ceil(0.3*m);b3=ceil(0.3*n);

a1=floor(sqrt(0.48)*m);b1=floor(sqrt(0.48)*n);  % 358
a2=floor(sqrt(0.18)*m);b2=floor(sqrt(0.18)*m);  % 256
a3=floor(sqrt(0.09)*m);b3=floor(sqrt(0.09)*m);  % 153

R1= 1-2*mod(R1*10^4,1);R2=1-2*mod(R2*10^4,1);
x1 = reshape(R1(1:a1*m),[a1,m]);
y1 = reshape(R2(1:b1*n),[b1,n]);
x2 = reshape(R1(a1*m+1:a1*m+a2*m),[a2,m]);
y2 = reshape(R2(b1*n+1:b1*n+b2*n),[b2,n]);
x3 = reshape(R1(a1*m+a2*m+1:a1*m+a2*m+a3*m),[a3,m]);
y3 = reshape(R2(b1*n+b2*n+1:b1*n+b2*n+b3*n),[b3,n]);

T=1000;
fai11 = sqrt(2/a1)*x1;
fai21 = sqrt(2/b1)*y1;
fai11(:, 1:a1) =fai11(:, 1:a1) * T;
fai11 = orth(fai11')';
fai21(:, 1:b1) = fai21(:, 1:b1) * T;
fai21 = orth(fai21')';

fai12 = sqrt(2/a2)*x2;
fai22 = sqrt(2/b2)*y2;
fai12(:, 1:a2) =fai12(:, 1:a2) * T;
fai12 = orth(fai12')';
fai22(:, 1:b2) = fai22(:, 1:b2) * T;
fai22 = orth(fai22')';

fai13 = sqrt(2/a3)*x3;
fai23 = sqrt(2/b3)*y3;
fai13(:, 1:a3) =fai13(:, 1:a3) * T;
fai13 = orth(fai13')';
fai23(:, 1:b3) = fai23(:, 1:b3) * T;
fai23 = orth(fai23')';

max_cip_r = AA(1);min_cip_r = AA(2);
cip_r = reshape(T1(1:a1*b1),[a1,b1]);
cip_r = cip_r / 255 * (max_cip_r-min_cip_r) + min_cip_r;
max_cip_g = AA(3);min_cip_g = AA(4);
cip_g = reshape(T1(a1*b1+1:a1*b1+a2*b2),[a2,b2]);
cip_g = cip_g / 255 * (max_cip_g-min_cip_g) + min_cip_g;
max_cip_b = AA(5);min_cip_b = AA(6);
cip_b = reshape(T1(a1*b1+a2*b2+1:a1*b1+a2*b2+a3*b3),[a3,b3]);
cip_b = cip_b / 255 * (max_cip_b-min_cip_b) + min_cip_b;

[ rdct_imr ] = nsl0_2d( cip_r,fai11,fai21' );
[ rdct_img ] = nsl0_2d( cip_g,fai12,fai22' );
[ rdct_imb ] = nsl0_2d( cip_b,fai13,fai23' );

rdct = cat(3,rdct_imr,rdct_img,rdct_imb);
rim = idct_3d( rdct );
rim(rim>255) = 255;
rim(rim<0) = 0;

end

function [ rim ] = nsl0_2d( y,A,B )
%   NSL0_2D 此处显示有关此函数的摘要
%   此处显示详细说明

sigma_min = 0.01;
sigma_decrease_factor = 0.05;  %
ksai = 0.01;

A_pinv = pinv(A);
B_pinv = pinv(B);

s = A_pinv * y * B_pinv;

sigma = 4 * max(max(abs(s)));
r = 0;
r0 = y - A * s * B;

while (sigma>sigma_min)

    if sum(sum((r-r0).^2)) < ksai
        
        d = -(sigma^2 * s) ./ (s.*s + sigma^2);
        s = s + d;
        s = s - A_pinv * (A * s * B - y) * B_pinv;
        r0 = y - A * s * B;
        
    end

    sigma = sigma * sigma_decrease_factor;
 
end

rim = s;

end

function [ tem2 ] = idct_3d( im )
% IDCT3 此处显示有关此函数的摘要
%   此处显示详细说明

[m,~,k] = size(im);
tem2 = im;

for i=1:k
    tem2(:,:,i)=idct(idct(im(:,:,i)).').';
end

for i=1:m
    tem2(i,:,:)=idct(squeeze(tem2(i,:,:)).').';
end

end
