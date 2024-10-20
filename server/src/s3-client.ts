import 'dotenv/config';
import { S3Client } from '@aws-sdk/client-s3';
import Globals from './globals.js';

const globalHere = (global as any) as Globals;

if (!globalHere.s3) {
    globalHere.s3 = new S3Client({
        credentials: {
            accessKeyId: process.env.AWS_ACCESS_KEY,
            secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY
        },
        region: process.env.AMAZON_S3_REGION
    });
}

// this is a singleton of our s3Client
export default globalHere.s3;