# PDF Maker - direct invocation

Puppeteer running within lambda, to be used via direct invocation - it doesn't require API GW, but uses
direct invocation via AWS SDK (cli or language specific SDK). It uses a payload json  (see `payload.json`)
and returns json with base64 encoded pdf.
IAM user used to invoke this function is provided via module outputs.

* Examples below are showing the syncronous invocation, max payload size (sent and received) is 6MB.
* See https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html for more details.

## TODO

* Need to figure out a resource based policy so we can invoke this lambda from ECS without using a generated IAM use.

## Example invocation with aws cli (v2 assumed)

```bash
~: aws lambda invoke --function-name dev-pdfmaker --payload file://payload.json pdf.json --cli-binary-format raw-in-base64-out
```

* Payload file must contain at least `html` key, which is must be base64 encoded html.
* Payload file can contain `headerTemplate` and/or `footerTemplate`, which must be base64 encoded html.
* Payload file can contain `format` and `margin` keys - refer to `payload.json` for example.
* Payload can set `landscape` or `printBackground` to `true` if required. Be careful with `printBackground` as it can result in large PDF files - https://github.com/puppeteer/puppeteer/issues/458
* Successful output is provided as the sample below:

```json
{ 
  "statusCode":200,
  "pdf":"JVBERi0xLjQ...ZgoxODgyNAolJUVPRg==",
  "isBase64Encoded":true
}
```
* When testing in cli you can extract and convert returned base64 encoded PDF from output file like this - `cat pdf.json | jq .pdf | tr -d \"  | base64 -d > out.pdf`

## Example invocation with Node.js (aws-sdk v3 required)

* Requires pdfmaker lambda function running on AWS - use this module to set it up.
* Requires Node.js runtime, tested with 14.x
* Install the required node modules - `npm install @aws-sdk/client-lambda`
* Copy the script provided below into `invoke-lambda-client.js` file. 
* Please note the `Payload` format comments for both invocation `params` and `data` being returned.
* Set the authentication required - check the outputs of the module to get the relevant settings
  * Setup the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` env variables
  * Update the sample script - set correct region in `const client = new LambdaClient({region:'eu-central-1'})`
* Run the sample script using `node  --trace-warnings invoke-lambda-client.js`
* Default output should look something like the one below

```
{
  statusCode: 200,
  pdf: 'JVBERi0xLjQKJ...goxMjgxOAolJUVPRg==',
  isBase64Encoded: true
}
```

### Using the example code in ECS

* ECS task running the code should have the appropriate permission (resource based policy on lambda function) setup
* If the above requirement is setup correct, the only other setting to take care of is `region:` setting as explained above
* Of course the example code should be modified to upload the PDF to S3 or similar.

## Example Node.js script

```js
const { LambdaClient, InvokeCommand } = require("@aws-sdk/client-lambda");

const client = new LambdaClient({region:'eu-central-1'}); // region needs to be set specifically

const params = {
  FunctionName: "sndbox-dev-pdfmaker",
  // base64 encoded payloads must not contain any line breaks - it should be oneline string,
  // equivalent to output of bash command base64 -w0 < file.html
  // 'html' is required, others are optional
  Payload: JSON.stringify(
          { html: "PCFET0NUWVBFIGh0bWw+CjxodG1sPgoKPGJvZHk+CjxoMj5IZWxsbyBMYW1iZGEgUERGPC9oMj4KTG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNlY3RldHVyIGFkaXBpc2NpbmcgZWxpdC4gTW9yYmkgbGVvIG51bGxhLCB2dWxwdXRhdGUgbHVjdHVzIHByZXRpdW0gYSwgc29sbGljaXR1ZGluIGVsZWlmZW5kIG1hc3NhLiBTZWQgaWQgbmlzaSB1dCB0ZWxsdXMgdGluY2lkdW50IGNvbmRpbWVudHVtLiBTZWQgcHJldGl1bSBmZWxpcyBzY2VsZXJpc3F1ZSBleCB0ZW1wb3IsIGEgZ3JhdmlkYSB0ZWxsdXMgdm9sdXRwYXQuIEFlbmVhbiBmZXVnaWF0LCBlbmltIGluIGx1Y3R1cyBtb2xlc3RpZSwgZW5pbSBhbnRlIHJ1dHJ1bSBsZWN0dXMsIGlkIHZlaGljdWxhIHZlbGl0IG51bmMgc2VkIGRvbG9yLgo8L2JvZHk+Cgo8L2h0bWw+Cg==",
            headerTemplate: "PGRpdiBzdHlsZT0iZm9udC1zaXplOiAxMHB4OyBwYWRkaW5nLXRvcDogNHB4OyB0ZXh0LWFsaWduOiBjZW50ZXI7IHdpZHRoOiAxMDAlOyI+CiAgIDxzcGFuPlRoaXMgaXMgYSBzYW1wbGUgaGVhZGVyPC9zcGFuPiAtIHBhZ2Ugbm8uOiA8c3BhbiBjbGFzcz0icGFnZU51bWJlciI+PC9zcGFuPgo8L2Rpdj4K",
            footerTemplate: "PGRpdiBzdHlsZT0iZm9udC1zaXplOiAxMHB4OyBwYWRkaW5nLWJvdHRvbTogNHB4OyB0ZXh0LWFsaWduOiBjZW50ZXI7IHdpZHRoOiAxMDAlOyI+CiAgIDxzcGFuPlRoaXMgaXMgYSBzYW1wbGUgZm9vdGVyPC9zcGFuPiAtIHBhZ2Ugbm8uOiA8c3BhbiBjbGFzcz0icGFnZU51bWJlciI+PC9zcGFuPgo8L2Rpdj4K",
            format: "A4",
            margin: { "top": "80", "right": "80", "bottom": "80", "left": "80" }
          }
        )
};

