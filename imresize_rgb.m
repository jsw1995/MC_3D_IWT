function [ im1 ] = imresize_rgb( im,im1_shape )
%   对三维数据进行差值
%   此处显示详细说明

m=im1_shape(1);
n=im1_shape(2);
im1r = imresize(im(:,:,1),[m,n]);
im1g = imresize(im(:,:,2),[m,n]);
im1b = imresize(im(:,:,3),[m,n]);
im1 = cat(3,im1r,im1g,im1b);

end

