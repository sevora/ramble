import { FC, useEffect, useState } from 'react';
import { useInView } from 'react-intersection-observer';
import { useNavigate, useParams } from 'react-router-dom';
import axios from 'axios';

// this is used to render a single follower/following account, just provide their username
import Profile from './Profile';

// this is used for the currently viewed account and not for the following/follower profiles
interface ProfileState {
    // these are from /account/view
    userCommonName: string,
    username:       string,

    // these are from /follower/count
    followCount:    number,
    followerCount:  number,
}

/**
 * 
 */
const ViewFollower: FC = () => {
    const { username: viewUsername, category } = useParams<{ username: string, category: string }>();
    const navigate = useNavigate();

    const [profile, setProfile] = useState<ProfileState | null>(null);

    const [accounts, setAccounts] = useState<{ username: string }[]>([]);
    const [page, setPage] = useState<number>(0);
    const [hasNextPage, setHasNextPage] = useState<boolean>(true);
    
    const [moreElementRef, inView] = useInView({ root: document.querySelector('#dashboard-outlet'), threshold: 1.0 });

    const loadProfileContextState = async () => {
        // reset the profile
        const accountResponse = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/view`, { username: viewUsername }, { withCredentials: true });
        const followerCountResponse = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/follower/count`, { username: viewUsername }, { withCredentials: true });
        const profile = { ...accountResponse.data, ...followerCountResponse.data };
        setProfile(profile as ProfileState);

        // reset the entire remaining state
        setPage(0);
        setAccounts([]);
        setHasNextPage(true);
    }

    /**
     * 
     */
    const getAccounts = async (category: 'follower' | 'following', page: number) => {
        const response = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/follower/list`, { username: viewUsername, page, category }, { withCredentials: true });
        return response.data.users as { username: string }[];
    }

    /**
     * 
     * @returns 
     */
    const loadMoreAccounts = async () => {
        const more = await getAccounts(category as any, page);

        if (more.length > 0) {
            setAccounts([...accounts, ...more]);
            setPage(page + 1);
        } else {
            setHasNextPage(false);
        }
    }
    
    // enforce criteria to be 'follower' and 'following'
    useEffect(() => {
        if (category !== 'follower' && category !== 'following') 
            navigate('/');
    }, []);

    // we want to load the profile 
    useEffect(() => {
        loadProfileContextState();
    }, [ viewUsername, category ]);

     // when the next button is inView (initially it is) we load more posts
     useEffect(() => {
        if (inView && hasNextPage) 
            loadMoreAccounts();
    }, [ inView, hasNextPage, accounts.length ]);

    if (profile === null || accounts === null) 
        return <></>

    return (
    <div>
        <div className='bg-white p-5'>
            <div className='font-semibold'>{profile.userCommonName}</div>
            <div>@{profile.username}</div>
        </div>

        <div className='sm:px-2 sm:w-3/4 sm:mx-auto rounded-lg'>
            <div className='flex'>
                <button className='px-5 py-3 hover:bg-slate-200' style={{ backgroundColor: category === 'following' ? 'white' : undefined, fontWeight: category === 'following' ? 'bold' : undefined }} onClick={() => navigate(`/profile/${viewUsername}/following`)}>{profile.followCount} Following</button>
                <button className='px-5 py-3 hover:bg-slate-200' style={{ backgroundColor: category === 'follower' ? 'white' : undefined, fontWeight: category === 'follower' ? 'bold' : undefined }} onClick={() => navigate(`/profile/${viewUsername}/follower`)}>{profile.followerCount} Followers</button>
            </div>

            {/* List of accounts being followed or getting followed by */}
            <div>
                {
                    accounts.map((account) => {
                        return (<Profile key={account.username} username={account.username} />)
                    })
                }
                <div className='w-full text-center p-5 bg-white' ref={moreElementRef}>{hasNextPage ? 'Loading' : 'No more profiles'}</div>
            </div>

        </div>
    </div>
    )
}

export default ViewFollower;