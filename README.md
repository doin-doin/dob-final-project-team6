# 자동화된 자산 관리 시스템
<img width="1380" alt="스크린샷 2023-06-28 오전 11 22 37" src="https://github.com/cs-devops-bootcamp/devops-04-Final-Team6/assets/107831623/6142e9d1-4ab7-4928-8f20-6f3f65acaa11">

## 프로젝트 소개

AWS 서비스를 사용하여 저장되어 있는 자산의 상태, 로그, 시스템 취약점을 주기적으로 점검하여 일일 점검 결과를 E-mail로 보내주고, 취약점 점검 결과를 실시간 SLACK 알림으로 문제 파악과 대응이 가능하도록 알려주는 시스템

## 요구사항

### 1. 기능 요구사항
1. 자산구분 시스템: 자산 분류 기준에 따라 수립된 정의 및 리소스에 적절한 태그 설정
2. 정보 자산 점검(CCE, CVE)
3. 모니터링 및 알람(취약성 점검 결과 알림, 일별 점검 결과 리포트)

### 2. 인프라 요구사항
1.  가용성, 내결함성, 확장성, 보안성 고려
2.  CI/CD 파이프라인 구성
3.  시각화 모니터링 시스템 구축

## 기술 스택

  <img src="https://img.shields.io/badge/amazonaws-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white"> <img src="https://img.shields.io/badge/GithubActions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white">
  <img src="https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white">
  <img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white">
  <img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white">
<img src="https://img.shields.io/badge/grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white">
<img src="https://img.shields.io/badge/python-3776AB?style=for-the-badge&logo=python&logoColor=white"> 
<img src="https://img.shields.io/badge/node.js-339933?style=for-the-badge&logo=Node.js&logoColor=white">


## AWS Services
### 자산 구분 시스템
- AWS Resource Groups & Tag Editor
  
### 정보 자산 점검
- Amazon Inspector
- AWS Systmes Manager
- Amazon SecurityHub

### 모니터링 및 알람
- Amazon EventBridge
- Amazon Managed Grafana
- Amazon SNS
- Amazon SES

## Requirements
- AWS Account
- AWS CLI (installed and configured)
- Git
- Terraform
- Email (Amazon SES verified)


## Terraform 사전 조건
- Amazon Inspecotr와 AWS Security Hub 수동으로 활성화해야 합니다.

  1. Amazon Inspector   
     시작하기 > Inspector 활성화

  2. AWS Security Hub   
     Security Hub로 이동 > Security Hub 활성화
   
## Terraform CI/CD Manual
- tf_backend 폴더의 tfstate.tf에서 s3 name 과 db table name을 변경합니다. (리전별로 고유 해야하기 때문)
- tf_backend를 로컬 환경에서 apply 합니다. (S3와 DynamoDB Table 배포)
- main.tf에서 배포한 s3와 table로 이름을 변경합니다. (.tf 파일들은 terraform 폴더안에 있습니다.)
- .github/workflows폴더에 Terraform.yml의 Branch를 본인이 사용 할 Branch로 변경합니다.
- ENV의 환경변수는 본인 변수로 변경합니다. (Github Secret Action에 설정한 변수 / AccessKey)
- Lambda Source는 labmda 폴더 안에 추가로 생성합니다.
- Lambda CI/CD는 test_lambda.tf 를 참고하세요 (주석으로 설명)
- Lambda에 nodejs를 사용할 시엔 terraform.yml 에서 build 부분을 참고하여 작업합니다. (Path 설정과 Command 설정)
- 설정한 Branch로 Push 하면, Terraform apply가 Github Action에서 자동 실행됩니다.
- terraform destroy를 하려면 commit message 를 "terraform destroy" 로 설정하고 push 하면 terraform destroy가 Github Action에서 자동 실행됩니다.
- 만일 첫 배포시에 "* Scaling activity (d16623f2-b987-4438-d653-ec78b9b0fd6a): Failed: Value (SSMInstanceProfile) for parameter iamInstanceProfile.name is invalid. Invalid IAM Instance Profile name. Launching EC2 instance failed." 해당 에러가 난다면 한번 더 배포해보세요. 두번째 배포 때는 성공 할겁니다. (원인 파악 중)


## Amazon Managed Grafana
- Amazon Managed Grafana console에서 워크 스페이스를 생성합니다.
- IAM Identity Center에 User를 생성합니다.
- Grafana 워크 스페이스에 생성한 user를 admin으로 할당합니다. 
- Grafana workspace URL로 접속하여 User id와 password를 입력합니다.(aws grafana 접속 완료)
- 접속한 Amazon Managed Grafana의 aws data sources 페이지에서 cloudwatch를 데이터 소스로 추가합니다.
(이 때, 해당 계정에 cloudwatch log 접근 권한이 추가되어 있는 상태여야 log group을 추가할 수 있습니다.)
- 이제 dashboard로 이동하여 new dashboard를 생성하여 데이터를 시각화 할 수 있습니다.

<p align="center">
    <img src="https://github.com/cs-devops-bootcamp/devops-04-Final-Team6/assets/126461973/c6adc023-8299-4509-9c6a-6883a335b483" width="750" />
</p>