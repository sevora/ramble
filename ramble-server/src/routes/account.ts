import { Router } from "express";
import { z } from 'zod';
import { sha256 } from "js-sha256";
import jsonwebtoken from 'jsonwebtoken';

import connection from "../mysql";
import httpOnlyAuthentication from "./middlewares/http-only-authentication";

const router = Router();

/**
 * Use this route to log-in through an HTTP-only cookie with a 
 * jsonwebtoken as the value.
 */
router.post('/login', async (request, response) => {
    // the schema required for logging in
    const loginSchema = z.object({
        username: z.string().min(4).max(25),
        password: z.string().min(8),
    });

    const { success } = loginSchema.safeParse(request.body);
    if (!success) return response.sendStatus(400); // information sent is incomplete

    const { username, password } = request.body as z.infer<typeof loginSchema>;
    const [ results ] = await connection.query<any[]>('SELECT BIN_TO_UUID(user_id) AS uuid FROM user WHERE user_name = ? AND user_password = ?', [ username, sha256(password) ]);
    if ( results.length === 0 ) return response.sendStatus(400); // user does not exist or password is incorrect

    const user = results[0];
    const token = jsonwebtoken.sign({ uuid: user.uuid }, process.env.SERVER_JWT_KEY || '', { expiresIn: 60 * 60 * 24 * 30 });
  
    // we set the cookie to expire after 30 days only
    response.cookie('ramble_authentication_token', token, { 
        httpOnly: true,
        sameSite: process.env.COOKIE_SAME_SITE, 
        secure: process.env.COOKIE_SECURE === "true", 
        maxAge: 1000 * 60 * 60 * 24 * 30
    });

    response.sendStatus(200);
});

/**
 * Use this to log-out, essentially removing the cookie with the
 * jsonwebtoken for the client.
 */
router.post('/logout', httpOnlyAuthentication, async(_request, response) => {
    // set the cookie to null and maxAge to -1 to clear it from the receiving client
    response.cookie('ramble_authentication_token', null, { 
        httpOnly: true, 
        sameSite: process.env.COOKIE_SAME_SITE, 
        secure: process.env.COOKIE_SECURE === "true", 
        maxAge: -1
    });

    response.sendStatus(200);
});

/**
 * Use this to sign-up for a new account. The username must be unique
 * otherwise this will fail.
 */
router.post('/signup', async(request, response) => {
     // the schema required for signing-up
     const signupSchema = z.object({
        username: z.string().min(4).max(25),
        password: z.string().min(8),
    });

    const { success } = signupSchema.safeParse(request.body);
    if (!success) return response.sendStatus(400);  // information sent is incomplete

    const { username, password } = request.body as z.infer<typeof signupSchema>;

    // doing this prevents failed inserts which still triggers auto increments
    const [ result ] = await connection.query<any[]>('SELECT user_name FROM user WHERE user_name = ?', [ username ]);
    if (result.length > 0) return response.sendStatus(400); // username is already taken

    try {
        await connection.query(
            'INSERT INTO user (user_common_name, user_name, user_password) VALUES (?, ?, ?)', 
            [ username, username, sha256(password) ]
        )
        return response.sendStatus(200);
    } catch {
       return response.sendStatus(500); // must be some server error
    }
});

/**
 * Use this to view the profile of a user, requires being logged-in.
 */
router.post('/view/:username', httpOnlyAuthentication, async(request, response) => {
    const [ results ] = await connection.query<any[]>('SELECT user_name, user_common_name, user_biography, user_created_at FROM user WHERE user_name = ?', [ request.params.username ]);
    if ( results.length === 0 ) return response.sendStatus(404); // user does not exist

    const user = results[0];
    response.json({
        userCommonName: user.user_common_name,
        username: user.user_name,
        userBiography: user.user_biography,
        userCreatedAt: user.user_created_at
    });
});


/**
 * Use this to view your profile, requires being logged-in.
 */
router.post('/view', httpOnlyAuthentication, async(request, response) => {
    const [ results ] = await connection.query<any[]>('SELECT user_name, user_common_name, user_biography, user_created_at FROM user WHERE BIN_TO_UUID(user_id) = ?', [ request.authenticated?.uuid ]);
    if ( results.length === 0 ) return response.sendStatus(404); // user does not exist

    const user = results[0];
    response.json({
        userCommonName: user.user_common_name,
        username: user.user_name,
        userBiography: user.user_biography,
        userCreatedAt: user.user_created_at
    });
});

/**
 * Use this to update profile details. Since this is httpOnlyAuthentication, the 
 * username is actually taken from the cookie and not from the original body of the request.
 */
router.post('/update', httpOnlyAuthentication, async(request, response) => {    
    // the schema for updating an account
    const accountSchema = z.object({
        username: z.string().min(4).max(25), // by design username is permanent
        userCommonName: z.string().min(4).max(50).optional(),
        password: z.string().min(8).optional(),
        biography: z.string().max(200).optional()
    });

    const { success } = accountSchema.safeParse(request.body);
    if (!success) return response.sendStatus(400);  // information sent is incomplete

    const { uuid } = request.authenticated!;
    const { username, userCommonName, biography, password } = request.body as z.infer<typeof accountSchema>;

    try {
        // there must be a better way to this.
        if (username) await connection.query('UPDATE user SET user_name = ? WHERE BIN_TO_UUID(user_id) = ?', [ username, uuid ]);
        if (userCommonName) await connection.query('UPDATE user SET user_common_name = ? WHERE BIN_TO_UUID(user_id) = ?', [ userCommonName, uuid ]);
        if (biography) await connection.query('UPDATE user SET user_biography = ? WHERE BIN_TO_UUID(user_id) = ?', [ biography, uuid ]);
        if (password) await connection.query('UPDATE user SET user_password = ? WHERE BIN_TO_UUID(user_id) = ?', [ sha256(password), uuid ]);
        return response.sendStatus(200);
    } catch {
        return response.sendStatus(500); // only a server error would've reached here
    }
});

/**
 * Use this to delete an existing account. It requires the password to be correct. 
 * Since we used httpOnlyAuthentication here, tthe username field will be set automatically.
 */
router.post('/delete', httpOnlyAuthentication, async(request, response) => {
    const deleteSchema = z.object({
        password: z.string().min(8)
    });

    const { success } = deleteSchema.safeParse(request.body);
    if (!success) return response.sendStatus(400);  // information sent is incomplete

    const { uuid } = request.authenticated!;
    const { password } = request.body as z.infer<typeof deleteSchema>;

    try {
        await connection.query('DELETE FROM user WHERE BIN_TO_UUID(user_id) = ? AND user_password = ?', [ uuid, sha256(password) ]);
        return response.sendStatus(200);
    } catch {
        return response.sendStatus(400);
    }
});

export default router;