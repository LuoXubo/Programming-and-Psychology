
% ======1.������Ҫ������======

clc;%��������
clear all;%�������
impdata=importdata('a009.log');

event_type=impdata.textdata(:,3); % ��ȡevent type
event_type=event_type(4:1616); %��event_type�����пռ��ļ����޳�

code=impdata.textdata(:,4); %��ȡcode��
code=code(4:1616); %��code�����пռ��ļ����޳�


time=impdata.textdata(:,5);  %��ȡ��timeһ�е�ÿһ��ʱ�̽ڵ�;
time=time(4:1616); %�޳�Time���еĿռ���
time=str2num(char(time));

% ======2.���ҳ�ÿ��trial��λ�ã����洢��Ӧλ�õ���======
num = 0; % numΪtrial���
t0 = 976921/10000; % ��һ��trial�ĳ�ʼʱ��
for i = 1:length(code) % ��code����Ѱ��trial('greenbox1' or 'redbox1')
    if strcmp(code{i},'greenbox1') || strcmp(code{i},'redbox1') % Ѱ�ҡ�greenbox1���͡�redbox1��
        num = num+1; 
        trial(num).num = num; % �����ṹ�壬�洢tria.num
        trial(num).mode = code{i}; % �洢trial.mode
        trial(num).start_time = time(i)/10000 - t0; % �洢trial.start_time
        trial_position(num) = i; % ��¼ÿ��trial��λ��
   end
end

% ======3.������trial��Ѱ��ISI��ITI��λ�ò��洢��time����Ӧ��trial======
for j = 1 : length(trial_position)
    if j < length(trial_position)
        for k = trial_position(j)+1 : trial_position(j+1)-1 % ��ǰ��length��trial_position��-1����trial��Ѱ��ISI��ITI��λ��
            switch code{k}
                case 'crossISI_4_8'
                    trial(j).ISI = time(k)/10000 - t0; % �洢trial.ISI
                case 'crossITI_8'
                    trial(j).ITI = time(k)/10000 - t0; % �洢trial.ITI
            end
        end
    else
        for k = trial_position(end)+1 : length(code) % �����һ��trial��Ѱ��ISI��ITI��λ��
            switch code{k}
                case 'crossISI_4_8'
                    trial(j).ISI = time(k)/10000 - t0; % �洢trial.ISI
                case 'crossITI_8'
                    trial(j).ITI = time(k)/10000 - t0; % �洢trial.ITI
            end
        end
    end
end

% ======4.������trial��Ѱ�Ҽ��㲢�洢rating_time��rating_reponse_time======
rating_num = 0; % ��¼rating_time�Ĵ���
resptime_num = 0; % ��¼rating_response_time�Ĵ���
for j = 1 : length(trial_position) 
    
    if j < length(trial_position) % ǰ(length(trial_position)-1)��trial
        for k = trial_position(j)+1 : trial_position(j+1)-1 % Ѱ�ҵ�j��trial��rating_time('Display Scale')��λ�ò��洢��trial(j)�ṹ��
            if strcmp(code{k},'Display Scale')
                rating_num = rating_num+1;
                trial(j).rating_time{rating_num} = time(k)/10000 - t0; % �洢rating_time��trial(j)�ṹ��
                rating_position(rating_num) = k; % ��¼rating_time��λ��
            end
        end
        rating_num = 0; % ÿһ��trialѰ����ɺ�Ҫ����
        for m = 1:length(rating_position) % �ڵ�j��trial��ÿ��rating_time('Display Scale')��Ѱ��rating_response_time(���������'Response')���洢����Ӧ��trial(j)�ṹ��
            if m < length(rating_position) % ǰ(length(rating_position)-1)��rating_time��Ѱ��rating_response_time
                for n = rating_position(m)+1 : rating_position(m+1)-1
                    if strcmp(event_type{n},'Response')
                        resptime_num = resptime_num+1;
                        trial(j).rating_response_time{resptime_num} = time(n)/10000 - t0 - trial(j).rating_time{resptime_num};
                        break % ֻ�������'Response'��Ѱ�ҵ���������ֹforѭ��
                    end
                end
                
            else % �����һ��rating_time��Ѱ��rating_response_time
                for n = rating_position(end)+1 : trial_position(j+1)-1
                    if strcmp(event_type{n},'Response')
                        resptime_num = resptime_num+1;
                        trial(j).rating_response_time{resptime_num} = time(n)/10000 - t0 - trial(j).rating_time{resptime_num};
                        break % ֻ�������'Response'��Ѱ�ҵ���������ֹforѭ��
                    end
                end
            end
        end
        resptime_num = 0;
        rating_position = []; % һ��Ҫ��գ���Ȼǰ���rating_position��Ϣ���ܻ�Ӱ������
                                     % ǰ(length(trial_position)-1)��trial
    

    else % ���һ��trial
        for k = trial_position(end)+1 : length(code)
            if strcmp(code{k},'Display Scale')
                rating_num = rating_num+1;
                trial(j).rating_time{rating_num} = time(k)/10000 - t0;
                rating_position(rating_num) = k;
            end
        end
        for m = 1:length(rating_position)
            if m < length(rating_position)
                for n = rating_position(m)+1 : rating_position(m+1)-1
                    if strcmp(event_type{n},'Response')
                        resptime_num = resptime_num+1;
                        trial(j).rating_response_time{resptime_num} = time(n)/10000 - t0 - trial(j).rating_time{resptime_num};
                        break
                    end
                end
                
            else
                for n = rating_position(end)+1 : length(event_type)
                    if strcmp(event_type{n},'Response')
                        resptime_num = resptime_num+1;
                        rating_response_time(resptime_num) = time(n)/10000 - t0 - trial(j).rating_time{resptime_num};
                        break
                    end
                end
            end
        end
    end % ���һ��trial
    
