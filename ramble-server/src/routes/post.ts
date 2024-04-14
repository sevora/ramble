import { Router } from "express";
import { z } from 'zod';

import connection from "../mysql";
import zodVerify from "./middlewares/zod-verify";
import httpOnlyAuthentication from "./middlewares/http-only-authentication";

const router = Router();
const ROWS_PER_PAGE = 10;

/**
 * Use this to create a new post, or reply, or repost. This is done relative 
 * to the logged in user based on httpOnlyAuthentication.
 */
router.post('/new', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({
        content: z.string().trim().min(1).max(200),
        parentId: z.string().uuid().optional()  // for replies
    }), request);

    if (!parameters) return response.sendStatus(400);

    const { uuid } = request.authenticated!;
    const { content, parentId } = parameters;

    try {
        // could look more beautiful
        await connection.query(`
            INSERT INTO post (post_user_id, post_content ${parentId ? ', post_parent_id' : ''}
            VALUES (UUID_TO_BIN(?), ? ${parentId ? ', UUID_TO_BIN(?)' : ''} `,
            [uuid, content, parentId]);
        return response.sendStatus(200);
    } catch {
        return response.sendStatus(500);
    }
});


/**
 * Use this to delete a post, the post must have been made by the user
 * logged in verified by httpOnlyAuthentication.
 */
router.post('/delete', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({
        postId: z.string().uuid()
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { postId } = parameters;

    await connection.query('DELETE FROM post WHERE BIN_TO_UUID(post_user_id) = ? AND BIN_TO_UUID(post_id) = ?', [uuid, postId]);
});

/**
 * Use this to like a post, the user must be logged in.
 */
router.post('/like', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({
        postId: z.string().uuid()
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { postId } = parameters;

    try {
        await connection.query('INSERT INTO `like` (like_user_id, like_post_id) VALUES (UUID_TO_BIN(?), UUID_TO_BIN(?))', [uuid, postId]);
        return response.sendStatus(200);
    } catch {
        return response.sendStatus(500); // can't double like a post
    }
});

/**
 * Use this to dislike a post, the user must be logged in.
 */
router.post('/dislike', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({
        postId: z.string().uuid()
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { postId } = parameters;

    await connection.query('DELETE FROM `like` WHERE BIN_TO_UUID(like_user_id) = ? AND BIN_TO_UUID(like_post_id) = ?', [uuid, postId]);
    return response.sendStatus(200);
});

/**
 * Use this to count the number of posts a user has made,
 * if no username is supplied, this returns the data of the client.
 */
router.post('/count', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({
        username: z.string().min(4).max(25).optional()
    }), request);

    if (!parameters) return response.sendStatus(400);

    let { uuid } = request.authenticated!;
    const { username } = parameters;

    // if a username is provided, that takes precedence
    if (username) {
        const [userResult] = await connection.query<any[]>('SELECT BIN_TO_UUID(user_id) AS `uuid` FROM user WHERE user_name = ?', [username]);
        if (userResult.length === 0) return response.sendStatus(404); // user does not exist
        uuid = userResult[0].uuid;
    }

    const [result] = await connection.query<any[]>(`SELECT COUNT(*) as post_count FROM post WHERE BIN_TO_UUID(post_user_id) = ?`, [ uuid ]);
    response.json({
        postCount: result[0].post_count
    });
});

/**
 * Use this to view a single post, the user must be logged in.
 * This sends the entire information about the post.
 */
router.post('/view', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({
        postId: z.string().uuid()
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { postId } = parameters;

    // we need to get all these related information, could be better
    const [ postResult ] = await connection.query<any[]>('SELECT BIN_TO_UUID(post_id) as `post_uuid`, post_content, BIN_TO_UUID(post_user_id) as `user_uuid`, post_created_at FROM post WHERE BIN_TO_UUID(post_id) = ?', [ postId ]);
    const [ userResult ] = await connection.query<any[]>('SELECT user_name, user_common_name FROM `user` WHERE BIN_TO_UUID(user_id) = ?', [ postResult[0].user_uuid ])
    const [ likeResult ] = await connection.query<any[]>('SELECT COUNT(*) AS like_count FROM `like` WHERE BIN_TO_UUID(like_post_id) = ?', [ postId ]);
    const [ commentResult ] = await connection.query<any[]>('SELECT COUNT(*) AS comment_count FROM post WHERE BIN_TO_UUID(post_parent_id) = ?', [ postId ]);
    
    const [ hasLiked ] = await connection.query<any[]>('SELECT * FROM `like` WHERE BIN_TO_UUID(like_user_id) = ? AND BIN_TO_UUID(like_post_id) = ?', [ uuid, postId ]);
    
    // then we send these information back
    response.json({
        postId:         postResult[0].post_uuid,
        postContent:    postResult[0].post_content,
        postCreatedAt:  postResult[0].post_created_at,
        
        userCommonName: userResult[0].user_common_name,
        username:       userResult[0].user_name,

        likeCount:      likeResult[0].like_count,
        commentCount:   commentResult[0].comment_count,

        hasLiked:       hasLiked.length > 0
    });
});

/**
 * Use this to list down multiple posts, the user must be logged in.
 * This only returns the postIds not the data in the post themselves.
 */
router.post('/list', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({
        page: z.number().min(0),
        parentId: z.string().uuid().optional(),
        category: z.enum(['trending', 'following']).optional()
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { page, parentId, category } = parameters;

    const pagination = [page * ROWS_PER_PAGE, ROWS_PER_PAGE];
    let results: any[] = [];

    if (parentId) {
        // this is get the comments to the post
        [results] = await connection.query<any[]>('SELECT BIN_TO_UUID(post_id) AS `uuid` FROM post WHERE post_parent_id = ? ORDER BY post_created_at DESC LIMIT ?, ?', [parentId, ...pagination]);
    } else if (category === 'trending') {
        [results] = await connection.query<any[]>(
            // this looks complicated but the point is to get the ids of the posts sorting them by the amount of likes and date
            `SELECT BIN_TO_UUID(post_id) AS \`uuid\`, COUNT(like_post_id) AS like_count
             FROM post
             LEFT JOIN \`like\` ON post_id = like_post_id
             GROUP BY post_id 
             ORDER BY EXTRACT(YEAR_MONTH FROM post_created_at) DESC, EXTRACT(DAY FROM post_created_at) DESC, like_count DESC
             LIMIT ?, ?`
            , pagination);
    } else if (category === 'following') {
        // this looks complicated but the point is to get the ids of the posts from users being followed, sorting them by the amount of likes and date
        [results] = await connection.query<any[]>(
            `SELECT BIN_TO_UUID(post_id) AS \`uuid\`, COUNT(like_post_id) AS like_count
            FROM post
            LEFT JOIN \`like\` ON post_id = like_post_id
            JOIN follower ON post_user_id = follows_id 
            WHERE BIN_TO_UUID(follower_id) = ? OR BIN_TO_UUID(post_user_id) = ?
            GROUP BY post_id 
            ORDER BY post_created_at DESC
            LIMIT ?, ?`
            , [uuid, uuid, ...pagination]);
    }

    // postIds are only sent back, not all the details
    response.json({
        posts: results.map(entry => ({ postId: entry.uuid }))
    });
});


export default router;