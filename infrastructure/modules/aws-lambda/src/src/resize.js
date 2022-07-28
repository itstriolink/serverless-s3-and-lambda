"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.handler = void 0;
const s3_1 = require("./s3");
const constants_1 = require("./constants");
const sharp_1 = __importDefault(require("sharp"));
const handler = async (event, context, callback) => {
    const bucket = event.Records[0].s3.bucket.name;
    const rawKey = event.Records[0].s3.object.key.replace(/\+/g, " ");
    try {
        const image = await (0, s3_1.readFromS3)(rawKey, bucket);
        const imageBuffer = image.Body;
        const resizedImages = [];
        const key = rawKey.substring(rawKey.lastIndexOf("/") + 1);
        const keyWithoutExtension = key.substring(0, key.lastIndexOf("."));
        console.log(keyWithoutExtension);
        for (const { width, height } of constants_1.transformSizes) {
            const resized = await resizeImage(imageBuffer, width, height);
            resizedImages.push({
                buffer: resized,
                key: `images/${width}x${height}/${keyWithoutExtension}.jpeg`
            });
        }
        await Promise.all(resizedImages.map(async (resized) => (0, s3_1.uploadToS3)(resized.buffer, resized.key, bucket)));
        callback(null, true);
    }
    catch (error) {
        console.error("Something went wrong while uploading the images to S3", error);
        callback(error);
    }
};
exports.handler = handler;
const resizeImage = async (content, width, height) => {
    return (0, sharp_1.default)(content)
        .resize(width, height, { fit: "contain" })
        .toFormat("jpeg")
        .toBuffer();
};
//# sourceMappingURL=resize.js.map