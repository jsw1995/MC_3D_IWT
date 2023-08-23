function [ rim ] = ext3( tem3,cover,def,r1,r2 )
%   EXT3 此处显示有关此函数的摘要
%   此处显示详细说明

[m,n,k]=size(cover);
% [m1,n1,k1]=size(im);

% 封面最低位
car=def(1);cbr=def(2);ccr=def(3);cdr= def(4);    %1,3,3,4
cag=def(5);cbg=def(6);ccg=def(7);cdg= def(8);    %3,5,5,10
cab=def(9);cbb=def(10);ccb=def(11);cdb= def(12); %4,5,5,10

% 图像分解基底
iar=def(1);ibr=def(2);icr=def(8);idr= def(12);   %1 3 10 10
iag=def(3);ibg=def(4);icg=def(6);idg= def(7);    %3 4 5 5 
iab=def(5);ibb=def(9);icb=def(10);idb= def(11);  %3 4 5 5

% 置乱随机序列
LLrr1=r1(1:m*0.5);LLrr2=r2(1:n*0.5); LHrr1=r1(m*0.5+1:m);LHrr2=r2(n*0.5+1:n);
HLrr1=r1(m+1:m*1.5);HLrr2=r2(n+1:n*1.5); HHrr1=r1(m*1.5+1:2*m);HHrr2=r2(n*1.5+1:2*n);

LLgr1=r1(2*m+1:m*2.5);LLgr2=r2(2*n+1:n*2.5); LHgr1=r1(m*2.5+1:3*m);LHgr2=r2(n*2.5+1:n*3);
HLgr1=r1(3*m+1:m*3.5);HLgr2=r2(3*n+1:n*3.5); HHgr1=r1(m*3.5+1:4*m);HHgr2=r2(n*3.5+1:4*n);

LLbr1=r1(4*m+1:m*4.5);LLbr2=r2(4*n+1:n*4.5); LHbr1=r1(m*4.5+1:5*m);LHbr2=r2(n*4.5+1:5*n);
HLbr1=r1(5*m+1:m*5.5);HLbr2=r2(5*n+1:n*5.5); HHbr1=r1(m*5.5+1:6*m);HHbr2=r2(n*5.5+1:6*n);

% 封面小波变换分解为12分
max1=252; min1=3;
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

% 密文小波分解为12份
[ tem2 ] = s1( tem3 );
LLr1=tem2(1:m/2,1:n/2,1);LHr1=tem2(1:m/2,n/2+1:n,1);HLr1=tem2(m/2+1:m,1:n/2,1);HHr1=tem2(m/2+1:m,n/2+1:n,1);
LLg1=tem2(1:m/2,1:n/2,2);LHg1=tem2(1:m/2,n/2+1:n,2);HLg1=tem2(m/2+1:m,1:n/2,2);HHg1=tem2(m/2+1:m,n/2+1:n,2);
LLb1=tem2(1:m/2,1:n/2,3);LHb1=tem2(1:m/2,n/2+1:n,3);HLb1=tem2(m/2+1:m,1:n/2,3);HHb1=tem2(m/2+1:m,n/2+1:n,3);

% 置乱
LLr1=scram( LLr1,LLrr1,LLrr2 );LHr1=scram( LHr1,LHrr1,LHrr2 );HLr1=scram( HLr1,HLrr1,HLrr2 );HHr1=scram( HHr1,HHrr1,HHrr2 );
LLg1=scram( LLg1,LLgr1,LLgr2 );LHg1=scram( LHg1,LHgr1,LHgr2 );HLg1=scram( HLg1,HLgr1,HLgr2 );HHg1=scram( HHg1,HHgr1,HHgr2 );
LLb1=scram( LLb1,LLbr1,LLbr2 );LHb1=scram( LHb1,LHbr1,LHbr2 );HLb1=scram( HLb1,HLbr1,HLbr2 );HHb1=scram( HHb1,HHbr1,HHbr2 );

% 提取
rimr1 = mod(mod(LLr1,car)-mod(LLr,car),car);
rimr2 = mod(mod(LHr1,cbr)-mod(LHr,cbr),cbr);
rimb1 = mod(mod(HLr1,ccr)-mod(HLr,ccr),ccr);
rimb2 = mod(mod(HHr1,cdr)-mod(HHr,cdr),cdr);

rimg1 = mod(mod(LLg1,cag)-mod(LLg,cag),cag);
rimb3 = mod(mod(LHg1,cbg)-mod(LHg,cbg),cbg);
rimb4 = mod(mod(HLg1,ccg)-mod(HLg,ccg),ccg);
rimr3 = mod(mod(HHg1,cdg)-mod(HHg,cdg),cdg);

rimg2 = mod(mod(LLb1,cab)-mod(LLb,cab),cab);
rimg3 = mod(mod(LHb1,cbb)-mod(LHb,cbb),cbb);
rimg4 = mod(mod(HLb1,ccb)-mod(HLb,ccb),ccb);
rimr4 = mod(mod(HHb1,cdb)-mod(HHb,cdb),cdb);

rimr = rimr1*(ibr*icr*idr)+rimr2*(icr*idr)+rimr3*idr+rimr4;
rimg = rimg1*(ibg*icg*idg)+rimg2*(icg*idg)+rimg3*idg+rimg4;
rimb = rimb1*(ibb*icb*idb)+rimb2*(icb*idb)+rimb3*idb+rimb4;
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

