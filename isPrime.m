function flag = isPrime(num)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
if num==2
    flag = 1;
elseif num == 1
    disp('1既不是素数，也不是合数');
    flag = 0;
else
    for i = 2:num-1
        if mod(num, i) == 0
            flag = 0;
            return;
        end
    end
    flag = 1;
end

end

