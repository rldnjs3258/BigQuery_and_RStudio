# <Gfr과 기울기>
#  - Gfr과 기울기를 EDA 해보자.
#  - Threshold 값을 정해서 labeling을 해보자.

# 라이브러리 로드
library(ggplot2)
library(GGally)


# 데이터 로드
data <- read.csv(file.choose())
head(data)


# 통계
summary(data)


# 분산
hist(data$value) # gfr
hist(data$slope) # 기울기


# 아웃라이어
boxplot(data$value) # gfr
boxplot(data$slope) # 기울기


# 비율 확인
total = length(data$person_id)
total

positive = length(which(data$slope > 0)) # 양수
zero = length(which(data$slope == 0)) # 0
negative = length(which(data$slope < 0)) # 음수

positive_percent = positive / total * 100 # 양수 비율
zero_percent = zero / total * 100 # 0
negative_percent = negative / total * 100 # 음수 비율


# ggpairs
ggpairs(data=data,
        columns=c(5,6)
        )


# threshold값(-3.052)으로 라벨링하기 
for(i in 1:total){
  if(data$slope[i] <= -3.052){
    data$binary[i] <- 0
  }
  else{
    data$binary[i] <- 1
  }
}


# 라벨링 잘 됐나 확인
print(total)

length(which(data$binary == 0))
length(which(data$binary == 1))
length(which(data$binary == 1)) / total * 100

length(which(data$slope <= -3.052))
length(which(data$slope > -3.052))