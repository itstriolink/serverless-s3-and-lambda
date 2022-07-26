
# PDF Maker

Puppeteer running within lambda behind a API Gateway

example invocation:

```javascript
const lambdaResponse = await axios.post(
    'https://[api-gateway-id].execute-api.eu-central-1.amazonaws.com/sample-stack',
    {
      html: "",
      footerTemplate: "",
      headerTemplate: "",
      format: 'A4',
      margin: { top: 40, right: 40, bottom: 40, left: 40 },
      landscape: false,
      printBackground: false
    },
    {
      responseType: 'stream',
      headers: {
        Accept: 'application/pdf',
        token: this.puppeteerConfig.secret
      }
    },
  );
  res.set({
    'content-type': lambdaResponse.headers['content-type'],
    'content-length': lambdaResponse.headers['content-length']
  });
  lambdaResponse.data.pipe(res);
```
