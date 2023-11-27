dat = data.frame(ID = 1:10,y1 = c(NA,NA,1.05,NA,rnorm(6)), y2 = c(1,NA,NA,NA,rnorm(6)))
dat

## y1 缺失的行有：1,2,4
## y2 缺失的行有：2,3,4
## y1和y2都缺失的行有：2,4

library(tidyverse)

# 去掉y1缺失的行
dat %>% drop_na(y1)

# 去掉y2缺失的行
dat %>% drop_na(y2)

# 去掉y1或者y2缺失的行:1,2,3,4,
dat %>% drop_na(y1,y2)


# 去掉y1和y2同时缺失的行：2,4
dat %>% filter(!is.na(y1) | !is.na(y2))

dat %>% filter(!(is.na(y1) & is.na(y2)))

dat[is.na(dat)] = 0

replace_na(dat$y1,5) # 把dat的y1列中的NA填充为5

fill(dat,y1,.direction = "up") # 将NA下一行的值填充到dat的y1列中的NA
