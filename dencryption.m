function [ rim ] = dencryption( cip,dnkey,def,ext_val,im_shape )
% 三通道分别压缩，合并一起，置乱，有意义密文嵌入
% 使用第一种嵌入方式

% [m,n,k]=size(im);
m = im_shape(1);n=im_shape(2);k=im_shape(3);
[M,N,K]=size(cip);
% 密钥生成
a1 = dnkey(1);b1=dnkey(2);x01=dnkey(3);y01=dnkey(4);
a2 = dnkey(5);b2=dnkey(6);x02=dnkey(7);y02=dnkey(8);
a3 = dnkey(9);b3=dnkey(10);x03=dnkey(11);y03=dnkey(12);
% 混沌序列生成
[ x1,y1 ] = ICSM_2D( [x01,y01],[a1,b1],m*n*1.5 );
[ x2,y2 ] = ICSM_2D( [x02,y02],[a2,b2],(M+N)*2*K );
[ x3,y3 ] = ICSM_2D( [x03,y03],[a3,b3],(M+N)*2*K );
% 提取
[ rT2 ] = ext2( cip,def,[m/2,n/2,k],x3,y3 );
% 反向置乱
rT1 = reshape(rT2,[0.5*m,0.5*3*n]);
rT1 = dscram( rT1,x2,y2 );
rT1 = reshape(rT1,[0.5*m,0.5*n,3]);
% 重构
[ rim ] = recon( rT1,ext_val,x1,y1,[m,n,k] );


end

