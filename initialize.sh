#!/bin/bash

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

echo "API ID: "$API_ID

# you can get REST API ID by `aws apigateway get-rest-apis`.
ROOT_RESOURCE_ID=$(aws apigateway get-resources --rest-api-id $API_ID --region ap-northeast-1 | jq -r ".items[] | .id")
echo "root resource ID: "$ROOT_RESOURCE_ID

RESOURCE_ID=$(RESOURCE_ID=aws apigateway create-resource --rest-api-id $API_ID \
    --region ap-northeast-1
    --parent-id $ROOT_RESOURCE_ID \
    --path-part record \
| jq -r ".id")

aws apigateway put-method \
    --rest-api-id $API_ID \
    --resource-id resource-id \
    --http-method POST \
    --authorization-type NONE
