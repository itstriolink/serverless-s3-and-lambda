"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.uploadToS3 = exports.readFromS3 = void 0;
const aws_sdk_1 = require("aws-sdk");
const s3 = new aws_sdk_1.S3();
const readFromS3 = async (key, bucket) => {
    return s3.getObject({ Key: key, Bucket: bucket }).promise();
};
exports.readFromS3 = readFromS3;
const uploadToS3 = (content, key, bucket) => {
    return s3
        .putObject({
        Body: content,
        Bucket: bucket,
        Key: key,
        ACL: "public-read",
        ContentType: "image/jpeg"
    })
        .promise();
};
exports.uploadToS3 = uploadToS3;
//# sourceMappingURL=s3.js.map