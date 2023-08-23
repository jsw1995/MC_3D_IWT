% 对两种加密方式进行实验仿真
clc;clear all;close all;clear;

%% 加密方式1
% im = double(imread('date512/1.bmp'));
% cover = double(imread('date512/2.bmp'));
% 
% [m,n,k]=size(im);
% [M,N,K]=size(cover);
% key='8d5ab8ba5340fce4420829ad5d12a0e45dacb0858544163d04c1d02b73e3697d';
% def=[1,3,3,5,3,5,5,9,3,5,5,8];
% [ cip,dnkey,ext_val,tc ] = encryption( im,cover,key,def );
% [ rim ] = dencryption( cip,dnkey,def,ext_val,[m,n,k] );
% 
% 
% figure(1)
% imshow(uint8(im))
% figure(2)
% imshow(uint8(cip))
% figure(3)
% imshow(uint8(rim))
% [psnr_cip, ~] = psnr(double(cover),double(uint8(cip)),255)
% [ssim_cip, ~] = ssim(uint8(cover),uint8(cip))
% [psnr_rim, ~] = psnr(double(im),double(uint8(rim)),255)
% [ssim_rim, ~] = ssim(uint8(im),uint8(rim))

%%  加密方式2
im = double(imread('date512/1.bmp'));
cover = double(imread('date512/2.bmp'));

[m,n,k]=size(im);
[M,N,K]=size(cover);
key='8d5ab8ba5340fce4420829ad5d12a0e45dacb0858544163d04c1d02773e3697d';
def=[1,3,3,4,3,5,5,10,4,5,5,9];
MC = 20;
[ cip,dnkey,ext_val,TT,tc ] = encryption2( im,cover,key,def,MC );
[ rim ] = dencryption2( cip,cover,dnkey,def,TT,ext_val,[m,n,k] );

figure(1)
imshow(uint8(im))
figure(2)
imshow(uint8(cip))
figure(3)
imshow(uint8(rim))

[psnr_cip, ~] = psnr(double(cover),double(uint8(cip)),255)
[ssim_cip, ~] = ssim(uint8(cover),uint8(cip))
[psnr_rim, ~] = psnr(double(im),double(uint8(rim)),255)
[ssim_rim, ~] = ssim(uint8(im),uint8(rim))