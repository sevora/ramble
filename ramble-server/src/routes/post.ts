import { Router } from "express";
import { z } from 'zod';

import connection from "../mysql";
import zodVerify from "./middlewares/zod-verify";
import httpOnlyAuthentication from "./middlewares/http-only-authentication";

const router = Router();

/**
 * Use this to create a new post, or reply, or repost. This is done relative 
 * to the logged in user based on httpOnlyAuthentication.
 */
router.post('/new', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({
        content: z.string().trim().min(1).max(200),
        repostId: z.string().uuid().optional(), // for reposts
        parentId: z.string().uuid().optional()  // for replies
    }), request);

    if (!parameters) return response.sendStatus(400);

    const { uuid } = request.authenticated!;
    const { content, repostId, parentId } = parameters;

    try {
        // could look more beautiful
        await connection.query(`
            INSERT INTO post (post_user_id, post_content ${repostId ? ', post_repost_id' : ''}) ${parentId ? ', post_parent_id' : ''}
            VALUES (UUID_TO_BIN(?), ? ${repostId ? ', UUID_TO_BIN(?)' : ''})  ${parentId ? ', UUID_TO_BIN(?)' : ''} `, 
        [ uuid, content, repostId, parentId ]);
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

    await connection.query('DELETE FROM post WHERE BIN_TO_UUID(post_user_id) = ? AND BIN_TO_UUID(post_id) = ?', [ uuid, postId ]);
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
        const [ userResult ] = await connection.query<any[]>(`SELECT BIN_TO_UUID(user_id) AS uuid FROM user WHERE user_name`, [ username ]);
        if ( userResult.length === 0 ) return response.sendStatus(404); // user does not exist
        uuid = userResult[0].uuid;
    }

    const [ result ] = await connection.query<any[]>(`SELECT COUNT(*) as post_count FROM post WHERE post_user_id = ?`, [ uuid ]);
    response.json({
        postCount: result[0].post_count
    });
});

/**
 * Use this to view a single post, the user must be logged in.
 */
router.post('/view', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({
        postId: z.string().uuid()
    }), request);


});

/**
 * Use this to list down multiple posts, the user must be logged in.
 * This only returns the postIds not the data in the post themselves.
 */
router.post('/list', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({
        page: z.number().min(0),
        parentId: z.string().uuid().optional(),
        category: z.enum([ 'following', 'trending' ])
    }), request);


});


export default router;