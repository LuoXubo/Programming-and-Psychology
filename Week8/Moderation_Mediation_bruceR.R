library(bruceR)

#### Demo Data ####
?mediation::student
data=mediation::student %>%
  dplyr::select(SCH_ID, free, smorale, pared, income,
                gender, work, attachment, fight, late, score)
names(data)[2:3]=c("SCH_free", "SCH_morale")
names(data)[4:7]=c("parent_edu", "family_inc", "gender", "partjob")
data$gender01=1-data$gender  # 0 = female, 1 = male
data$gender=factor(data$gender01, levels=0:1, labels=c("Female", "Male"))

## Model 1 (moderation)##
PROCESS(data, y="score", x="late", mods="gender")

## Model 4 (mediation) ##
PROCESS(data, y="score", x="parent_edu",
        meds="family_inc",
        ci="boot", nsim=1000, seed=1)

## Model 6 (serial mediation) ##
PROCESS(data, y="score", x="parent_edu",
        meds=c("family_inc", "late"),
        med.type="serial",
        ci="boot", nsim=1000, seed=1)


## Model 8 ##
PROCESS(data, y="score", x="fight",
        meds="late",
        mods="gender",
        mod.path=c("x-m","x_y"),
        ci="boot", nsim=1000, seed=1)