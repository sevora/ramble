import { useState, ChangeEvent } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

import useAccount from './hooks/account';
import ValidatedField from './ValidatedField';

/**
 * This is the sign-up component. Use this to interact
 * with the API to create a new account.
 */
function SignUp() {
    const navigate = useNavigate();
    const { setUsername: setGlobalUserName, setIsLoggedIn } = useAccount();
    const [ signUpError, setSignUpError ] = useState<string>(''); // this is the error message for when sign-up fails

    const [ username, setUsername ] = useState<string>('');
    const [ usernameValid, setUsernameValid ] = useState(false);

    const [ password, setPassword ] = useState<string>('');
    const [ passwordValid, setPasswordValid ] = useState(false);

    const [ verifyPassword, setVerifyPassword ] = useState<string>('');    
    const verifyPasswordValid = password === verifyPassword;

    function gotoLogIn() {
        navigate('/welcome');
    }

    function onChangeUsername(event: ChangeEvent<HTMLInputElement>) {
        const value = event.target.value.trim();
        setUsername(value);

        setUsernameValid(
            value.length >= 4 &&
            value.length <= 25 &&
            /^[a-z0-9_]+$/.test(value)
        );

        setSignUpError('');
    }

    function onChangePassword(event: ChangeEvent<HTMLInputElement>) {
        const value = event.target.value.trim();
        setPassword(value);
        setPasswordValid(value.length >= 8);
    }

    function onChangeVerifyPassword(event: ChangeEvent<HTMLInputElement>) {
        const value = event.target.value.trim();
        setVerifyPassword(value);
    }

    const signup = async () => {
        // this sign-up process will also log-us in
        try {
            await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/signup`, { username, password }, { withCredentials: true });
            await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/login`, { username, password }, { withCredentials: true });
            const account = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/view`, {}, { withCredentials: true });
            const data = account.data as { username: string, userCommonName: string };
            
            // when we successfully get the data, we are then logged-in
            setGlobalUserName(data.username);
            setIsLoggedIn(true);
        } catch {
            setSignUpError('Username is already taken!')
        }
    }

    return (
        <form onSubmit={event => event.preventDefault()}>
            <div className="mb-2">
                <label className="block text-sm mb-2">Create your username</label>
                <ValidatedField valid={usernameValid} onChange={onChangeUsername} value={username} autoComplete="off" errorMessage='Username must be lowercase, 4-25 characters, no spaces in between, underscore is the only special character allowed.' successMessage='This is permanent. Choose wisely.' placeholder='Username' />
                <p className='text-xs text-red-500 italic'>{signUpError}</p>
            </div>
            <div className="mb-2">
                <label className="block text-sm mb-2">Choose your password</label>
                <ValidatedField valid={passwordValid} onChange={onChangePassword} value={password} autoComplete="off" type="password" errorMessage='Password must be a minimum of 8 characters.' successMessage='Alright!' placeholder='Password' />
            </div>
            <div className="mb-2">
                <label className="block text-sm mb-2">Verify your password</label>
                <ValidatedField valid={verifyPasswordValid} onChange={onChangeVerifyPassword} value={verifyPassword} autoComplete="off" type="password"  errorMessage='Your password verification does not match' successMessage='Your passwords match!' placeholder='Verify Password' />
            </div>
            <div className="flex items-center justify-between">
                <a onClick={gotoLogIn} className="inline-block align-baseline text-sm text-slate-600 hover:text-slate-950 cursor-pointer underline">Already have an account?</a>
                <button onClick={signup} disabled={!usernameValid || !passwordValid || !verifyPasswordValid } className="bg-slate-800 disabled:bg-slate-200 hover:bg-slate-950 text-white py-2 px-10 rounded-full" type="button">
                    Create Account
                </button>
            </div>
        </form>
    )
}

export default SignUp;