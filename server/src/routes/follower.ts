import { Router } from "express";
import { z } from 'zod';

import connection from "../mysql.js";
import zodVerify from "./middlewares/zod-verify.js";
import httpOnlyAuthentication from "./middlewares/http-only-authentication.js";

const router = Router();
const rowsPerPage = 10;

/**
 * Use this to create an association between two accounts, following another account.
 * The follower is the one logged in by httpOnlyAuthentication.
 */
router.post('/follow', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({ 
        username: z.string().min(4).max(25) 
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { username } = parameters;

    try {
        await connection.query('INSERT INTO follower (follower_id, follows_id) VALUES (UNHEX(?), (SELECT user_id FROM `user` WHERE user_name = ?))', [ uuid, username ]);
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
        username: z.string().min(4).max(25)
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { username } = parameters;
    
    await connection.query('DELETE FROM follower WHERE follower_id = UNHEX(?) AND follows_id = (SELECT user_id FROM `user` WHERE user_name = ?)', [ uuid, username ]);
    response.sendStatus(200);
});

/**
 * A way to query if the client is following or being followed by a user or not,
 */
router.post('/ask', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({ 
        username: z.string().min(4).max(25)
    }), request);

    if (!parameters) return response.sendStatus(400);
    
    const { uuid } = request.authenticated!;
    const { username } = parameters;

    // if this can be done in a single query that is much more efficient I'm all for it
    const [ otherUserResult ] = await connection.query<any[]>('SELECT HEX(user_id) AS `uuid` FROM `user` WHERE user_name = ?', [ username ]);
    if (otherUserResult.length === 0) return response.sendStatus(400);

    const [ isFollowerResult ] = await connection.query<any[]>('SELECT * FROM follower WHERE follower_id = UNHEX(?) AND follows_id = UNHEX(?)', [ otherUserResult[0].uuid, uuid ]);
    const [ isFollowingResult ] = await connection.query<any[]>('SELECT * FROM follower WHERE follower_id = UNHEX(?) AND follows_id = UNHEX(?)', [ uuid, otherUserResult[0].uuid ]);
    
    response.json({
        isFollower:  isFollowerResult.length > 0,
        isFollowing: isFollowingResult.length > 0
    });
});

/**
 * Use this to get the the number of followers and following of a user.
 * If no username is provided, the client's own data would be sent.
 */
router.post('/count', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({ 
        username: z.string().min(4).max(25).optional()
    }), request);

    if (!parameters) return response.sendStatus(400);
    
    let { uuid } = request.authenticated!;
    const { username } = parameters;

    // if a username is provided, that takes precedence and so we count that person's data instead
    if (username) {
        const [ userResult ] = await connection.query<any[]>('SELECT HEX(user_id) AS `uuid` FROM `user` WHERE user_name = ?', [ username ]);
        if ( userResult.length === 0 ) return response.sendStatus(404); // user does not exist
        uuid = userResult[0].uuid;
    }
    
    // these queries count the number of followers and following of specified user respectively
    const [ followerResult ] = await connection.query<any[]>(`SELECT COUNT(*) as follower_count FROM follower WHERE follows_id = UNHEX(?)`, [ uuid ]);
    const [ followsResult ] = await connection.query<any[]>(`SELECT COUNT(*) as follow_count FROM follower WHERE follower_id = UNHEX(?)`, [ uuid ]);

    // send the data back
    response.json({
        followerCount: followerResult[0].follower_count,
        followCount: followsResult[0].follow_count
    });
});

/**
 * Use this to list the followers or following, it uses a pagination system,
 * infinite scroll is ideal for this endpoint.
 */
router.post('/list', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({ 
        username: z.string().min(4).max(25).optional(),
        category: z.enum([ 'following', 'follower' ]),
        page: z.number().min(0)
    }), request);

    if (!parameters) return response.sendStatus(400);
    let { uuid } = request.authenticated!;
    const { username, category, page } = parameters;

    // if a username is provided we want to get that one's result instead
    if (username) {
        const [ userResult ] = await connection.query<any[]>('SELECT HEX(user_id) AS `uuid` FROM `user` WHERE user_name = ?', [ username ]);
        if ( userResult.length === 0 ) return response.sendStatus(404); // user does not exist
        uuid = userResult[0].uuid;
    }

    const [ what, from ] = category === 'follower' ? [ 'follower_id', 'follows_id' ] : [ 'follows_id', 'follower_id' ];

    // take note of this query very essential for this kind of association
    const [ results ] = await connection.query<any[]>(`SELECT user_name FROM user, follower WHERE user_id = ${what} AND ${from} = UNHEX(?) ORDER BY follow_created_at DESC, HEX(user_id) LIMIT ?, ?`, [ uuid, page * rowsPerPage, rowsPerPage ]);
    
    // we then rename these properties following the convention
    return response.json({ users: results.map(entry => 
            entry.user_name
        )
    });
});

export default router;