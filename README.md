# Ramble
## Overview
Ramble is a social media applicaion structured in a manageable, and extendable style. I made this primarily for a university project in our Computer Science Course and the goal is to be able to write a CRUD-application utilizing a SQL database management system. As this is a small project, user account creation is infinite and does not require any third-party identity verification. For production purposes, that must be revised. However, under a local development environment and as a university project, it focuses on providing a clean, functional, and efficient implementation integrating these powerful web and database technologies. The updates around October 2024 aim to add more functionalities such as media upload and a mobile client written with Dart and Flutter.

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

### Organization
This project is organizeed into multiple directories depending on what the module's part is. We have multiple clients from web to mobile applications. Therefore to figure out how this entire project works, you have to individually read through each of their own provided `README.md` files.