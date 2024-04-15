import { FC, useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

import useAccount from './hooks/account';
import timeAgo from './helpers/time-ago';

interface PostProps extends React.HTMLProps<HTMLDivElement> {
    /**
     * Provide only the postId and this should automatically 
     * have all the functionality.
     */
    postId: string;
}

/**
 * This describes the state of a post in a single object.
 * You could infer what this means.
 */
interface PostState { 
    postId:         string
    postContent:    string
    postCreatedAt:  string
    userCommonName: string
    username:       string
    likeCount:      number
    replyCount:     number 
    hasLiked:       boolean
}

/**
 * A reusable component that is reliant on the backend to get the state.
 */
const Post: FC<PostProps> = ({ postId, className='', ...otherProperties }) => {
    const account = useAccount(); // probably not the best organization but this works for me
    const [ state, setState ] = useState<PostState | null>(null);
    const navigate = useNavigate();

    const getPost = async () => {
        const response = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/view`, { postId }, { withCredentials: true });
        const data = response.data as PostState;
        setState(data);
    }

    // either do a like or a dislike
    const toggleLike = async () => {
        if (state === null) return;
        const action = state.hasLiked ? 'dislike' : 'like';
        await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/${action}`, { postId }, { withCredentials: true });
        await getPost();
    }
    
    // we get this post everytime the id changes
    useEffect(() => {
        getPost();
    }, [ postId ]);

    // do not render anything if the state hasn't been fetched yet
    if (state === null) 
        return <></>;

    return (
        <div className={'border-b-2' + className} { ...otherProperties }>
            <div className='px-5 py-3 hover:bg-neutral-100 cursor-pointer'>
                <div className='flex items-center gap-2 whitespace-nowrap'>
                    <div className='font-semibold'>{state.userCommonName}</div>
                    <div className='hover:underline cursor-pointer' onClick={() => navigate(`/profile/${state.username}`)}>@{state.username}</div>
                    <div className='text-slate-400'>• {timeAgo(state.postCreatedAt)}</div>
                </div>
                <div className='w-full text-lg'>
                    {state.postContent}
                </div>
            </div>

            <div className='w-full flex items-center border-t-2 border-b-2 justify-around'>
                <button className='grow p-2 text-md hover:bg-neutral-100' style={{ fontWeight: state.hasLiked ? 'bold' : undefined }} onClick={toggleLike}>{state.likeCount} likes</button>
                <button className='grow p-2 text-md hover:bg-neutral-100'>{state.replyCount} replies</button>
                <button className='grow p-2 text-md hover:bg-neutral-100' style={{ visibility: account.username !== state.username ? 'hidden' : undefined}}>Delete post</button>
            </div>
        </div>
    );
}

export default Post;