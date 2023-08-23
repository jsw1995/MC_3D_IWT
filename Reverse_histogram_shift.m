function [ rT2 ] = Reverse_histogram_shift( rT3,TT )
%REVERSE_HISTOGRAM_SHIFT 此处显示有关此函数的摘要
%   此处显示详细说明

rT2r = mod(rT3(:,:,1)+TT(1),256);
rT2g = mod(rT3(:,:,2)+TT(2),256);
rT2b = mod(rT3(:,:,3)+TT(3),256);
rT2 = cat(3,rT2r,rT2g,rT2b);

end

