import { FC, useEffect, useState } from 'react';
import { useInView } from 'react-intersection-observer';
import { useNavigate, useParams } from 'react-router-dom';
import axios from 'axios';

import Post from './Post';
import useAccount from './hooks/account';

/**
 * ProfileState values is a mix of one or more API calls.
 * In this case we use /account/view and /post/count
 * to get all these information.
 */
interface ProfileState {
    // these are from /account/view
    userCommonName: string,
    username: string,
    userBiography: string | null,
    userCreatedAt: string,

    // these are from /follower/count
    followCount: number,
    followerCount: number,

    // this is from /post/count
    postCount: number
}

/**
 * 
 */
interface FollowContext {
    isFollowing: boolean,
    isFollower: boolean
}

const ViewProfile: FC = () => {
    const { username: viewUsername } = useParams<{ username: string }>();
    const { username: clientUsername } = useAccount();
    const isClient = viewUsername === clientUsername;

    const [profile, setProfile] = useState<ProfileState | null>(null);
    const [follow, setFollow] = useState<FollowContext | null>(null);
    const [posts, setPosts] = useState<{ postId: string }[]>([]);

    const [page, setPage] = useState<number>(0);
    const [hasNextPage, setHasNextPage] = useState<boolean>(true);

    const navigate = useNavigate();
    const [moreRef, inView] = useInView({ root: document.querySelector('#dashboard-outlet'), threshold: 1.0 });

    /**
     * Loads the profile and the context related to it
     * @returns 
     */
    const loadProfileContextState = async () => {
        // reset the profile
        try {
            const accountResponse = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/view`, { username: viewUsername }, { withCredentials: true });
            const followerCountResponse = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/follower/count`, { username: viewUsername }, { withCredentials: true });
            const postCountResponse = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/count`, { username: viewUsername }, { withCredentials: true });
            const profile = { ...accountResponse.data, ...followerCountResponse.data, ...postCountResponse.data };
            setProfile(profile as ProfileState);
    
        } catch {
            navigate('/404');
            return;
        }
       
       
    
        await getFollowContext();

        // reset the entire remaining state
        setPage(0);
        setPosts([]);
        setHasNextPage(true);
    }

    /**
     * 
     */
    const getFollowContext = async () => {
        // reset the follow context
        const followResponse = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/follower/ask`, { username: viewUsername }, { withCredentials: true });
        setFollow(followResponse.data as FollowContext);
    }

    /**
     * Use this to get the posts at category and page
     * @param category the category of the post
     * @param page the current page
     * @returns the postIds in an array
     */
    const getPosts = async (page: number) => {
        const response = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/list`, { username: viewUsername, page }, { withCredentials: true });
        return response.data.posts as { postId: string }[];
    }

    /**
     * This is the logic to load more posts through
     * infinite scrolling. Had wasted time figuring out a lot of things here.
     */
    const loadMorePosts = async () => {
        const more = await getPosts(page);
        if (more.length > 0) {
            setPosts([...posts, ...more]);
            setPage(page + 1);
        } else {
            setHasNextPage(false);
        }
    }

    /**
     * This is used to toggle the follow state of the profile being viewed
     */
    const toggleFollow = async () => {
        if (follow === null) return;
        const action = follow.isFollowing ? 'unfollow' : 'follow';
        await axios.post(`${import.meta.env.VITE_BACKEND_URL}/follower/${action}`, { username: viewUsername }, { withCredentials: true });
        await getFollowContext();
    }

    // we want to load the profile 
    useEffect(() => {
        loadProfileContextState();
    }, [viewUsername]);

    // when the next button is inView (initially it is) we load more posts
    useEffect(() => {
        if (inView && hasNextPage)
            loadMorePosts();
    }, [inView, hasNextPage, posts.length]);

    if (profile === null || follow === null)
        return <></>

    return (
        <div>
            {/* This is the viewed user profile */}
            <div className='p-5 sm:px-20 bg-white border-b-2'>
                <div className='flex items-center'>
                    <div>
                        <div className='font-semibold flex-grow w-full'>{profile.userCommonName}</div>
                        <div>@{profile.username}</div>
                        
                    </div>

                    {/* This badge appears next to username if they follow you */}
                    {follow.isFollower && <div className='text-xs rounded-lg bg-slate-200 ml-2 px-2 py-1'>Follows you</div>}

                    {/* The setting also changes depending on who you are */}
                    <button className='ml-auto bg-slate-800 hover:bg-slate-950 text-white px-9 py-2 rounded-full' onClick={() => isClient ? navigate(`/update`) : toggleFollow()}>
                        {/* Cursed ternary */}
                        {isClient ? 'Update' : follow.isFollowing ? 'Unfollow' : 'Follow'}
                    </button>

                </div>

                {/* The bio has suggestions if you are the client */}
                <div className='text-neutral-600 mt-2 flex-grow w-3/4'>
                    {profile.userBiography}
                    {isClient && !profile.userBiography && <div className='italic'>Update your account to add bio...</div>}
                </div>


                <div className='flex-grow w-full text-neutral-900 pt-2'>Joined {new Date(profile.userCreatedAt).toISOString().replace('-', '/').split('T')[0].replace('-', '/')}</div>

                {/* These contain the follow count, clicking on one should redirect appropriately */}
                <div className='pb-2 flex gap-4'>
                    <div className='hover:underline cursor-pointer' onClick={() => navigate(`/profile/${viewUsername}/following`)}>
                        <span className='font-semibold mr-1'>{profile.followCount}</span> following
                    </div>

                    <div className='hover:underline cursor-pointer' onClick={() => navigate(`/profile/${viewUsername}/follower`)}>
                        <span className='font-semibold mr-1'>{profile.followerCount}</span> followers
                    </div>
                </div>
            </div>

            {/* These are the viewed user's posts */}
            <div className='sm:w-3/4 sm:mx-auto rounded-lg'>
                <div className='bg-white rounded-tl-none rounded-lg'>
                    {
                        posts.map(post => {
                            const { postId } = post;
                            return <Post key={postId} postId={postId} onFail={id => setPosts(posts.filter(p => p.postId !== id))} showParentPost className='hover:bg-slate-100' />
                        })
                    }
                    <div className='w-full text-center p-5' ref={moreRef}>{hasNextPage ? 'Loading' : 'No more posts'}</div>
                </div>
            </div>

        </div>
    );
}

export default ViewProfile;