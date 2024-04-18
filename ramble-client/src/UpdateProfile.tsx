import { FC, FormEventHandler, useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

import ValidatedField from './ValidatedField';
import useAccount from './hooks/account';

/**
 * This component is used to update the profile.
 * Here, one can set their common name and biography.
 */
const UpdateProfile: FC = () => {
    const { username, setIsLoggedIn } = useAccount();
    const navigate = useNavigate();

    const [userCommonName, setUserCommonName] = useState<string>('');
    const [biography, setBiography] = useState<string>('');
    const [password, setPassword] = useState<string>('');

    // stores validity state for common name
    const [userCommonNameValid, setUserCommonNameValid] = useState<boolean>(false);

    // stores whether there are errors on different parts
    const [updateAccountError, setUpdateAccountError] = useState<boolean>(false);
    const [deleteAccountError, setDeleteAccountError] = useState<boolean>(false);

    /**
     * This is called to populate the account input fields
     * when rendering this component.
     */
    const populateAccountFields = async () => {
        const response = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/view`, {}, { withCredentials: true });
        const account = response.data as { userCommonName: string, username: string, userBiography?: string };
        setUserCommonName(account.userCommonName);
        setBiography(account.userBiography || '');
    }

    /**
     * The user common name has a length minimum and limit,
     * which if not met will show the error message.
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
     * This is called after updating an account, navigate 
     * back the client to their profile.
     */
    const updateAccount = async () => {
        try {
            await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/update`, { userCommonName: userCommonName.trim(), biography: biography.trim() }, { withCredentials: true });
            navigate(`/profile/${username}`);
        } catch { setUpdateAccountError(true) }
    }

    /**
     * This is for when attempting to delete the account. 
     * If successful, redirects the client back to the landing page.
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
                {/* This contains the user common name and username field */}
                <div className='w-full'>
                    <ValidatedField valid={userCommonNameValid} onInput={onInputUsername} value={userCommonName} size={userCommonName.length} maxLength={50} className='font-semibold flex-grow border border-gray-300 rounded-md' errorMessage='The display name must be between 4-50 characters.' autoComplete='username' />
                    <div>{'@' + username}</div>
                </div>

                <div style={{ visibility: updateAccountError ? 'visible' : 'hidden' }} className='flex-grow w-1/5 mr-2 text-red-600 text-xs italic'>Account update failed!</div>

                {/* This is the save button */}
                <button onClick={updateAccount} className='ml-auto mr-2 text-neutral-600 bg-slate-800 hover:bg-slate-950 text-white px-9 py-2 rounded-full' type='button'>
                    Save
                </button>

                {/* This is the cancel button that disappears on mobile */}
                <button onClick={() => navigate(`/profile/${username}`)} className='ml-auto hidden sm:block text-neutral-600 bg-slate-200 hover:bg-slate-300 px-9 py-2 rounded-full' type='button'>
                    Cancel
                </button>

            </div>

            {/* This is where the biography is set */}
            <textarea value={biography} onInput={event => setBiography((event.target as any).value)} rows={4} maxLength={200} minLength={1} className="mt-2 block p-2.5 w-3/4 rounded-md border border-gray-300 focus:ring-neutral-100" placeholder="Describe yourself..."></textarea>

            {/* Option to delete the account interface */}
            <div className='mt-4'>
                <label className='block'>
                    Wish to delete your account? <span className='font-semibold'>This process is irreversible.</span></label>
                <div className=''>
                    <input value={password} onInput={event => { setPassword((event.target as HTMLInputElement).value.trim()); setDeleteAccountError(false) }} className='border border-gray-300 rounded-lg mt-2 px-3 py-2 mr-2 block sm:inline' type='password' placeholder='Enter password here' autoComplete='current-password' />
                    <button onClick={deleteAccount} className='text-neutral-600 text-white bg-red-600 hover:bg-red-500 mt-2 px-3 py-2 rounded-md' type='button'>
                        Delete Account
                    </button>
                </div>
                <div style={{ visibility: deleteAccountError ? 'visible' : 'hidden' }} className='mt-2 text-red-600 text-xs italic'>Failed to delete, password invalid!</div>
            </div>

        </form>
    )
}

export default UpdateProfile;