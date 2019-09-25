# <Bloodpressure1>
#  - R과 BigQuery를 연동하여 데이터를 불러와 보자.
#  - 불러온 데이터를 정제해 보자.

# 라이브러리 설치
install.packages("bigrquery")
install.packages("devtools")
install.packages("ggvis")
devtools::install_github("rstats-db/bigrquery")


# 라이브러리 이용
library(bigrquery)
library(ggvis)
library(ggplot2)
library(data.table)


# R과 BigQuery 연동
# 참고 : https://bestpractice80.tistory.com/12
projectName <- "private" # 프로젝트와 데이터셋 지정
datasetName <- "private"

ds <- bq_dataset(projectName, datasetName)


# 원하는 쿼리문 작성
sql <- 
"
SELECT
  *
FROM
  private
"


# 쿼리문 실행 파라미터
tb <- bq_dataset_query(ds,
                       query = sql,
                       billing = NULL,
                       quiet = NA)


# 쿼리문 실행
raw_bloodpressure <- bq_table_download(tb)
print(raw_bloodpressure)


# EDA
head(raw_bloodpressure) # 앞 5줄
str(raw_bloodpressure) # structure 확인
summary(raw_bloodpressure)


# 데이터 정제
# 데이터 선택
bloodpressure <- data.frame(raw_bloodpressure $ person_id, raw_bloodpressure $ value_as_number, raw_bloodpressure $measurement_date)
# 데이터 열 이름 수정
colnames(bloodpressure) = c("person_id", "value_as_number", "measurement_date")
# person_id 기준으로 오름정렬
bloodpressure <- bloodpressure[c(order(bloodpressure$person_id)),]
bloodpressure