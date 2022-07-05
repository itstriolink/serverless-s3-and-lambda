import { readFromS3, resizeImage, uploadToS3 } from "./s3";
import { transformSizes } from "./constants";
import { Context, S3Event } from "aws-lambda";

interface IResizedImage {
  buffer: Buffer;
  key: string;
}

export const handler = async (event: S3Event, context: Context) => {
  const bucket = event.Records[0].s3.bucket.name as string;
  const rawKey = event.Records[0].s3.object.key.replace(/\+/g, " ") as string;

  try {
    const image = await readFromS3(rawKey, bucket);
    const imageBuffer = image.Body as Buffer;

    const resizedImages: IResizedImage[] = [];
    const key = rawKey.substring(rawKey.lastIndexOf("/") + 1);

    for (const { width, height } of transformSizes) {
      const resized = await resizeImage(imageBuffer, width, height);

      resizedImages.push({
        buffer: resized,
        key: `images/${width}x${height}/${key}`
      });
    }
    await Promise.all(
      resizedImages.map(async (resized) =>
        uploadToS3(resized.buffer, resized.key, bucket)
      )
    );

    return true;
  } catch (error) {
    console.error(
      "Something went wrong while uploading the images to S3",
      error
    );
  }
};
