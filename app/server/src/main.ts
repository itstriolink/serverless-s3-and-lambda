import serverless from "serverless-http";
import express, { Request, Response } from "express";
import cors from "cors";
import {
  S3Client,
  HeadObjectCommand,
  PutObjectCommand
} from "@aws-sdk/client-s3";
import { v4 } from "uuid";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";

const s3 = new S3Client({
  region: "us-east-1"
});

const app = express();
app.use(express.json());
app.use(cors());

app.get("/presign-url", async (req: Request, res: Response) => {
  const uuid = v4();

  const command = new PutObjectCommand({
    Bucket: process.env.S3_BUCKET_NAME,
    Key: `uploads/${uuid}.jpeg`,
    ContentType: "image/jpeg"
  });

  const signedUrl = await getSignedUrl(s3, command, { expiresIn: 3600 });

  return res.status(200).json({
    id: uuid,
    url: signedUrl
  });
});

app.get("/image/:id", async (req: Request, res: Response) => {
  const id = req.params.id;

  const command = new HeadObjectCommand({
    Bucket: process.env.S3_BUCKET_NAME,
    Key: "images/128x128/" + id + ".jpeg"
  });

  try {
    await s3.send(command);
  } catch (error) {
    return res.status(404).json({
      message: "Image with the requested id was not found"
    });
  }

  const links = [];
  const sizes = ["128x128", "64x64", "32x32"];
  const bucketBaseUrl = `https://${process.env.S3_BUCKET_NAME}.s3.amazonaws.com`;

  for (const size of sizes) {
    links.push(`${bucketBaseUrl}/images/${size}/${id}.jpeg`);
  }

  return res.status(200).json({
    links
  });
});

app.use((req: Request, res: Response) => {
  return res.status(404).json({
    error: "Not Found"
  });
});

module.exports.handler = serverless(app);
