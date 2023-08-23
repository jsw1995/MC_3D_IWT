function [ T1,AA ] = comp_3d( im,R1,R2 )

% Ñ¹ËõÂÊÎª 0.25

[m,n,k]=size(im);
% a1=ceil(0.7*m);b1=ceil(0.7*n);  % 359
% a2=ceil(0.4*m);b2=ceil(0.4*n);  % 205
% a3=ceil(0.3*m);b3=ceil(0.3*n);  % 154

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

% Ñ¹Ëõ
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

dct_im = dct_3d( im );
T1_r = fai11*dct_im(:,:,1)*fai21';
T1_g = fai12*dct_im(:,:,2)*fai22';
T1_b = fai13*dct_im(:,:,3)*fai23';

max_cip_r = max(max(T1_r));
min_cip_r = min(min(T1_r));
cip_r = round( (T1_r-min_cip_r)/(max_cip_r-min_cip_r) * 255);
max_cip_g = max(max(T1_g));
min_cip_g = min(min(T1_g));
cip_g = round((T1_g-min_cip_g)/(max_cip_g-min_cip_g) * 255);
max_cip_b = max(max(T1_b));
min_cip_b = min(min(T1_b));
cip_b = round((T1_b-min_cip_b)/(max_cip_b-min_cip_b) * 255);

T1 = 127*ones([0.5*m,0.5*n,k]);
T1(1:a1*b1)=cip_r; T1(a1*b1+1:a1*b1+a2*b2)=cip_g; T1(a1*b1+a2*b2+1:a1*b1+a2*b2+a3*b3)=cip_b;
T1(isnan(T1))=0;
AA = [max_cip_r,min_cip_r,max_cip_g,min_cip_g,max_cip_b,min_cip_b];

end

function [ tem ] = dct_3d( im )

[m,~,k]=size(im);
tem=im;

for i=1:m
    tem(i,:,:)=dct(squeeze(im(i,:,:)).').';
end

for i=1:k
    tem(:,:,i)=dct(dct(tem(:,:,i)).').';
end

end
