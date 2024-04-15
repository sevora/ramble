import { FC, useEffect, useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';

interface ProfileProps {
    username: string
}

/**
 * 
 */
interface AccountState {
    userCommonName: string,
    username:       string,
    userBiography:  string,
    userCreatedAt:  string
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
    const [ account, setAccount ] = useState<AccountState | null>(null);
    const [ follow, setFollow ] = useState<FollowContext | null>(null);
    const navigate = useNavigate();

    /**
     * 
     */
    const getAccountState = async () => {
        const account = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/view`, { username }, { withCredentials: true });
        setAccount(account.data as AccountState);
    }

    const getFollowContext = async() => {
        const follow = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/follower/ask`, { username }, { withCredentials: true });
        setFollow(follow.data as FollowContext);
    }

    useEffect(() => {
        getAccountState();
        getFollowContext();
    }, []);

    if (account === null || follow === null) 
        return <></>

    return (
        <div className='flex flex-wrap bg-white px-5 py-3 border-b-2 w-full hover:bg-neutral-100 cursor-pointer' onClick={() => navigate(`/profile/${account.username}`)}>

            <div className='flex w-full items-center'>
                <div className='flex gap-2 w-3/5'>
                    <div className='font-semibold whitespace-nowrap text-ellipsis truncate'>{account.userCommonName}</div>              
                    <div className='hover:underline cursor-pointer whitespace-nowrap text-ellipsis truncate' onClick={() => navigate(`/profile/${account.username}`)}>@{account.username}</div>
                </div>
                
                {/* The setting also changes depending on who you are */}
                <button className='ml-auto bg-neutral-200 hover:bg-neutral-400 py-2 px-5 rounded-full'>
                        {/* Cursed ternary */}
                        {follow.isFollowing ? 'Unfollow' : 'Follow'}
                </button>
            </div>

            <div className='flex-grow w-full'>{account.userBiography}</div>
        </div>
    );
}

export default Profile;