end



% ======5.�����е�trial��Ѱ��pain��vibration��difficulty��difference��ֵ======
for j = 1 : length(trial_position) 
    trial(j).pain = []; % Ԥ�����ڴ棬����˳��
    trial(j).vibration = [];
    trial(j).difficulty = [];
    trial(j).difference = [];
    if j < length(trial_position) % -----------------ǰ(length(trial_position)-1)��trial-----------------
        for k = trial_position(j)+1 : trial_position(j+1)-1
            if strmatch('This pain',code{k}(8:end))
                trial(j).pain = str2num(code{k}(end-1:end));
            elseif  strmatch('This vibration',code{k}(8:end))
                trial(j).vibration = str2num(code{k}(end-1:end));
            elseif strmatch('Difficulty',code{k}(8:end))
                trial(j).difficulty = str2num(code{k}(end-1:end));
            elseif strmatch('Difference',code{k}(8:end))
                trial(j).difference = str2num(code{k}(end-1:end));
            end
        end


    else % --------------���һ��trial----------------
        for k = trial_position(end)+1 : length(code)
            if strmatch('This pain',code{k}(8:end))
                trial(j).pain = str2num(code{k}(end-1:end));
            elseif  strmatch('This vibration',code{k}(8:end))
                trial(j).vibration = str2num(code{k}(end-1:end));
            elseif strmatch('Difficulty',code{k}(8:end))
                trial(j).difficulty = str2num(code{k}(end-1:end));
            elseif strmatch('Difference',code{k}(8:end))
                trial(j).difference = str2num(code{k}(end-1:end));
            end
        end
    end
end



% ======6.��trial�ṹ���еĳ�Ա���м򵥵���======

for i = 1:length(trial) % �ֱ�ʵ��ģ̬��'redbox1'��'greenbox1'�ĳ�'memory encoding'��'non-memory encoding'
    switch trial(i).mode
        case 'redbox1'
            trial(i).mode = 'memory encoding';
        case 'greenbox1'
            trial(i).mode = 'non-memory encoding';
    end
end

for n = 1:length(trial) % ��rating_time��rating_response_timeϸ������ֿ�����
    trial(n).rating_time1 = []; % Ԥ�ȷ����ڴ�
    trial(n).rating_reponse_time1 = [];
    trial(n).rating_time2 = [];
    trial(n).rating_reponse_time2 = [];
    trial(n).rating_time3 = [];
    trial(n).rating_reponse_time3 = [];
    switch length(trial(n).rating_time)
        case 3
            trial(n).rating_time1 = trial(n).rating_time{1,1};
            trial(n).rating_time2 = trial(n).rating_time{1,2};
            trial(n).rating_time3 = trial(n).rating_time{1,3};
        case 2
            trial(n).rating_time1 = trial(n).rating_time{1,1};
            trial(n).rating_time2 = trial(n).rating_time{1,2};
        case 1
            trial(n).rating_time1 = trial(n).rating_time{1,1};
        case 0
    end
    switch length(trial(n).rating_response_time)
        case 3
            trial(n).rating_reponse_time1 = trial(n).rating_response_time{1,1};
            trial(n).rating_reponse_time2 = trial(n).rating_response_time{1,2};
            trial(n).rating_reponse_time3 = trial(n).rating_response_time{1,3};
        case 2
            trial(n).rating_reponse_time1 = trial(n).rating_response_time{1,1};
            trial(n).rating_reponse_time2 = trial(n).rating_response_time{1,2};
        case 1
            trial(n).rating_reponse_time1 = trial(n).rating_response_time{1,1};
        case 0
    end
end

trial = rmfield(trial,{'rating_time','rating_response_time'}); % ɾ��trial�ṹ����rating_time��rating_response_time������Ա����



% ======7.��trial�ķ�����д��Excel�ļ�======
values = struct2cell(trial(:)); % �ṹתϸ��
headers = fieldnames(trial); % ��ñ���
xlsdata = cat(2, headers, values)'; % ����
xlswrite('trials.xlsx', xlsdata); % д��excel�ļ�

