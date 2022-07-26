import { S3 } from "aws-sdk";
import sharp from "sharp";

const s3 = new S3();

export const readFromS3 = async (key: string, bucket: string) => {
  return s3.getObject({ Key: key, Bucket: bucket }).promise();
};

export const uploadToS3 = (content: Buffer, key: string, bucket: string) => {
  return s3
    .putObject({
      Body: content,
      Bucket: bucket,
      Key: key,
      ContentType: "image/webp"
    })
    .promise();
};

export const resizeImage = async (
  content: Buffer,
  width: number,
  height: number
): Promise<Buffer> => {
  return sharp(content)
    .resize(width, height, { fit: "contain" })
    .webp({
      quality: 100
    })
    .toBuffer();
};
