# Ramble
## Overview
Ramble is a lightweight Twitter Clone structured in a simple, manageable, and extendable style. I made this primarily for a university project in our Computer Science Course and the goal is to be able to write a CRUD-application utilizing a SQL database management system. As this is a small project, user account creation is infinite and does not require any third-party identity verification. For production purposes, that must be revised. However, under a local development environment and as a university project, it focuses on providing a clean, functional, and efficient implementation integrating these powerful web and database technologies.

## Scope and Limitations
### Features
This project is essentially a Twitter clone, with the core functionality implemented. That is to say, in this project, you can:
- Create an account
- Update the account's display name and biography
- Delete the account
- View accounts, your currently logged in account, or other accounts
- Follow or unfollow accounts
- View the follower or following list of your account or other accounts
- To post a *ramble*, to *ramble*, *rambling*, if this was Twitter, it would be *tweet*
- View your timeline with the posts from accounts you follow, or view the posts globally
- View and reply on a post
- View the posts of an account from their profile including their replies to other posts
- Delete your posts or replies
- Search for an account or post by using keywords

The frontend also was written to implement an infinite scroll feature. Essentially, as long as there are posts or accounts that can be shown you can simply scroll down and they will be loaded as needed to populate the page you're viewing. This applies to all of the pages which can potentially contain a lot of data such as viewing your timeline, searching for accounts or posts, checking the follower or following list of an account, or viewing the posts of an account from their profile page.

### Limitations
Of course, there are limitations due to the time constraint in developing this project in around 4 days or so. Here are some of the limitations:
- The deletion of a post will cause all replies connected, *even if they're from other users*, be deleted as well, this is the simplest implementation of deleting a post, but in a real social media platform, that is undesirable.
- Consequently, the deletion of an account will delete all their posts and will also have the same behaviour as the previous point.
- Post statistics are not sent in real-time, or even periodic time, and availability of new posts on the timeline are not notified to users.
- There are no loaders or skeletons to visually indicate or aid that data is being retrieved at the moment as the local development environment guarantees a near instantaneous response.
- There is no repost feature.
- You can mention another user in your posts but it won't be generated into a link that points to their account.
- There are no media servers and features: so there are no profile images, profile banners, uploading of videos and images.
- There are no privacy features: such as limit the users who can view one's account, block other accounts, or limit replies in a post.
- There are no notification features: so you won't be notified if someone follows you or replies to your post.
- There is no messaging system: that is a whole other project on its own.

## Stack
### Frontend
- [React](https://react.dev) - library to build user-interface.
- [TypeScript](https://www.typescriptlang.org) - better code tooling, analysis without having to run code.
- [TailwindCSS](https://tailwindcss.com) - utility-first CSS framework.
- [Zustand](https://github.com/pmndrs/zustand) - lightweight state management for React.
- [React Router](https://reactrouter.com/en/main) - for managing client-side routes and components.
- [react-icons](https://react-icons.github.io/react-icons/) - icons for React all in one place.
- [react-intersection-observer] - a React implementation of the Intersection Observer API, mainly used for infinite scroll.

### Backend
- [Express](https://expressjs.com) - lightweight unopinionated http server.
- [TypeScript](https://www.typescriptlang.org) - better code tooling, analysis without having to run code.
- [MySQL](https://www.mysql.com) - a database management system.
- [Zod](https://zod.dev) - object validation.
- [node-mysql2](https://github.com/sidorares/node-mysql2) - fast MySQL driver for Node.js
- [jsonwebtoken](https://github.com/auth0/node-jsonwebtoken) - for our authentication purposes.

## MySQL Configuration
It is required that the timezone for the MySQL server be set to UTC for the dates to be in proper format. Use [`ddl.sql`](/ddl.sql) to generate the tables for the database.

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

For the frontend, it is written to be in the simplest form with the least custom dependencies, meaning you could easily modify each page on its own without having to learn about all the other components. However, it is still possible to refactor the code better as there are a lot of common implementations across the pages or views. An example would be the implementation of infinite scroll which is essentially the same across all the components.