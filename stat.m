function [pr_mean,pr_std] = stat(pr)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
len = length(pr);
%求取变量中所有元素的和
s1 = sum(pr);
% 求该被试疼痛评分的平均值
pr_mean = s1/len;
% 求该被试疼痛评分的平方和
pr_ss = sum(pr.^2);
% 求该被试疼痛评分的标准差
pr_std = sqrt(pr_ss/len - pr_mean.^2);
end

