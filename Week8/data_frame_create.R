respid <-c(1,2,3,4,5)
hourwage <- c(27.0,33.0,65.5,44.5,15.0)
age <-c(34,46,51,39,22)
gender <-c("male","female","male","male","female")
educ <-c(10,12,15,13,8)
wage_data <-data.frame(respid,hourwage,age,gender,educ)

#提取列
age_from_wd<-wage_data$age
age_from_wd<-wage_data[,3]
age_from_wd<-wage_data[,"age"]

hwgen_from_wd <-wage_data[,c("hourwage","gender")]
hwgen_from_wd <-wage_data[,c(2,4)]

#提取行
wage_data[4,]
wage_data[2:4,]
wage_data[c(1,4,5),]

#筛选特定行
male <- wage_data[,"gender"] == "male"
wage_data[male,]

respid <-c(6,7,8,9,10)
hourwage <- c(59.0,49.0,48.0,38.9,29.9)
age <-c(43,64,55,59,24)
gender <-c("female","male","female","male","female")
educ <-c(15,10,11,9,7)
wage_data2 <-data.frame(respid,hourwage,age,gender,educ)

#合并wage_data wage_data2
wage_data_m = rbind(wage_data2,wage_data)

marstat <- c("single","married","married","married","single")
wage_data_mars <-cbind(wage_data,marstat)