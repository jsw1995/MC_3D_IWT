function [ rim ] = ext2( cip,def,im_shape,r1,r2 )
%   EXT2 此处显示有关此函数的摘要
%   def=[1,3,3,5,3,5,5,9,3,5,5,8];

[m,n,k]=size(cip);
m1=im_shape(1);n1=im_shape(2);k1=im_shape(3);
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

[ rtem2 ] = s1( cip );
LLr11=rtem2(1:m/2,1:n/2,1);LHr11=rtem2(1:m/2,n/2+1:n,1);HLr11=rtem2(m/2+1:m,1:n/2,1);HHr11=rtem2(m/2+1:m,n/2+1:n,1);
LLg11=rtem2(1:m/2,1:n/2,2);LHg11=rtem2(1:m/2,n/2+1:n,2);HLg11=rtem2(m/2+1:m,1:n/2,2);HHg11=rtem2(m/2+1:m,n/2+1:n,2);
LLb11=rtem2(1:m/2,1:n/2,3);LHb11=rtem2(1:m/2,n/2+1:n,3);HLb11=rtem2(m/2+1:m,1:n/2,3);HHb11=rtem2(m/2+1:m,n/2+1:n,3);

% 置乱
LLr11=scram( LLr11,LLrr1,LLrr2 );LHr11=scram( LHr11,LHrr1,LHrr2 );HLr11=scram( HLr11,HLrr1,HLrr2 );HHr11=scram( HHr11,HHrr1,HHrr2 );
LLg11=scram( LLg11,LLgr1,LLgr2 );LHg11=scram( LHg11,LHgr1,LHgr2 );HLg11=scram( HLg11,HLgr1,HLgr2 );HHg11=scram( HHg11,HHgr1,HHgr2 );
LLb11=scram( LLb11,LLbr1,LLbr2 );LHb11=scram( LHb11,LHbr1,LHbr2 );HLb11=scram( HLb11,HLbr1,HLbr2 );HHb11=scram( HHb11,HHbr1,HHbr2 );

% 提取
rimr1=mod(LLr11,ar);
rimr2=mod(LHr11,br);
rimr3=mod(HLr11,cr);
rimr4=mod(HHr11,dr);


rimg1=mod(LLg11,ag);
rimg2=mod(LHg11,bg);
rimg3=mod(HLg11,cg);
rimg4=mod(HHg11,dg);


rimb1=mod(LLb11,ab);
rimb2=mod(LHb11,bb);
rimb3=mod(HLb11,cb);
rimb4=mod(HHb11,db);

dec_im = rimr1*ar1+rimr2*br1+rimr3*cr1+rimr4*dr1+rimg1*ag1+rimg2*bg1+rimg3*cg1+rimg4*dg1+rimb1*ab1+rimb2*bb1+rimb3*cb1+rimb4;

bin_im = dec2bin(dec_im,24);
rimr = reshape(bin2dec(bin_im(:,1:8)),[m1,n1]);
rimg = reshape(bin2dec(bin_im(:,9:16)),[m1,n1]);
rimb = reshape(bin2dec(bin_im(:,17:24)),[m1,n1]);
rim = cat(3,rimr,rimg,rimb);

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
