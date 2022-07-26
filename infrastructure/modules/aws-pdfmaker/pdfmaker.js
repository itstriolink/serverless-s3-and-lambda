const chromium = require("chrome-aws-lambda");

exports.handler = async (event, context) => {
  let footerTemplate;
  let headerTemplate;
  let decodedHTML;
  
  function base64dec(data) {
     let encodedData;
     encodedData = Buffer.from(data, "base64");
     return encodedData.toString("utf8");
  }

  try {
    decodedHTML = base64dec(event["html"]);
    } catch (e) {
      let errorMsg;
      errorMsg = e.toString().concat(" - Event must have 'html' key with base64 encoded value defined!");
      context.succeed({
        statusCode: 400,
        body: errorMsg,
      });
    return;
  }
  
  if ("footerTemplate" in event) {
    footerTemplate = base64dec(event["footerTemplate"]);
  }
  
  if ("headerTemplate" in event) {
    headerTemplate = base64dec(event["footerTemplate"]);
  }
  
  const {
    format,
    printBackground,
    landscape,
    margin,
  } = event;

  let browser;
  try {
    /**
     * Try to launch the browser
     */
    browser = await chromium.puppeteer.launch({
      args: [
        ...chromium.args,
        // "--disable-software-rasterizer",
        // "--disable-gpu",
        // "--disable-dev-shm-usage",
        // "--disable-setuid-sandbox",
        // "--no-first-run",
        // "--no-sandbox",
        // "--no-zygote",
        // "--single-process",
      ],
      defaultViewport: chromium.defaultViewport,
      executablePath: await chromium.executablePath,
      headless: chromium.headless,
    });

    if (!browser) {
      throw new Error("Chrome did not load");
    }

    const page = await browser.newPage();
    await page.setContent(decodedHTML, {
      waitUntil: "networkidle0",
    });

    const pdf = await page.pdf({
      printBackground: printBackground ? printBackground : false,
      headerTemplate,
      footerTemplate,
      displayHeaderFooter: !!headerTemplate || !!footerTemplate,
      format: format ? format : "A4",
      margin: margin ? margin : { top: 80, right: 80, bottom: 80, left: 80 },
      landscape: landscape ? landscape : false,
    });

    /**
     * Return base64 encoded PDF
     */
    context.succeed({
      statusCode: 200,
      pdf: pdf.toString("base64"),
      isBase64Encoded: true,
    });

    
  } catch (error)
  
  {
    console.error(error.toString())
    context.succeed({
      statusCode: 400,
      body: error.toString(),
    });

  } finally {
    if (browser) {
      await browser.close();
    }
  }
};