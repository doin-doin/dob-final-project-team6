resource "aws_lambda_function" "test_lambda" { #Lambda 함수 설정
  function_name    = "test_Lambda" # Lambda 함수 이름
  role             = aws_iam_role.lambda_role.arn
  handler          = "test.handler" # 소스 이름으로 핸들러 설정
  runtime          = "nodejs16.x" # 런타임 설정 (nodejs, python ...)
  filename         = "${data.archive_file.testLambda_zip.output_path}" # data 블록에서 설정한 archive_file 이름으로 변경 (testLambda_zip)
  source_code_hash = filebase64sha256(data.archive_file.testLambda_zip.output_path) # data 블록에서 설정한 archive_file 이름으로 변경 (testLambda_zip)
  environment {
    variables = {
      SECURITY_HUB_REGION = "ap-northeast-2"
    }
  }
  tags = { #태그 설정
    "Name" = "test_lambda",
    "TEST" = "test_lambda",
    "Env"  = "TEST",
    "Type" = "lambda",
    "Owner"= "DevOps",
    "Privacy" = "Y"
  }
}

data "archive_file" "testLambda_zip" { #.zip 생성
  type        = "zip"
  source_dir  = "../lambda/TEST" #소스 파일 디렉토리 path 설정
  output_path = "../lambda_zip/testLambda.zip" # .zip file 이름 설정
}