const command = new InvokeCommand(params);

// Expect https://docs.aws.amazon.com/AWSJavaScriptSDK/v3/latest/clients/client-lambda/interfaces/invokecommandoutput.html
client.send(command).then(
  (data) => {
    // Payload is an Uint8Array in AWS SDK v3 so it takes extra effort to decode it.
    // See  https://github.com/aws/aws-sdk-js-v3/issues/1877 and https://github.com/aws/aws-sdk-js-v3/issues/1877#issuecomment-776811808
    // Print the whole Payload to console.log
    console.log(JSON.parse(Buffer.from(data["Payload"]).toString()));
    // Print the base64 encoded pdf to console.log
    //console.log(JSON.parse(Buffer.from(data["Payload"]).toString())["pdf"]);
  },
  (error) => {
    console.log(error);
  }
);
```

## Sample payload.json

* Showing all the options available, `html` is required, others are optional.

```json
{ 
    "html": "PCFET0NUWVBFIGh0bWw+CjxodG1sPgoKPGJvZHk+CjxoMj5IZWxsbyBMYW1iZGEgUERGPC9oMj4KTG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNlY3RldHVyIGFkaXBpc2NpbmcgZWxpdC4gTW9yYmkgbGVvIG51bGxhLCB2dWxwdXRhdGUgbHVjdHVzIHByZXRpdW0gYSwgc29sbGljaXR1ZGluIGVsZWlmZW5kIG1hc3NhLiBTZWQgaWQgbmlzaSB1dCB0ZWxsdXMgdGluY2lkdW50IGNvbmRpbWVudHVtLiBTZWQgcHJldGl1bSBmZWxpcyBzY2VsZXJpc3F1ZSBleCB0ZW1wb3IsIGEgZ3JhdmlkYSB0ZWxsdXMgdm9sdXRwYXQuIEFlbmVhbiBmZXVnaWF0LCBlbmltIGluIGx1Y3R1cyBtb2xlc3RpZSwgZW5pbSBhbnRlIHJ1dHJ1bSBsZWN0dXMsIGlkIHZlaGljdWxhIHZlbGl0IG51bmMgc2VkIGRvbG9yLgo8L2JvZHk+Cgo8L2h0bWw+Cg==",
            "headerTemplate": "PGRpdiBzdHlsZT0iZm9udC1zaXplOiAxMHB4OyBwYWRkaW5nLXRvcDogNHB4OyB0ZXh0LWFsaWduOiBjZW50ZXI7IHdpZHRoOiAxMDAlOyI+CiAgIDxzcGFuPlRoaXMgaXMgYSBzYW1wbGUgaGVhZGVyPC9zcGFuPiAtIHBhZ2Ugbm8uOiA8c3BhbiBjbGFzcz0icGFnZU51bWJlciI+PC9zcGFuPgo8L2Rpdj4K",
            "footerTemplate": "PGRpdiBzdHlsZT0iZm9udC1zaXplOiAxMHB4OyBwYWRkaW5nLWJvdHRvbTogNHB4OyB0ZXh0LWFsaWduOiBjZW50ZXI7IHdpZHRoOiAxMDAlOyI+CiAgIDxzcGFuPlRoaXMgaXMgYSBzYW1wbGUgZm9vdGVyPC9zcGFuPiAtIHBhZ2Ugbm8uOiA8c3BhbiBjbGFzcz0icGFnZU51bWJlciI+PC9zcGFuPgo8L2Rpdj4K",
            "format": "A4",
            "margin": { "top": "80", "right": "80", "bottom": "80", "left": "80" },
            "landscape": false,
            "printBackground": false
}
```
