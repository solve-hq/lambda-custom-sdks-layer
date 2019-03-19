# lambda-custom-sdks-layer

A Lambda Layer that packages the aws-sdk and aws-xray-sdk to use in nodejs 8.10 lambda functions.

## Current Versions

- [AWS SDK v2.423.0](https://github.com/aws/aws-sdk-js/releases/tag/v2.395.0)
- [AWS Xray 2.2.0](https://github.com/aws/aws-xray-sdk-node/releases/tag/aws-xray-sdk%402.2.0)

## Build and Deploy

To deploy this layer to a new region, use the `build.sh` script like so:

```bash
$ ./build.sh deploy <Region> <Bucket Prefix> <Profile>
```

The `<Bucket Prefix>` argument will be combined with the `<Region>` argument to form the full name of the s3 bucket to store the layer code. So for example, this command:

```bash
$ ./build.sh deploy us-west-1 source-code solve-dev-eric
```

Will upload the layer code to the `source-code-us-west-1` bucket. That bucket must exist in the `us-west-1` region for the deploy to be successful.

This stack will need to be created in the region before deploying functions that use the layer in said region.

## Usage

To use this layer in your nodejs lambda functions, import the `AWS::SSM::Parameter` created by this stack:

```yaml
Parameters:
  CustomSDKsLayerVersionArn:
    Type: "AWS::SSM::Parameter::Value<String>"
    Default: "/Solve/Layers/NodeJS/CustomSDKs/ARN"
    Description: The Layer Version ARN of the Custom SDKs Layer which packages aws-sdk and aws-xray-sdk
```

And then reference the parameter when creating the lambda function resource, like so:

```yaml
Resources:
  PublishedContentSubscriber:
    Type: AWS::Serverless::Function
    Properties:
      CodeUri: ./ingestion/published-content-subscriber
      Handler: index.handler
      Runtime: nodejs8.10
      Layers:
        - !Ref CustomSDKsLayerVersionArn
```

## How to update the sdk versions

Update the dependencies in the `./nodejs/package.json` file:

```json
"aws-sdk": "^2.395.0",
"aws-xray-sdk": "^2.2.0"
```
