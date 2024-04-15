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
        <div className='bg-white'>
            <div className='font-semibold'>{account.userCommonName}</div>
            <div className='hover:underline cursor-pointer' onClick={() => navigate(`/profile/${account.username}`)}>@{account.username}</div>

        </div>
    );
}

export default Profile;