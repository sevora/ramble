import { Router } from "express";
import { z } from 'zod';
import { sha256 } from "js-sha256";
import jsonwebtoken from 'jsonwebtoken';

import connection from "../mysql";
import zodVerify from "./middlewares/zod-verify";
import httpOnlyAuthentication from "./middlewares/http-only-authentication";

const router = Router();

/**
 * Use this route to log-in through an HTTP-only cookie with a 
 * jsonwebtoken as the value.
 */
router.post('/login', async (request, response) => {
    const parameters = zodVerify(z.object({
        username: z.string().trim().min(4).max(25),
        password: z.string().trim().min(8)
    }), request);

    if (!parameters) return response.sendStatus(400); // information sent is incomplete

    const { username, password } = parameters;
    const [ results ] = await connection.query<any[]>('SELECT HEX(user_id) AS `uuid`, user_common_name, user_name FROM `user` WHERE (user_name = ? OR user_email = ?) AND user_password = ?', [ username, username, sha256(password) ]);
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

    // we only send a 200 to signify success in logging-in
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

    // signifies success on logging-out
    response.sendStatus(200);
});

/**
 * Use this to sign-up for a new account. The username must be unique
 * otherwise this will fail.
 */
router.post('/signup', async(request, response) => {
    const parameters = zodVerify(z.object({
        username: z.string().trim().min(4).max(25).regex(/[a-z0-9_]+/),
        email: z.string().email(),
        password: z.string().trim().min(8),
    }), request);
    
    if (!parameters) return response.sendStatus(400);  // information sent is incomplete
    const { username, email, password } = parameters;

    try {
        await connection.query(
            'INSERT INTO `user` (user_common_name, user_name, user_email, user_password) VALUES (?, ?, ?)', 
            [ username, username, email, sha256(password) ]
        );
        return response.sendStatus(200); // the signup is a success
    } catch {
       return response.sendStatus(400); // username is already taken
    }
});


/**
 * Use this to view your profile or the profile of another user, requires being logged-in.
 * If username is provided in the request body use that, otherwise use the client's user_id.
 */
router.post('/view', httpOnlyAuthentication, async(request, response) => {
    const parameters = zodVerify(z.object({ 
        username: z.string().min(4).max(25).optional()
    }), request);

    if (!parameters) return response.sendStatus(400);
    const { uuid } = request.authenticated!;
    const { username } = parameters;

    const [ userResult ] = username !== undefined ?
        await connection.query<any[]>(`SELECT user_id, user_name, user_common_name, user_biography, user_created_at FROM \`user\` WHERE user_name = ?`, [ username ]):
        await connection.query<any[]>(`SELECT user_id, user_name, user_common_name, user_biography, user_created_at FROM \`user\` WHERE user_id = UNHEX(?)`, [ uuid ]); 
    
    if ( userResult.length === 0 ) return response.sendStatus(404); // user does not exist
    const user = userResult[0];

    // in this one, we actually want to send the details
    response.json({
        userCommonName: user.user_common_name,
        username:       user.user_name,
        userBiography:  user.user_biography,
        userCreatedAt:  user.user_created_at
    });
});

/**
 * Use this to update profile details. Since this is httpOnlyAuthentication, the 
 * username is actually taken from the cookie and not from the original body of the request.
 */
router.post('/update', httpOnlyAuthentication, async(request, response) => {    
    const parameters = zodVerify(
        // the schema for updating an account
        z.object({
            userCommonName: z.string().trim().min(4).max(50).optional(),
            biography: z.string().trim().max(200).optional()
        }), 
    request);

    if (!parameters) return response.sendStatus(400);  // information sent is incomplete
    const { uuid } = request.authenticated!;
    const { userCommonName, biography } = parameters;

    // there must be a better way to this
    if (userCommonName) await connection.query('UPDATE `user` SET user_common_name = ? WHERE user_id = UNHEX(?)', [ userCommonName, uuid ]);
    if (biography !== undefined) await connection.query('UPDATE `user` SET user_biography = ? WHERE user_id = UNHEX(?)', [ biography, uuid ]);
    return response.sendStatus(200); // only send a 200 to signify success of operation
});

/**
 * Use this to delete an existing account. It requires the password to be correct. 
 * Since we used httpOnlyAuthentication here, tthe username field will be set automatically.
 */
router.post('/delete', httpOnlyAuthentication, async(request, response) => {
    const parameters = zodVerify(z.object({
        password: z.string().trim().min(8)
    }), request);

    if (!parameters) return response.sendStatus(400);  // information sent is incomplete

    const { uuid } = request.authenticated!;
    const { password } = parameters;

    const [ findUser ] = await connection.query<any[]>('SELECT * FROM `user` WHERE user_id = UNHEX(?) AND user_password = ?', [ uuid, sha256(password) ]);
    if (findUser.length === 0) return response.sendStatus(405);

    await connection.query('DELETE FROM `user` WHERE user_id = UNHEX(?) AND user_password = ?', [ uuid, sha256(password) ]);
    return response.sendStatus(200); // only send to signify success of operation
});

export default router;