function isSushu = sushu(x)
%sushu 判断一个数是否是素数
% sushu(x)
% 输入： x 输入要判断的数
% 输出： isSushu 0表示不是素数， 1表示是素数,-1表示既不是素数也不是合数
%
if x==1
   disp('既不是素数也不是合数')
   isSushu = -1;
   reurn;
end
isSushu = 1;
for i=2:x-1
    if mod(x, i)==0
        isSushu = 0;
    end
end