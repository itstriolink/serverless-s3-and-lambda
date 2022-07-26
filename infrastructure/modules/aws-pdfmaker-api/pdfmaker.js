const chromium = require("chrome-aws-lambda");

/**
 * Render HTML with Chrome to PDF
 *  - use base64 encoded images
 *  - use embedded CSS
 *
 * @return {Promise<string|*>}
 */
exports.handler = async (event, context) => {

  let data;
  try {
    data = JSON.parse(event.body);
  } catch (e) {
    context.succeed({
      statusCode: 400,
      body: e.toString(),
    });
    return;
  }

  if (!event.headers || event.headers["secret"] !== process.env.SECRET) {
    context.succeed({
      statusCode: 400,
      body: "Invalid Secret",
    });
    return;
  }

  const {
    footerTemplate,
    headerTemplate,
    format,
    printBackground,
    margin,
    html,
  } = data;


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
    await page.setContent(html, {
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
     * Return binary PDF
     */
    context.succeed({
      headers: {
        "Content-type": "application/pdf",
      },
      statusCode: 200,
      body: pdf.toString("base64"),
      isBase64Encoded: true,
    });

  } finally {
    if (browser) {
      await browser.close();
    }
  }
};
