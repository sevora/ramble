declare global {
    namespace NodeJS {
        interface ProcessEnv {
            readonly MYSQL_HOST?: string;
            readonly MYSQL_USER?: string;
            readonly MYSQL_PASSWORD?: string;
            readonly MYSQL_DATABASE?: string;
            
            readonly SERVER_PORT?: number;
            readonly SERVER_JWT_KEY?: string;

            readonly CLIENT_URL?: string;
            
            readonly COOKIE_SAME_SITE?: "lax" | "strict" | "none";
            readonly COOKIE_SECURE?: "true" | "false";
        }
    }
}

export {};