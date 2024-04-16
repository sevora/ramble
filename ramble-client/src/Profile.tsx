import { FC, useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

import useAccount from './hooks/account';

interface ProfileProps {
    username: string
}

/**
 * 
 */
interface AccountState {
    userCommonName: string,
    username: string,
    userBiography: string,
    userCreatedAt: string
}

/**
 * 
 */
interface FollowContext {
    isFollowing: boolean,
    isFollower: boolean
}

/**
 * Reusable component that renders a single profile.
 */
const Profile: FC<ProfileProps> = ({ username }) => {
    const { username: clientUsername } = useAccount();

    const [account, setAccount] = useState<AccountState | null>(null);
    const [follow, setFollow] = useState<FollowContext | null>(null);
    const navigate = useNavigate();

    /**
     * 
     */
    const getAccountState = async () => {
        const account = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/view`, { username }, { withCredentials: true });
        setAccount(account.data as AccountState);
    }

    const getFollowContext = async () => {
        const follow = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/follower/ask`, { username }, { withCredentials: true });
        setFollow(follow.data as FollowContext);
    }

    /**
     * This is used to toggle the follow state of the profile being viewed
     */
    const toggleFollow = async () => {
        if (follow === null || account === null) return;
        const action = follow.isFollowing ? 'unfollow' : 'follow';
        await axios.post(`${import.meta.env.VITE_BACKEND_URL}/follower/${action}`, { username: account.username }, { withCredentials: true });
        await getFollowContext();
    }

    useEffect(() => {
        getAccountState();
        getFollowContext();
    }, []);

    if (account === null || follow === null)
        return <></>

    return (
        <div className='flex flex-wrap bg-white px-5 py-3 border-b-2 w-full hover:bg-slate-100' onClick={() => navigate(`/profile/${account.username}`)}>

            <div className='flex w-full items-center'>
                <div className='flex gap-2 w-3/5'>
                    <div className='hover:underline cursor-pointer font-semibold whitespace-nowrap text-ellipsis truncate'>{account.userCommonName}</div>
                    <div className='hover:underline cursor-pointer whitespace-nowrap text-ellipsis truncate'>@{account.username}</div>
                </div>

                {/* The setting also changes depending on who you are */}
                {clientUsername !== account.username &&
                
                    (<>
                        {/* This is quite the solution because Tailwind won't guarantee adding the styles */}
                        {follow.isFollowing && <button onClick={event => { event.stopPropagation(); toggleFollow() }} className='ml-auto bg-slate-200 hover:bg-slate-300 py-2 px-5 rounded-full'>
                            Unfollow
                        </button>}

                        {!follow.isFollowing && <button onClick={event => { event.stopPropagation(); toggleFollow() }} className='ml-auto bg-slate-800 hover:bg-slate-950 text-white py-2 px-5 rounded-full'>
                            Follow
                        </button>}
                    </>)
                }
            </div>

            <div className='flex-grow w-full'>{account.userBiography}</div>
        </div>
    );
}

export default Profile;