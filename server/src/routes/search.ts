import { Router } from "express";
import { z } from 'zod';

import connection from "../mysql";
import zodVerify from "./middlewares/zod-verify";
import httpOnlyAuthentication from "./middlewares/http-only-authentication";

const router = Router();
const rowsPerPage = 10;

/**
 * Use this to search for a post, requires that the 
 * user is logged in. It is a simple search.
 */
router.post('/post', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({
        content: z.string().min(1).max(200),
        page: z.number().min(0)
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { content, page } = parameters;

    const [ results ] = await connection.query<any[]>('SELECT HEX(post_id) AS `uuid` FROM post WHERE post_content LIKE ? ORDER BY post_created_at DESC, HEX(post_id) LIMIT ?, ?', [ `%${content}%`, page * rowsPerPage, rowsPerPage ]);
    response.json({
        posts: results.map(entry => entry.uuid)
    });

});

/**
 * Use this to search for an account, requires that the 
 * user is logged in. It's a simple search.
 */
router.post('/account', httpOnlyAuthentication, async (request, response)  => {
    const parameters = zodVerify(z.object({
        username: z.string().min(1).max(200),
        page: z.number().min(0)
    }), request);
    
    if (!parameters) return response.sendStatus(400);
    const { username, page } = parameters;

    const [ results ] = await connection.query<any[]>('SELECT user_name FROM `user` WHERE user_name LIKE ? OR user_common_name LIKE ? ORDER BY user_created_at DESC, HEX(user_id) LIMIT ?, ?', [ `%${username}%`, `%${username}%`, page * rowsPerPage, rowsPerPage ]);
    response.json({
        users: results.map(entry => entry.user_name)
    });
    
});

export default router;