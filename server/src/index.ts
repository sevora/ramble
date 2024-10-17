import './verify-environment';
import 'dotenv/config';

import express from 'express';
import cors from 'cors';
import cookieParser from 'cookie-parser';

import accountRouter from './routes/account';
import followerRouter from './routes/follower';
import postRouter from './routes/post';
import searchRouter from './routes/search';

const application = express();
const port = process.env.SERVER_PORT || 80;

/**
 * These are the third-party middlewares required
 * for this application.
 */
application.use([
    cors({
        origin: process.env.CLIENT_URL,
        methods: ['GET', 'POST'],
        credentials: true
    }),
    express.json(),
    express.urlencoded({ extended: false }),
    cookieParser()
]);

/**
 * These are our custom routers.
 */
application.use('/account', accountRouter);
application.use('/follower', followerRouter);
application.use('/post', postRouter);
application.use('/search', searchRouter);

application.listen(port || 80, () => {
    console.log(`Server listening on port: ${port}`);
});

