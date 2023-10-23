function data=readExpData(file)
% ������˪ - 201728012503021 - Date: 20180413 (revised: 20180428)
% ���˼·��ÿ�ζ�ȡһ�У�������greenbox1��redbox1�����ʼ��һ���µĽṹ�����trial��
% ������������Ҫ��ȡ����Ϣ�����trial��������Ӧ���Ը�ֵ��ֱ������crossITI_8ʱtrial����
fid=fopen(file,'r'); % ԭʼ�����ļ�ָ��
trialNum=0; % Trial�ı��
afterScale=0; % ̽��Event Type�Ƿ�ΪDisplay Scale����ĵ�һ��Response����ʼ��Ϊ0
%% ���ݶ�ȡ
while ~feof(fid) % ������ȡֱ���ļ�ĩβ
    % ÿ�ζ�ȡһ��
    line=fgetl(fid);
    linedata=strsplit(line,'\t'); % ���Ʊ��\t����ַ���
    if length(linedata)<6 % �ж��Ƿ�Ϊ��ʽ���ݣ����Ƿ��ж��У�
        continue % ����ʽ������������һ��ѭ��
    end
    event_type=linedata{3}; % ԭʼ�������Event Type��
    code_text=linedata{4}; % ԭʼ�������Code��
    current_time=str2double(linedata{5})/10000; % ԭʼ�������Time��
    if afterScale & regexp(event_type,'Response')
        % ��ȡDisplay Scale����ĵ�һ��Response��RT
        RT=str2double(linedata{6})/10000; % ԭʼ�������TTime�У�����ΪRT
        % RTҲ������current_time-trial.Trial_OnsetTime-display_time_temp����
        afterScale=0; % �ָ�̽�⿪��Ϊ0
    end
    % < === Trial�жϿ�ʼ === >
    % trialΪ�ṹ�������struct��
    % greenbox1��redbox1Ϊÿ��Trial��ʼ�ı�ǣ���������ʽ�ж�
    if regexp(code_text,'greenbox1|redbox1')
        % Trial�ı�š������뿪ʼʱ��
        trialNum=trialNum+1;
        trial.Trial=trialNum;
        trial.Trial_Type=regexp(code_text,'greenbox|redbox','match');
        trial.Trial_OnsetTime=current_time;
        % ���������˳���ʼ��ΪȱʧֵNaN
        trial.ISI_Onset=nan;
        trial.pain_DisplayOnset=nan; trial.pain_RT=nan; trial.pain_Rating=nan;
        trial.vibration_DisplayOnset=nan; trial.vibration_RT=nan; trial.vibration_Rating=nan;
        trial.difficulty_DisplayOnset=nan; trial.difficulty_RT=nan; trial.difficulty_Rating=nan;
        trial.difference_DisplayOnset=nan; trial.difference_RT=nan; trial.difference_Rating=nan;
        trial.ITI_Onset=nan;
    % ��Ҫ���ж���������ȡ���ݣ���������ʽ'\d+'ƥ��Codeһ���е����֣����Ե����֣�
    elseif regexp(code_text,'crossISI_4_8')
        trial.ISI_Onset=current_time-trial.Trial_OnsetTime;
    elseif regexp(code_text,'Display Scale')
        display_time_temp=current_time-trial.Trial_OnsetTime;
        afterScale=1; % ����Display Scale֮�󣬿�ʼ̽��Response���򿪿��أ�
    elseif regexp(code_text,'This pain')
        trial.pain_DisplayOnset=display_time_temp;
        trial.pain_RT=RT;
        trial.pain_Rating=str2double(regexp(code_text,'\d+','match'));
    elseif regexp(code_text,'This vibration')
        trial.vibration_DisplayOnset=display_time_temp;
        trial.vibration_RT=RT;
        trial.vibration_Rating=str2double(regexp(code_text,'\d+','match'));
    elseif regexp(code_text,'Difficulty')
        trial.difficulty_DisplayOnset=display_time_temp;
        trial.difficulty_RT=RT;
        trial.difficulty_Rating=str2double(regexp(code_text,'\d+','match'));
    elseif regexp(code_text,'Difference')
        trial.difference_DisplayOnset=display_time_temp;
        trial.difference_RT=RT;
        trial.difference_Rating=str2double(regexp(code_text,'\d+','match'));
    % crossITI_8Ϊÿ��Trial�����ı��
    elseif regexp(code_text,'crossITI_8')
        trial.ITI_Onset=current_time-trial.Trial_OnsetTime;
        % �ϲ�trial��data
        if exist('data','var')==0
            data=struct2table(trial); % ����ǵ�1��trial�����ȸ�ֵ
        else
            data=[data;struct2table(trial)]; % ����ǵ�2�����ϵ�trial����ϲ�����
        end
    end
    % < === Trial�жϽ��� === >
end
%% �������
fclose('all'); % �ر������ļ�
data=sortrows(data,{'Trial_Type','Trial'},{'ascend','ascend'}); % ��������
disp(data);
end