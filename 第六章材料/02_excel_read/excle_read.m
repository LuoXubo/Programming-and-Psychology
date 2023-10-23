
%% 1.%%--------��ȡ�ļ����������---------------%%
clear;clc;
%ѡ���ļ�����ȡ�ļ������ļ�·��
[filename,pathname]=uigetfile({'*.xlsx'});
%.xlsx�ļ��ļ����룬��ȡ������ÿ������
logdata=xlsread([pathname filename]);%TRUE�Զ���ȡΪ1��FALSE�Զ���ȡΪ0
Subjectindex=logdata(:,1)
Session=logdata(:,2)
Fixation_Onset=logdata(:,3)
Text1_Onset=logdata(:,4)
Blank_Onset=logdata(:,5)
Audio_Onset=logdata(:,6)
Text2_Onset=logdata(:,7)
If_Response=logdata(:,8)
Corre_Response=logdata(:,9)
Response_Onset=logdata(:,10)

%% 2.%%-------����ÿ������ÿ��trial��ʱ��----------%%
trial_duration=(Text2_Onset+5000-Fixation_Onset)/1000; 

%% 3.%%------����ÿ������4����������ȷ�ʡ�ƽ����Ӧʱ����ȷ��Ӧ��ƽ����Ӧʱ-------%%

%%���ֲ�������������
Fixation_Duration=Text1_Onset-Fixation_Onset; %��ȡfixation����ʱ����3000��2000��
for i=1:6000
   if Fixation_Duration(i) == 3000 && Audio_Onset(i) == 1;
       condition(i) = 1; %condtion1:��ĸ����Ϊ6 & ����������
  elseif Fixation_Duration(i) == 3000 && Audio_Onset(i)== 0;
       condition(i) = 2; %condtion2:��ĸ����Ϊ6 & ����������
  elseif Fixation_Duration(i) == 2000 && Audio_Onset(i) == 1;
       condition(i) = 3; %condtion3:��ĸ����Ϊ9 & ����������
  elseif Fixation_Duration(i) == 2000 && Audio_Onset(i) == 0;
       condition(i) = 4; %condtion4:��ĸ����Ϊ9 & ����������

   end
end
condition=condition';%%һ�и�Ϊһ��

%%���㷴Ӧʱ�����Ϊ0���ʾδ��ʱ������Ӧ
reaction_time=Response_Onset-Text2_Onset; 

%%Ԥ��վ���
ACC = zeros(30,5);% ACCΪ30*5���󣬴洢ÿ������4��condition����ȷ�ʣ���һ��Ϊ���Ժţ�2-5�ж�Ӧ4������
RT = zeros(30,9);% RTΪ30*9���󣬴洢ÿ������4��condition��ƽ����Ӧ����һ��Ϊ���Ժţ�2-5�ж�Ӧ4��������ƽ����Ӧʱ��6-9�ж�Ӧ4��������ȷ��Ӧ��ƽ����Ӧʱ

for sub = 1:30 %����ѭ��

  ACC (sub,1)=sub; %���������д��ACC��RT����ĵ�һ��
    RT (sub,1)=sub;

    for cond =1:4 % 4��conditionѭ��
        num_cond_trial = 0; %ÿ������ÿ��������trial������50��trial��
        num_cond_trial_correct = 0;%ÿ������ÿ��������ȷ��Ӧ��tiral
         RT_cond_trial = [];%ÿ������ÿ�������ķ�Ӧʱ
         RT_cond_trial_correct = [];%%ÿ������ÿ��������ȷ��Ӧ�ķ�Ӧʱ

    for trial = 1:200 % ÿ�����Թ�200 ��trialѭ��
            trial_num = (sub-1)*200+trial; %trial��˳��������6000����
            if condition(trial_num) == cond
               num_cond_trial = num_cond_trial + 1;

               % ÿ�������ķ�Ӧʱ��ʱ�洢�� RT_cond_trial��
                RT_cond_trial(num_cond_trial) = reaction_time(trial_num);

                if Corre_Response(trial) == 1
               % ÿ��������ȷ��Ӧ�ķ�Ӧʱ��ʱ�洢�� RT_cond_trial_correct ��
                RT_cond_trial_correct(trial) = reaction_time(trial_num);
                     num_cond_trial_correct =  num_cond_trial_correct + 1;
                end
            end

            % ÿ����������ȷ��
            ACC(sub,cond+1) = num_cond_trial_correct/num_cond_trial;
            % ÿ��������ƽ����Ӧʱ
            RT(sub,cond+1) = mean(RT_cond_trial);
            % ÿ��������ȷ��Ӧ��ƽ����Ӧʱ
            RT(sub,cond+5) = sum(RT_cond_trial_correct)/num_cond_trial_correct ;

        end
    end
end

%% 4.%%--------------ΪACC��RTÿ�еı�ͷ������������Ϊ.csv�ļ�-----------%%
ACCtitle={'sub','cond1','cond2','cond3','cond4'};
ACCtable=table(ACC(:,1),ACC(:,2),ACC(:,3),ACC(:,4),ACC(:,5),'VariableNames',ACCtitle);
 writetable(ACCtable,'ACC.csv');

RTtitle={'sub','cond1','cond2','cond3','cond4','cond1_correct','cond2_correct','cond3_correct','cond4_correct'};
RTtable=table(RT(:,1),RT(:,2),RT(:,3),RT(:,4),RT(:,5),RT(:,6),RT(:,7),RT(:,8),RT(:,9),'VariableNames',RTtitle);
writetable(RTtable,'RT.csv');
