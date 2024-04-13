import { Request, Response, NextFunction } from 'express';
import jsonwebtoken from 'jsonwebtoken';

/**
 * The presence of this middleware in a route signifies that the user must be logged in for that 
 * route to work, otherwise a status code 400 is sent. The `request.body.username` is also modified by this middleware.
 */
export default async function httpOnlyAuthentication(request: Request, response: Response, next: NextFunction) {
    const token = request.cookies.ramble_authentication_token;
    if (!token) return response.sendStatus(400);

    try {
        // we set the username in the body with the value found inside the jsonwebtoken
        const { uuid } = jsonwebtoken.verify(token, process.env.SERVER_JWT_KEY || '') as { uuid: string };
        request.authenticated = { uuid };
        return next();
    } catch {
        return response.sendStatus(401);
    }
}