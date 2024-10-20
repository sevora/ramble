import { S3Client } from '@aws-sdk/client-s3';

interface Globals {
    s3: S3Client;
}

export default Globals;