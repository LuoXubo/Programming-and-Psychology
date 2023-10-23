% 包寒吴霜 - 201728012503021 - Date: 20180413 (revised: 20180502)
clc;clear;
[filename, pathname]=uigetfile({'*.log';'*.txt'}, '请选择数据文件');
data=readExpData([pathname filename]); % 运行readExpData函数
[sfilename, sfilepath]=uiputfile('*.csv', '请保存数据', 'sub_.csv');
writetable(data,[sfilepath sfilename],'Delimiter',','); % 保存数据
fprintf('%s has been successfully processed!\n',[pathname filename]);
fprintf('Saved at %s\n',[sfilepath sfilename]);