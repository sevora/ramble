import { Router } from "express";
import { z } from 'zod';

import connection from "../mysql";
import zodVerify from "./middlewares/zod-verify";
import httpOnlyAuthentication from "./middlewares/http-only-authentication";

const router = Router();
const ROWS_PER_PAGE = 10;

/**
 * Use this to search for a post, requires that the 
 * user is logged in.
 */
router.post('/post', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({
        content: z.string().min(1).max(200),
        page: z.number().min(0)
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { content, page } = parameters;

    const [ results ] = await connection.query<any[]>('SELECT BIN_TO_UUID(post_id) AS `uuid` FROM post WHERE post_content LIKE ? LIMIT ?, ?', [ `%${content}%`, page * ROWS_PER_PAGE, ROWS_PER_PAGE ]);
    response.json({
        posts: results.map(entry => ({ 
            postId: entry.uuid 
        }))
    });

});

/**
 * Use this to search for an account, requires that the 
 * user is logged in.
 */
router.post('/account', httpOnlyAuthentication, async (request, response)  => {
    const parameters = zodVerify(z.object({
        username: z.string().min(4).max(25),
        page: z.number().min(0)
    }), request);
    
    if (!parameters) return response.sendStatus(400);
    const { username, page } = parameters;

    const [ results ] = await connection.query<any[]>('SELECT BIN_TO_UUID(user_id) AS `uuid` FROM `user` WHERE user_name LIKE ? LIMIT ?, ?', [ `%${username}%`, page * ROWS_PER_PAGE, ROWS_PER_PAGE ]);
    response.json({
        accounts: results.map(entry => ({ 
            accountId: entry.uuid 
        }))
    });
    
});

export default router;