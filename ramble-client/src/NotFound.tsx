import { FC } from 'react';

/**
 * This component should appear whenever the client tries to 
 * visit a page that does not exist.
 */
const NotFound: FC = () => {
    return (
        <div className="w-screen h-screen flex flex-col justify-center items-center text-center">
            <h1 className="mb-4 text-6xl font-semibold text-slate-800">404</h1>
            <p className="mb-4 text-lg text-gray-600">Oops! Looks like you're lost.</p>
            <div className="animate-bounce">
                <svg className="mx-auto h-16 w-16 text-slate-800" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8"></path>
                </svg>
            </div>
        </div>
    );
}

export default NotFound;