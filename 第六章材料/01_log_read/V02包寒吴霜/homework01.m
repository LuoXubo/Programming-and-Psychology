% ������˪ - 201728012503021 - Date: 20180413 (revised: 20180502)
clc;clear;
[filename, pathname]=uigetfile({'*.log';'*.txt'}, '��ѡ�������ļ�');
data=readExpData([pathname filename]); % ����readExpData����
[sfilename, sfilepath]=uiputfile('*.csv', '�뱣������', 'sub_.csv');
writetable(data,[sfilepath sfilename],'Delimiter',','); % ��������
fprintf('%s has been successfully processed!\n',[pathname filename]);
fprintf('Saved at %s\n',[sfilepath sfilename]);