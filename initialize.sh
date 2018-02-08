#!/bin/sh

aws lambda create-function \
    --function-name blood-pressure-recorder \
    --runtime nodejs6.10 \
    --role arn:aws:iam::026455325571:role/lambda_basic_execution \
    --handler index.handler \
    --zip-file fileb://./package.zip

API_ID=$(aws apigateway create-rest-api \
    --name 'Blood Pressure Recorder' \
    --region ap-northeast-1 \
| jq -r ".id")

ID=$(aws apigateway get-resources --rest-api-id $API_ID --region ap-northeast-1 | jq -r ".items[] | .id")
