# <slope and label>
#  - slope이 0과 음수인 값들만 남기기
#  - threshold 정해서 slope의 p-value가 좋은 값들만 남기기
#  - slope이 음수일 때의 label을 1 : 9의 비율로 나누기


# 1. 라이브러리 로드
library(ggplot2)
library(GGally)
library(shiny)


# 2. 데이터 로드
data <- read.csv(file.choose())
head(data)
summary(data)


# 3. 0과 음수만 남기기
test <- data[data$slope <= 0,]
summary(test)


# 4. 토탈
total = length(test$person_id)


# 5. label을 0(최악) : 1(차악)로 나누기
for(i in 1:total){
  if(test$slope[i] <= -20){
    test$binary[i] <- 0
  }
  else{
    test$binary[i] <- 1
  }
}


# 6. 확인
print(test)
summary(test)

length(which(test$binary == 0))
length(which(test$binary == 1))
length(which(test$binary == 1)) / total * 100

length(which(test$slope <= -20))
length(which(test$slope > -20))


# 7. p-value을 threshold 값 미만 데이터 지우기
for (i in unique(test$person_id)){
  result <- test[test$person_id == i,]
  lm_result <- lm(result$value ~ as.Date(result$value_month, "%Y-%m-%d"), data = result)
  test[,residuals:=mean((lm(result$value ~ as.Date(result$value_month, "%Y-%m-%d")))$residuals), by=test$person_id]
}


# 8. 저장
write.csv(test, "C:/Download/test1.csv")