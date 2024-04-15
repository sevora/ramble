import axios from 'axios';
import { FC, useEffect, useState } from 'react';
import { useInView } from 'react-intersection-observer';
import { useParams } from 'react-router-dom';

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
    username:       string,
    userBiography:  string | null,
    userCreatedAt:  Date,

    // this is from /post/count
    postCount:      number
}

/**
 * 
 */
interface FollowState {
    isFollowing: boolean,
    isFollower: boolean
}

const ViewProfile: FC = () => {
    const { username: viewUsername } = useParams<{ username: string }>();
    const { username: clientUsername } = useAccount();
    const isClient = viewUsername === clientUsername;

    const [profile, setProfile] = useState<ProfileState | null>(null);
    const [follow, setFollow] = useState<FollowState | null>(null);
    const [posts, setPosts] = useState<{ postId: string }[]>([]);

    const [page, setPage] = useState<number>(0);
    const [hasNextPage, setHasNextPage] = useState<boolean>(true);

    const [moreButtonReference, inView] = useInView({ root: document.querySelector('#dashboard-outlet'), threshold: 1.0 });


    /**
     * Loads the profile and the context related to it
     * @returns 
     */
    const loadProfileContextState = async () => {
        // reset the profile
        const accountResponse = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/account/view`, { username: viewUsername }, { withCredentials: true });
        const postCountResponse = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/count`, { username: viewUsername }, { withCredentials: true });
        const profile = { ...accountResponse.data, ...postCountResponse.data };
        setProfile(profile as ProfileState);

        // reset the follow context
        const followResponse = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/follower/ask`, { username: viewUsername }, { withCredentials: true });
        setFollow(followResponse.data as FollowState);

        // reset the entire remaining state
        setPage(0);
        setPosts([]);
        setHasNextPage(true);
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
        if (!hasNextPage) return;

        const more = await getPosts(page);

        if (more.length > 0) {
            setPosts([...posts, ...more]);
            setPage(page + 1);
        } else {
            setHasNextPage(false);
        }
    }
    
    // we want to load the profile 
    useEffect(() => {
        loadProfileContextState();
    }, [ viewUsername ]);

     // when the next button is inView (initially it is) we load more posts
     useEffect(() => {
        if (inView) 
            loadMorePosts();
    }, [ inView ]);

    if (profile === null || follow === null)
        return <></>

    return (
        <div>
            {/* This is the viewed user profile */}
            <div className='p-3 bg-white flex items-center justify-around border-b-2'>
                <div className='flex flex-wrap items-center'>
                    <div className='font-semibold flex-grow w-full'>{profile.userCommonName}</div>
                    <div>@{profile.username}</div>

                    {/* This badge appears next to username if they follow you */}
                    { follow.isFollower && <div className='text-xs rounded-lg bg-neutral-200 ml-2 px-2 py-1'>Follows you</div>}

                    {/* The bio has suggestions if you are the client */}
                    <div className='text-neutral-600 flex-grow w-full'>
                        {profile.userBiography}
                        { isClient && !profile.userBiography && <div className='italic'>Update your account to add bio...</div>}
                    </div>
                </div>

                {/* The setting also changes depending on who you are */}
                <button className='h-3/4 bg-neutral-200 hover:bg-neutral-400 py-2 px-4 rounded-full'>
                    {/* Cursed ternary */}
                    {isClient ? 'Update Account' : follow.isFollowing ? 'Unfollow' : 'Follow' }
                </button>
            </div>

            {/* These are the viewed user's posts */}
            <div className='sm:w-3/4 sm:mx-auto rounded-lg'>
                <div className='bg-white rounded-tl-none rounded-lg'>   
                    {
                        posts.map(post => {
                            const { postId } = post;
                            return <Post key={postId} postId={postId} className='hover:bg-neutral-100' />
                        })
                    }
                    <div className='w-full text-center p-5 hover:bg-neutral-200' ref={moreButtonReference}>{!hasNextPage ? 'Loading' : 'No more posts'}</div>
                </div>
            </div>
            
        </div>
    );
}

export default ViewProfile;