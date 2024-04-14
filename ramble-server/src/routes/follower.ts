import { Router } from "express";
import { z } from 'zod';

import connection from "../mysql";
import zodVerify from "./middlewares/zod-verify";
import httpOnlyAuthentication from "./middlewares/http-only-authentication";

const router = Router();
const ROWS_PER_PAGE = 10;

/**
 * Use this to create an association between two accounts, following another account.
 * The follower is the one logged in by httpOnlyAuthentication.
 */
router.post('/follow', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({ 
        username: z.string().min(4).max(25).regex(/[a-z0-9_]+/) 
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { username } = parameters;

    try {
        await connection.query('INSERT INTO follower (follower_id, follows_id) VALUES (UUID_TO_BIN(?), (SELECT user_id FROM `user` WHERE user_name = ?))', [ uuid, username ]);
    } catch {
        return response.sendStatus(500); // can't follow from or a non-existing account
    }

    response.sendStatus(200);
});

/**
 * Use this to unfollow a user from a username. The one that will be unfollowing 
 * is the one logged in by httpOnlyAuthentication.
 */
router.post('/unfollow', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({ 
        username: z.string().min(4).max(25).regex(/[a-z0-9_]+/) 
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { username } = parameters;

    try {
        await connection.query('DELETE FROM follower WHERE BIN_TO_UUID(follower_id) = ? AND follows_id = (SELECT user_id FROM `user` WHERE user_name = ?)', [ uuid, username ]);
    } catch {
        return response.sendStatus(500);
    }
});

/**
 * Use this to list the followers or following, it uses a pagination system,
 * infinite scroll is ideal for this endpoint.
 */
router.post('/list', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({ 
        category: z.enum([ 'following', 'follower' ]),
        page: z.number().min(0)
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { category, page } = parameters;
    const [ what, from ] = category === 'follower' ? [ 'follower_id', 'follows_id' ] : [ 'follows_id', 'follower_id' ];

    try {
        // take note of this query very essential for this kind of association
        const [ results ] = await connection.query<any[]>(`SELECT user_name, user_common_name, user_biography FROM user, follower WHERE user_id = ${what} AND ${from} = ? ORDER BY follow_created_at DESC LIMIT ?, ?`, [ uuid, page * ROWS_PER_PAGE, ROWS_PER_PAGE ]);
        
        // we then rename these properties following the convention
        return response.json({ users: results.map(entry => 
                ({ 
                    username:       entry.user_name, 
                    userCommonName: entry.user_common_name, 
                    biography:      entry.user_biography 
                })
            )
        });
    } catch {
        return response.sendStatus(500); // means some sort of server error
    }
});

export default router;