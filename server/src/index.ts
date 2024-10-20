import './verify-environment.js';
import 'dotenv/config';

import express from 'express';
import cors from 'cors';
import cookieParser from 'cookie-parser';

import accountRouter from './routes/account.js';
import followerRouter from './routes/follower.js';
import postRouter from './routes/post.js';
import searchRouter from './routes/search.js';

const application = express();
const port = process.env.SERVER_PORT || 80;

/**
 * These are the third-party middlewares required
 * for this application.
 */
application.use([
    cors({
        origin: "*",
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

