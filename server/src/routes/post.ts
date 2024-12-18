import { Router } from "express";
import { z } from 'zod';
import { v4 as uuidv4 } from 'uuid';
import { extname } from "path";

import s3 from '../s3-client.js';
import connection from "../mysql.js";
import zodVerify from "./middlewares/zod-verify.js";
import httpOnlyAuthentication from "./middlewares/http-only-authentication.js";

import multer from 'multer';
import multerS3 from 'multer-s3';
import cryptoRandomString from 'crypto-random-string';

const router = Router();
const rowsPerPage = 10;

/**
 * This is the storage engine for multer, which will allow us
 * to store the files into an Amazon S3 Bucket
 */
const s3Storage = multerS3({
    s3,
    cacheControl: 'max-age=2592000', // (60 * 60 * 24 * 30) or 30 days refers to the no. of seconds it should be cached
    bucket: process.env.AMAZON_S3_BUCKET,
    contentType: multerS3.AUTO_CONTENT_TYPE,

    // This is the key generator. We want the key to be unique so we decrease the chance of 
    // collision as much as possible
    key: (_request, _file, callback) => { 
        const randomName = cryptoRandomString({ length: 32, type: 'url-safe' });
        const uuid = uuidv4();
        const autogeneratedName = `${randomName}-${uuid}`;
        callback(null, autogeneratedName);
    }
});

/**
 * Use this as a middleware to enable image uploads,
 * it uses the 'images' field for the data.
 */
const imageUpload = multer({
    limits: { fileSize: 1000 * 1000 * 30 }, // 30 megabyte limit per file
    storage: s3Storage,
    fileFilter(_request, file, callback) {
        const extension = extname(file.originalname).toLowerCase();
        if (['.jpg', '.jpeg', '.png'].includes(extension)) {
            callback(null, true);
        } else {
            callback(new Error("Invalid Mimetype"));
        }
    },
}).single('image');

/**
 * Use this to create a new post, or reply, or repost. This is done relative 
 * to the logged in user based on httpOnlyAuthentication.
 */
router.post('/new', httpOnlyAuthentication, async (request, response) => {
    imageUpload(request, response, async (error) => {
        const parameters = zodVerify(z.object({
            content: z.string().trim().max(200),
            parentId: z.string().regex(/[0-9a-fA-F]+/).length(32).optional()  // for replies
        }), request);
    
        if (!parameters || error) return response.sendStatus(400);
        
        const { uuid } = request.authenticated!;
        const { content, parentId } = parameters;

        const file = request.file as Express.MulterS3.File;
        const location = file ? file.location : undefined;

        if (content.length <= 0 && !file) return response.sendStatus(400);

        try {
            await connection.query(`
                INSERT INTO \`post\` (post_user_id, post_content, post_media, post_parent_id)
                VALUES (UNHEX(?), ?, ?, UNHEX(?))
            `, [ uuid, content, location, parentId ])
            return response.sendStatus(200);
        } catch (error) {
            return response.sendStatus(500);
        }
    });
});


/**
 * Use this to delete a post, the post must have been made by the user
 * logged in verified by httpOnlyAuthentication.
 */
