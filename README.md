# Ramble
## Description
Ramble is a lightweight Twitter Clone that has the core features while being structured in a more manageable and extendable style. 

## Stack
### Frontend
- [React](https://react.dev) - library to build user-interface.
- [TypeScript](https://www.typescriptlang.org) - better code tooling, analysis without having to run code.
- [TailwindCSS](https://tailwindcss.com) - utility-first CSS framework.
- [Zustand](https://github.com/pmndrs/zustand) - lightweight state management for React.
- [react-mentions](https://github.com/signavio/react-mentions) - simplifies mentions in UIs.
- [react-infinite-scroll-component](https://github.com/ankeetmaini/react-infinite-scroll-component) - simplifies infinite-scroll implementation.

### Backend
- [Express](https://expressjs.com) - lightweight unopinionated http server.
- [TypeScript](https://www.typescriptlang.org) - better code tooling, analysis without having to run code.
- [MySQL](https://www.mysql.com) - a database management system.
- [Zod](https://zod.dev) - object validation.
- [jsonwebtoken](https://github.com/auth0/node-jsonwebtoken) - for our authentication purposes.
- [cookies](https://github.com/jshttp/cookie) - library to easily serialize http-only cookies.

## Overview
Ramble allows the creation of user accounts, posting of "rambles", commenting, liking, and of course interactive views such as a home page, trending page, and a profile page. As this is a small project, user account creation is infinite and does not require any third-party identity verification. For production purposes, that must be revised. However, for development and as a university project, it focuses on providing a super efficient and smooth user experience whilst integrating these powerful web and database technologies.

## Environment Variables
### ramble-client
This file can be named `.env` or `.env.development.local` or `.env.production.local` and will adjust transpilation or bundling accordingly to whether it is on development or production matching the file names.
```env
# This is URL of the backend (ramble-server).
VITE_BACKEND_URL="http://localhost:8000"
```
**NOTE**: Do not forget to create this file, otherwise issues will persist when using the client.

### ramble-server
A `.env` file must be provided inside the `ramble-server` with the following information:
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
CLIENT_URL="localhost:3000"

# IMPORTANT: sameSite means they're basically on the same domain, when secure is false, sameSite has to be 'lax' or 'strict' 
# for it to work on certain browsers (option 'none' is only okay over https) 
# IMPORTANT: when secure is true, the cookie will only work on https
# IMPORTANT: during development, they're both on localhost so sameSite is 'lax' and since it is over http secure should be 'false'
COOKIE_SAME_SITE="lax"
COOKIE_SECURE="false"
```
**NOTE**: Do not forget to create this file, otherwise issues will persist when starting the server.

## Installation
Do `npm install` inside both `ramble-client` and `ramble-server` directories. As of development, v20.12.2 is the version of Node.js being used.

## Commands
### ramble-server
The directories mentioned here are relative to `/ramble-server`.
- `npm run build` - transpile the source code from `/src` to `/build`.
- `npm start` - run the code inside `/build`, remember to run the build command first to generate this directory.
- `npm run dev` - concurrently compile and run the build under nodemon.

## MySQL Configuration
It is required that the timezone for the MySQL server be set to UTC for the dates to be in proper format. Use [`ddl.sql`](/ddl.sql) to generate the database.

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