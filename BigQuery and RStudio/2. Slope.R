# <Bloodpressure2>
#  - 환자의 gfr 기울기(slope)를 구하기 위해, 각 환자의 x축 : date, y축 : gfr로 기울기를 구해야 한다.
#  - Linear model을 만들면 R 내장함수에 의해 기울기(slope)를 구할 수 있다.
#  - gfr 데이터로 기울기를 구하기 전에, Bloodpressure 데이터로 기울기 구하기를 테스트 해 보자.
#  - Bloodpressure1에서 이어지는 코드이다. (이전 코드가 작성되어 있어야 작동됨)


# EDA

# 플롯 그리기
test <- bloodpressure[bloodpressure $person_id == 5960,] # 환자 아이디 5960인 값들을 test로 만든다.
plot(test$measurement_date, test$value_as_number) # x축 : 날짜, y축 : 혈압 플로팅
test %>% ggvis( ~test$measurement_date, ~test$value_as_number, fill=~test$person_id) %>% layer_points() # x축 : 날짜, y축 : 혈압 플로팅


# 날짜별 혈압의 평균 구하기
aggregate(test$value_as_number, by=list(test$measurement_date), mean)

# Linear regression - x축 : 날짜, y축 : 혈압
lm_result <- lm(test$value_as_number ~ test$measurement_date, data=test) # lm 모델 생성
ggplot(test, aes(test$measurement_date, test$value_as_number)) + geom_point() + stat_smooth(method=lm) # lm 모델 그리기
print(lm_result$coefficients) # y절편과 기울기 확인
summary(lm_result)

# 분산과 아웃라이어 확인
hist(test$value_as_number) # 분산
boxplot(test$value_as_number) # 아웃라이어

# 기울기 구하기
coeff <- numeric(length=20000) # 기울기 넣을 리스트
for (i in unique(bloodpressure$person_id)) { # 환자 id를 유니크하게 뽑아냄
  test <- bloodpressure[bloodpressure $person_id == i,] # 환자 id 값의 데이터를 test에 넣음
  lm_result <- lm(test$value_as_number ~ test$measurement_date, data=test) # 데이터로 lm 모델을 만듬
  coeff<- append(lm_result$coefficients[[2]], coeff) # 기울기 리스트
}