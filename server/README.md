# Ramble Server
This is an overview of the ramble server. This is important for the clients to work as they need to communicate with this server.

## Stack
- [Express](https://expressjs.com) - lightweight unopinionated http server.
- [TypeScript](https://www.typescriptlang.org) - better code tooling, analysis without having to run code.
- [MySQL](https://www.mysql.com) - a database management system.
- [Zod](https://zod.dev) - object validation.
- [node-mysql2](https://github.com/sidorares/node-mysql2) - fast MySQL driver for Node.js
- [jsonwebtoken](https://github.com/auth0/node-jsonwebtoken) - for our authentication purposes.

## MySQL Configuration
It is required that the timezone for the MySQL server be set to UTC for the dates to be in proper format. Use [`ddl.sql`](/ramble-server/ddl.sql) to generate the tables for the database.

## Environment Variables
A `.env` file must be provided with the following information:
```env
# These are used to establish a connection with the MySQL DBMS. Values are merely examples, please change accordingly.
MYSQL_HOST="localhost"
MYSQL_USER="root"
MYSQL_PASSWORD="password123!"
MYSQL_DATABASE="ramble"

# These are server-specific values. Please set properly.
SERVER_JWT_KEY="hardtoguess"
SERVER_PORT=8000 # by default, will use 80 if not defined.

# This is the URL of the frontend (ramble-client).
# The exact URL is necessary, otherwise the CORS policy will prevent communication between server and client.
CLIENT_URL="http://localhost:5173"

# IMPORTANT: sameSite means they're basically on the same domain, when secure is false, sameSite has to be 'lax' or 'strict' 
# for it to work on certain browsers (option 'none' is only okay over https) 
# IMPORTANT: when secure is true, the cookie will only work on https
# IMPORTANT: during development, they're both on localhost so sameSite is 'lax' and since it is over http secure should be 'false'
COOKIE_SAME_SITE="lax"
COOKIE_SECURE="false"
```
**NOTE**: Do not forget to create this file, otherwise issues will persist when starting the server.

## Installation
Do `npm install`. As of development, v20.12.2 is the version of Node.js being used. On `ramble-server` do `npm run build` to transpile the files from src into build that `npm start` or `npm run dev` will use.

## Commands
These are the available commands for this module.
- `npm run build` - transpile the source code from `/src` to `/build`.
- `npm start` - run the code inside `/build`, remember to run the build command first to generate this directory.
- `npm run dev` - concurrently compile and run the build under nodemon.

## Coding Practice and Convention
The casing of the MySQL tables and columns are in snake case. However, in TypeScript (or JavaScript), camelCase is the norm. So as a result, in queries and resulting objects of the queries we use snake case however when passing it along as a result of the API, we use camelCase. To provide a clear example,
```ts
const [ results ] = await connection.query<any[]>('SELECT user_name, user_common_name, user_password FROM user WHERE user_name = ?', [ username ]);
const user = results[0];

response.json({
    userCommonName: user.user_common_name,
    username: user.user_name
});
```
This is the convention we are following for better clarity.