router.post('/delete', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({
        postId: z.string().regex(/[0-9a-fA-F]+/).length(32)
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { postId } = parameters;

    await connection.query('DELETE FROM post WHERE post_user_id = UNHEX(?) AND post_id = UNHEX(?)', [uuid, postId]);
    response.sendStatus(200);
});

/**
 * Use this to like a post, the user must be logged in.
 */
router.post('/like', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({
        postId: z.string().regex(/[0-9a-fA-F]+/).length(32)
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { postId } = parameters;

    try {
        await connection.query('INSERT INTO `like` (like_user_id, like_post_id) VALUES (UNHEX(?), UNHEX(?))', [uuid, postId]);
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
        postId: z.string().regex(/[0-9a-fA-F]+/).length(32)
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { postId } = parameters;

    await connection.query('DELETE FROM `like` WHERE like_user_id = UNHEX(?) AND like_post_id = UNHEX(?)', [uuid, postId]);
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
        const [userResult] = await connection.query<any[]>('SELECT HEX(user_id) AS `uuid` FROM user WHERE user_name = ?', [username]);
        if (userResult.length === 0) return response.sendStatus(404); // user does not exist
        uuid = userResult[0].uuid;
    }

    const [result] = await connection.query<any[]>(`SELECT COUNT(*) as post_count FROM post WHERE post_user_id = UNHEX(?)`, [uuid]);
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
        postId: z.string().regex(/[0-9a-fA-F]+/).length(32)
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { postId } = parameters;

    // this is a single large query to view a post
    const [result] = await connection.query<any[]>(`
        SELECT 
            -- these are the post properties
            HEX(post_id) as post_uuid,
            HEX(post_parent_id) as post_parent_uuid,
            post_content,
            post_media,
            post_created_at,
            
            -- these are the user properties
            HEX(user_id) as user_uuid,
            user_name,
            user_common_name,
            user_profile_picture,

            -- these are properties that are counted in the other tables
            (SELECT COUNT(*) FROM \`like\` WHERE like_post_id = post_id) AS like_count,
            (SELECT COUNT(*) FROM post WHERE post_parent_id = source_post.post_id) AS comment_count,
            (SELECT COUNT(*) FROM \`like\` WHERE like_user_id = UNHEX(?) AND like_post_id = post_id) > 0 AS hasLiked
        -- we give it an alias to be able to reference it inside inner queries
        FROM 
            post source_post
        -- some properties are needed from the user table
        LEFT JOIN 
            \`user\` u ON user_id = post_user_id
        -- we find the post with the same postId
        WHERE 
            post_id = UNHEX(?)`, [ uuid, postId ]);

    if (result.length === 0) return response.sendStatus(404);
    const post = result[0];

    response.json({
        postId: post.post_uuid,
        postParentId: post.post_parent_uuid,
        postContent: post.post_content,
        postMedia: post.post_media,
        postCreatedAt: post.post_created_at,
        userCommonName: post.user_common_name,
        username: post.user_name,
        userProfilePicture: post.user_profile_picture,
        likeCount: post.like_count,
        replyCount: post.comment_count,
        hasLiked: post.hasLiked > 0
    });
});

/**
 * Use this to list down multiple posts, the user must be logged in.
 * This only returns the postIds not the data in the post themselves.
 * The API works as follows:
 * - Setting category to trending means global posts, grouped by day, sorted by likes
 * - Setting category to following means sorted by time of posting and limited to followed accounts
 * - If username is provided, only posts of a specific user, sorted by time of posting is sent.
 * - If parentId is supplied, only the child posts will be sent back (the comments).
 * Only one of this will be followed at any time.
 */
router.post('/list', httpOnlyAuthentication, async (request, response) => {
    const parameters = zodVerify(z.object({
        page: z.number().min(0),
        username: z.string().min(4).max(25).optional(),
        parentId: z.string().regex(/[0-9a-fA-F]+/).length(32).optional(),
        category: z.enum(['trending', 'following', 'likes']).optional()
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { username, page, parentId, category } = parameters;

    const pagination = [page * rowsPerPage, rowsPerPage];
    let results: any[] = [];

    // query intended to get the replies to a post
    if (parentId)
        [results] = await connection.query<any[]>('SELECT HEX(post_id) AS `uuid` FROM post WHERE post_parent_id = UNHEX(?) ORDER BY post_created_at DESC, HEX(post_id) LIMIT ?, ?', [parentId, ...pagination]);

    // query to get the posts of a user
    else if (username)
        [results] = await connection.query<any[]>('SELECT HEX(post_id) AS `uuid` FROM post JOIN user ON post_user_id = user_id WHERE user_name = ? ORDER BY post_created_at DESC, HEX(post_id) LIMIT ?, ?', [username, ...pagination]);

    // this query was intended to be for trending posts, but because of issues when paginating and duplicates, we do global instead
    else if (category === 'trending')
        [results] = await connection.query<any[]>('SELECT HEX(post_id) AS `uuid` FROM post ORDER BY post_created_at DESC, HEX(post_id) DESC LIMIT ?, ?', pagination);

    // query to get the posts but only when following the user
    else if (category === 'following')
        [results] = await connection.query<any[]>('(SELECT HEX(post_id) AS `uuid`, post_id, post_created_at FROM post JOIN follower ON (post_user_id = follows_id AND follower_id = UNHEX(?))) UNION (SELECT HEX(p.post_id) AS `uuid`, p.post_id, p.post_created_at FROM post p WHERE p.post_user_id = UNHEX(?)) ORDER BY post_created_at DESC, HEX(post_id) LIMIT ?, ?', [uuid, uuid, ...pagination]);
    
    else if (category === 'likes')
        [results] = await connection.query<any[]>('(SELECT HEX(post_id) AS `uuid`, post_id, post_created_at FROM post JOIN `like` ON (post_id = like_post_id AND like_user_id = UNHEX(?))) ORDER BY post_created_at DESC, HEX(post_id) LIMIT ?, ?', [uuid, ...pagination]);

    // postIds are only sent back, not all the details
    response.json({
        posts: results.map(entry => entry.uuid)
    });
});


export default router;