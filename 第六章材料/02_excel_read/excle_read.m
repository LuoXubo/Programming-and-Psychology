
%% 1.%%--------读取文件并定义变量---------------%%
clear;clc;
%选择文件，获取文件名和文件路径
[filename,pathname]=uigetfile({'*.xlsx'});
%.xlsx文件文件读入，读取并定义每列数据
logdata=xlsread([pathname filename]);%TRUE自动读取为1，FALSE自动读取为0
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

%% 2.%%-------计算每名被试每个trial的时长----------%%
trial_duration=(Text2_Onset+5000-Fixation_Onset)/1000; 

%% 3.%%------计算每名被试4个条件的正确率、平均反应时和正确反应的平均反应时-------%%

%%区分并定义四种条件
Fixation_Duration=Text1_Onset-Fixation_Onset; %获取fixation呈现时长（3000或2000）
for i=1:6000
   if Fixation_Duration(i) == 3000 && Audio_Onset(i) == 1;
       condition(i) = 1; %condtion1:字母长度为6 & 有语音干扰
  elseif Fixation_Duration(i) == 3000 && Audio_Onset(i)== 0;
       condition(i) = 2; %condtion2:字母长度为6 & 无语音干扰
  elseif Fixation_Duration(i) == 2000 && Audio_Onset(i) == 1;
       condition(i) = 3; %condtion3:字母长度为9 & 有语音干扰
  elseif Fixation_Duration(i) == 2000 && Audio_Onset(i) == 0;
       condition(i) = 4; %condtion4:字母长度为9 & 无语音干扰

   end
end
condition=condition';%%一行改为一列

%%计算反应时，如果为0则表示未及时做出反应
reaction_time=Response_Onset-Text2_Onset; 

%%预设空矩阵
ACC = zeros(30,5);% ACC为30*5矩阵，存储每个被试4个condition的正确率，第一列为被试号，2-5列对应4种条件
RT = zeros(30,9);% RT为30*9矩阵，存储每个被试4个condition的平均反应，第一列为被试号，2-5列对应4种条件的平均反应时，6-9列对应4种条件正确反应的平均反应时

for sub = 1:30 %被试循环

  ACC (sub,1)=sub; %将被试序号写进ACC和RT矩阵的第一列
    RT (sub,1)=sub;

    for cond =1:4 % 4个condition循环
        num_cond_trial = 0; %每个被试每种条件的trial数（共50个trial）
        num_cond_trial_correct = 0;%每个被试每种条件正确反应的tiral
         RT_cond_trial = [];%每个被试每种条件的反应时
         RT_cond_trial_correct = [];%%每个被试每种条件正确反应的反应时

    for trial = 1:200 % 每个被试共200 个trial循环
            trial_num = (sub-1)*200+trial; %trial的顺序数（共6000个）
            if condition(trial_num) == cond
               num_cond_trial = num_cond_trial + 1;

               % 每种条件的反应时暂时存储在 RT_cond_trial中
                RT_cond_trial(num_cond_trial) = reaction_time(trial_num);

                if Corre_Response(trial) == 1
               % 每种条件正确反应的反应时暂时存储在 RT_cond_trial_correct 中
                RT_cond_trial_correct(trial) = reaction_time(trial_num);
                     num_cond_trial_correct =  num_cond_trial_correct + 1;
                end
            end

            % 每种条件的正确率
            ACC(sub,cond+1) = num_cond_trial_correct/num_cond_trial;
            % 每种条件的平均反应时
            RT(sub,cond+1) = mean(RT_cond_trial);
            % 每种条件正确反应的平均反应时
            RT(sub,cond+5) = sum(RT_cond_trial_correct)/num_cond_trial_correct ;

        end
    end
end

%% 4.%%--------------为ACC和RT每列的表头命名，并保存为.csv文件-----------%%
ACCtitle={'sub','cond1','cond2','cond3','cond4'};
ACCtable=table(ACC(:,1),ACC(:,2),ACC(:,3),ACC(:,4),ACC(:,5),'VariableNames',ACCtitle);
 writetable(ACCtable,'ACC.csv');

RTtitle={'sub','cond1','cond2','cond3','cond4','cond1_correct','cond2_correct','cond3_correct','cond4_correct'};
RTtable=table(RT(:,1),RT(:,2),RT(:,3),RT(:,4),RT(:,5),RT(:,6),RT(:,7),RT(:,8),RT(:,9),'VariableNames',RTtitle);
writetable(RTtable,'RT.csv');
