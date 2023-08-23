function [ cip ] = emb3( im,cover,def,r1,r2 )
%   第二种嵌入方式直方图移位形式，解密需要封面图像
%   def=[1,3,3,4,3,5,5,10,4,5,5,10]

[m,n,k]=size(cover);
[m1,n1,k1]=size(im);

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


% 图像分解
imr=im(:,:,1);img=im(:,:,2);imb=im(:,:,3);
imr1=floor(imr/(ibr*icr*idr)); imr2=floor(mod(imr,ibr*icr*idr)/(icr*idr)); imr3=floor(mod(imr,icr*idr)/idr); imr4=mod(imr,idr);
img1=floor(img/(ibg*icg*idg)); img2=floor(mod(img,ibg*icg*idg)/(icg*idg)); img3=floor(mod(img,icg*idg)/idg); img4=mod(img,idg);
imb1=floor(imb/(ibb*icb*idb)); imb2=floor(mod(imb,ibb*icb*idb)/(icb*idb)); imb3=floor(mod(imb,icb*idb)/idb); imb4=mod(imb,idb);

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


% 嵌入
LLr1 = cor(mod(imr1 + mod(LLr,car), car) + floor(LLr/car)*car, LLr, car);
LHr1 = cor(mod(imr2 + mod(LHr,cbr), cbr) + floor(LHr/cbr)*cbr, LHr, cbr);
HLr1 = cor(mod(imb1 + mod(HLr,ccr), ccr) + floor(HLr/ccr)*ccr, HLr, ccr);
HHr1 = cor(mod(imb2 + mod(HHr,cdr), cdr) + floor(HHr/cdr)*cdr, HHr, cdr);

LLg1 = cor(mod(img1 + mod(LLg,cag), cag) + floor(LLg/cag)*cag, LLg, cag);
LHg1 = cor(mod(imb3 + mod(LHg,cbg), cbg) + floor(LHg/cbg)*cbg, LHg, cbg);
HLg1 = cor(mod(imb4 + mod(HLg,ccg), ccg) + floor(HLg/ccg)*ccg, HLg, ccg);
HHg1 = cor(mod(imr3 + mod(HHg,cdg), cdg) + floor(HHg/cdg)*cdg, HHg, cdg);

LLb1 = cor(mod(img2 + mod(LLb,cab), cab) + floor(LLb/cab)*cab, LLb, cab);
LHb1 = cor(mod(img3 + mod(LHb,cbb), cbb) + floor(LHb/cbb)*cbb, LHb, cbb);
HLb1 = cor(mod(img4 + mod(HLb,ccb), ccb) + floor(HLb/ccb)*ccb, HLb, ccb);
HHb1 = cor(mod(imr4 + mod(HHb,cdb), cdb) + floor(HHb/cdb)*cdb, HHb, cdb);

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
