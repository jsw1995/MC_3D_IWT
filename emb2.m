function [ cip ] = emb2( im,cover,def,r1,r2 )
%   三维形式嵌入
%   def=[1,3,3,5,3,5,5,9,3,5,5,8];

[m,n,k]=size(cover);
[m1,n1,k1]=size(im);
ar=def(1);br=def(2);cr=def(3);dr= def(4);
ag=def(5);bg=def(6);cg=def(7);dg= def(8);
ab=def(9);bb=def(10);cb=def(11);db= def(12);

LLrr1=r1(1:m*0.5);LLrr2=r2(1:n*0.5); LHrr1=r1(m*0.5+1:m);LHrr2=r2(n*0.5+1:n);
HLrr1=r1(m+1:m*1.5);HLrr2=r2(n+1:n*1.5); HHrr1=r1(m*1.5+1:2*m);HHrr2=r2(n*1.5+1:2*n);

LLgr1=r1(2*m+1:m*2.5);LLgr2=r2(2*n+1:n*2.5); LHgr1=r1(m*2.5+1:3*m);LHgr2=r2(n*2.5+1:n*3);
HLgr1=r1(3*m+1:m*3.5);HLgr2=r2(3*n+1:n*3.5); HHgr1=r1(m*3.5+1:4*m);HHgr2=r2(n*3.5+1:4*n);

LLbr1=r1(4*m+1:m*4.5);LLbr2=r2(4*n+1:n*4.5); LHbr1=r1(m*4.5+1:5*m);LHbr2=r2(n*4.5+1:5*n);
HLbr1=r1(5*m+1:m*5.5);HLbr2=r2(5*n+1:n*5.5); HHbr1=r1(m*5.5+1:6*m);HHbr2=r2(n*5.5+1:6*n);

ar1 = br*cr*dr*ag*bg*cg*dg*ab*bb*cb*db;
br1 = cr*dr*ag*bg*cg*dg*ab*bb*cb*db;
cr1 = dr*ag*bg*cg*dg*ab*bb*cb*db;
dr1 = ag*bg*cg*dg*ab*bb*cb*db;
ag1 = bg*cg*dg*ab*bb*cb*db;
bg1 = cg*dg*ab*bb*cb*db;
cg1 = dg*ab*bb*cb*db;
dg1 = ab*bb*cb*db;
ab1 = bb*cb*db;
bb1 = cb*db;
cb1 = db;

max1=252;min1=3;
cover(cover<min1)=min1;
cover(cover>max1)=max1;

[ tem ] = s1( cover );
LLr=tem(1:m/2,1:n/2,1);LHr=tem(1:m/2,n/2+1:n,1);HLr=tem(m/2+1:m,1:n/2,1);HHr=tem(m/2+1:m,n/2+1:n,1);
LLg=tem(1:m/2,1:n/2,2);LHg=tem(1:m/2,n/2+1:n,2);HLg=tem(m/2+1:m,1:n/2,2);HHg=tem(m/2+1:m,n/2+1:n,2);
LLb=tem(1:m/2,1:n/2,3);LHb=tem(1:m/2,n/2+1:n,3);HLb=tem(m/2+1:m,1:n/2,3);HHb=tem(m/2+1:m,n/2+1:n,3);

% 置乱
LLr=scram( LLr,LLrr1,LLrr2 );LHr=scram( LHr,LHrr1,LHrr2 );HLr=scram( HLr,HLrr1,HLrr2 );HHr=scram( HHr,HHrr1,HHrr2 );
LLg=scram( LLg,LLgr1,LLgr2 );LHg=scram( LHg,LHgr1,LHgr2 );HLg=scram( HLg,HLgr1,HLgr2 );HHg=scram( HHg,HHgr1,HHgr2 );
LLb=scram( LLb,LLbr1,LLbr2 );LHb=scram( LHb,LHbr1,LHbr2 );HLb=scram( HLb,HLbr1,HLbr2 );HHb=scram( HHb,HHbr1,HHbr2 );

% 嵌入
imr=dec2bin(im(:,:,1),8);img=dec2bin(im(:,:,2),8);imb=dec2bin(im(:,:,3),8);
im_bin = [imr,img,imb];
im_dec = bin2dec(im_bin);

imt = reshape(im_dec,[m1,n1]);

imr1=floor(imt/ar1);         imr2=floor(mod(imt,ar1)/br1);imr3=floor(mod(imt,br1)/cr1);imr4=floor(mod(imt,cr1)/dr1);
img1=floor(mod(imt,dr1)/ag1);img2=floor(mod(imt,ag1)/bg1);img3=floor(mod(imt,bg1)/cg1);img4=floor(mod(imt,cg1)/dg1);
imb1=floor(mod(imt,dg1)/ab1);imb2=floor(mod(imt,ab1)/bb1);imb3=floor(mod(imt,bb1)/cb1);imb4=mod(imt,db);

