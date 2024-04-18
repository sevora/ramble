/// <reference types="vite/client" />
interface ImportMetaEnv {
    /**
     * This is the URL of the backend. Please define this properly
     * through the environment variables.
     */
    readonly VITE_BACKEND_URL: string;
}

interface ImportMeta {
    readonly env: ImportMetaEnv;
}