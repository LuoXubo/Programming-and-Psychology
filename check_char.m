function res = check_char(char)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
    if char >= 'A' && char <= 'Z'
        res = lower(char);
        disp(res);
    elseif char >= '0' && char <= '9'
        res = str2double(char);
        disp(res);
    else
        disp(char); 
    end
end