LLr1 = cor(imr1 + floor(LLr/ar)*ar, LLr, ar);
LHr1 = cor(imr2 + floor(LHr/br)*br, LHr, br);
HLr1 = cor(imr3 + floor(HLr/cr)*cr, HLr, cr);
HHr1 = cor(imr4 + floor(HHr/dr)*dr, HHr, dr);

LLg1 = cor(img1 + floor(LLg/ag)*ag, LLg, ag);
LHg1 = cor(img2 + floor(LHg/bg)*bg, LHg, bg);
HLg1 = cor(img3 + floor(HLg/cg)*cg, HLg, cg);
HHg1 = cor(img4 + floor(HHg/dg)*dg, HHg, dg);

LLb1 = cor(imb1 + floor(LLb/ab)*ab, LLb, ab);
LHb1 = cor(imb2 + floor(LHb/bb)*bb, LHb, bb);
HLb1 = cor(imb3 + floor(HLb/cb)*cb, HLb, cb);
HHb1 = cor(imb4 + floor(HHb/db)*db, HHb, db);

% 反向置乱
LLr1=dscram( LLr1,LLrr1,LLrr2 );LHr1=dscram( LHr1,LHrr1,LHrr2 );HLr1=dscram( HLr1,HLrr1,HLrr2 );HHr1=dscram( HHr1,HHrr1,HHrr2 );
LLg1=dscram( LLg1,LLgr1,LLgr2 );LHg1=dscram( LHg1,LHgr1,LHgr2 );HLg1=dscram( HLg1,HLgr1,HLgr2 );HHg1=dscram( HHg1,HHgr1,HHgr2 );
LLb1=dscram( LLb1,LLbr1,LLbr2 );LHb1=dscram( LHb1,LHbr1,LHbr2 );HLb1=dscram( HLb1,HLbr1,HLbr2 );HHb1=dscram( HHb1,HHbr1,HHbr2 );


tem2r = [LLr1,LHr1;HLr1,HHr1];
tem2g = [LLg1,LHg1;HLg1,HHg1];
tem2b = [LLb1,LHb1;HLb1,HHb1];
tem2 = cat(3,tem2r,tem2g,tem2b);

[ cip ] = ds1( tem2 );

end

function [ tem3 ] = s1( im )
%   s整数小波变换
%   im输入图像，a相似矩阵，b、c、d细节矩阵。
%   这个为一维的
im=double(im);
[m,n,k]=size(im);

tem = im;
tem(:,1:n/2,:) = floor((im(:,1:2:n,:)+im(:,2:2:n,:))/2);
tem(:,n/2+1:n,:) = im(:,2:2:n,:)-im(:,1:2:n,:);

tem2 = tem;
tem2(1:m/2,:,:)=floor((tem(1:2:m,:,:)+tem(2:2:m,:,:))/2);
tem2(m/2+1:m,:,:)=tem(2:2:m,:,:)-tem(1:2:m,:,:);

tem3 = tem2;

% tem3(:,:,1)=floor((tem2(:,:,1)+tem2(:,:,2)+tem2(:,:,3))/3);
% tem3(:,:,2)=tem2(:,:,2)-tem2(:,:,1);
% tem3(:,:,3)=tem2(:,:,3)-tem2(:,:,1);

tem3(:,:,1)=floor( (tem2(:,:,1) + tem2(:,:,2) + tem2(:,:,3))/3 );
tem3(:,:,2)=tem2(:,:,2) - tem2(:,:,1);
tem3(:,:,3)=tem2(:,:,3) - tem2(:,:,2);

end

function [ im ] = ds1( tem3 )
%   s小波变换逆变换
%   im输出结果，a相似矩阵，b,c,d输入的三个细节矩阵
%   一维

[m,n,k]=size(tem3);

tem2 = tem3;

% tem2(:,:,1)=tem3(:,:,1)-floor((tem3(:,:,2)+tem3(:,:,3))/3);
% tem2(:,:,2)=tem3(:,:,2)+tem2(:,:,1);
% tem2(:,:,3)=tem3(:,:,3)+tem2(:,:,1);

tem2(:,:,2)=tem3(:,:,1) - floor( (tem3(:,:,3)-tem3(:,:,2))/3 );
tem2(:,:,1)=tem2(:,:,2) - tem3(:,:,2);
tem2(:,:,3)=tem2(:,:,2) + tem3(:,:,3);


tem = tem2;
tem(1:2:m,:,:)=tem2(1:m/2,:,:)-floor(tem2(m/2+1:m,:,:)/2);
tem(2:2:m,:,:)=tem2(1:m/2,:,:)+floor((tem2(m/2+1:m,:,:)+1)/2);

im = tem;
im(:,1:2:n,:)=tem(:,1:n/2,:)-floor(tem(:,n/2+1:n,:)/2);
im(:,2:2:n,:)=tem(:,1:n/2,:)+floor((tem(:,n/2+1:n,:)+1)/2);

end

function [ cip2 ] = cor( cip,cover,e )
%   CORRECTION 修正
%   此处显示详细说明

tem = cip-cover;
cip2 = cip;
cip2(tem < -e/2) = cip(tem < -e/2) + e;
cip2(tem > e/2) = cip(tem > e/2) - e;

end
