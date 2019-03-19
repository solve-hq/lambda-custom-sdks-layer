#!/bin/bash
set -e
set -o pipefail

echo '***Start***'

INSTRUCTION="If you want to deploy, try running the script with 'deploy region bucket-prefix profile', e.g. 'deploy eu-west-2 solveless-stack-source-code solve-dev-eric'"

if [ $# -eq 0 ]; then
  echo "Missing arguments." 
  echo $INSTRUCTION
  exit 1
elif [ "$1" = "deploy" ] && [ $# -eq 4 ]; then 
  AWS_REGION=$2
  BUCKET_NAME="$3-$AWS_REGION"
  PROFILE=$4
  
  sam build
  sam package --template-file ./.aws-sam/build/template.yaml --s3-bucket $BUCKET_NAME --output-template-file ./.aws-sam/build/packaged.yml --region $AWS_REGION --profile $PROFILE
  aws cloudformation deploy --template-file ./.aws-sam/build/packaged.yml --stack-name custom-aws-sdk-layer --capabilities CAPABILITY_IAM --region $AWS_REGION --profile $PROFILE
else
  echo $INSTRUCTION
  exit 1
fi

