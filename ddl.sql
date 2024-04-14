-- ramble.`user` definition

CREATE TABLE `user` (
  `user_id` binary(16) NOT NULL DEFAULT (uuid_to_bin(uuid())),
  `user_common_name` varchar(50) NOT NULL,
  `user_name` varchar(25) NOT NULL,
  `user_password` text NOT NULL,
  `user_biography` text,
  `user_created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uc_user` (`user_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- ramble.follower definition

CREATE TABLE `follower` (
  `follower_id` binary(16) NOT NULL,
  `follows_id` binary(16) NOT NULL,
  `follow_created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`follower_id`,`follows_id`),
  KEY `fk_user_follows` (`follows_id`),
  CONSTRAINT `fk_user_follower` FOREIGN KEY (`follower_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_follows` FOREIGN KEY (`follows_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- ramble.post definition

CREATE TABLE `post` (
  `post_id` binary(16) NOT NULL DEFAULT (uuid_to_bin(uuid())),
  `post_user_id` binary(16) NOT NULL,
  `post_content` text,
  `post_parent_id` binary(16) DEFAULT NULL,
  `post_repost_id` binary(16) DEFAULT NULL,
  `post_created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`post_id`),
  KEY `fk_user_post` (`post_user_id`),
  KEY `fk_post_post` (`post_parent_id`),
  KEY `fk_post_repost` (`post_repost_id`),
  CONSTRAINT `fk_post_post` FOREIGN KEY (`post_parent_id`) REFERENCES `post` (`post_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_post_repost` FOREIGN KEY (`post_repost_id`) REFERENCES `post` (`post_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_post` FOREIGN KEY (`post_user_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- ramble.`like` definition

CREATE TABLE `like` (
  `like_user_id` binary(16) NOT NULL,
  `like_post_id` binary(16) NOT NULL,
  `like_created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`like_by_id`,`like_post_id`),
  KEY `fk_post_like` (`like_post_id`),
  CONSTRAINT `fk_post_like` FOREIGN KEY (`like_post_id`) REFERENCES `post` (`post_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_user_like` FOREIGN KEY (`like_by_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;