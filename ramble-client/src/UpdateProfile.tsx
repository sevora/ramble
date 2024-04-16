import { FC, FormEventHandler, useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

import ValidatedField from './ValidatedField';
import useAccount from './hooks/account';

const UpdateProfile: FC = () => {
    const { username, setUsername: setGlobalUserName, setUserCommonName: setGlobalUserCommonName, setIsLoggedIn } = useAccount();
    const navigate = useNavigate();

    const [ userCommonName, setUserCommonName ] = useState<string>('');
    const [ biography, setBiography ] = useState<string>('');
    const [ password, setPassword ] = useState<string>('');

    //
    const [ userCommonNameValid, setUserCommonNameValid ] = useState<boolean>(false);

    //
    const [ updateAccountError, setUpdateAccountError ] = useState<boolean>(false);
    const [ deleteAccountError, setDeleteAccountError ] = useState<boolean>(false);

    /**
     * 
     */
    const populateAccountFields = async () => {
        const response = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/view`, {}, { withCredentials: true });
        const account = response.data as { userCommonName: string, username: string, userBiography?: string };
        setUserCommonName(account.userCommonName);
        setBiography(account.userBiography || '');
    }

    /**
     * 
     */
    const onInputUsername: FormEventHandler<HTMLInputElement> = (event) => {
        const value = (event.target as HTMLInputElement).value;
        setUserCommonName(value);

        const trimmed = value.trim();

        setUserCommonNameValid(
            trimmed.length >= 4 &&
            trimmed.length <= 50
        );
    }

    /**
     * 
     */
    const updateAccount = async () => {
        try {
            await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/update`, { userCommonName: userCommonName.trim(), biography: biography.trim() }, { withCredentials: true });
            setGlobalUserCommonName(userCommonName);
            navigate(`/profile/${username}`);
        } catch { setUpdateAccountError(true) }
    }

    /**
     * 
     */
    const deleteAccount = async () => {
        try {
            await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/delete`, { password }, { withCredentials: true })
            setIsLoggedIn(false);
            navigate('/');
        } catch { setDeleteAccountError(true) }
    }

    useEffect(() => {
        populateAccountFields();
    }, []);

    return (
        <form onSubmit={event => event.preventDefault()} className='p-5 sm:px-20 bg-white border-b-2'>
            <div className='flex items-center'>

                    <div className='w-full'>
                        <ValidatedField valid={userCommonNameValid} onInput={onInputUsername} value={userCommonName} size={userCommonName.length} maxLength={50} className='font-semibold flex-grow border border-gray-300 rounded-md' errorMessage='The display name must be between 4-50 characters.' autoComplete='username' />
                        <div>{'@' + username}</div>
                    </div>

                <div style={{ visibility: updateAccountError ? 'visible' : 'hidden' }} className='flex-grow w-1/5 mr-2 text-red-600 text-xs italic'>Account update failed!</div>
                
                <button onClick={updateAccount} className='ml-auto mr-2 text-neutral-600 bg-neutral-200 hover:bg-neutral-400 px-9 py-2 rounded-full' type='button'>
                    Save
                </button>

                <button onClick={() => navigate(`/profile/${username}`)} className='ml-auto text-neutral-600 bg-neutral-200 hover:bg-neutral-400 px-9 py-2 rounded-full' type='button'>
                    Cancel
                </button>

            </div>

            <textarea value={biography} onInput={event => setBiography((event.target as any).value)} rows={4} maxLength={200} minLength={1} className="mt-2 block p-2.5 w-3/4 rounded-md border border-gray-300 focus:ring-neutral-100" placeholder="Describe yourself..."></textarea>
            
            <div className='mt-4'>
                <label className='block'>
                    Wish to delete your account? <span className='font-semibold'>This process is irreversible.</span></label>
                <div className='flex'>
                    <input value={password} onInput={event => { setPassword((event.target as HTMLInputElement).value.trim()); setDeleteAccountError(false) }} className='border border-gray-300 rounded-md px-2 mr-2' type='password' placeholder='Enter password here' autoComplete='current-password' />
                    <button onClick={deleteAccount} className='text-neutral-600 text-white bg-red-600 hover:bg-red-500 px-9 py-1 rounded-md' type='button'>
                        Delete Account
                    </button>
                </div>
                <div style={{ visibility: deleteAccountError ? 'visible' : 'hidden' }} className='mt-2 text-red-600 text-xs italic'>Failed to delete, password invalid!</div>
            </div>
            
        </form>
    )
}

export default UpdateProfile;