declare namespace Express {
    interface Request {
        /**
         * An additional property that is only set when the user is authenticated,
         * based on `ramble-server` specific processes.
         */
        authenticated?: {
            /**
             * This is a unique identifier for the user, can be used to compare
             * with `ramble.user.user_id` converted to UUID using `BIN_TO_UUID(...)`
             */
            uuid: string
        }
    }
} 