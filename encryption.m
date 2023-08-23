function [ cip,dnkey,ext_val,T2 ] = encryption( im,cover,key,def )
% 三通道分别压缩，合并一起，置乱，有意义密文嵌入
% 使用第一种嵌入方式
% key='8d5ab8ba5340fce4420829ad5d12a0e45dacb0858544163d04c1d02b73e3697d';

[m,n,k]=size(im);
[M,N,K]=size(cover);
% 密钥生成
[ dnkey ] = dkey( im,key );
a1 = dnkey(1);b1=dnkey(2);x01=dnkey(3);y01=dnkey(4);
a2 = dnkey(5);b2=dnkey(6);x02=dnkey(7);y02=dnkey(8);
a3 = dnkey(9);b3=dnkey(10);x03=dnkey(11);y03=dnkey(12);
% 混沌序列生成
[ x1,y1 ] = ICSM_2D( [x01,y01],[a1,b1],m*n*1.5 );
[ x2,y2 ] = ICSM_2D( [x02,y02],[a2,b2],(M+N)*2*K );
[ x3,y3 ] = ICSM_2D( [x03,y03],[a3,b3],(M+N)*2*K );
% 阶梯式压缩
[ T1,ext_val ] = comp_3d( im,x1,y1 );
% 置乱
T2 = reshape(T1,[0.5*m,0.5*3*n]);
T2 = scram( T2,x2,y2 );
% figure(12)
% imhist(uint8(T2))
T2 = reshape(T2,[0.5*m,0.5*n,3]);
% 嵌入
[ cip ] = emb2( T2,cover,def,x3,y3 );

end

function [ dnkey ] = dkey( p,key )
%   DKEY 动态密钥生成
%   p明文，key动态密钥 

x = ones(1,256);
sha_sum = 0;
time = clock;
sha_time = SHA(time,'SHA-256');
sha_p = SHA(p,'SHA-256');
for i=1:32  % hex2dec只能到2^52，所以运用循环每8位来一次，也可以其他位数
    tem = ones(1,8);
    tem2 = ones(1,8);
    sn = dec2bin(hex2dec(sha_p((i-1)*2+1:(i-1)*2+2)),8);
    tn = dec2bin(hex2dec(sha_time((i-1)*2+1:(i-1)*2+2)),8);
    kn = dec2bin(hex2dec(key((i-1)*2+1:(i-1)*2+2)),8);
    tem(sn==kn) = 0;
    tem2(char(tem+'0')==tn) = 0;
    x((i-1)*8+1:(i-1)*8+8) = tem2;
    sha_sum = sha_sum + bin2dec(num2str(tem2));
end

a1=0;b1=0;x01=0;y01=0;
a2=0;b2=0;x02=0;y02=0;
a3=0;b3=0;x03=0;y03=0;
for i = 1:16
    a1=a1+x(i)*2^(-i);
    b1=b1+x(i+16)*2^(-i);
    x01=x01+x(i+32)*2^(-i);
    y01=y01+x(i+48)*2^(-i);
    
    a2=a2+x(i+64)*2^(-i);
    b2=b2+x(i+80)*2^(-i);
    x02=x02+x(i+96)*2^(-i);
    y02=y02+x(i+112)*2^(-i);
    
    a3=a3+x(i+128)*2^(-i);
    b3=b3+x(i+160)*2^(-i);
    x03=x03+x(i+176)*2^(-i);
    y03=y03+x(i+192)*2^(-i);
end

a1=mod(a1*sha_sum,11)+20;b1=mod(b1*sha_sum,11)+20;x01=x01*sha_sum/8192;y01=y01*sha_sum/8192;
a2=mod(a2*sha_sum,11)+20;b2=mod(b2*sha_sum,11)+20;x02=x02*sha_sum/8192;y02=y02*sha_sum/8192;
a3=mod(a3*sha_sum,11)+20;b3=mod(b3*sha_sum,11)+20;x03=x03*sha_sum/8192;y03=y03*sha_sum/8192;
dnkey = [a1,b1,x01,y01,a2,b2,x02,y02,a3,b3,x03,y03];

end


function h = SHA(inp,meth)
% HASH - Convert an input variable into a message digest using any of
%        several common hash algorithms
%
% USAGE: h = hash(inp,'meth')
%
% inp  = input variable, of any of the following classes:
%        char, uint8, logical, double, single, int8, uint8,
%        int16, uint16, int32, uint32, int64, uint64
% h    = hash digest output, in hexadecimal notation
% meth = hash algorithm, which is one of the following:
%        MD2, MD5, SHA-1, SHA-256, SHA-384, or SHA-512
%
% NOTES: (1) If the input is a string or uint8 variable, it is hashed
%            as usual for a byte stream. Other classes are converted into
%            their byte-stream values. In other words, the hash of the
%            following will be identical:
%                     'abc'
%                     uint8('abc')
%                     char([97 98 99])
%            The hash of the follwing will be different from the above,
%            because class "double" uses eight byte elements:
%                     double('abc')
%                     [97 98 99]
%            You can avoid this issue by making sure that your inputs
%            are strings or uint8 arrays.
%        (2) The name of the hash algorithm may be specified in lowercase
%            and/or without the hyphen, if desired. For example,
%            h=hash('my text to hash','sha256');
%        (3) Carefully tested, but no warranty. Use at your own risk.
%        (4) Michael Kleder, Nov 2005
%
% EXAMPLE:
%
% algs={'MD2','MD5','SHA-1','SHA-256','SHA-384','SHA-512'};
% for n=1:6
%     h=hash('my sample text',algs{n});
%     disp([algs{n} ' (' num2str(length(h)*4) ' bits):'])
%     disp(h)
% end

inp=inp(:);
% convert strings and logicals into uint8 format
if ischar(inp) || islogical(inp)
    inp=uint8(inp);
else % convert everything else into uint8 format without loss of data
    inp=typecast(inp,'uint8');
end

% verify hash method, with some syntactical forgiveness:
meth=upper(meth);
switch meth
    case 'SHA1'
        meth='SHA-1';
    case 'SHA256'
        meth='SHA-256';
    case 'SHA384'
        meth='SHA-384';
    case 'SHA512'
        meth='SHA-512';
    otherwise
end
algs={'MD2','MD5','SHA-1','SHA-256','SHA-384','SHA-512'};
if isempty(strcmp(algs,meth))
    error(['Hash algorithm must be ' ...
        'MD2, MD5, SHA-1, SHA-256, SHA-384, or SHA-512']);
end

% create hash
x=java.security.MessageDigest.getInstance(meth);
x.update(inp);
h=typecast(x.digest,'uint8');
h=dec2hex(h)';
if(size(h,1))==1 % remote possibility: all hash bytes  128, so pad:
    h=[repmat('0',[1 size(h,2)]);h];
end
h=lower(h(:)');

end




