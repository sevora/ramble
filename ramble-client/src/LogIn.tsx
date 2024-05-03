import { FormEventHandler, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

import useAccount from './hooks/account';

/**
 * This is the log-in component which allows us to login 
 * through an existing account.
 */
function LogIn() {
    const navigate = useNavigate();
    const { setUsername: setGlobalUserName, setIsLoggedIn } = useAccount();

    const [ username, setUsername ] = useState<string>('');
    const [ password, setPassword ] = useState<string>('');
    const [ error, setError ] = useState<string>('');

    
    const gotoSignUp = () => navigate('/welcome/signup');

    /**
     * The username can have no spaces and is lowercased,
     * only underscore is the special character allowed.
     */
    const onInputUsername: FormEventHandler<HTMLInputElement> = (event) => {
        const value = (event.target as HTMLInputElement).value.trim().toLowerCase();
        setUsername(value);
    }

    /**
     * The password has no spaces as well, it is unusual
     * to have passwords that have spaces in between.
     */
    const onInputPassword: FormEventHandler<HTMLInputElement> = (event) => {
        const value = (event.target as HTMLInputElement).value.trim();
        setPassword(value);
    }

    /**
     * This is for the login button, it attempts a login, which sets up the httpOnly cookie 
     * that can't be accessed directly here. Then we do another request for viewing our information,
     * should that succeed, it means we are logged in, as that endpoint requires the httpOnly cookie.
     */
    const login = async () => {
        try {
            // we do a log-in and retrieval of information through another route
            await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/login`, { username, password }, { withCredentials: true });
            const account = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/view`, {}, { withCredentials: true });
            const data = account.data as { username: string, userCommonName: string };
            
            // when we successfully get the data, we are then logged-in
            setGlobalUserName(data.username);
            setIsLoggedIn(true);
        } catch {
            setError('Username or password is incorrect!');
        }
    }

    return (
        <form>
            <div className="mb-4">
                <label className="block text-sm mb-2" htmlFor="username">Username</label>
                <input value={username} onInput={onInputUsername} className="shadow border rounded-md w-full py-2 px-3" type="text" autoComplete="username" placeholder="Username" />
            </div>
            <div className="mb-4">
                <label className="block text-sm mb-2" htmlFor="password">Password</label>
                <input value={password} onInput={onInputPassword} onKeyDown={event => event.key === 'Enter' && login()} className="shadow border rounded w-full py-2 px-3 mb-3" type="password" autoComplete="current-password" placeholder="Password" />
                <p className="text-red-500 text-xs italic">{error}</p>
            </div>
            <div className="flex items-center justify-between">
                <a onClick={gotoSignUp} className="inline-block align-baseline text-sm text-slate-600 hover:text-slate-950 cursor-pointer underline">Create an account?</a>
                <button onClick={login} className="bg-slate-800 hover:bg-slate-950 text-white py-2 px-10 rounded-full" type="button">
                    Log In
                </button>
            </div>
        </form>
    )
};

export default LogIn;